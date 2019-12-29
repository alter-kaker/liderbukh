
\header {
  title = "אַז דער רבי זינגט"
  subtitle = "Az Der Rebe Zingt"
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

mel = \relative a {
    \partial 8 {d8} |
    g a bf c d4. d,8 |
    g a bf c d4 r8 d( |
    ef4) r8 ef g4 f8 ef |
    d4.( bf8) d4 b |
    c8 c c c c4 a |
    bf8 bf bf bf bf2 |
    a4 a d8( c) bf a |
    g4( a bf) b |
    c8 c c c c4 a |
    bf8 bf bf bf bf2 |
    a4 a d8( c) bf a |
    \end 7/8 g2 g4 r8
  }

acc = \chordmode {
  \partial 8 { s8 }
  g1:m |
  g:m |
  c:m |
  g:m |
  c:m |
  g:m |
  c2:m7 d:7 |
  g2.:m g4:7 |
  c1:m |
  g:m |
  c2:m7 d:7 |
  g8*7:m
  }

\score {
  <<
    \new ChordNames {
        \acc

        }
    \new Staff {
      \clef treble
      \key g \minor
      \time 4/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
\bar "|."

        }
      }
    \new Lyrics \lyricsto "melody" {
      Un az der re -- be zingt,
un az der re -- be zingt, 
zin -- gen a -- le kho -- si -- dim,
ay ya ba ba ba bay,
ay ya ba ba ba bay,
zin -- gen a -- le kho -- si -- dim.
Ya ba ba ba bay,
ay ya ba ba ba bay,
zin -- gen a -- le kho -- si -- dim.

      }
    >>
  }

