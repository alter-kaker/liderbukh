
\header {
  composer = "מוזיק: אַראַנזשירן פֿון זאַלמאַן מלאָטעק"
  title = "אין אַלע גאַסן, דאַלאָיי פּאָליציי"
  subtitle = "In Ale Gasn, Daloy Politsey"
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

mel-a = \relative d'' {
  \partial 8 { e8 }
  a e a e f f e4 |
  c8 c d d e e4.
  \repeat volta 2 {
    a8 e a e f f e4 |
    c8 c b b a a4.
  }
}
mel-b = \relative d'' {
  e4 c8. b16 a4 e' |
  \tuplet 3/2 { f8 d d } \tuplet 3/2 { d d d } d2 |
  e8. e16 e8 f e d c b |
  c4 a8 a a2 |
  \repeat volta 2 {
    e'2 d4. g8 |
    e4 e8 e d4. d8 |
    c4 \tuplet 3/2 { c8 c c } b4 e |
    }
  \alternative {
    { r a, a8( b c d) | }
    { r4 a'4 a2 | }
  }  
}
      
acc-a = \chordmode {
  \partial 8 { s8 }
  a2:m d4:m a:m |
  f: d:m a2:m |
  a:m d4:m a:m |
  f:m e:7 a2:m |
}
acc-b = \chordmode {
  c: a:m |
  d1:m |
  e:7 |
  a:m |
  a2:7 d:m |
  a:7 d:m |
  a:m e:7 |
  d:m a:m |
  \once \set chordChanges = ##f d:m a:m |
}

\score {
  \header { piece = "אין אַלע גאַסן" }
  <<
    \new ChordNames {
        \acc-a

        }
    \new Staff {
      \clef treble
      \key a \minor
      \time 4/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel-a 

        }
      }
    \new Lyrics \lyricsto "melody" {
      In a -- le ga -- sn vu men geyt
      hert men za -- ba -- stov -- kes.
      Ying -- lekh, meyd -- lekh, kind un keyt
      shmu -- esn fun pri -- bov -- kes.

    }
  >>
}
\score {
  \header { piece = "דאַלאָיי פּאָליציי" }
  <<
    \new ChordNames {
      \acc-b
    }
    \new Staff {
      \clef treble
      \key a \minor
      \time 4/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel-b
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Bri -- der un shves -- ter,
      lo -- mir zikh ge -- bn di hent,
      lo -- mir ni -- ko -- lay -- ke -- len tse -- bre -- khn di vent!
      Hey, hey da -- loy po -- li -- tsey,
      da -- loy sa -- mo -- der -- zhav -- yets 
      vra -- sey! __ 
      vra -- sey!
    }
  >>
}

