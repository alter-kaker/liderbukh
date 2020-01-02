\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"
mel = \relative a {
    \partial 8 {d8} |
    g a bf c d4. d,8 |
    g a bf c d4 r8 d( |
    ef4) r8 ef g4 f8 ef |
    d4.( bf8) d4 b |
    c8 c c c c4 a |
    bf8 bf bf bf bf2 |
    a4 a d8( c) bf a |
    g4( a bf) b |
    c8 c c c c4 a |
    bf8 bf bf bf bf2 |
    a4 a d8( c) bf a |
    \end 7/8 g2 g4 r8
  }

acc = \chordmode {
  \partial 8 { s8 }
  g1:m |
  g:m |
  c:m |
  g:m |
  c:m |
  g:m |
  c2:m7 d:7 |
  g2.:m g4:7 |
  c1:m |
  g:m |
  c2:m7 d:7 |
  g8*7:m
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
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
\bar "|."

        }
      }
    \include "../includes/lyrics.ly"
    >>
  }
