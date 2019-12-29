
\header {
  title = "אויפֿן וועג שטייט אַ בוים"
  subtitle = "Oyfn Veg Shteyt A Boym"
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
mel = \relative a'{
  g8 g d'2 	|
  c8 c bf2	|
  c8 c bf4. a8 	|
  a4 bf2		|
  g8 g d' d4. 	|
  c8 c bf2	|
  c8 c bf4.a8	|
  a4 g2		|
  g8 g d'4 d	|
  c8 c bf4 bf	|
  c8 c bf4 a	|
  a4 bf2	|
  g8 g d'4. d8	|
  c8 c bf2	|
  c8 c bf4. a8	|
  a4 g2		|
  f'8 f g4. g8	|
  f8 f bf,2	|
  f'4. ef8 f ef	|
  d4 d2		|
  f8 f g4. f8	|
  bf a g2	|
  f4. ef8 f ef	|
  d4 d2		|
  bf8 d f4. d8	|
  d c c2		|
  d8 bf bf4 g	|
  g f2		|
  bf8 a c4 bf |
  df8 c c2	|
  bf4. a8 a g	|
  g4 g2		|
  g4 d'8 c c bf	|
  bf c c bf bf a	|
  a bf bf a a g	|
  g bf a c bf4	|
  g d'8 c c bf	|
  bf c c bf bf a 	|
  bf4. a8 a g	|
  g2.
}
acc = \chordmode { 
  g2.:m		|
  c4:m g2:m	|
  c4:m d2:	|
  g2.:m		|
  g2.:m		|
  c4:m g2:m	|
  c4:m d2:	|
  g2.:m		|
  g2.:m		|
  c4:m g2:m	|
  c4:m d2:	|
  g2.:m		|
  g:m		|
  c4:m g2:m	|
  d2.:7		|
  g:m		|
  bf4: ef2:	|
  bf2.:		|
  f:7		|
  bf:		|
  bf4: ef2:	|
  g4:m ef2:	|
  f2.:7		|
  bf:		|
  bf:		|
  d:7		|
  g:m		|
  f:7		|
  bf:		|
  c:m		|
  d:7		|
  g:m		|
  g:m		|
  c:m		|
  d:7		|
  g4:m d: g:m	|
  g2.:m		|
  c:m		|
  d:7		|
  g:m		|
}

\score {
  <<
    \new ChordNames {
        \acc

      }
    \new Staff {
      \clef treble
      \key g \minor
      \time 3/4
      \tempo "Ballad style"
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Oy -- fn veg shteyt a boym, shteyt er an -- ge -- boy -- gn,
      a -- le feyg -- l fu -- nem boym ze -- nen zikh tse -- floy -- gn.
      Dray keyn miz -- rekh, dray keyn may -- rev, un der resht keyn 
      du -- rem,
      un dem boym ge -- lozt a -- leyn, hef -- ker far -- n shtu -- rem.
      Zog ikh tsu der ma -- me: her, zolst mikh nor nit shte -- rn,
      vel ikh ma -- me, eyns un tsvey bald a foy -- gl ve -- rn…
      Ikh vel zi -- tsn oy -- fn boym un vel im far -- vi -- gn, 
      i -- bern vin -- ter mit a treyst, mit a shey -- nem ni -- gn.
      Yam ta ri ta ri, ta ri ta ri ta ri ta ri ta ri ta ri ta ri ta ri tam;
      yam ta ri ta ri ta ri ta ri ta ri ta ri ta ri tam.
    }
  >>
}

