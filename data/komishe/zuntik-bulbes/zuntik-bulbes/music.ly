\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel = \relative b {
  e8 a a a |
  c a a a |
  c b16 c d8 c16( b) |
  c4 c8 r |
  c16 c b c d8 c16( b) |
  c4 c8 r |
  \repeat volta 2 {
    e16 e e e e e e e |
    a8 a, a16 a a8 |
  }
  \alternative {
    {
      c b16( c) d8 c16( b) |
      a8( c) e r
    }
    {
      c b16( c) d8 c16( b) |
      a4 a8 r
    }
  }
}
acc = \chordmode {
  a2:m |
  a:m |
  f4: g: |
  c2: |
  d4:m7 e:7 |
  a2:m |
  \repeat volta 2 {
    a2: |
    d4:m7+ a:m |
  }
  \alternative {
    { 
      f4: g: |
      c2:
      }
    {
      f4: e:7 |
      a2:m
    }
  }
}

\score {
  <<
    \new ChordNames {
      \acc
    }
    \new Staff {
      \clef treble
      \key a \minor
      \time 2/4
      \tempo Andantino
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Zun -- tik bul -- be, mon -- tik bul -- be,
      dins -- tik un mit -- vokh bul -- be
      do -- ner -- shtik un fray -- tik bul -- be.
      Sha -- bes far a no -- vi -- ne— 
      a bul -- be ku -- ge -- le…
      \repeat unfold 2 { Zun -- tik vay -- ter bul -- be! }
    }
  >>
}