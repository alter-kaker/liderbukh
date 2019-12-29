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

import os
import yaml
from lib import formats

class Node:
    _level = 0
    _templates = {}
    
    def __init__(self, slug, path, settings, parent):
        
        self.slug = slug        
        self.settings = settings
        self.meta = {
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
                f"{ self.slug }: Cannot open metadata file:" )
            print( e )
        self.scan()
        self.load()
        self.prepare_formats()
    
    def rep(self):
        return "  "*self._level+self.slug
    
    def __repr__( self ):
        rep = f"{ self.rep() }\n"
        try:
            for child in self.children:
                rep += child.__repr__()
        except: pass
        return rep
    
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
    
    def prepare_formats(self):
        self.formats = {}
        for template, v in ( ( i[0], i[1] ) for i in self._templates ):
            try:
                filename = v['filename']
            except:
                filename = f"{ self.slug }.{ v['ext'] }"
            try:
                self.formats.update( {
                    template:
                        v['class'](
                            template, # slug
                            self.data[ v['dataname'] ], #data
                            os.path.join( self.meta['relpath'], filename ),
                            self )
                    } )
            except:
                print(f"Failed to initialize index template")
                raise
        
    def write(self, recurse=True):
        for format in self.formats.values():
            format.render()
            format.write()
            format.copy()
        if recurse:
            try:
                for child in self.children:
                    child.write( recurse=True )
            except:
                pass

class Branch(Node):
    
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
            self.meta['canon']=False
            self.children.sort( key=lambda x: x.slug )
            for i, val in enumerate(self.children):
                if self.children[i].slug == self.slug:
                    self.meta['canon'] = True
                    self.children.insert( 0, self.children.pop(i) )
                    break
    
    def query(self, q):
        if q:
            result = []
            for entry in self.children:
                if entry.slug in q:
                    result.append( entry )
                else:
                    try:
                        result.extend( entry.query(q) )
                    except AttributeError:
                        pass
            return result
        
        else: 
            return self
    
    def __iter__(self):
        return self.children.__iter__()
    
    def __getitem__(self, key):
        return self.children[key]
        
class Sheet(Node):
    _level = 3
    _templates = [
        ( 'music', { 
            'class': formats.Lilypond,
            'dataname': 'music',
            'ext': 'ly' } ),
        ( 'leadsheet', {
            'class': formats.TeX,
            'dataname': 'lyrics',
            'ext': 'lytex' } )
            ]

    def __init__(self, slug, path, settings, parent):        
        super().__init__(slug, path, settings, parent)
        
        self.meta = {
            **self.meta['parent'].meta,
            **self.meta,
            'textby': None,
            'musicby': None }

class Entry(Branch):
    _child = Sheet
    _level = 2
    
    def __repr__(self):
        if len( self.children ) == 1:
            return f"{ self.rep() }\n"
        else:
            return super().__repr__()

class Category(Branch):
    _child = Entry
    _level = 1

class Book(Branch):
    _child = Category
    _templates = [
        ( 'index', { 
            'class': formats.HTML,
            'dataname': 'index', 
            'filename': 'index.html' } )
            ]
    
    def __init__( self, slug, path, settings, parent=None ):
        super().__init__( slug, path, settings, parent )
        self.settings['data_dir'] = path
