# Liderbukh
### A program to create beautiful lead sheets using Python, Lilypond, and LaTeX, with templates and a collection of Yiddish folksongs

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
  -f, --filename TEXT       Only process this song file. Please provide
                            filename without extension.
  --help                    Show this message and exit.

```
## TODO (in no particular order):

* Add option to create a single, book-style pdf 
* Add html export
* Add metadata fields for source, arranger, etc
* Add transposition support?
* Add support for multiple templates based on, for example, language and target format
* Show song category in lead sheet template
* Add option to process one song at a time (done), or a list of songs, or only new songs 
* Generate index file for songs
* Make some meta fields required
