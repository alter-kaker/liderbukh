
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

\score {
  <<
    \new ChordNames {
      \chordmode { 
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
        \repeat volta 2 {
          g:m |
          d:7 |
          d:7 |
          g:m |
          g:m |
          d:7 |
          c:m6 |
          g4:m d4:7 |
          bf2: |
          c:m6 |
          c:m6 |
          g:m |
          g:m |
          d:7 |
        }
        \alternative {
          { c4:m6 d:7 | g4.:m d8:7 }
          { c4:m6 d:7 | g2.:m }
        }
      }
    }
    \new Staff {
      \clef treble
      \key g \minor
      \time 2/4
      \tempo "Allegro moderato"
      \new Voice = "melody" {
        \relative d'{
          d8 d d d |
          fs16 ef d4. |
          ef8 d ef g |
          fs2 |
          g8 fs g a |
          bf16 a g4. |
          bf8 g bf d |
          a2 |
          c8 a fs d |
          bf'16 a g4. |
          fs8 g a bf |
          a4. r8|
          bf a fs d8 |
          bf'16 a g4 r16 g |
          fs8 c ef g |
          fs2 |
          
          \repeat volta 2 {
            d'8 bf a g |
            fs8. eff16 d8. d16 |
            a'8 a bf a |
            g2 |
            d8 bf' a g |
            fs8. ef16 d8 d16 d |
            a'8 a bf a |
            g2 |
            bf8 d d d |
            c8. bf16 a4 |
            c8 ef d c |
            bf8. a16 g4 |
            d'8 bf a g  |
            fs8. ef16 d8 d |
            }
            \alternative {
              { a' a bf a | g2 | }
              { d'8 c bf a | g2 }
            }
          }
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Fun dem hi -- ml tsu -- ge -- shikt
      a ma -- to -- ne mir,
      mit an oy -- tser mikh ba -- glikt,
      hot got on a shir.
      
      Likh -- tik iz far mir mayn velt,
      nit mit zu -- nen -- shayn,
      krigt men den fun oyts -- res gelt,
      a mey -- de -- le vi mayn!
      
      Ver hot a -- za mey -- de -- le 
      a ma -- le -- khl a kleyns?
      Oy -- gn vi tsvey shte -- rn -- dlekh,
      a ne -- sho -- me -- le a reyns.
      
      \repeat volta 2 {
      Li -- ber Got, ikh bet bay dir,
      shits un hit zi op far mir!
      Ver hot a -- za mey -- de -- le,
      a 
      }
      \alternative { 
        { mey -- de -- le a kleyns! } 
        { mey -- de -- le a kleyns! }
      }
    }
  >>
}

