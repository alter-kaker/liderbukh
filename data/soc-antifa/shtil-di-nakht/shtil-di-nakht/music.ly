\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel = \relative d'' {
  e4. c8       |
  f e d c     |
  d4.( c16 b   |
  c4.) r8      |
  g'4. e8       |
  a8 g c, d    |
  e2~           |
  e8 r e e      |

\repeat volta 2 {
   a4 g8 a      |
   f f e a,   |
   d4.( c16 b  | 
   c4.) r8     |
   b4 e8 e      |
   g f e d     | 
}
\alternative {
  {a'2~ | a8 r e e}
  {a,2~ | a4 r }
  }
}

acc = \chordmode {
  { a2:m    	|
    d:m 		|
    e:7   	|
    a:m     	|
    c     	|
    f4: \parenthesize g:7 |
    c2     	|
    \parenthesize e4:7 \once \set chordChanges = ##f e:7 |
  }
  \repeat volta 2 {
    a2:7    	| 
    d4:m a:m 	| 
    e2:7    	| 
    a:m      	|
    e:7     	| 
    \parenthesize d4:m \parenthesize e:7 | 
  }
  \alternative {
    { a2:m  	|
      \parenthesize e4:7 \once \set chordChanges = ##f e:7 |
    }
    { a2:m  	|
      a2:m 
    }
  }
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
      \tempo Andantino
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Shtil, di nakht iz oys -- ge -- shternt
      un der frost hot shtark ge -- brent.
      Tsi ge -- denk -- stu vi ikh hob dikh ge -- lernt
      hal -- tn a shpa -- yer in di hent?
    }
  >>
}
