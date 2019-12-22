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
from collections import defaultdict

import timeit

class Node:
    def __init__(self, slug, path, parent=None):
        #print( f'{ slug }: Initializing...' )
        self.meta = {
            'slug': slug,
            'path': path,
            'parent': parent }
        self.read_meta()
    
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
    
    def read_meta(self):
        #print( f"{ self.meta['slug'] }: Reading meta file" )
        try:
            with open(
                os.path.join(self.meta['path'], 'meta.yaml' ) ) as f:
                self.meta.update( yaml.load( f ) )
        except Exception as e:
             print(
                 f"{ self.meta['slug'] }: Cannot open meta file: { e }"
                 )

class Tree(Node):
    def __init__(self, slug, path, parent=None):
        super().__init__(slug, path, parent)
        self.index = [i for i in self.generate_index()]
    
    def __repr__(self):
        contents = []
        for entry in self.index:
            contents.append(entry)
        if contents:
            repre = '%s: %s' % (self.meta['slug'], contents)
        else:
            repre = self.meta['slug']
        return repre
    
    def query(self, q=False):
        if q:
            result = []
            try:
                q.extend('')
            except AttributeError:
                q = [q]
            for entry in self.index:
                if entry.meta['slug'] in q:
                    result.append( entry )
                else:
                    try:
                        result.extend( entry.query(q) )
                    except AttributeError:
                        pass
            return result
    
    def __iter__(self):
        return self.index.__iter__()
    
    def __getitem__(self, key):
        return self.index[key]
    
    def generate_index(self):
        #print( f'{self.meta['slug']}: Scanning folder...' )
        try:
            for dir_path in (
                    directory.path
                    for directory in os.scandir( self.meta['path'] ) 
                    if directory.is_dir()
                    and os.path.isfile(
                        os.path.join( directory.path, 'meta.yaml' ) ) ):
                slug, path = os.path.split(dir_path)[1], dir_path
                yield self.child(slug, path, self)
        except Exception as e:
            print(f"{ self.meta['slug'] }: Cannot generate index: {e}")
            raise

class Entry(Tree):
    child = Node

class Category(Tree):
    child = Entry

class Book(Tree):
    child = Category

test1 = """
from __main__ import Node, Tree, Category, Entry, Book
print('test1')
tree = Book('data', 'data')

"""

test2 = """
from __main__ import Node, Tree, Category, Entry,  Book
print('test2')
tree = Book('data', 'data')
result = tree.query(['rozhinkes-mit-mandlen', 'afn-pripetchik'])

#print(result)
"""


#build tree using Entry
time1 = timeit.timeit(test1, number=10)

#build and query tree using Entry
time2 = timeit.timeit(test2, number=10)

print(time1)
print(time2)
