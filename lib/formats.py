#!/usr/bin/env python3

# Version 2.0
#
# Copyright 2019 Marc Trius
#
# License: 
#
# This file is part of Liderbukh.
# Liderbukh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Liderbukh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import subprocess
import re
import os
import pyratemp
from lib import marktex
from lib import functions

class Format():
    def __init__(self, slug, data, parent ):
        self.slug = slug
        self.data = data
        self.parent = parent
    
    def render( self ):
        template_args = {}
        with open( os.path.join( self.parent.settings['template_dir'],
                        f"{ self.slug }.template") ) as template:
            template_args['string'] = template.read()
        template_args['data'] = {
            **self.data,
            **self.parent.meta,
            'formats': self.parent.formats
            }
        template_args['escape'] = None
        
        try:
            self.output = pyratemp.Template( **template_args )()
        
        except Exception as e:
            print( f"{ self.slug }: ",
                'Error processing template',
                '\n',
                f'{ e }' )
            raise

class WritableFormat(Format):
    def __init__(self, slug, data, parent, relpath, filename ):
        super().__init__(slug, data, parent )
        self.relpath = relpath
        self.filename = filename
        self.temp_dir = os.path.join(
            self.parent.settings['temp_dir'], relpath )
        self.output_dir = os.path.join(
            self.parent.settings['output_dir'], relpath )
        self.root_dir = os.getcwd()
        self.output_names = [ filename ]
        self.link = os.path.join(
            parent.settings['root'], self.relpath, filename )
    def write( self ):
        if not os.path.isdir(self.temp_dir):
            try:
                os.makedirs(self.temp_dir)
            except Exception as e:
                print('Failed to create output directory at %s: %s' % (self.output_dir, e))
                raise        
        
        path = os.path.join( self.temp_dir, self.filename )
        
        print(f"Writing { path }" )
        try:
            with open( path, 'w+', encoding='utf-8') as f:
                f.write(self.output)
                print('Success!')
        
        except Exception as e:
            print( 'Error: %s\n' % (e) )
            
    def copy(self):
        
        if not os.path.isdir(self.output_dir):
            try:
                os.makedirs(self.output_dir)
            except Exception as e:
                print('Failed to create output directory at %s: %s' % (self.output_dir, e))
                raise
        
        for filename in self.output_names:
            print(f"Copying { filename } to output folder..." )
            try:
                subprocess.run([
                    'cp',
                    os.path.join( self.temp_dir, filename ),
                    self.output_dir],
                    check=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE)
            except subprocess.CalledProcessError as e:
                functions.runerror(e)
            print('Success!')

class TeX(WritableFormat):
    def __init__(self, slug, data, parent, relpath, filename ):
        super().__init__( slug, data, parent, relpath, filename )
        
        pdfname = f"{ os.path.splitext(filename)[0] }.pdf"
        self.texname = f"{ os.path.splitext(filename)[0] }.tex"
        self.output_names = [ pdfname ]
        self.data['lyrics'] = marktex.marktex(self.data['lyrics'])
        self.link = os.path.join(  parent.settings['root'], self.relpath, pdfname )
    
    def write(self):
        super().write()
        
        try:
            os.chdir( self.temp_dir )
        except Exception as e:
            print( 'Cannot open temporary directory: %s' %
                e )
            raise
        
        print('Running lilypond-book (PDF)...')
        try:
            subprocess.run([
                'lilypond-book',
                '--latex-program=xelatex',
                '--loglevel=ERROR',
                self.filename],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            functions.runerror(e)
        
        print( 'Running XeLaTeX...' )
        try:
            subprocess.run([
                'xelatex',
                '-interaction=nonstopmode',
                '-halt-on-error',
                self.texname ],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            functions.runerror(e)
        
        os.chdir( self.root_dir )

class HTML(WritableFormat):
    def __init__(self, slug, data, parent, relpath, filename ):
        super().__init__( slug, data, parent, relpath, filename )
        self.data.update( { 'tree': parent.root } )
        self.data['canonical_url'] = os.path.join( 
            parent.settings['root'], relpath, filename )

class HTML_index(HTML):
    pass

class HTML_page(HTML):
    def __init__(self, slug, data, parent, relpath, filename ):
        super().__init__( slug, data, parent, relpath, filename )
        self.data.update( { 'children': self.parent.children } )

class Lilypond(WritableFormat):
    def render(self):
        try:
            os.chdir( os.path.join( self.parent.settings['data_dir'], self.relpath ) )
            matches = re.findall(r"(?:\\include )[\"](.+)[\"]", self.data['music'], flags=0)
            for match in matches:
                with open(match) as include:
                    self.data['music'] = self.data['music'].replace(f'\include "{match}"', include.read())
            os.chdir( self.root_dir )
        except Exception as e:
            print( e )
            raise
        
        super().render()
        

class PNG(WritableFormat):
    def __init__(self, slug, data, parent, relpath, filename ):
        super().__init__( slug, data, parent, relpath, filename )
        
        self.filename = f"{ os.path.splitext(filename)[0] }.htmly"
        
    #def render(self):
        #pass
    
    def write(self):
        super().write()
        try:
            os.chdir( self.temp_dir )
        except Exception as e:
            print( 'Cannot open temporary directory: %s' %
                e )
            raise
        
        
        
        print('Running lilypond (PNG)...')
        try:
            subprocess.run([
                'lilypond-book',
                '--loglevel=ERROR',
                '--format=html',
                '--lily-output-dir=bah',
                '--use-source-file-names',
                self.filename],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            functions.runerror(e)
        os.chdir( self.root_dir )

class HTML_sheet(Format):
    pass
