\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

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
