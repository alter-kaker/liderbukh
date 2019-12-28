
\header {
  title = "אין אַלע גאַסן, דאַלאָיי פּאָליציי"
  subtitle = "In Ale Gasn, Daloy Politsey"
  }
\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel-a = \relative d'' {
  \partial 8 { d8 }
  g d g d ef ef d4 |
  bf8 bf c c d d4.
  \repeat volta 2 {
    g8 d g d ef ef d4 |
    bf8 bf a a g g4.
  }
}
mel-b = \relative d'' {
  d4 bf8. a16 g4 d' |
  \tuplet 3/2 { ef8 c c } \tuplet 3/2 { c c c } c2 |
  d8. d16 d8 ef d c bf a |
  bf4 g8 g g2 |
  \repeat volta 2 {
    d'2 c4. f8 |
    d4 d8 d c4. c8 |
    bf4 \tuplet 3/2 { bf8 bf bf } a4 d |
    }
  \alternative {
    { r g, g8( a bf c) | }
    { r4 g'4 g2 | }
  }  
}
      
acc-a = \chordmode {
  \partial 8 { s8 }
  g2:m c4:m g:m |
  ef: c:m g2:m |
  g:m c4:m g:m |
  ef:m d:7 g2:m |
}
acc-b = \chordmode {
  bf: g:m |
  c1:m |
  d:7 |
  g:m |
  g2:7 c:m |
  g:7 c:m |
  g:m d:7 |
  c:m g:m |
  \once \set chordChanges = ##f c:m g:m |
}

\score {
  \header { piece = "אין אַלע גאַסן" }
  <<
    \new ChordNames {
        \acc-a

        }
    \new Staff {
      \clef treble
      \key g \minor
      \time 4/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel-a 

        }
      }
    \new Lyrics \lyricsto "melody" {
      In a -- le ga -- sn vu men geyt
      hert men za -- ba -- stov -- kes.
      Ying -- lekh, meyd -- lekh, kind un keyt
      shmu -- esn fun pri -- bov -- kes.

    }
  >>
}
\score {
  \header { piece = "דאַלאָיי פּאָליציי" }
  <<
    \new ChordNames {
      \acc-b
    }
    \new Staff {
      \clef treble
      \key g \minor
      \time 4/4
      \tempo Allegretto
      \new Voice = "melody" {
        \mel-b
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Bri -- der un shves -- ter,
      lo -- mir zikh ge -- bn di hent,
      lo -- mir ni -- ko -- lay -- ke -- len tse -- bre -- khn di vent!
      Hey, hey da -- loy po -- li -- tsey,
      da -- loy sa -- mo -- der -- zhav -- yets 
      vra -- sey! __ 
      vra -- sey!
    }
  >>
}

