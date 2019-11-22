# Version 1.0
#
# Copyright 2019 Marc Trius
#
# License: 
#
# This file is part of Liderbukh.
# Liderbukh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Liderbukh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import mistune 
import warnings

class LyricsRenderer(mistune.Renderer):
    # Unsupported Elements
    def __init__(self, *args, **kwargs):
      super().__init__(hard_wrap=True, *args, **kwargs)
    
    def not_supported(self, string):
        warnings.warn('%s is not supported, \
output may be broken.' % \
            (stack()[1][3]), Warning, stacklevel=4)
        return self.text(string)

    def block_code(self, string, *_):
        return self.not_supported(string)
    def block_quote(self, string, *_):
        return self.not_supported(string)
    def block_html(self, string, *_):
        return self.not_supported(string)
    def header(self, string, *_):
        return self.not_supported(string)
    def hrule(self, *_):
        return self.not_supported('')
    def list(self, string, *_):
        return self.not_supported(string)
    def list_item(self, string, *_):
        return self.not_supported(string)
    def table(self, string, *_):
        return self.not_supported(string)
    def table_row(self, string, *_):
        return self.not_supported(string)
    def table_cell(self, string, *_):
        return self.not_supported(string)
    def autolink(self, string, *_):
        return self.not_supported(string)
    def codespan(self, string, *_):
        return self.not_supported(string)
    def image(self, string, *_):
        return self.not_supported(string)
    def link(self, string, *_):
        return self.not_supported(string)
    def strikethrough(self, string, *_):
        return self.not_supported(string)
    def inline_html(self, string, *_):
        return self.not_supported(string)
    # Verse Elements
    
    def paragraph(self, text):
        return('%s\\\\!\n\n' % text)
    def emphasis(self, text):
        return('{\em %s}' % text)
    def double_emphasis(self, text):\
        return self.emphasis(text)
    def linebreak(self):
        return('\\\\*\n')
    def newline(self):
        return('\\\\*\n')
