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
Usage: liderbukh.py [OPTIONS]

Options:
  -s, --settings-file PATH  Settings file. Default: settings.yaml
  -d, --debug               Turn debug mode on
  -n, --no-write            Generate song data but don't write any files
  -p, --path TEXT           Only process this song file. Please provide path
                            without extension.
  -i, --index-only          Only write index file. Mutually exclusive with
                            --no-write
  --help                    Show this message and exit.


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
