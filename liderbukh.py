#!/usr/bin/env python3

# Version 1.0
#
# Copyright 2019 Marc Trius
#
# License: 
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import click
import os
import pyratemp
import yaml
import mistune
import subprocess
import sys

import lib.marktex

def runerror(exception):
  if exception.stderr:
    print ( exception.stderr.decode() )
  else:
    print ( exception.stdout.decode() )
  sys.exit()

class Liderbukh():
    def __init__(self, settings, debug):
        self.debug = debug
        self.render_tex = mistune.Markdown(renderer=lib.marktex.LyricsRenderer(escape=False)) # Load Markdown parser with TeX renderer
        with open(settings) as f: # Open Settings file
            try:
                self.settings = yaml.load(f.read())
            except yaml.scanner.ScannerError as e:
                print ( "Invalid settings file: %s\nYAML error: %s" 
                       % (settings, e) )
                sys.exit(1)
    def load_file(self, file_name, dir=''): # Method to load files
        try:
            with open( os.path.join(self.settings['root_dir'], 
                    dir, file_name), 
                    encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print ("Can't open file %s: %s." % 
                    (file_name, e))
            raise
    
    def build_index(self): # Build the index
        index = []
        data_dir = os.path.join(self.settings['root_dir'], self.settings['data_dir'])
        
        print('Building index...\n')
        try:
            print('Scanning data directory...\n')
            for entry in os.scandir(data_dir):
                if entry.is_dir():
                    try:
                        cat = open(
                            os.path.join(entry.path, 'cat.yaml'))
                    except FileNotFoundError as e:
                        print ("Warning: category %s doesn\'t have a metadata file. Any files in this category will not be read." % entry.path)
                        continue
                    
                    try:
                        category_meta = yaml.load(cat)
                    except yaml.scanner.ScannerError as e:
                        print ( "Warning: category %s has an invalid metadata file. Any files in this category will not be read." 
                            % entry.path )
                        continue
                    category_meta['category_path'] = entry.name
                    
                    category_index = []
                    for metafile in os.scandir(entry.path):
                        if metafile.is_file() and metafile.name.endswith('.yaml') and metafile.name != 'cat.yaml':
                            category_index.append(
                                os.path.splitext(
                                    os.path.relpath(
                                        metafile.path, start=os.path.join(
                                            os.curdir, data_dir
                                        )
                                    )
                                )[0]
                            )
                    index.append(
                        {
                            'songs': category_index,
                            'meta': category_meta
                        }
                    )
        
        except Exception as e:
            print ( "Failed to build index." )
        
        print('Index built successfully')
        return index
      
    def process_song(self,  path, chapter ):
            print( 'Processing %s...' % path )
            temp_path = os.path.join(self.settings['root_dir'],
                                    self.settings['temp_dir'], path )
            out_path = os.path.join(self.settings['root_dir'],
                                    self.settings['output_dir'], path)
            song = {
                'meta':{
                    'filename': os.path.split(path)[1],
                    'path': path,
                    'ly_path': ''.join([ temp_path, '.ly'] ),
                    'tex_path': ''.join([ temp_path, '.lytex']),
                    'pdf_path': ''.join([ out_path, '.pdf'] )
                }
            }
            for field in self.settings['song_meta']:
                song['meta'].update({field: None})
            
            print('Loading song meta...')
            try:
                meta = yaml.load(self.load_file('%s.yaml' %
                                                os.path.join(self.settings['data_dir'], path ) ) )
            except yaml.scanner.ScannerError as e:
                print("Invalid song file: %s\nYAML error: %s" % (song, e) )
                raise
            
            try:
                for key in meta:
                    song['meta'][key] = meta[key]
            except KeyError as e:
                print("Invalid song file: %s\nField %s not known." 
                      % (song, e) )
                raise
            
            song['meta']['chapter_name'] = chapter
            
            print('Loading music data...')
            try:
                song['music'] = self.load_file('%s.ly' %
                                                os.path.join(self.settings['data_dir'], path ) ) .replace(
                            '\include "../../templates/preamble.ly"',
                            self.load_file(
                                    'preamble.ly', self.settings['templates_dir']))
            except Exception:
                print( 'Error loading music data for %s' % ( path ) )
                raise
            
            #Overwrite with template output
            try:
                song['music'] = self.build_template(
                        song, 'lilypond.template' )
            except Exception:
                print( 'Error building Lilypond template for %s' % ( path ) )
                raise
            
            print('Loading lyrics...')
            try:
                song['lyrics'] = self.load_file('%s.md' %
                                                os.path.join(self.settings['data_dir'], path ) )
            except Exception:
                print( 'Error loading lyrics for %s' % ( path ) ) 
                raise
            
            print('Rendering TeX...')
            try:
                song['tex'] = self.render_tex( song['lyrics'] )
            except Exception:
                print( 'Error rendering TeX for %s' % ( path ) )
                raise
            
            #Load TeX template output 
            try:
                song['tex'] = self.build_template( 
                    song, 'tex.template' )
            except Exception:
                print( 'Error building TeX template for %s' % ( path ) )
                raise
            
            return song
    
    def build_template(self, data, template):
        
        print('Applying %s...' % template)
        template_args = {}
        template_args['string'] = self.load_file(
                template, self.settings['templates_dir'])
        template_args['data'] = data
        template_args['escape'] = None
        try:
            return pyratemp.Template(**template_args)()
        except Exception:
            print( 'Error processing template %s for %s' %
                  ( template, data['meta']['filename'] ) )
            raise
    
    # Write files
    def write_files(self, song):
        print('Preparing to write output for %s...\n' % song['meta']['path'])
        
        tex_path = song['meta']['tex_path']
        ly_path = song['meta']['ly_path']
        pdf_path = song['meta']['pdf_path']
        xetex_path = os.path.splitext(os.path.split(song['meta']['tex_path'])[1])[0] + '.tex'
        
        output_dir = os.path.dirname(pdf_path)
        temp_dir = os.path.dirname(tex_path)
        root_dir = os.getcwd()
        
        if not os.path.isdir(output_dir):
            try:
                os.mkdir(output_dir)
            except Exception as e:
                print('Failed to create output directory at %s: %s' % (output_dir, e))
                raise

        if not os.path.isdir(temp_dir):
            try:
                os.mkdir(temp_dir)
            except Exception as e:
                print('Failed to create output directory at %s: %s' % (output_dir, e))
                raise
        
            
        print('Writing:\t\t%s' % tex_path)
        try:
            with open(tex_path, 'w+', encoding='utf-8') as f:
                f.write(song['tex'])
                print('Success!\n')
        except Exception as e:
            print( 'Error: %s\n' % (e) )
            
        print('Writing:\t\t%s' % ly_path)
        try:
            with open(ly_path, 'w+', encoding='utf-8') as f:
                f.write(song['music'])
                print('Success!\n')
        except Exception as e:
            print( 'Error: %s\n' % (e) )
        
        print('Writing:\t\t%s:\n' % (pdf_path) )
        print('Running lilypond-book...')

        try:
            subprocess.run([
                'lilypond-book',
                '--latex-program=xelatex',
                '--output=%s' % ( temp_dir ),
                '--loglevel=ERROR',
                tex_path],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
          runerror(e)
        
        print( 'Running XeLaTeX...' )
        try:
            os.chdir( temp_dir )
        except Exception as e:
            print( 'Cannot open temporary directory: %s' %
                  e )
        try:
            subprocess.run([
                'xelatex',
                '-interaction=nonstopmode',
                '-halt-on-error',
                xetex_path],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
            os.chdir(root_dir)
        except subprocess.CalledProcessError as e:
          runerror(e)
        
        print('Copying %s to output folder...' % pdf_path )
        try:
            subprocess.run([
                'mv',
                '%s/%s' % ( temp_dir, os.path.split(pdf_path)[1] ),
                '%s' % ( pdf_path )],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            runerror(e)
        print('\n%s written successfully!\n' %
              pdf_path)
        

@click.command()

@click.option('--settings-file',
              '-s', default='settings.yaml',
              help='Settings file. Default: settings.yaml',
              type=click.Path(exists=True))

@click.option(
            '--debug', '-d', default=False, is_flag=True,
            help='Turn debug mode on')

@click.option('--no-write',
              '-n',
              default=False,
              is_flag=True,
              help='Generate song data but don\'t write any files')

@click.option('--path',
              '-p',
              default=None,
              help='Only process this song file. Please provide path without extension.')

def main(settings_file, debug, no_write, path):
    book = Liderbukh(settings_file, debug)
    
    try:
        index = book.build_index()
        batch = []
        
        for category in index:
            for song in category['songs']:
                print(song)
                if path is None or path == song['path']:
                    batch.append( ( song, category['meta']['category_name'] ) )
        
        if not no_write:
            temp_dir = book.settings['temp_dir']
            output_dir = book.settings['output_dir']
            if not os.path.isdir(output_dir):
                try:
                    os.mkdir(output_dir)
                except Exception as e:
                    print('Failed to create output directory at %s: %s' % (output_dir, e))
                    raise
            if not os.path.isdir(temp_dir):
                try:
                    os.mkdir(temp_dir)
                except Exception as e:
                    print('Failed to create temporary directory at %s: %s' % (temp_dir, e))
                    raise
        
        for bat in batch:
            song = book.process_song(*bat)
            
            if not no_write:
                book.write_files(song)
    except:
        
        if debug: raise
        sys.exit(1)

if __name__ == '__main__':
    main()
