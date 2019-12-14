#!/usr/bin/env python3

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
                yield {
                    'entry_path': entry_path,
                    'category_path': cat_path,
                    **cat_meta,
                    **entry_meta }
    except ( FileNotFoundError, NotADirectoryError ) as e:
        print('Cannot proceed: %s' % e)
        sys.exit(1)

for i in index('data'):
    print('%s - %s' % ( i['category_name'], i['songname'] ))
