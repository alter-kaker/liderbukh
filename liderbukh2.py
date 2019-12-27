#!/usr/bin/env python3

# Version 2.0
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

import os
import yaml
import sys
import pyratemp
import lib.marktex
import mistune
import subprocess

import timeit

def runerror(exception):
    if exception.stderr:
        print ( exception.stderr.decode() )
    else:
        print ( exception.stdout.decode() )
    sys.exit()

class Node:
    def __init__(self, slug, path, settings, parent):
        #print( f'{ slug }: Initializing...' )
        self.settings = settings
        self.meta = {
            'slug': slug,
            'datapath': path,
            'relpath': os.path.relpath( path, self.settings['data_dir'] ),
            'parent': parent }
        try:
            with open(
                os.path.join(
                    self.meta['datapath'], 'meta.yaml' ) ) as metafile:
                self.meta.update( yaml.load( metafile ) )
        except Exception as e:
             print(
                 f"{ self.meta['slug'] }: Cannot open meta file:" )
             print( e )
        
        self.scan()
        self.load()
    
    def __repr__(self):
        return self.meta['slug']
    
    def __call__(self, query=None):
        if not query:
            return self
        else:
            if self.meta['slug'] in query:
                return [self]
            else:
                return None
    
    def load(self):
        self.data = {}
        for path in self.files:
            slug = os.path.splitext( os.path.basename( path ) )[0]
            with open( path, encoding='utf-8' ) as datum:
                self.data.update( 
                    { slug: datum.read() } )
    
    def scan(self):
        self.files = []
        for entry in os.scandir( self.meta['datapath'] ):
            if ( not entry.is_dir() 
                    and os.path.splitext(entry.path)[1] in ['.ly', '.md'] ):
                self.files.append( entry.path )

class Branch(Node):
    
    def __repr__(self):
        contents = []
        for entry in self.children:
            contents.append(entry)
        if contents:
            repre = '%s: %s' % (self.meta['slug'], contents)
        else:
            repre = self.meta['slug']
        return repre
    
    def scan(self):
        self.children = []
        self.files = []
        for entry in os.scandir( self.meta['datapath'] ):
            if entry.is_dir() and os.path.isfile(
                os.path.join( entry.path, 'meta.yaml' ) ):
                slug, path = os.path.split(entry.path)[1], entry.path
                self.children.append( self._child(slug, path, self.settings, self) )
            elif not entry.name == 'meta.yaml':
                self.files.append( entry.path )
            else: pass
        
        if len(self.children) > 1:
            self.children.sort( key=lambda x: getattr(x, "meta")['slug'] )
    
    def query(self, q=False):
        if q:
            result = []
            try:
                q.extend('')
            except AttributeError:
                q = [q]
            for entry in self.children:
                if entry.meta['slug'] in q:
                    result.append( entry )
                else:
                    try:
                        result.extend( entry.query(q) )
                    except AttributeError:
                        pass
            return result
    
    def __iter__(self):
        return self.children.__iter__()
    
    def __getitem__(self, key):
        return self.children[key]
        
class Sheet(Node):
    def __init__(self, slug, path, settings, parent):
        slug = f"{slug}-{parent.meta['slug']}"
        super().__init__(slug, path, settings, parent)
        
        self.meta = {
            **self.meta['parent'].meta,
            **self.meta,
            'textby': None,
            'musicby': None }
        
        self.template()

    def template (self):
        ly = f"{self.meta['slug']}.ly"
        lytex = f"{self.meta['slug']}.lytex"
        try:
            self.music = Format( 
                'music', 
                self.data['music'], 
                os.path.join(self.meta['relpath'], ly),
                self)
        except:
            print(f"Failed to initialize music template")
            raise
        
        try:
            self.leadsheet = Tex(
                'leadsheet',
                self.data['lyrics'],
                os.path.join(self.meta['relpath'], lytex),
                self,
                {'ly_path': ly} )
        except:
            print(f"Failed to initialize leadsheet template")
            raise
        
    def write(self):
        self.music.render()
        self.music.write()
        self.music.copy()
        
        self.leadsheet.render()
        self.leadsheet.write()
        self.leadsheet.copy()

class Entry(Branch):
    _child = Sheet

class Category(Branch):
    _child = Entry

class Book(Branch):
    _child = Category
    def __init__( self, slug, path, settings, parent=None ):
        super().__init__( slug, path, settings, parent )
        self.settings['data_dir'] = path
        
        self.template()
        self.index.render()
        self.index.write()
        self.index.copy()
    
    def template(self):
        try:
            self.index = Format( 
                'index', 
                self.data['index'], 
                 'index.html',
                self,
                { 'tree': self.children } )
        except:
            print(f"Failed to initialize index template")
            raise

class Format():
    def __init__(self, slug, data, relpath, parent, more={} ):
        self.slug = slug
        self.data = { slug: data,
                            **more}
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
            print( f"{ self.meta['slug'] }: ",
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
            runerror(e)
        print('Success!')

class Tex(Format):
    _onestep = False
    def __init__(self, slug, data, relpath, parent, more={} ):
        super().__init__( slug, data, relpath, parent, more )
        
        self.parse_md = mistune.Markdown(
                renderer=lib.marktex.LyricsRenderer(escape=False))
        self.data[slug] = self.parse_md( data )
        
        pdf_out = os.path.join( 
                    self.output_dir,
                    f"{ os.path.basename(os.path.splitext(self.relpath)[0]) }.pdf" )
        
        if os.path.exists(pdf_out  ):
                self.pdf_relpath = f"{ os.path.splitext(self.relpath)[0] }.pdf" #In case we're only recompiling index or query
    
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
            runerror(e)
        
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
        

#test1 = """
#from __main__ import Node, Branch, Category, Entry, Sheet, Book, Format, Ly, Tex
#print('test1')
tree = Book(
    'data',
    'data',
    {
        'template_dir': 'templates',
        'output_dir': 'docs',
        'data_dir': 'data',
        'temp_dir': 'tmp'
    }
)

for category in tree:
    for entry in category:
        for sheet in entry:
            #sheet.write()
            pass

#"""

test2 = """
from __main__ import Node, Branch, Category, Entry, Sheet, Book, Format
print('test2')
tree = Book('data', 'data')
result = tree.query(['rozhinkes-mit-mandlen', 'afn-pripetchik'])

#print(result)
"""


#build tree using Entry
#time1 = timeit.timeit(test1, number=10)

##build and query tree using Entry
#time2 = timeit.timeit(test2, number=100)

#print(time1)
#print(time2)
