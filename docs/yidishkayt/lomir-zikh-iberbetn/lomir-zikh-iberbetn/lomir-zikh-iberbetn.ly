
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
  a8 a4 a8 |
  cs bf16( cs) bf8 a |
  cs bf16( cs) bf8 a |
  a' e f e |
  d2 |
  a'8 e f e |
  d2 |
  \repeat unfold 2 {e8 e4 d8 |
    cs bf16( a) g8 g |
    a bf cs bf |
  }
  \alternative{
    { cs2 |}
    { a2}
  }
}

acc = \chordmode { 
  \repeat unfold 4 { a2:7 | }
  d:m |
  a:7 |
  d:m |
  a:7 |
  g:m |
  g:m |
  a |
  e:7 |
  g:m |
  g:m |
  a
}

\score {
  <<
    \new ChordNames {
        \acc
    }
    \new Staff {
      \clef treble
      \key a \phrygian
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
