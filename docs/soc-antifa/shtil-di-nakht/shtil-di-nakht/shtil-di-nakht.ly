
\header {
  poet = "טעקסט: הירש גליק"
  title = "שטיל, די נאַכט איז אויסגעשטערנט"
  subtitle = "Shtil, di Nakht Iz Oysgeshternt"
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

mel = \relative d'' {
  e4. c8       |
  f e d c     |
  d4.( c16 b   |
  c4.) r8      |
  g'4. e8       |
  a8 g c, d    |
  e2~           |
  e8 r e e      |

\repeat volta 2 {
   a4 g8 a      |
   f f e a,   |
   d4.( c16 b  | 
   c4.) r8     |
   b4 e8 e      |
   g f e d     | 
}
\alternative {
  {a'2~ | a8 r e e}
  {a,2~ | a4 r }
  }
}

acc = \chordmode {
  { a2:m    	|
    d:m 		|
    e:7   	|
    a:m     	|
    c     	|
    f4: \parenthesize g:7 |
    c2     	|
    \parenthesize e4:7 \once \set chordChanges = ##f e:7 |
  }
  \repeat volta 2 {
    a2:7    	| 
    d4:m a:m 	| 
    e2:7    	| 
    a:m      	|
    e:7     	| 
    \parenthesize d4:m \parenthesize e:7 | 
  }
  \alternative {
    { a2:m  	|
      \parenthesize e4:7 \once \set chordChanges = ##f e:7 |
    }
    { a2:m  	|
      a2:m 
    }
  }
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
      \tempo Andantino
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Shtil, di nakht iz oys -- ge -- shternt
      un der frost hot shtark ge -- brent.
      Tsi ge -- denk -- stu vi ikh hob dikh ge -- lernt
      hal -- tn a shpa -- yer in di hent?
    }
  >>
}

