
\header {
  title = "ווער האָט אַזאַ מיידעלע?"
  subtitle = "Ver Hot Aza Meydele?"
  }
\version "2.18.2"
\language "english"
#(set-global-staff-size 17)

end =
  #(define-music-function
    (parser location signature)
    (fraction?)
  #{
    \once \omit Staff.TimeSignature \time #signature
  #})

\layout {
  \context {  % Use Typewriter font for chord symbols
    \ChordNames {
      \set chordChanges = ##t
      \override ChordName.font-family = #'typewriter
      }
    }
  \context {  % Change font size for lyrics
    \Lyrics {
      \override LyricText.font-size = #'-1
      }
    }
  \context {  % Beam according to rhythm
    \Staff {
      \set Timing.beamExceptions = #'()
      }
    }
  }

\paper {      % Load fonts
  fonts = #
  (make-pango-font-tree
   "Linux Libertine"
   "Linux Biolinum"
   "Courier 10 Pitch"
   (/ (* staff-height pt) 2.5)
    )
  bookTitleMarkup = \markup {
    \override #'(baseline-skip . 3.5)
    \column {
      \fill-line { \fromproperty #'header:dedication }
      \override #'(baseline-skip . 3.5)
      \column {
        \fill-line {
          \override #'(font-name . "Drugulin CLM")
          \huge \larger \larger \bold
          \fromproperty #'header:title
          }
        \fill-line {
          \large \bold
          \fromproperty #'header:subtitle
          }
        \fill-line {
          \smaller \bold
          \fromproperty #'header:subsubtitle
          }
        \fill-line {
          \fromproperty #'header:meter
          \fromproperty #'header:arranger
          }
          \fill-line {
          \override #'(font-name . "Drugulin CLM")
          \fromproperty #'header:composer
          { \large \bold \fromproperty #'header:instrument }
          \override #'(font-name . "Drugulin CLM")
          \fromproperty #'header:poet
          }
        }
      }
    }
    scoreTitleMarkup = \markup {
      \column {
      \on-the-fly \print-all-headers { \bookTitleMarkup \hspace #1 }
      \fill-line {
        \null
        \override #'(font-name . "Drugulin CLM")
        \huge
        \lower #5
        \fromproperty #'header:piece
        }
      }
    }
  }

mel = \relative d'{
  d8 d d d |
  fs ef d8. d16 |
  ef8 d ef g |
  fs4. r8 |
  g fs g a |
  bf a g8. g16 |
  bf8 g bf d |
  a4. r8 |
  c a fs d |
  bf'16 a g4. |
  g8 g a bf |
  a4 r8 a |
  bf a fs d16 d |
  bf' a g4 r8 |
  g8 ef fs16 g fs ef |
  d4. r8 |
  d8 g fs g fs8. ef16 d8 d |
  a' a bf a |
  g4. r8 |
  d8 bf' a g |
  fs8. ef16 d8 d16 d |
  a'8 a bf a |
  g4 r |
  bf8 d d d |
  c8. bf16 a4 |
  c8 ef d c |
  bf8. a16 g4 |
  d8 d' c bf  |
  a8. g16 fs8 a |
  c ef d c |
  g2 |
}
acc = \chordmode { 
  g2:m |
  g2:m |
  g2:m |
  d2:7 |
  g:m |
  g:m |
  g:m |
  d:7 |
  d:7 |
  g:m |
  ef: |
  d:7 |
  d:7 |
  c:m6 |
  ef: |
  d:7 |
  g:m |
  d:7 |
  d:7 |
  g:m |
  g:m |
  d:7 |
  c:m6 |
  g4.:m d8:7 |
  bf2: |
  c:m6 |
  c:m6 |
  g:m |
  g:m |
  d:7 |
  c4:m6 d:7 |
  g4.:m \parenthesize d8:7
}

\score {
  <<
    \new ChordNames {
        \acc

        }
    \new Staff {
      \clef treble
      \key g \minor
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

