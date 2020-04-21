
\header {
  poet = "טעקסט: איציק מאַנגער"
  composer = "מוזיק: פּ. לאַסקאָווסקי"
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
  a8 a e'2 	|
  d8 d c2	|
  d8 d c4. b8 	|
  b4 c2		|
  a8 a e' e4. 	|
  d8 d c2	|
  d8 d c4.b8	|
  b4 a2		|
  a8 a e'4 e	|
  d8 d c4 c	|
  d8 d c4 b	|
  b4 c2	|
  a8 a e'4. e8	|
  d8 d c2	|
  d8 d c4. b8	|
  b4 a2		|
  g'8 g a4. a8	|
  g8 g c,2	|
  g'4. f8 g f	|
  e4 e2		|
  g8 g a4. g8	|
  c b a2	|
  g4. f8 g f	|
  e4 e2		|
  c8 e g4. e8	|
  e d d2		|
  e8 c c4 a	|
  a g2		|
  c8 b d4 c |
  ef8 d d2	|
  c4. b8 b a	|
  a4 a2		|
  a4 e'8 d d c	|
  c d d c c b	|
  b c c b b a	|
  a c b d c4	|
  a e'8 d d c	|
  c d d c c b 	|
  c4. b8 b a	|
  a2.
}
acc = \chordmode { 
  a2.:m		|
  d4:m a2:m	|
  d4:m e2:	|
  a2.:m		|
  a2.:m		|
  d4:m a2:m	|
  d4:m e2:	|
  a2.:m		|
  a2.:m		|
  d4:m a2:m	|
  d4:m e2:	|
  a2.:m		|
  a:m		|
  d4:m a2:m	|
  e2.:7		|
  a:m		|
  c4: f2:	|
  c2.:		|
  g:7		|
  c:		|
  c4: f2:	|
  a4:m f2:	|
  g2.:7		|
  c:		|
  c:		|
  e:7		|
  a:m		|
  g:7		|
  c:		|
  d:m		|
  e:7		|
  a:m		|
  a:m		|
  d:m		|
  e:7		|
  a4:m e: a:m	|
  a2.:m		|
  d:m		|
  e:7		|
  a:m		|
}

\score {
  <<
    \new ChordNames {
        \acc

      }
    \new Staff {
      \clef treble
      \key a \minor
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

