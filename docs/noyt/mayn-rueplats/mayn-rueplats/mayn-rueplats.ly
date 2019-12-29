
\header {
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
        g2.:m |
        bf |
        c2:m6 d4:7 |
        g2.:m |
        g2:m bf4:7 |
        ef4: f2: |
        f2: bf4: |
        g2.:m |
        g2:m c4:m |
        g2:m d4:7 |
        g2.:m | g:m
      }
    }
    \new Staff = "main" {
      \clef treble
      \key g \minor
      \time 3/4
      \tempo Andante
      \new Voice = "melody" {
        \relative d'{ 
          \partial 4. { g8 g8. c16 }
          d4. f8 g8. f16 |
          d4 bf8 r16 bf d8. d16 |
          d4. bf8 c a |
          g4 r8 g bf d |
          g4. d8 bf'8. a16 |
          g4 f a8. g16 |
          f4. c8 d ef |
          d2 d8 d |
          d4.( c16 d ef8) c |
          bf4.( a16 bf c8) a |
          g2.~ |
          \end 3/8 { g4 r8 } |
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

