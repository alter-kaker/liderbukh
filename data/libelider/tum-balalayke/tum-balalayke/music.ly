\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel-a = \relative fs''{ 
  d2 d4 |
  d2 d4 |
  d( c) bf |
  a2. |
  c2 c4 |
  c2 d4 |
  c( bf) a |
  g2. |
  g4 bf d |
  g2 g4 |
  bf a g |
  d2 d4 |
  f ef d |
  a2 c4 |
  c bf a |
  g2 g4 |
}
mel-b = \relative fs'' {
  d4 d d |
  d d d |
  d c bf |
  a2 a4 |
  c c c |
  c c c |
  c bf a |
  g2 g4 |
  g bf d |
  g2 g4 |
  bf a g | 
  d2 f4 |
  f ef d |
  a2 c4 |
  c bf a |
  g2.
}

acc-a = \chordmode { 
  g2.:m |
  g:m |
  g:m |
  d:7 |
  c:m6 |
  c:m6 |
  d:7 |
  \repeat unfold 3 { g:m }
  c:m6
  d:7 |
  c:m6 |
  c:m6 |
  d:7 |
  g:m |
}

\score {
  <<
    \new ChordNames {
      \acc-a
      \once \set chordChanges = ##f
      \acc-a

    }
    \new Staff {
      \clef treble
      \key g \minor
      \time 3/4
      \tempo Moderato
      \new Voice = "melody" {
        \mel-a
        \bar "||"
        \mel-b
        \bar "|."

      }
    }
    \new Lyrics \lyricsto "melody" {
      Shteyt a bo -- kher  un er trakht,
      trakht un trakht a gan -- tse nakht:
      ve -- men tsu ne -- men un nit far -- she -- men,
      ve -- men tsu ne -- men un nit far -- she -- men.
      Tum -- ba -- la, tum -- ba -- la, tum ba -- la -- lay -- ke,
      Tum -- ba -- la, tum -- ba -- la, tum ba -- la -- lay -- ke!
      Tum ba -- la -- lay -- ke, shpil ba -- la -- lay -- ke,
      Tum ba -- la -- lay -- ke, frey -- lekh zol zayn!
    }
  >>
}