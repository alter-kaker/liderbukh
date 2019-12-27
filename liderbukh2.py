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
from collections import defaultdict

import timeit

class Node:
    def __init__(self, slug, path, parent=None):
        #print( f'{ slug }: Initializing...' )
        self.meta = {
            'slug': slug,
            'path': path,
            'parent': parent }
        try:
            with open(
                os.path.join(
                    self.meta['path'], 'meta.yaml' ) ) as metafile:
                self.meta.update( yaml.load( metafile ) )
        except Exception as e:
             print(
                 f"{ self.meta['slug'] }: Cannot open meta file:" )
             print( e )
        
        self.scan()
    
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
    
    def load_content(self):
        self.content = {}
        for path in self.files:
            slug = os.path.splitext( os.path.basename( path ) )[0]
            with open ( os.path.join( 'templates', f"{ slug }.template" ) ) as template:
                with open( path ) as content:
                    self.content.update( 
                        { slug: 
                            ( content.read(),
                            template.read() )
                                } )
    
    def scan(self):
        self.files = []
        for entry in os.scandir( self.meta['path'] ):
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
        for entry in os.scandir( self.meta['path'] ):
            if entry.is_dir() and os.path.isfile(
                os.path.join( entry.path, 'meta.yaml' ) ):
                slug, path = os.path.split(entry.path)[1], entry.path
                self.children.append( self.child(slug, path, self) )
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
    def __init__(self, slug, path, parent='Entry'):
        slug = f"{slug}-{parent.meta['slug']}"
        super().__init__(slug, path, parent)
        self.meta = {
            **self.meta['parent'].meta,
            **self.meta,
            'textby': None,
            'musicby': None }
    
    def formats(self):
        try:
            self.ly = Ly (
                self.content['music'][0],
                self.meta,
                self.content['music'][1] )
            self.ly.render()
        except KeyError:
            print ( 'Warning: no  music for sheet', self.meta['slug'])
        
        
        try:
            self.tex = Tex (
                self.content['lyrics'][0],
                self.meta,
                self.content['lyrics'][1] )
            self.tex.render()
        except KeyError:
            print ( 'Warning: no lyrics for sheet', self.meta['slug'])

class Entry(Branch):
    child = Sheet

class Category(Branch):
    child = Entry

class Book(Branch):
    child = Category
    
    def formats(self):
        #print(self.content)
        self.html = Html(
            { 'children':
                self.children,
             'text':
                 self.content['index'][0] },
            self.meta,
            self.content['index'][1] )
        self.html.render()

class Format():
    datakey = 'data'
        
    def __init__(self, data, meta, template ):
        self.data = data
        self.meta = meta
        self.template = template
    
    def render( self ):
        template_args = {}
        template_args['string'] = self.template
        template_args['data'] = { self.datakey: self.data }
        template_args['data'].update( self.meta )
        template_args['escape'] = None
        
    
        try:
            self.output = pyratemp.Template( **template_args )()
        
        except Exception as e:
            print( f"{ self.meta['slug'] }: ",
                'Error processing template',
                '\n',
                f'{ e}' )
            raise

class Ly(Format):
    datakey = 'music'

class Tex(Format):
    datakey = 'tex'
    
    def __init__(self, data, meta, template ):
        super().__init__( data, meta, template )
        self.parse_md = mistune.Markdown(
                renderer=lib.marktex.LyricsRenderer(escape=False))
        self.data = self.parse_md( data )
        self.meta.update(
            {
                'ly_path': 'lilypondpath'
                    } )

class Html(Format):
    datakey = 'index'

test1 = """
from __main__ import Node, Branch, Category, Entry, Sheet, Book, Format, Ly, Tex
print('test1')
tree = Book('data', 'data')

for category in tree:
    for entry in category:
        for sheet in entry:
            sheet.load_content()
            sheet.formats()

tree.load_content()
tree.formats()
"""

test2 = """
from __main__ import Node, Branch, Category, Entry, Sheet, Book, Format
print('test2')
tree = Book('data', 'data')
result = tree.query(['rozhinkes-mit-mandlen', 'afn-pripetchik'])

#print(result)
"""


#build tree using Entry
time1 = timeit.timeit(test1, number=100)

##build and query tree using Entry
#time2 = timeit.timeit(test2, number=100)

print(time1)
#print(time2)
