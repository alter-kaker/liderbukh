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

def query_tree(tree, query=[]):
    for slug in query:
        try:
            for category in tree:
                for entry in category['entries']:
                    if slug == entry[0]['slug']:
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
                entry_index = [ {
                    'slug': entry_slug,
                    'path': entry_path } ]
                for variant_slug, variant_path in index_dirs( entry_path ):
                    entry_index.append( {
                        'slug': variant_slug,
                        'path': variant_path } )
                cat_index.append( entry_index )
            index.append( {
                'slug': cat_slug,
                'entries': cat_index } )
        return index
                
    except ( FileNotFoundError, NotADirectoryError ) as e:
        print('Cannot proceed: %s' % e)
        sys.exit(1)
    except: raise

test1 = """
from __main__ import index_dirs, read_dir_meta, index_tree
tree = index_tree('data')
"""

test2 = """

from __main__ import index_dirs, read_dir_meta, query_tree, index_tree

tree = index_tree('data')

result = [ n[0][0]['slug'] for n in query_tree( tree, ['rozhinkes-mit-mandlen', 'afn-pripetchik'] ) ]
"""

#build tree using tree_index
time1 = timeit.timeit(test1, number=1000)

#query index
time2 = timeit.timeit(test2, number=1000)

print(time1) #0.5776s
print(time2) #0.56937
