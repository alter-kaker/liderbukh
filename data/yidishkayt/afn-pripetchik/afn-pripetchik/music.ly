
\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

mel-a = \relative g'{ 
  a8 b c c c4 |
  b8 d c b a4 |
  c8 b c4 d |
  e2. 
}
mel-b = \relative g''{ 
  \repeat volta 2 {
    a8 e g f d b |
    d f e c a4 |
  }
  \alternative {
    { b8( d) c4 d | 
      e2. 
    }
    { b8( d) c4 b | 
      a2. 
    }
  }
}
mel-c = \relative g'{ 
  a8 c b gs e4 | 
  b'8 d c b a4 | 
  c8 b c4 d | 
  e2. | 
}

acc-a = \chordmode { 
  a2.:m | 
  e2:7 a4:m | 
  f2.: | 
  c |  
}
acc-b = \chordmode { 
  \repeat volta 2 { 
    a4:7 d2:m6 | 
    d4:m6 a2:m | }
  \alternative {
    { d4:m a:m d:m | e2.:7 }
    { d4:m6 e2:7 | a2.:m }
  }
}
                      
acc-c = \chordmode { 
  a4:m e2:7 | 
  e2:7 a4:m | 
  f2.: | 
  c2.: | 
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
      \key a \minor
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