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
from lib import parser
from lib import functions

class Format():
    def __init__(self, slug, data, parent ):
        
        self.slug = slug
        self.parent = parent
        self.data = self.parse(data)
    
    def parse(self, data):
        return { 
            key:  self.parser(value) for key, value in data.items()}
    
    def make(self):
        return False
    
    def parser(self, datum):
        return datum
    

class WritableFormat(Format):
    def __init__(self, slug, data, parent, relpath, filename ):
        self.relpath = relpath
        self.filename = filename
        self.root_dir = os.getcwd()
        self.output_filename = filename
        
        super().__init__(slug, data, parent )
        
        self.link = os.path.join(
            self.parent.settings['root'], self.relpath, self.output_filename )
        self.temp_dir = os.path.join(
            self.parent.settings['temp_dir'], relpath )
        self.output_dir = os.path.join(
            self.parent.settings['output_dir'], relpath )
        
        self.template_data = {}
    
    def make(self):        
        print(f'Creating { os.path.join(self.output_dir, self.output_filename) }')
        
        self.render()
        self.write()
        self.copy()
    
    def render( self ):
        template_args = {}
        self.template_data['formats'] = self.parent.formats
        
        with open( os.path.join( self.parent.settings['template_dir'],
                        f"{ self.slug }.template") ) as template:
            template_args['string'] = template.read()
        template_args['data'] = {
            **self.data,
            **self.template_data,
            **self.parent.meta
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
        
    def write( self ):
        if not os.path.isdir(self.temp_dir):
            try:
                os.makedirs(self.temp_dir)
            except Exception as e:
                print('Failed to create output directory at %s: %s' % (self.output_dir, e))
                raise        
        
        path = os.path.join( self.temp_dir, self.filename )
        
        try:
            print('writing', path)
            with open( path, 'w+', encoding='utf-8') as f:
                f.write(self.output)
        
        except Exception as e:
            print( 'Error: %s\n' % (e) )
            
    def copy(self):
        
        if not os.path.isdir(self.output_dir):
            try:
                os.makedirs(self.output_dir)
            except Exception as e:
                print('Failed to create output directory at %s: %s' % (self.output_dir, e))
                raise
        
        try:
            subprocess.run([
                'cp',
                os.path.join( self.temp_dir, self.output_filename ),
                self.output_dir],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            functions.runerror(e)

class TeX(WritableFormat):
    def __init__(self, slug, data, parent, relpath, filename ):
        super().__init__( slug, data, parent, relpath, filename )
        self.texname = f"{ os.path.splitext(filename)[0] }.tex"
        self.output_filename = f"{ os.path.splitext(filename)[0] }.pdf"
        self.link = os.path.join(
            self.parent.settings['root'], self.relpath, self.output_filename )
    
    def parser(self, datum):
        return parser.parse_tex(datum)
    
    def write(self):
        super().write()
        
        try:
            os.chdir( self.temp_dir )
        except Exception as e:
            print( 'Cannot open temporary directory: %s' %
                e )
            raise
        
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

class Lilypond(WritableFormat):
    def parser(self, datum):
        try:
            os.chdir( os.path.join( self.parent.settings['data_dir'], self.relpath ) )
            matches = re.findall(r"(?:\\include )[\"](.+)[\"]", datum, flags=0)
            for match in matches:
                with open(match) as include:
                    datum = datum.replace(f'\include "{match}"', include.read())
            os.chdir( self.root_dir )
            return datum
        except Exception as e:
            print( e )
            raise
        

class PNG(Lilypond):
    def __init__(self, slug, data, parent, relpath, filename ):
        
        super().__init__( slug, data, parent, relpath, filename )
        
        self.basename = os.path.splitext(filename)[0]
        self.output_filename = self.filename
        self.filename = f"{ self.basename }.htmly"
    
    def render(self):
        self.musicsource = f"{ self.basename }.pngly"
        self.template_data['musicsource'] = self.musicsource
        
        super().render()
        
    def write(self):
        super().write()
        try:
            os.chdir( self.temp_dir )
        except Exception as e:
            print( 'Cannot open temporary directory: %s' %
                e )
            raise
        try:
            with open( self.musicsource, 'w+', encoding='utf-8') as f:
                f.write(self.data['music'])
        
        except Exception as e:
            print( 'Error: %s\n' % (e) )
        
        try:
            subprocess.run([
                'lilypond-book',
                '--loglevel=ERROR',
                '--format=html',
                '--lily-output-dir=lily',
                '--use-source-file-names',
                self.filename],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            functions.runerror(e)
        
        os.chdir( self.root_dir )



class HTML(Format):
    def parser(self, datum):
        return parser.parse_html(datum)

class HTML_page(HTML, WritableFormat):
    def __init__(self, slug, data, parent, relpath, filename ):
        super().__init__( slug, data, parent, relpath, 'index.html' )
        self.template_data.update( { 
            'tree': parent.root,
            'canonical_url': os.path.join(
                parent.settings['root'], relpath, filename ),
            'children': self.parent.children } )
        self.link = os.path.join(
            self.parent.settings['root'], self.relpath )

class HTML_index(HTML_page):
    pass

class HTML_sheet(HTML):
    pass
