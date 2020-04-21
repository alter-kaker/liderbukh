
\header {
  poet = "טעקסט: מאַרק וואַרשאַווסקי"
  title = "אַפֿן פּריפּעטשיק ברענט אַ פֿײַרל"
  subtitle = "Afn Pripetchik Brent a Fayrl"
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

mel-a = \relative g'{ 
  a8 b c c c4 |
  b8 d c b a4 |
  c8 b c4 d |
  e2. 
}
mel-b = \relative g''{ 
  \repeat volta 2 {
    a8 e g f d b |
    d f e c a4 |
  }
  \alternative {
    { b8( d) c4 d | 
      e2. 
    }
    { b8( d) c4 b | 
      a2. 
    }
  }
}
mel-c = \relative g'{ 
  a8 c b gs e4 | 
  b'8 d c b a4 | 
  c8 b c4 d | 
  e2. | 
}

acc-a = \chordmode { 
  a2.:m | 
  e2:7 a4:m | 
  f2.: | 
  c |  
}
acc-b = \chordmode { 
  \repeat volta 2 { 
    a4:7 d2:m6 | 
    d4:m6 a2:m | }
  \alternative {
    { d4:m a:m d:m | e2.:7 }
    { d4:m6 e2:7 | a2.:m }
  }
}
                      
acc-c = \chordmode { 
  a4:m e2:7 | 
  e2:7 a4:m | 
  f2.: | 
  c2.: | 
}

\score {
  <<
    \new ChordNames {
      \acc-a
      \acc-b
      \acc-c
      \acc-b

        }
    \new Staff {
      \clef treble
      \key a \minor
      \time 3/4
      \tempo Andantino
      \new Voice = "melody" {
        \mel-a
        \mel-b
        \bar "|."
        \mel-c
        \mel-b
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Oy -- fn pri -- pe -- tchik brent a fa -- y -- rl,
      un in shtub iz heys,
      
      \repeat volta 2 {
        un der re -- be le -- rnt klay -- ne kin -- der -- lakh
        }
      \alternative {
        { dem a -- lef beys }  
        { dem a -- lef beys }
        }
      Zetz zhe kin -- der -- lakh,
      gedank zhe ta -- ye -- re
      vos ir he -- rn do,
      \repeat volta 2 {
        zog zhe nokh a mol un ta -- ke nokh a mol
      }
      \alternative {
        { kometz a -- lef: o }
        { kometz a -- lef: o }
      }
    }
  >>
}
