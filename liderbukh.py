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
                    self.settings['data_dir'], dir, file_name), 
                    encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print ("Can't open file %s: %s." % 
                    (file_name, e))
            raise
    
    def build_book_data(self): # Build all the book data
        book_data = []
        print('Building book data...\n')
        try:
            print('Reading data directory...\n')
            songlist = [
                os.path.splitext(metafile)[0] for metafile in os.listdir( os.path.join(
                    self.settings['root_dir'], 
                    self.settings['data_dir'])) if metafile.endswith(".yaml")]
        except Exception as e:
            print("Could not read song meta files: %s" % (e))
            raise
        
        try:
            print('Reading chapter list...\n')
            for chapter_name in self.settings['book']['chapters']:
                book_data.append( {'name': chapter_name, 'songs': [] } )
        except Exception as e:
            print('Failed: %s' % e )
            raise
        
        print('Processing songs...\n')
        for filename in songlist:
            song = self.process_song(filename)
            try:
                    book_data[int(song['meta']['chapter'])]['songs'].append(song)
            except IndexError as e:
                    print('Error processing chapter number %s for %s: %s' % (
                        song['meta']['chapter'], song['meta']['filename'], e))
                    raise
        
        print('Book data complete\n')
        return book_data
      
    def process_song(self, filename):
            print('Processing %s...' % filename)
            base_path = os.path.join(self.settings['root_dir'],  # For output file paths
                    self.settings['temp_dir'], filename )
            song = {
                'meta':{
                    'filename': filename,
                    'ly_path': ''.join([ base_path, '.ly'] ),
                    'tex_path': ''.join([ base_path, '.lytex'])
                    } }
            
            for field in self.settings['song_meta']:
                song['meta'].update({field: None})
            
            print('Loading song meta...')
            try:
                meta = yaml.load(self.load_file('%s.yaml' % filename ))
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
            
            print('Loading music data...')
            try:
                song['music'] = self.load_file(
                    ''.join([song['meta']['filename'],'.ly'])).replace(
                            '\include "templates/preamble.ly"',
                            self.load_file(
                                    'preamble.ly', self.settings['templates_dir']))
            except Exception:
                print( 'Error loading music data for %s' % ( song['meta']['filename'] ) )
                raise
            
            # Overwrite with template output
            try:
                song['music'] = self.build_template(
                        song, 'lilypond.template' )
            except Exception:
                print( 'Error building Lilypond template for %s' % ( song['meta']['filename'] ) )
                raise
            
            print('Loading lyrics...')
            try:
                song['lyrics'] = self.load_file(''.join([song['meta']['filename'],
                        self.settings['lyrics_ext']]))
            except Exception:
                print( 'Error loading lyrics for %s' % ( song['meta']['filename'] ) ) 
                raise
            
            print('Rendering TeX')
            try:
                song['tex'] = self.render_tex( song['lyrics'] )
            except Exception:
                print( 'Error rendering TeX for %s' % ( song['meta']['filename'] ) )
                raise
            
            # Load TeX template output 
            try:
                song['tex'] = self.build_template( 
                    song, 'tex.template' )
            except Exception:
                print( 'Error building TeX template for %s' % ( song['meta']['filename'] ) )
                raise
            
            print('Processing complete for %s\n' % filename)
            return song
    
    def build_template(self, data, template):
        
        print('Applying %s' % template)
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
        print('Preparing to write output for %s...\n' % song['meta']['filename'])
        
        output_dir = self.settings['output_dir']
        temp_dir = self.settings['temp_dir']
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
        
        tex_path = song['meta']['tex_path']
        ly_path = song['meta']['ly_path']
        pdf_path = ''.join([
            os.path.join(output_dir, song['meta']['filename']),
            '.pdf'])
            
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
        
        filename = song['meta']['filename']
        
        print('Writing:\t\t%s:' % (pdf_path) )
        print('Running lilypond-book...')

        try:
            subprocess.run([
                'lilypond-book',
                '--latex-program=xelatex',
                '--output=%s' % ( temp_dir ),
                '--loglevel=ERROR',
                song['meta']['tex_path']])
        except Exception as e:
            print( 'Error: %s' % (e) )
        
        print( 'Running XeLaTeX...' )
        try:
            os.chdir( temp_dir )
            subprocess.run([
                'xelatex',
                '-interaction=batchmode',
                '-halt-on-error',
                '%s.tex' % ( filename )])
            os.chdir(root_dir)
            subprocess.run([
                'mv',
                '%s/%s.pdf' % (temp_dir, filename),
                '%s/%s.pdf' % (self.settings['output_dir'], filename)])
            print('Success!\n')
        except Exception as e:
            print ( 'Error: %s' % (e) )
            raise
    

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

@click.option('--filename',
              '-f',
              default=None,
              help='Only process this song file. \
              Please provide filename without extension.')

def main(settings_file, debug, no_write, filename):
    book = Liderbukh(settings_file, debug)
    if filename:
        data = book.process_song(filename)
        if not no_write:
                book.write_files(data)
    else:
        try:
            data = book.build_book_data()
        except Exception as e:
            print ( "Failed to build book data" )
            if debug: raise
            sys.exit(1)
        if not no_write:
            for chapter in data:
                for song in chapter['songs']:
                    book.write_files(song)

if __name__ == '__main__':
    main()
