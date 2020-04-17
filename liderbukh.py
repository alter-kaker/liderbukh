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

import yaml
import sys
import argparse

from lib import nodes

try:
    with open( 'settings.yaml') as f:
        settings = yaml.load(f.read())
except OSError:
    print ( 'Could not read settings file. Aborting.' )
    sys.exit(1)

parser = argparse.ArgumentParser(
    description='Create beautiful lead sheets using Python, Lilypond, and LaTeX, with templates and a collection of Yiddish folksongs.' )

parser.add_argument(
    '-d', '--display', 
    help = 'display data tree or query',
    action='store_true' )

parser.add_argument(
    '-n', '--no-write',
    help = 'generate tree but don\'t write any files',
    action='store_true' )

parser.add_argument(
    'query', 
    help='list of entries to compile',
    nargs='*' )

parser.add_argument(
    '-i', '--index-only',
    help='write index.html only',
    action='store_false' )

parser.add_argument(
    '-r', '--remote-build',
    help='build with http links',
    action='store_true' )

if __name__ == "__main__":
    args = parser.parse_args()
    
    if args.remote_build:
        settings['settings'].update( {'root': settings['settings']['http_root'] } )
    else:
        settings['settings'].update( {'root': settings['settings']['local_root'] } )

    tree = nodes.Book(
        settings['slug'],
        settings['path'],
        settings['settings']
    )
    
    print (f'Remote build: {args.remote_build}')
    
    if len(args.query) > 0:
        result = tree.query(args.query)
        if args.display:
            print(result)
        if not args.no_write:
            tree.make(recurse=False)
            result.make()
    else:
        if args.display:
            print(tree)
        if not args.no_write:
            tree.make(recurse=True)
