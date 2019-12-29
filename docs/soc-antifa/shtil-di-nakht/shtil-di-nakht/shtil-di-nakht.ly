
\header {
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
  d4. bf8       |
  ef d c bf     |
  c4.( bf16 a   |
  bf4.) r8      |
  f'4. d8       |
  g8 f bf, c    |
  d2~           |
  d8 r d d      |

\repeat volta 2 {
   g4 f8 g      |
   ef ef d g,   |
   c4.( bf16 a  | 
   bf4.) r8     |
   a4 d8 d      |
   f ef d c     | 
}
\alternative {
  {g'2~ | g8 r d d}
  {g,2~ | g4 r }
  }
}

acc = \chordmode {
  { g2:m    	|
    c:m 		|
    d:7   	|
    g:m     	|
    bf     	|
    ef4: \parenthesize f:7 |
    bf2     	|
    \parenthesize d4:7 \once \set chordChanges = ##f d:7 |
  }
  \repeat volta 2 {
    g2:7    	| 
    c4:m g:m 	| 
    d2:7    	| 
    g:m      	|
    d:7     	| 
    \parenthesize c4:m \parenthesize d:7 | 
  }
  \alternative {
    { g2:m  	|
      \parenthesize d4:7 \once \set chordChanges = ##f d:7 |
    }
    { g2:m  	|
      g2:m 
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
      \key g \minor
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

