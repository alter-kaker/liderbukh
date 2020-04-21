\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"

\score {
  <<
    \new ChordNames = "mainChords" {
      \chordmode { 
        a1:m |
        a:m |
        c |
        c: |
        a2:m c: |
        g: d:m |
        a:m c:7 |
        a1:m |
        a:m |
        d:m |
        f: |
        c: |
        a:7 |
        c:7 |
        g2: c:7 |
        a1:m
      }
    }
    \new Staff = "main" {
      \clef treble
      \key a \minor
      \time 4/4
      \tempo Moderato
      \new Voice = "melody" {
        \relative f'{ 
          a8 b c d c b a b |
          c a~a4 r4. d8 |
          c8 d e f e d c d | \break
          e8 c~c4 r4. e8 |
          
          << 
            { 
              e8 f g f g4. r8 |
              g f e d a'4.\fermata d,8 |
            }
            <<
              \new ChordNames \with {
                alignAboveContext = #"mainChords"
              } 
              
                
                \chordmode { 
                  \override ChordName #'font-size = #-1 {
                  a1:m |
                  f2: e:7 |
                }
              }
              \new Staff \with {
                \remove "Time_signature_engraver"
                alignAboveContext = #"mainChords"
                fontSize = #-3
                \override StaffSymbol.staff-space = #(magstep -3)
                \override StaffSymbol.thickness = #(magstep -3)
                firstClef = ##f
                \override VerticalAxisGroup.default-staff-staff-spacing =
                  #'((basic-distance . 10)
                     (minimum-distance . 10)
                     (padding . 1)
                     (stretchability . 10))
              } 
              
              \new Voice = "variation"
              \relative d''{
                e8 f g a g f e( d) |
                f8 e8 d c b4.\fermata d8 |
              }
            >>
          >>
          
          c8 d e d c g a bf |
          a2. r4 |\bar "||"\break
          a'2 a |
          a4 g16( f8.) g4. r8 |
          a8. g16 f8 e f g a f |
          e2. r4 |
          g2 g4 r8 a |
          bf a g f e r e f |
          g f e d c8. d16 c8 bf |
          a2. r4 \bar "|."
        }
      }
    }
    
    \new Lyrics \lyricsto "melody" {
      Shpil zhe mir a li -- de -- le in yi -- dish,
      der -- ve -- kn zol es freyd un nit keyn khi -- desh,
      az a -- le groys un kleyn,
      zol -- n es far -- shteyn,
      fun moyl tsu moyl dos li -- de -- le zol geyn!
      
      Shpil, shpil, klez -- merl, shpil,
      veyst dokh vos ikh meyn un vos ikh vil;
      shpil, shpil! A li -- de -- le far mir,
      shpil a li -- de -- le mit harts un mit ge -- fil!
    }
    
              \new Lyrics \with {
                alignAboveContext = #"variation"
              }
              \lyricsto "variation" 
              \lyricmode{ 
                a -- le men -- tshn groys un kleyn,
                zol -- n es far -- shteyn, fun
              }
  >>
}
