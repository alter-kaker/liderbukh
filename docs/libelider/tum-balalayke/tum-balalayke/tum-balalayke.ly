
\header {
  title = "טום־באַלאַלײַקע"
  subtitle = "Tum-Balalayke"
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

mel-a = \relative fs''{ 
  d2 d4 |
  d2 d4 |
  d( c) bf |
  a2. |
  c2 c4 |
  c2 d4 |
  c( bf) a |
  g2. |
  g4 bf d |
  g2 g4 |
  bf a g |
  d2 d4 |
  f ef d |
  a2 c4 |
  c bf a |
  g2 g4 |
}
mel-b = \relative fs'' {
  d4 d d |
  d d d |
  d c bf |
  a2 a4 |
  c c c |
  c c c |
  c bf a |
  g2 g4 |
  g bf d |
  g2 g4 |
  bf a g | 
  d2 f4 |
  f ef d |
  a2 c4 |
  c bf a |
  g2.
}

acc-a = \chordmode { 
  g2.:m |
  g:m |
  g:m |
  d:7 |
  c:m6 |
  c:m6 |
  d:7 |
  \repeat unfold 3 { g:m }
  c:m6
  d:7 |
  c:m6 |
  c:m6 |
  d:7 |
  g:m |
}

\score {
  <<
    \new ChordNames {
      \acc-a
      \once \set chordChanges = ##f
      \acc-a

    }
    \new Staff {
      \clef treble
      \key g \minor
      \time 3/4
      \tempo Moderato
      \new Voice = "melody" {
        \mel-a
        \bar "||"
        \mel-b
        \bar "|."

      }
    }
    \new Lyrics \lyricsto "melody" {
      Shteyt a bo -- kher  un er trakht,
      trakht un trakht a gan -- tse nakht:
      ve -- men tsu ne -- men un nit far -- she -- men,
      ve -- men tsu ne -- men un nit far -- she -- men.
      Tum -- ba -- la, tum -- ba -- la, tum ba -- la -- lay -- ke,
      Tum -- ba -- la, tum -- ba -- la, tum ba -- la -- lay -- ke!
      Tum ba -- la -- lay -- ke, shpil ba -- la -- lay -- ke,
      Tum ba -- la -- lay -- ke, frey -- lekh zol zayn!
    }
  >>
}
