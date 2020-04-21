\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel = \relative a'{ 
  \partial 4 e4 | 
  a a c a |
  b b4 r4 e, |
  b' r8 b d4 r8 b |
  e4 r r8 a a a |
  e4. e8 g4 g |
  f e d c8 c |
  b4. b8 e4 e |
  a, r r r8 e' |
  a,4 a a r8 e' |
  b4 b b r |
  e8 e e e g4 g8 g |
  f2 r4 d8 e |
  f4 f8 f f4 e8 d |
  e4 c8 b a4 c8 d |
  e4 d8 d c4 b8 b |
  \end 3/4 a2 r4  
}

acc = \chordmode { 
  \partial 4 s4 |
  a1:m |
  e:7 |
  e:7 |
  a:m |
  a:7 |
  d:m |
  e:7 |
  a:m |
  a:m |
  d:m6 |
  a:7 |
  d:m |
  d:m |
  a:m |
  e:7 |
  a2.:m
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
