\version "2.18.2"
\language "english"
\include "../../templates/preamble.ly"

mel = \relative b {
  d8 g g g |
  bf g g g |
  bf a16 bf c8 bf16( a) |
  bf4 bf8 r |
  bf16 bf a bf c8 bf16( a) |
  bf4 bf8 r |
  \repeat volta 2 {
    d16 d d d d d d d |
    g8 g, g16 g g8 |
  }
  \alternative {
    {
      bf a16( bf) c8 bf16( a) |
      g8( bf) d r
    }
    {
      bf a16( bf) c8 bf16( a) |
      g4 g8 r
    }
  }
}
acc = \chordmode {
  g2:m |
  g:m |
  ef4: f: |
  bf2: |
  c4:m7 d:7 |
  g2:m |
  \repeat volta 2 {
    g2: |
    c4:m7+ g:m |
  }
  \alternative {
    { 
      ef4: f: |
      bf2:
      }
    {
      ef4: d:7 |
      g2:m
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
      \key g \minor
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