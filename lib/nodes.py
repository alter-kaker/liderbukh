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
    
    def __init__(self, slug, path, settings, parent, root):
        
        self.slug = slug        
        self.root = root
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
        for template, v in ( ( i[0], i[1] ) for i in self.templates ):
            try:
                filename = f"{ self.slug }.{ v['ext'] }"
            except:
                filename = v['filename']
            try:
                self.formats.update( {
                    template:
                        v['class'](
                            template, # slug
                            self.data, #data
                            self.meta['relpath'], #relpath
                            filename, #filename
                            self ) # parent
                    } )
            except:
                print(f"{self.slug}: Failed to initialize template {template}")
                raise
        
    def write(self, recurse=True):
        for format in self.formats.values():
            format.render()
            format.write()
            format.copy()
        

class Branch(Node):
    
    def scan(self):
        self.children = []
        for entry in os.scandir( self.meta['datapath'] ):
            if entry.is_dir() and os.path.isfile(
                os.path.join( entry.path, 'meta.yaml' ) ):
                slug, path = os.path.split(entry.path)[1], entry.path
                self.children.append( self._child(slug, path, self.settings, self, self.root) )
        
        if len(self.children) > 1:
            self.meta['canon']=False
            self.children.sort( key=lambda x: x.slug )
            for i, val in enumerate(self.children):
                if self.children[i].slug == self.slug:
                    self.meta['canon'] = True
                    self.children.insert( 0, self.children.pop(i) )
                    break
        super().scan()
    
    def query(self, q):
        if q:
            result = Result()
            for entry in self.children:
                if entry.slug in q:
                    result.children.append( entry )
                else:
                    try:
                        result.children.extend( entry.query(q) )
                    except AttributeError:
                        pass
            return result
        
        else: 
            return self
    
    def __iter__(self):
        return self.children.__iter__()
    
    def __getitem__(self, key):
        return self.children[key]
    
    def write(self, recurse=True):
        super().write(recurse = recurse)
        if recurse:
                #try:
                    for child in self.children:
                        try:
                            child.write( recurse=True )
                        except Exception as e:
                            print(f'Error writing: {child.slug}, {e}')
                            raise
                #except:
                    #pass
        
class Sheet(Node):
    _level = 3

    def __init__(self, slug, path, settings, parent, root):               
        self.templates = [
            ( 'music', { 
                'class': formats.Lilypond,
                'ext': 'ly' } ),
            ( 'leadsheet', {
                'class': formats.TeX,
                'ext': 'lytex' } ),
            ( 'image', {
                'class': formats.PNG,
                'ext': 'png' } )
            #( 'HTML_fragment', {
                #'class': formats.HTML_fragment,
                #'ext': 'htmly' } )
                ]
        
        super().__init__(slug, path, settings, parent, root)

        self.meta = {
            **self.meta['parent'].meta,
            **self.meta,
            'textby': None,
            'musicby': None }

class Entry(Branch):
    _child = Sheet
    _level = 2
    
    def __init__(self, slug, path, settings, parent, root):               
        self.templates = [
            #( 'page', {
                #'class': formats.HTML_page,
                #'ext': 'html' } )
                ]
        
        super().__init__(slug, path, settings, parent, root)
    def __repr__(self):
        if len( self.children ) == 1:
            return f"{ self.rep() }\n"
        else:
            return super().__repr__()

class Category(Branch):
    _child = Entry
    _level = 1
    def prepare_formats(self):
        pass

class Book(Branch):
    _child = Category
    
    def __init__( self, slug, path, settings ):
        self.templates = [
        ( 'index', { 
            'class': formats.HTML_index,
            'filename': 'index.html' } )
            ]
        super().__init__( slug, path, settings, None, self )
        self.settings['data_dir'] = path
        
class Result(Branch):
    def __init__(self):
        self.children = []
        self.slug = 'result'
    def write(self):
        for child in self.children:
            child.write( recurse=True )
