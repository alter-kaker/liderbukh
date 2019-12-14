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

def list_dirs_meta( parent ):
    for dir_path in (
            directory.path
            for directory in os.scandir( parent ) 
            if directory.is_dir()
            and os.path.isfile(
                os.path.join( directory.path, 'meta.yaml' ) ) ):
        with open( os.path.join( dir_path, 'meta.yaml' ) ) as meta_file:
            try:
                dir_meta = yaml.load( meta_file )
            except Exception as e:
                print('YAML error: %s' % e )
                continue
        yield dir_path, dir_meta

def index(data_dir='data'):
    try:
        for cat_path, cat_meta in list_dirs_meta(data_dir):
            for entry_path, entry_meta in list_dirs_meta(cat_path):
                for var_path, var_meta in list_dirs_meta(entry_path):
                    yield {
                        'var_path': var_path,
                        'entry_path': entry_path,
                        'category_path': cat_path,
                        **cat_meta,
                        **entry_meta,
                        **var_meta }
                else:
                    yield {
                        'entry_path': entry_path,
                        'category_path': cat_path,
                        **cat_meta,
                        **entry_meta }
    except ( FileNotFoundError, NotADirectoryError ) as e:
        print('Cannot proceed: %s' % e)
        sys.exit(1)

for i in index('data'):
    try:
        print( f"{ i['var_name'] if ( 'var_name' in i.keys() ) else i['songname'] } — " 
           f"{ i['linewidth'] }" )
    except KeyError as e:
        print( f'KeyError: { e } in { i["songname"] }' )
