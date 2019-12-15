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

def index_dirs( path ):
    for dir_path in (
            directory.path
            for directory in os.scandir( path ) 
            if directory.is_dir()
            and os.path.isfile(
                os.path.join( directory.path, 'meta.yaml' ) ) ):
        yield os.path.split(dir_path)[1], dir_path

def read_dir_meta( path ):
        with open( os.path.join( path, 'meta.yaml' ) ) as meta_file:
            try:
                meta = yaml.load( meta_file )
                return meta
            except Exception as e:
                print('YAML error: %s' % e )

def is_var(i): 
        if ( 'entry_slug' in i.keys() ): 
            return True
        else: return False

def query_tree(tree, query=[]):
    for slug in query:
        try:
            for category in tree:
                for entry in category['entries']:
                    if slug == entry['slug']:
                        yield entry, category['slug']
                        
        except Exception as e:
            print('Cannot proceed: %s' % e)
            raise
            sys.exit(1)

def index_tree(data_dir):
    index = []
    try:
        for cat_slug, cat_path in index_dirs( data_dir ):
            cat_index = []
            for entry_slug, entry_path in index_dirs( cat_path ):
                var_index = []
                for var_slug, var_path in index_dirs( entry_path ):
                    var_index.append( {
                        'slug': var_slug,
                        'path': var_path } )
                entry = {
                    'slug': entry_slug,
                    'path': entry_path,
                    'variations': var_index }
                cat_index.append( entry )
            index.append( {
                'slug': cat_slug,
                'path': cat_path,
                'entries': cat_index } )
        return index
                
    except ( FileNotFoundError, NotADirectoryError ) as e:
        print('Cannot proceed: %s' % e)
        sys.exit(1)

test1 = """
from __main__ import index_dirs, read_dir_meta, is_var, index_tree
tree = index_tree('data')
"""

test2 = """

from __main__ import index_dirs, read_dir_meta, is_var, query_tree, index_tree

tree = index_tree('data'), ['rozhinkes-mit-mandlen', 'afn-pripetchik']

result = [ n for n in query_tree( tree ) ]

"""

#build tree using tree_index
time1 = timeit.timeit(test1, number=1000)

#query index
time2 = timeit.timeit(test2, number=1000)

print(time1) #0.5776s
print(time2) #0.56937
