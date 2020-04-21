
\header {
  poet = "טעקסט: דזשייק יעלען"
  composer = "מוזיק: לעוו פּאָלאַק, דזשייק יעלען"
  title = "אַ ייִדישע מאַמע"
  subtitle = "A Yidishe Mame"
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

mel = \relative d' {
    \partial 8 {e8} |
    a a b b c c d d |
    e e f d e4~e8 e, |
    a a b b c c d d |
    c c b a b4~b8 g |
    c c d d ef ef f f |
    ef ef f ef d4~d8 d |
    ef ef d d c c b b |
    c c d c b4. e,8 |
    a a b b c c d d |
    e e f d e2 |
    f f8 e d f |
    e2 c |
    b4 as8 b c4 b |
    e\fermata \breathe e, a8e a4 |
    \repeat volta 2 {
      c2 a~ |
      a8 c b c d c b a |
      b1~ |
      b8 r e,4 b'8 e, b'4 |
      d2 b~ |
      b8 d c d e d c b |
      c1~ |
      c8 r c4 d e |
      f f f f |
      f g8 f e4 ds |
      e1~ |
      e4 a, b c |
      d d d d |
      d e8d c b a b |
      c1~ |
      c8 r e,4 a8 e a4 |
      c2 a~ |
      a8 c b c d c b a |
      b1~ |
      b8 r e,4 b'8 e, b'4 |
      d2 b~ |
      b8 d c d e d c b |
      c1~ |
      c2 d4 e |
      f g8 f e4 d8 e |
      f4 d d c8 d |
      e4 f8 e d4 c8 d |
      e4 c c b8 c |
      d4 e8 d c4 b8 a |
      a'2 f |
    }
      \alternative {
        {
          e4( f8 e d c) b( e) |
          a,4 e a8 e a4
        }
        {
          r4 e( f) e |
          \end 7/8 a2. r8
        }
      }
    }

acc = \chordmode {
  \partial 8 { s8 }
  a1:m |
  a:m |
  a:m |
  a2:m e4.: g8:7 |
  c1:m |
  c2:m g:7 |
  c1:m |
  f2:m g4.:7 e8: |
  a1:m |
  a2:m e:7 |
  d1:m |
  a:m |
  d:m |
  e2:7 a:m |
  \repeat volta 2 {
    a1:m |
    a2:m d:m6 |
    e2: d:m6 |
    e1:7 |
    d:m6 |
    d2:m6 e:7 |
    a1:m |
    a:m |
    d:m |
    g: |
    c: |
    c: |
    d:m |
    e:7 |
    a:m |
    a:m |
    a:m |
    a2:m d:m6 |
    e: d:m6 |
    e1:7 |
    d:m6 |
    d2:m6 e:7 |
    a1:m |
    a:m |
    d:m |
    d:m |
    a:m |
    a:m |
    d:m |
    f2: d:m|
  }
  \alternative {
    { 
      e1:7 |
      a:m
    }
    {
      e:7 |
      a8*7:m
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
      \time 4/4
      \tempo Andante
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Ich vil bay aykh a ka -- she fre -- gn,
      zogt mir ver es ken:
      Mit vel -- khe ta -- ye -- re far -- me -- gens
      bentsht Got a -- le -- men?
      Men koyft es nit far kay -- ne gelt;
      dos git men nor um -- zist,
      un dokh az men far -- lirt dos,
      vi -- fil tre -- rn men far -- gist!
      a tsvey -- te git men key -- nem nit
      es helft nit keyn ge -- veyn,
      Oy! ver es hot far -- loy -- rn,
      der veyst shorn vos ikh meyn.
      a Yi -- di -- she ma -- me,
      es gibt nit be -- ser in der velt
      a yi -- di -- she ma -- me,
      oy, vey, vi bit -- er ven zi felt!
      Vi sheyn un likh -- tig iz in hoyz 
      ven di me -- me's do;
      Vi troye -- rik fins -- ter vert ven Got
      nemt ir oyf o -- lom ha -- bo!
      In va -- ser und fa -- yer,
      volt iz ge -- lo -- fn far ir kind,
      nit hal -- tn ir ta -- yer
      do iz ge -- vis di gres -- te zind;
      oy vi glik -- likh un raykh iz der mentsh vos hot
      a -- za shey -- ne ma -- to -- ne ge -- shenkt fun Got
      nor an al -- ti -- shke yi -- di -- she ma -- me
      ma -- me mayn! A yi -- di -- she
      ma -- me mayn!
    }
  >>
}
