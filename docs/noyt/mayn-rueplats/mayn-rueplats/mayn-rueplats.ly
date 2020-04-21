
\header {
  poet = "טעקסט: מאָריס ראָזענפֿעלד"
  title = "מײַן רועפּלאַץ"
  subtitle = "Mayn Rueplats"
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

\score {
  <<
    \new ChordNames = "mainChords" {
      \chordmode { 
        s4. |
        a2.:m |
        c |
        d2:m6 e4:7 |
        a2.:m |
        a2:m c4:7 |
        f4: g2: |
        g2: c4: |
        a2.:m |
        a2:m d4:m |
        a2:m e4:7 |
        a2.:m | a:m
      }
    }
    \new Staff = "main" {
      \clef treble
      \key a \minor
      \time 3/4
      \tempo Andante
      \new Voice = "melody" {
        \relative d''{ 
          \partial 4. { a8 a8. d16 }
          e4. g8 a8. g16 |
          e4 c8 r16 c e8. e16 |
          e4. c8 d b |
          a4 r8 a c e |
          a4. e8 c'8. b16 |
          a4 g b8. a16 |
          g4. d8 e f |
          e2 e8 e |
          e4.( d16 e f8) d |
          c4.( b16 c d8) b |
          a2.~ |
          \end 3/8 { a4 r8 } |
          \bar "|."
        }
      }
    }
    
    \new Lyrics \lyricsto "melody" {
      Nisht zukh mir vu di mir -- tn gri -- nen,
      ge -- funst mikh dor -- tn nist mayn  shats;
      vu le -- bns vel -- ken bay ma -- shi -- nen—
      dor -- tn iz mayn ru -- e -- plats,
      dor -- tn iz __ mayn ru __ e -- plats. __
    }
  >>
}

