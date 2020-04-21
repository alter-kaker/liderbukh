\version "2.18.2"
\language "english"

\include "../../../../templates/preamble.ly"

mel = \relative f''{
  a8 a a a a a g f  | 
  e4( a) e4. e8     |
  a b c b a a g f | 
  e2 r4 r8 e8       |
  \repeat volta 2 {
    g8( f) g( a) g4( f8) e |
    d4 c8 b a4 c16 r c8  | 
    e e e e g f e d 
  }
  \alternative {
    { e2( a4) r8 g }
    { a,2. r4 }
  }
}

acc = \chordmode {
  a1:m  | 
  a:m   | 
  a:m   | 
  a:m   |
  \repeat volta 2 { 
    a:7   | 
    d:m7  | 
    e:7   | 
  }
  \alternative { 
    { a1:m }
    { \once \set chordChanges = ##f a1:m }
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
      \time 4/4
      \tempo Andante
      \new Voice = "melody" {
        \mel
        \bar "|."
        }
      }
    \new Lyrics \lyricsto "melody" {
      Ikh bin shoyn a mey -- dl in di yo -- rn
      vos hos -- to mir mayn ke -- pe -- le far -- dreyt?
      Ikh volt shoyn lang a ka -- le ge -- vo -- rn,
      un ef -- sher ta -- ke kha -- se -- ne ge --  hot.

    }
  >>
}
