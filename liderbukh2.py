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

def index(data_dir='data'):
    try:
        for cat_slug, cat_path in index_dirs( data_dir ):
            for entry_slug, entry_path in index_dirs( cat_path ):
                for var_slug, var_path in index_dirs( entry_path ):
                    yield {
                        'slug': var_slug,
                        'entry_slug': entry_slug,
                        'category_slug': cat_slug,
                        'path': var_path }
                else:
                    yield defaultdict( list,
                        {
                        'slug': entry_slug,
                        'category_slug': cat_slug,
                        'path': entry_path } )
    except ( FileNotFoundError, NotADirectoryError ) as e:
        print('Cannot proceed: %s' % e)
        sys.exit(1)

def build_tree( data_dir='data' ):
    items = []
    for item in index( data_dir ):
        items.append(item)
    tree = defaultdict(list)
    for item in items:
        if is_var(item):
            for entry in items:
                if entry['slug'] == item['entry_slug']:
                    entry['variations'].append(item)
                    tree[item['category_slug']].append(entry)
        else: tree[item['category_slug']].append(item)
    return tree

test1 = """
from __main__ import index_dirs, read_dir_meta, is_var, index
list = []

for i in index('data'):
    list.append(i)
for i in list:
    try:
        if is_var(i):
            for n in list:
                if n['slug'] == i['entry_slug']:
                    #print( f"Variation: {n['slug']}" )
                    pass
    except KeyError as e:
        print( f'KeyError: { e } in { i["slug"] }' )
    
   
    #print( i['slug'] )
"""

test2 = """
from __main__ import index_dirs, read_dir_meta, is_var, index
list = []

for i in index('data'):
    list.append(i)
for i in list:
    i.update(**read_dir_meta(i['path']))
    try:
        if is_var(i):
            #print( i['entry_slug'] )
            for n in list:
                #print( n )
                if n['slug'] == i['entry_slug']:
                    print( f"וואַריאַציע פֿון: {read_dir_meta(n['path'])['songname']}" )
                #else: print( 'No match' )
        print( f"{ i['var_name'] if ( 'var_name' in i.keys() ) else i['songname'] } — " 
           f"{ i['linewidth'] }" )
    except KeyError as e:
        print( f'KeyError: { e } in { i["songname"] }' )
    
   
    print( i['slug'] )
"""

test3 = """
from __main__ import index_dirs, read_dir_meta, is_var, index
songs = ['rozhinkes-mit-mandlen', 'afn-pripetchik']

list = [ n for n in index( 'data' ) 
    if n['slug'] in songs ]

meta = [ (read_dir_meta(item['path'])['songname']) for item in list ]

print(meta)
"""

test4 = """
from __main__ import index_dirs, read_dir_meta, is_var, index, build_tree
tree = build_tree()
"""

#index only
time1 = timeit.timeit(test1, number=100)/100

#index with meta
time2 = timeit.timeit(test2, number=100)/100

#find songs from list and fetch meta
time3 = timeit.timeit(test3, number=100)/100 
time4 = timeit.timeit(test4, number=100)/100

print(time1) #0.0008s
print(time2) #0.0262s
print(time3) #0.0252s
print(time4)
