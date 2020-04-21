
\header {
  poet = "טעקסט: אבֿרהם גאָלדפֿאַדען"
  title = "ראָזשינקעס מיט מאַנדלען"
  subtitle = "Rozhinkes Mit Mandlen"
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

mel = \relative a' {
  \partial 4 { b4 } |
    e e b |
    e e2 |
    d8 d cs4 d |
    e b2 |
    d4 cs4 d |
    fs e d |
    e d cs |
    b2 b8 b
    d4 d d |
    d d d |
    d g, a |
    b d,4. d8 |
    d4 g a |
    b a g |
    a g fs |
    e2. |
    e'8( fs) e( fs) e( fs) |
    e2 \repeat unfold 2 {
      e,8 g |
      b4 b b |
      b4.( a8) g( a) |
      b2.~ |
      b4 r } b |
    fs8 fs fs4 g8 g |
    a( b16 a g4) fs |
    g e2~ |
    e2. |
    c'2 c4 |
    c ds e |
    b2.~ |
    b |
    fs2 g4 |
    a4( g) fs |
    g e2~ |
    e2. |
    b'2 b4 |
    ds c b |
    e2 fs4 |
    g fs e |
    fs( g) a |
    a g fs |
    e4.( b8) g'fs|
    \end 2/4 e2
  }

acc = \chordmode {
  \partial 4 {s4}
  e2.:m |
  e:m |
  d: |
  e:m |
  b:m |
  b:m
  fs:7 |
  b:m |
  g:  |
  \parenthesize d: |
  g2: d4:7|
  e2.:m |
  g2: d4:7 |
  e2.:m |
  a2:m b4:7 |
  e2.:m |
  a:m |
  e:m |
  e:m |
  b:7 |
  e:m |
  e:m |
  e:m |
  d:7 |
  g: |
  g: |
  a:m6 |
  b:7 |
  e:m |
  e:m |
  a:m |
  a:m |
  e:m |
  e:m |
  a:m6 |
  b:7 |
  e:m |
  e:m |
  b:7 |
  b:7 |
  e2:m d4: |
  c2.: |
  a:m |
  b:7 |
  e2:m b4:7 |
  e2:m
  }

\score {
  <<
    \new ChordNames {
      \acc
    }
    \new Staff {
      \clef treble
      \key e \minor
      \time 3/4
      \tempo Andante
      \new Voice = "melody" {
        \mel
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      In dem Beys Ha -- mik -- dosh
      in a vin -- kel khe -- der
      zitst di al -- mo -- ne bas Tsi -- yen a -- leyn.
      Ir ben yo -- khid -- l Yi -- de -- le vigt zi ke -- se -- der
      un zingt im tsum shlo -- fn
      a li -- de -- le sheyn:
      ay lyu lyu lyu…
      Un -- ter Yi -- de -- les vi -- ge -- le
      shteyt a klor vai -- se tsi -- ge -- le.
      Dos tsi -- ge -- le iz ge -- fo -- rn hand -- len
      dos vet zayn dayn be -- ruf
      ro -- zhin -- kes mit mand -- len.
      Shlof zhe Yi -- de -- le shlof zhe Yi -- de -- le, 
      shlof zhe Yi -- de -- le shlof ay lyu lyu.
    }
  >>
}

