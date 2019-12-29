\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

\score {
  <<
    \new ChordNames = "mainChords" {
      \chordmode { 
        s4. |
        g2.:m |
        bf |
        c2:m6 d4:7 |
        g2.:m |
        g2:m bf4:7 |
        ef4: f2: |
        f2: bf4: |
        g2.:m |
        g2:m c4:m |
        g2:m d4:7 |
        g2.:m | g:m
      }
    }
    \new Staff = "main" {
      \clef treble
      \key g \minor
      \time 3/4
      \tempo Andante
      \new Voice = "melody" {
        \relative d'{ 
          \partial 4. { g8 g8. c16 }
          d4. f8 g8. f16 |
          d4 bf8 r16 bf d8. d16 |
          d4. bf8 c a |
          g4 r8 g bf d |
          g4. d8 bf'8. a16 |
          g4 f a8. g16 |
          f4. c8 d ef |
          d2 d8 d |
          d4.( c16 d ef8) c |
          bf4.( a16 bf c8) a |
          g2.~ |
          \end 3/8 { g4 r8 } |
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
