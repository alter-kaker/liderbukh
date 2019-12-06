\version "2.18.2"
\language "english"
\include "../../templates/preamble.ly"

mel = \relative a{ 
  \partial 4 d4 | 
  g g bf g |
  a a4 r4 d, |
  a' r8 a c4 r8 a |
  d4 r r8 g g g |
  d4. d8 f4 f |
  ef d c bf8 bf |
  a4. a8 d4 d |
  g, r r r8 d' |
  g,4 g g r8 d' |
  a4 a a r |
  d8 d d d f4 f8 f |
  ef2 r4 c8 d |
  ef4 ef8 ef ef4 d8 c |
  d4 bf8 a g4 bf8 c |
  d4 c8 c bf4 a8 a |
  \end 3/4 g2 r4  
}

acc = \chordmode { 
  \partial 4 s4 |
  g1:m |
  d:7 |
  d:7 |
  g:m |
  g:7 |
  c:m |
  d:7 |
  g:m |
  g:m |
  c:m6 |
  g:7 |
  c:m |
  c:m |
  g:m |
  d:7 |
  g2.:m
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
      \tempo "Tempo di marcia"
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Der veg iz shver, mir vey -- sn,
      der kamf nit laykht, keyn shpil, 
      a par -- ti -- zan zayn le -- bn leygt in shlakht
      fa -- rn groy -- sn fray -- hayt -- tsil.
      Hey, Ef Pe O, mir zay -- nen do!
      Mu -- ti ke un dray -- ste tsum shlakht!
      Par -- ti -- za -- nen nokh haynt,
      gey -- en shlo -- gn dem faynt,
      i -- nem kamf far an ar -- be -- ter makht!
    }
  >>
}
