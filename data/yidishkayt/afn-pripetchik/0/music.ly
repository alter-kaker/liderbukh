
\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel-a = \relative g'{ 
  g8 a bf bf bf4 |
  a8 c bf a g4 |
  bf8 a bf4 c |
  d2. 
}
mel-b = \relative g''{ 
  \repeat volta 2 {
    g8 d f ef c a |
    c ef d bf g4 |
  }
  \alternative {
    { a8( c) bf4 c | 
      d2. 
    }
    { a8( c) bf4 a | 
      g2. 
    }
  }
}
mel-c = \relative g'{ 
  g8 bf a fs d4 | 
  a'8 c bf a g4 | 
  bf8 a bf4 c | 
  d2. | 
}

acc-a = \chordmode { 
  g2.:m | 
  d2:7 g4:m | 
  ef2.: | 
  bf |  
}
acc-b = \chordmode { 
  \repeat volta 2 { 
    g4:7 c2:m6 | 
    c4:m6 g2:m | }
  \alternative {
    { c4:m g:m f: | d2.:7 }
    { c4:m6 d2:7 | g2.:m }
  }
}
                      
acc-c = \chordmode { 
  g4:m d2:7 | 
  d2:7 g4:m | 
  ef2.: | 
  bf2.: | 
}

\score {
  <<
    \new ChordNames {
      \acc-a
      \acc-b
      \acc-c
      \acc-b

        }
    \new Staff {
      \clef treble
      \key g \minor
      \time 3/4
      \tempo Andantino
      \new Voice = "melody" {
        \mel-a
        \mel-b
        \bar "|."
        \mel-c
        \mel-b
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Oy -- fn pri -- pe -- tchik brent a fa -- y -- rl,
      un in shtub iz heys,
      
      \repeat volta 2 {
        un der re -- be le -- rnt klay -- ne kin -- der -- lakh
        }
      \alternative {
        { dem a -- lef beys }  
        { dem a -- lef beys }
        }
      Zetz zhe kin -- der -- lakh,
      gedank zhe ta -- ye -- re
      vos ir he -- rn do,
      \repeat volta 2 {
        zog zhe nokh a mol un ta -- ke nokh a mol
      }
      \alternative {
        { kometz a -- lef: o }
        { kometz a -- lef: o }
      }
    }
  >>
}