\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel = \relative g'{ 
  g8 g4 g8 |
  b af16( b) af8 g |
  b af16( b) af8 g |
  g' d ef d |
  c2 |
  g'8 d ef d |
  c2 |
  \repeat unfold 2 {d8 d4 c8 |
    b af16( g) f8 f |
    g af b af |
  }
  \alternative{
    { b2 |}
    { g2}
  }
}

acc = \chordmode { 
  \repeat unfold 4 { g2:7 | }
  c:m |
  g:7 |
  c:m |
  g:7 |
  f:m |
  f:m |
  g |
  d:7 |
  f:m |
  f:m |
  g
}

\score {
  <<
    \new ChordNames {
        \acc
    }
    \new Staff {
      \clef treble
      \key g \phrygian
      \time 2/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
      \bar "|."

      }
    }
    \new Lyrics \lyricsto "melody" {
      Lo -- mir zikh i -- ber -- be -- tn,
      i -- ber -- be -- tn,
      shtel dem sa -- mo -- var!
      Shtel dem sa -- mo -- var!
      \repeat unfold 2 { 
        Lo -- mir zikh i -- ber -- be -- tn,
        zay zhe nit keyn nar! 
      }
    }
  >>
}