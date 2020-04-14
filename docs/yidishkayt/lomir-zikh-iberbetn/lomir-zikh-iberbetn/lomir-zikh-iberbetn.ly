
\header {
  title = "לאָמיר זיך איבערבעטן"
  subtitle = "Lomir Zikh Iberbetn"
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

mel = \relative g'{ 
  g8 g4 g8 |
  b af16( b) af8 g |
  b af16( b) af8 g |
  g' d ef d |
  c2 |
  g'8 d ef d |
  c2 |
  \repeat unfold 2 {d8 d4 c8 |
    b af16( g) f8 f |
    g af b af |
  }
  \alternative{
    { b2 |}
    { g2}
  }
}

acc = \chordmode { 
  \repeat unfold 4 { g2:7 | }
  c:m |
  g:7 |
  c:m |
  g:7 |
  f:m |
  f:m |
  g |
  d:7 |
  f:m |
  f:m |
  g
}

\score {
  <<
    \new ChordNames {
        \acc
    }
    \new Staff {
      \clef treble
      \key g \phrygian
      \time 2/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
      \bar "|."

      }
    }
    \new Lyrics \lyricsto "melody" {
      Lo -- mir zikh i -- ber -- be -- tn,
      i -- ber -- be -- tn,
      shtel dem sa -- mo -- var!
      Shtel dem sa -- mo -- var!
      \repeat unfold 2 { 
        Lo -- mir zikh i -- ber -- be -- tn,
        zay zhe nit keyn nar! 
      }
    }
  >>
}
