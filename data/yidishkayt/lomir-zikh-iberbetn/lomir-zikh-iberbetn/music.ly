\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel = \relative g'{ 
  a8 a4 a8 |
  cs bf16( cs) bf8 a |
  cs bf16( cs) bf8 a |
  a' e f e |
  d2 |
  a'8 e f e |
  d2 |
  \repeat unfold 2 {e8 e4 d8 |
    cs bf16( a) g8 g |
    a bf cs bf |
  }
  \alternative{
    { cs2 |}
    { a2}
  }
}

acc = \chordmode { 
  \repeat unfold 4 { a2:7 | }
  d:m |
  a:7 |
  d:m |
  a:7 |
  g:m |
  g:m |
  a |
  e:7 |
  g:m |
  g:m |
  a
}

\score {
  <<
    \new ChordNames {
        \acc
    }
    \new Staff {
      \clef treble
      \key a \phrygian
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