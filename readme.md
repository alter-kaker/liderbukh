# Liderbukh
### A program to create beautiful lead sheets using Python, Lilypond, and LaTeX, with templates and a collection of Yiddish folksongs

Visit the collection: https://liderbukh.jews.international/

## Dependencies:
### Python 3
#### Modules:
* pyratemp
* yaml
* click
* mistune

### Lilypond and lilypond-book
### XeLaTeX
#### Packages:
* multicol
* verse
* fontspec
* graphicx
* polyglossia
* fancyhdr

### Font: Drugulin CLM
* [Link to the font on GitHub](https://github.com/derpayatz/fonts/tree/master/Fonts/Hebrew%20Letters%20only/Culmus%20Project%20(GPL%20and%20GPL%2BFE)/Maxim%20Iorsh%20(GPL)/Basic%20Fonts/Drugulin "Drugulin CLM on GitHub")

## Usage
```
$ chmod +x liderbukh.py
$ ./liderbukh.py --help
usage: liderbukh.py [-h] [-d] [-n] [-i] [query [query ...]]

positional arguments:
  query             list of entries to compile

optional arguments:
  -h, --help        show this help message and exit
  -d, --display     display data tree or query
  -n, --no-write    generate tree but don't write any files
  -i, --index-only  write index.html only




```
## TODO (in no particular order):

* Add option to create a single, book-style pdf 
* Add html export (partly done)
* Add metadata fields for source, arranger, etc
* Add transposition support?
* Add support for multiple templates based on, for example, language and target format
* Add option to process a list of songs, or only new songs 
* Make some meta fields required
* Add auto generated "version" and "last updated" field to song meta, and display it in the index and possibly in the pdf.
* Add html templates for individual songs, with notes
* Add a space for notes on the index page.
