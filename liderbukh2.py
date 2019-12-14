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
import timeit

def list_dirs_meta( path ):
    for dir_path in (
            directory.path
            for directory in os.scandir( path ) 
            if directory.is_dir()
            and os.path.isfile(
                os.path.join( directory.path, 'meta.yaml' ) ) ):
        with open( os.path.join( dir_path, 'meta.yaml' ) ) as meta_file:
            try:
                dir_meta = yaml.load( meta_file )
            except Exception as e:
                print('YAML error: %s' % e )
                continue
        yield os.path.split(dir_path)[1], dir_path, dir_meta

def is_var(i): 
        if ( 'entry_slug' in i.keys() ): 
            return True
        else: return False

def index(data_dir='data'):
    try:
        for cat_slug, cat_path, cat_meta in list_dirs_meta( data_dir ):
            for entry_slug, entry_path, entry_meta in list_dirs_meta( cat_path ):
                for var_slug, var_path, var_meta in list_dirs_meta( entry_path ):
                    yield {
                        'slug': var_slug,
                        'entry_slug': entry_slug,
                        'category_slug': cat_slug,
                        'path': var_path,
                        **cat_meta,
                        **entry_meta,
                        **var_meta }
                else:
                    yield {
                        'slug': entry_slug,
                        'category_slug': cat_slug,
                        'path': entry_path,
                        **cat_meta,
                        **entry_meta }
    except ( FileNotFoundError, NotADirectoryError ) as e:
        print('Cannot proceed: %s' % e)
        sys.exit(1)

test1 = """
from __main__ import list_dirs_meta, is_var, index
for i in index('data'):
    try:
        if is_var(i):
            #print( i['entry_slug'] )
            for n in index('data'):
                #print( n )
                if n['slug'] == i['entry_slug']:
                    print( f"וואַריאַציע פֿון: {n['songname']}" )
                #else: print( 'No match' )
        print( f"{ i['var_name'] if ( 'var_name' in i.keys() ) else i['songname'] } — " 
           f"{ i['linewidth'] }" )
    except KeyError as e:
        print( f'KeyError: { e } in { i["songname"] }' )
    
   
    print( i['slug'] )
"""

test2 = """
from __main__ import list_dirs_meta, is_var, index
list = []

for i in index('data'):
    list.append(i)
for i in list:
    try:
        if is_var(i):
            #print( i['entry_slug'] )
            for n in list:
                #print( n )
                if n['slug'] == i['entry_slug']:
                    print( f"וואַריאַציע פֿון: {n['songname']}" )
                #else: print( 'No match' )
        print( f"{ i['var_name'] if ( 'var_name' in i.keys() ) else i['songname'] } — " 
           f"{ i['linewidth'] }" )
    except KeyError as e:
        print( f'KeyError: { e } in { i["songname"] }' )
    
   
    print( i['slug'] )
"""

test3 = """
from __main__ import list_dirs_meta, is_var, index

for n in index('data'):
    if n['slug'] == 'rozhinkes-mit-mandlen':
        print( n['songname'] )
        break
"""

test4 = """
from __main__ import list_dirs_meta, is_var, index
list = []

for i in index('data'):
    list.append(i)

for n in list:
    if n['slug'] == 'rozhinkes-mit-mandlen':
        print( n['songname'] )
        break
"""

test5 = """
from __main__ import list_dirs_meta, is_var, index

songs = ['rozhinkes-mit-mandlen', 'afn-pripetchik']
print([ n['songname'] for n in index('data') 
    if n['slug'] in songs ] )

"""

test6 = """
from __main__ import list_dirs_meta, is_var, index
list = []
songs = ['rozhinkes-mit-mandlen', 'afn-pripetchik']

for i in index('data'):
    list.append(i)

print([ n['songname'] for n in list 
    if n['slug'] in songs ] )
"""

time1 = timeit.timeit(test1, number=100)/100
time2 = timeit.timeit(test2, number=100)/100
print(time1)
print(time2) #faster
#time3 = timeit.timeit(test3, number=100)/100
#time4 = timeit.timeit(test4, number=100)/100
#print(time3) #faster
#print(time4)
#time5 = timeit.timeit(test3, number=100)/100
#time6 = timeit.timeit(test4, number=100)/100
#print(time5) #faster
#print(time6)
