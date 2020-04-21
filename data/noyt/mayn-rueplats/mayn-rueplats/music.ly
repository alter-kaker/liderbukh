\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

\score {
  <<
    \new ChordNames = "mainChords" {
      \chordmode { 
        s4. |
        a2.:m |
        c |
        d2:m6 e4:7 |
        a2.:m |
        a2:m c4:7 |
        f4: g2: |
        g2: c4: |
        a2.:m |
        a2:m d4:m |
        a2:m e4:7 |
        a2.:m | a:m
      }
    }
    \new Staff = "main" {
      \clef treble
      \key a \minor
      \time 3/4
      \tempo Andante
      \new Voice = "melody" {
        \relative d''{ 
          \partial 4. { a8 a8. d16 }
          e4. g8 a8. g16 |
          e4 c8 r16 c e8. e16 |
          e4. c8 d b |
          a4 r8 a c e |
          a4. e8 c'8. b16 |
          a4 g b8. a16 |
          g4. d8 e f |
          e2 e8 e |
          e4.( d16 e f8) d |
          c4.( b16 c d8) b |
          a2.~ |
          \end 3/8 { a4 r8 } |
          \bar "|."
        }
      }
    }
    
    \new Lyrics \lyricsto "melody" {
      Nisht zukh mir vu di mir -- tn gri -- nen,
      ge -- funst mikh dor -- tn nist mayn  shats;
      vu le -- bns vel -- ken bay ma -- shi -- nen—
      dor -- tn iz mayn ru -- e -- plats,
      dor -- tn iz __ mayn ru __ e -- plats. __
    }
  >>
}
