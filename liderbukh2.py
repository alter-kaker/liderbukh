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
        self.slug = slug
        self.path = path
        self.parent = parent
    
    def __repr__(self):
        return self.slug
    
    def __call__(self, query=None):
        if not query:
            return self
        else:
            if self.slug in query:
                return [self]
            else:
                return None

class Tree(Node):
    def __init__(self, slug, path, parent=None):
        super().__init__(slug, path, parent)
        self.index = [i for i in self.generate_index()]
    
    def __repr__(self):
        contents = []
        for entry in self.index:
            contents.append(entry)
        if contents:
            repre = '%s: %s' % (self.slug, contents)
        else:
            repre = self.slug
        return repre
    
    def __call__(self, query=False):
        if query:
            result = []
            try:
                query.extend('')
            except AttributeError:
                query = [query]
            for entry in self.index:
                if entry.slug in query:
                    result.append( entry )
                else:
                    try:
                        result.extend( entry(query) )
                    except:
                        pass
            return result
        else:
            return self.index
    
    def generate_index(self):
        try:
            for dir_path in (
                    directory.path
                    for directory in os.scandir( self.path ) 
                    if directory.is_dir()
                    and os.path.isfile(
                        os.path.join( directory.path, 'meta.yaml' ) ) ):
                slug, path = os.path.split(dir_path)[1], dir_path
                yield self.child(slug, path, self)
        except Exception as e:
            print(f'Exception: {e}')        

class Entry(Tree):
    child = Node
    def __init__(self, slug, path, parent=None):
        super().__init__(slug, path, parent)
        self.index.insert(0, self.child(slug, path, self))

class Category(Tree):
    child = Entry

class Book(Tree):
    child = Category

test1 = """
from __main__ import index_dir, Node, Tree, Category, Entry, Book
tree = Book('data', 'data')

#print(tree)
"""

test2 = """
from __main__ import index_dir, Node, Tree, Category, Entry,  Book
tree = Book('data', 'data')
result = [n for n in tree(['rozhinkes-mit-mandlen', 'afn-pripetchik'])]

#print(result)
"""


#build tree using Entry
time1 = timeit.timeit(test1, number=1000)

#build and query tree using Entry
time2 = timeit.timeit(test2, number=1000)

print(time1)
print(time2)
