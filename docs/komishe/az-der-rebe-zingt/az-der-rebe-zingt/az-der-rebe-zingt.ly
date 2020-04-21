
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
mel = \relative a' {
    \partial 8 {e8} |
    a b c d e4. e,8 |
    a b c d e4 r8 e( |
    f4) r8 f a4 g8 f |
    e4.( c8) e4 cs |
    d8 d d d d4 b |
    c8 c c c c2 |
    b4 b e8( d) c b |
    a4( b c) cs |
    d8 d d d d4 b |
    c8 c c c c2 |
    b4 b e8( d) c b |
    \end 7/8 a2 a4 r8
  }

acc = \chordmode {
  \partial 8 { s8 }
  a1:m |
  a:m |
  d:m |
  a:m |
  d:m |
  a:m |
  d2:m7 e:7 |
  a2.:m a4:7 |
  d1:m |
  a:m |
  d2:m7 e:7 |
  a8*7:m
  }

\score {
  <<
    \new ChordNames {
        \acc

        }
    \new Staff {
      \clef treble
      \key a \minor
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

