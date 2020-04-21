\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel = \relative d'{
  e8 e e e |
  gs f e4 |
  f8 e f a |
  gs4. r8 |
  a gs a b |
  c b a8. a16 |
  c8 a c e |
  b4. r8 |
  d b gs e |
  c'16 b a4. |
  a8 a b c |
  b4 r8 b |
  c b gs e16 e |
  c' b a4 r8 |
  a8 f gs16 a gs f |
  e4. r8 |
  e8 a gs a gs8. f16 e8 e |
  b' b c b |
  a4. r8 |
  e8 c' b a |
  gs8. f16 e8 e16 e |
  b'8 b c b |
  a4 r |
  c8 e e e |
  d8. c16 b4 |
  d8 f e d |
  c8. b16 a4 |
  e8 e' d c  |
  b8. a16 gs8 b |
  d f e d |
  a2 |
}
acc = \chordmode { 
  a2:m |
  a2:m |
  a2:m |
  e2:7 |
  a:m |
  a:m |
  a:m |
  e:7 |
  e:7 |
  a:m |
  f: |
  e:7 |
  e:7 |
  d:m6 |
  f: |
  e:7 |
  a:m |
  e:7 |
  e:7 |
  a:m |
  a:m |
  e:7 |
  d:m6 |
  a4.:m e8:7 |
  c2: |
  d:m6 |
  d:m6 |
  a:m |
  a:m |
  e:7 |
  d4:m6 e:7 |
  a4.:m \parenthesize e8:7
}

\score {
  <<
    \new ChordNames {
        \acc

        }
    \new Staff {
      \clef treble
      \key a \minor
      \time 2/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Fun dem hi -- ml tsu -- ge -- shikt
      a ma -- to -- ne mir,
      mit an oy -- tser mikh ba -- glikt,
      ikh lib im on a shir.
      
      Likh -- tik iz far mir mayn velt,
      ful mit zu -- nen -- shayn,
      er iz mir tay -- rer fun oyts -- res gelt,
      tay -- rer yin -- ge -- le du mayns!
      
      Ver hot a -- za yin -- ge -- le 
      a ma -- le -- khl a sheyns?
      Oy -- gn vi tsvey shte -- rn -- dlekh,
      a ne -- sho -- me -- le a reyns.
      
      Li -- ber Got, ikh bet bay dir,
      hit im op far mir, far mir!
      Ver hot a -- za yin -- ge -- le,
      a -- ma -- le -- khl a sheyns!
    }
  >>
}
