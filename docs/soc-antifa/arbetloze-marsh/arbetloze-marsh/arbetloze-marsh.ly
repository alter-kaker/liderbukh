
\header {
  poet = "טעקסט: מרדכי געבירטיג"
  title = "ארבעטלאָזע מאַרש"
  subtitle = "Arbetloze Marsh"
  }
\version "2.18.2"
\language "english"
#(set-global-staff-size 17)

end =
  #(define-music-function
    (parser location signature)
    (fraction?)
  #{
    \once \omit Staff.TimeSignature \time #signature
  #})

\layout {
  \context {  % Use Typewriter font for chord symbols
    \ChordNames {
      \set chordChanges = ##t
      \override ChordName.font-family = #'typewriter
      }
    }
  \context {  % Change font size for lyrics
    \Lyrics {
      \override LyricText.font-size = #'-1
      }
    }
  \context {  % Beam according to rhythm
    \Staff {
      \set Timing.beamExceptions = #'()
      }
    }
  }

\paper {      % Load fonts
  fonts = #
  (make-pango-font-tree
   "Linux Libertine"
   "Linux Biolinum"
   "Courier 10 Pitch"
   (/ (* staff-height pt) 2.5)
    )
  bookTitleMarkup = \markup {
    \override #'(baseline-skip . 3.5)
    \column {
      \fill-line { \fromproperty #'header:dedication }
      \override #'(baseline-skip . 3.5)
      \column {
        \fill-line {
          \override #'(font-name . "Drugulin CLM")
          \huge \larger \larger \bold
          \fromproperty #'header:title
          }
        \fill-line {
          \large \bold
          \fromproperty #'header:subtitle
          }
        \fill-line {
          \smaller \bold
          \fromproperty #'header:subsubtitle
          }
        \fill-line {
          \fromproperty #'header:meter
          \fromproperty #'header:arranger
          }
          \fill-line {
          \override #'(font-name . "Drugulin CLM")
          \fromproperty #'header:composer
          { \large \bold \fromproperty #'header:instrument }
          \override #'(font-name . "Drugulin CLM")
          \fromproperty #'header:poet
          }
        }
      }
    }
    scoreTitleMarkup = \markup {
      \column {
      \on-the-fly \print-all-headers { \bookTitleMarkup \hspace #1 }
      \fill-line {
        \null
        \override #'(font-name . "Drugulin CLM")
        \huge
        \lower #5
        \fromproperty #'header:piece
        }
      }
    }
  }

mel = \relative g' {
  a8 r e r    |
  a r c r    |
  b c d e    |
  c b a4     |
  a8 b c d   |
  e f e4     |
  e8 a g f   |
  e f e4     |
  d8 e f d   |
  c d e c   |
  b c d e    |
  d c b a    |
  gs a b e,   |
  a c e4     |
  d8 e16( f) e8 d |
  c b a4     |
  gs8 a b e,  |
  c' r b r   |
  a2~   |
  a4 r
  }

acc = \chordmode {
  a2:m  |
  a:m   |
  e:7      |
  a:m      |
  g:7      |
  c       |
  a:7      |
  c       |
  d:m      |
  a:m      |
  e:7      |
  a:m      |
  e:7      |
  a:m      |
  d:m      |
  a:m      |
  e:7      |
  c4 e4:7  |
  a2:m      |
  a:m
  }

\score {
  <<
    \new ChordNames {
        \acc

        }
    \new Staff {
      \clef treble
      \key a \minor
      \time 2/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
\bar "|."

        }
      }
    \new Lyrics \lyricsto "melody" {
      Ayns tzvey dray fir
ar -- bet -- lo -- se ze -- nen mir.
Nit ge -- hert kha -- do -- shim lang
in fa -- brik dem ha -- mer klang,
s'li -- gn key -- lim kalt far -- ge -- sen,
s'nemt der zha -- ver zey shoyn fre -- sen.
Gey -- en mir a -- rum in gas
vi di gvi -- rim pust un pas,
vi di gvi -- rim pust un pas.

      }
    >>
  }

