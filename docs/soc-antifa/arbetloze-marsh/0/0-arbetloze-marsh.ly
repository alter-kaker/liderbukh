
\header {
  title = "ארבעטלאָזע מאַרש"
  subtitle = "Arbetloze Marsh"
  }
\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel = \relative g' {
  g8 r d r    |
  g r bf r    |
  a bf c d    |
  bf a g4     |
  g8 a bf c   |
  d ef d4     |
  d8 g f ef   |
  d ef d4     |
  c8 d ef c   |
  bf c d bf   |
  a bf c d    |
  c bf a g    |
  fs g a d,   |
  g bf d4     |
  c8 d16( ef) d8 c |
  bf a g4     |
  fs8 g a d,  |
  bf' r a r   |
  g2~   |
  g4 r
  }

acc = \chordmode {
  g2:m  |
  g:m   |
  d:7      |
  g:m      |
  f:7      |
  bf       |
  g:7      |
  bf       |
  c:m      |
  g:m      |
  d:7      |
  g:m      |
  d:7      |
  g:m      |
  c:m      |
  g:m      |
  d:7      |
  bf4 d4:7  |
  g2:m      |
  g:m
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
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
\bar "|."

        }
      }
    \new Lyrics \lyricsto "melody" {
      Ayns tzvey dray fir
ar -- bet -- lo -- se ze -- nen mir.
Nit ge -- hert kha -- do -- shim lang
in fa -- brik dem ha -- mer klang,
s'li -- gn key -- lim kalt far -- ge -- sen,
s'nemt der zha -- ver zey shoyn fre -- sen.
Gey -- en mir a -- rum in gas
vi di gvi -- rim pust un pas,
vi di gvi -- rim pust un pas.

      }
    >>
  }

