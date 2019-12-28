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
from lib import nodes

try:
    with open( 'settings.yaml') as f:
        settings = yaml.load(f.read())
except OSError:
    print ( 'Could not read settings file. Aborting.' )
    sys.exit(1)
        
tree = nodes.Book(
    settings['slug'],
    settings['path'],
    settings['settings']
)

tree.write()

for category in tree:
    for entry in category:
        for sheet in entry:
            sheet.write()
