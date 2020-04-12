
\header {
  title = "פּאַרטיזאַנען מאַרש"
  subtitle = "Partizanen Marsh"
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

mel = \relative a{ 
  \partial 4 d4 | 
  g g bf g |
  a a4 r4 d, |
  a' r8 a c4 r8 a |
  d4 r r8 g g g |
  d4. d8 f4 f |
  ef d c bf8 bf |
  a4. a8 d4 d |
  g, r r r8 d' |
  g,4 g g r8 d' |
  a4 a a r |
  d8 d d d f4 f8 f |
  ef2 r4 c8 d |
  ef4 ef8 ef ef4 d8 c |
  d4 bf8 a g4 bf8 c |
  d4 c8 c bf4 a8 a |
  \end 3/4 g2 r4  
}

acc = \chordmode { 
  \partial 4 s4 |
  g1:m |
  d:7 |
  d:7 |
  g:m |
  g:7 |
  c:m |
  d:7 |
  g:m |
  g:m |
  c:m6 |
  g:7 |
  c:m |
  c:m |
  g:m |
  d:7 |
  g2.:m
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
      \tempo "Tempo di marcia"
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Der veg iz shver, mir vey -- sn,
      der kamf nit laykht, keyn shpil, 
      a par -- ti -- zan zayn le -- bn leygt in shlakht
      fa -- rn groy -- sn fray -- hayt -- tsil.
      Hey, Ef Pe O, mir zay -- nen do!
      Mu -- ti ke un dray -- ste tsum shlakht!
      Par -- ti -- za -- nen nokh haynt,
      gey -- en shlo -- gn dem faynt,
      i -- nem kamf far an ar -- be -- ter makht!
    }
  >>
}

