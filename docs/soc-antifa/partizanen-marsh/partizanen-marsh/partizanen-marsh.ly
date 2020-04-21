
\header {
  poet = "טעקסט: ש. קאַטשערגינסקי"
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

mel = \relative a'{ 
  \partial 4 e4 | 
  a a c a |
  b b4 r4 e, |
  b' r8 b d4 r8 b |
  e4 r r8 a a a |
  e4. e8 g4 g |
  f e d c8 c |
  b4. b8 e4 e |
  a, r r r8 e' |
  a,4 a a r8 e' |
  b4 b b r |
  e8 e e e g4 g8 g |
  f2 r4 d8 e |
  f4 f8 f f4 e8 d |
  e4 c8 b a4 c8 d |
  e4 d8 d c4 b8 b |
  \end 3/4 a2 r4  
}

acc = \chordmode { 
  \partial 4 s4 |
  a1:m |
  e:7 |
  e:7 |
  a:m |
  a:7 |
  d:m |
  e:7 |
  a:m |
  a:m |
  d:m6 |
  a:7 |
  d:m |
  d:m |
  a:m |
  e:7 |
  a2.:m
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

