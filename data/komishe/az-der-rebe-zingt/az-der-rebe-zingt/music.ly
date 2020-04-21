\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"
mel = \relative a' {
    \partial 8 {e8} |
    a b c d e4. e,8 |
    a b c d e4 r8 e( |
    f4) r8 f a4 g8 f |
    e4.( c8) e4 cs |
    d8 d d d d4 b |
    c8 c c c c2 |
    b4 b e8( d) c b |
    a4( b c) cs |
    d8 d d d d4 b |
    c8 c c c c2 |
    b4 b e8( d) c b |
    \end 7/8 a2 a4 r8
  }

acc = \chordmode {
  \partial 8 { s8 }
  a1:m |
  a:m |
  d:m |
  a:m |
  d:m |
  a:m |
  d2:m7 e:7 |
  a2.:m a4:7 |
  d1:m |
  a:m |
  d2:m7 e:7 |
  a8*7:m
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
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
\bar "|."

        }
      }
    \include "../includes/lyrics.ly"
    >>
  }
