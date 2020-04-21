
\header {
  title = "זונטיק בולבעס"
  subtitle = "Zuntik Bulbes"
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

mel = \relative b {
  e8 a a a |
  c a a a |
  c b16 c d8 c16( b) |
  c4 c8 r |
  c16 c b c d8 c16( b) |
  c4 c8 r |
  \repeat volta 2 {
    e16 e e e e e e e |
    a8 a, a16 a a8 |
  }
  \alternative {
    {
      c b16( c) d8 c16( b) |
      a8( c) e r
    }
    {
      c b16( c) d8 c16( b) |
      a4 a8 r
    }
  }
}
acc = \chordmode {
  a2:m |
  a:m |
  f4: g: |
  c2: |
  d4:m7 e:7 |
  a2:m |
  \repeat volta 2 {
    a2: |
    d4:m7+ a:m |
  }
  \alternative {
    { 
      f4: g: |
      c2:
      }
    {
      f4: e:7 |
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
      Zun -- tik bul -- be, mon -- tik bul -- be,
      dins -- tik un mit -- vokh bul -- be
      do -- ner -- shtik un fray -- tik bul -- be.
      Sha -- bes far a no -- vi -- ne— 
      a bul -- be ku -- ge -- le…
      \repeat unfold 2 { Zun -- tik vay -- ter bul -- be! }
    }
  >>
}
