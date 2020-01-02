
\header {
  title = "איך בין שוין אַ מיידל אין די יאָרן"
  subtitle = "Ikh Bin Shoyn a Meydl in di Yorn"
  }
\version "2.18.2"
\language "english"

\include "../../../../templates/preamble.ly"

mel = \relative f''{
  g8 g g g g g f ef  | 
  d4( g) d4. d8     |
  g a bf a g g f ef | 
  d2 r4 r8 d8       |
  \repeat volta 2 {
    f8( ef) f( g) f4( ef8) d |
    c4 bf8 a g4 bf16 r bf8  | 
    d d d d f ef d c 
  }
  \alternative {
    { d2( g4) r8 f }
    { g,2. r4 }
  }
}

acc = \chordmode {
  g1:m  | 
  g:m   | 
  g:m   | 
  g:m   |
  \repeat volta 2 { 
    g:7   | 
    c:m7  | 
    d:7   | 
  }
  \alternative { 
    { g1:m }
    { \once \set chordChanges = ##f g1:m }
  }
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

