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
import os
import pyratemp
from lib import marktex
from lib import functions

class Format():
    def __init__(self, slug, data, relpath, parent ):
        self.slug = slug
        self.data = { slug: data }
        self.relpath = relpath
        self.parent = parent
        self.temp_path = os.path.join( self.parent.settings['temp_dir'], self.relpath )
        self.temp_dir = os.path.dirname( self.temp_path )
        self.output_dir = os.path.join(
            self.parent.settings['output_dir'],
            os.path.dirname(self.relpath) )
        self.root_dir = os.getcwd()
    
    def render( self ):
        template_args = {}
        with open( os.path.join( self.parent.settings['template_dir'],
                        f"{ self.slug }.template") ) as template:
            template_args['string'] = template.read()
        
        template_args['data'] = {
            **self.data,
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
        
        if not os.path.isdir(self.output_dir):
            try:
                os.makedirs(self.output_dir)
            except Exception as e:
                print('Failed to create output directory at %s: %s' % (self.output_dir, e))
                raise
        
        print(f"Writing { self.temp_path }" )
        try:
            with open( self.temp_path, 'w+', encoding='utf-8') as f:
                f.write(self.output)
                print('Success!')
        
        except Exception as e:
            print( 'Error: %s\n' % (e) )
            
    def copy(self):
        print('Copying %s to output folder...' % self.temp_path )
        try:
            subprocess.run([
                'cp',
                self.temp_path,
                self.output_dir],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            functions.runerror(e)
        print('Success!')

class TeX(Format):
    _onestep = False
    def __init__(self, slug, data, relpath, parent ):
        super().__init__( slug, data, relpath, parent )
        self.data.update( { 'ly_path': f"{ parent.slug }.ly" } )
        
        self.parse_md = marktex.marktex
        self.data[slug] = self.parse_md( data )
        
        pdf_out = os.path.join( 
                    self.output_dir,
                    f"{ os.path.basename(os.path.splitext(self.relpath)[0]) }.pdf" )
        
        self.pdf_relpath = f"{ os.path.splitext(self.relpath)[0] }.pdf" 
    
    def write(self):
        super().write()
        self.lytex_path = self.temp_path
        self.temp_path = f"{ os.path.splitext(self.temp_path)[0] }.pdf"
        
        try:
            os.chdir( self.temp_dir )
        except Exception as e:
            print( 'Cannot open temporary directory: %s' %
                e )
            raise
        
        print('Running lilypond-book...')
        try:
            subprocess.run([
                'lilypond-book',
                '--latex-program=xelatex',
                '--loglevel=ERROR',
                os.path.basename(self.lytex_path)],
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
                os.path.basename(
                    os.path.join(
                        self.parent.settings['temp_dir'], 
                        f"{ os.path.splitext(self.relpath)[0] }.tex") ) ],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE)
        except subprocess.CalledProcessError as e:
            runerror(e)
        
        os.chdir( self.root_dir )

class HTML(Format):
    def __init__(self, slug, data, relpath, parent ):
        super().__init__( slug, data, relpath, parent )
        self.data.update( { 'tree': parent.children } )
