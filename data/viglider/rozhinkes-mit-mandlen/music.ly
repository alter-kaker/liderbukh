\version "2.18.2"
\language "english"

\include "../../templates/preamble.ly"

mel = \relative a' {
  \partial 4 { a4 } |
    d d a |
    d d2 |
    c8 c b4 c |
    d a2 |
    c4 b4 c |
    e d c |
    d c b |
    a2 a8 a
    c4 c c |
    c c c |
    c f, g |
    a c,4. c8 |
    c4 f g |
    a g f |
    g f e |
    d2. |
    d'8( e) d( e) d( e) |
    d2 \repeat unfold 2 {
      d,8 f |
      a4 a a |
      a4.( g8) f( g) |
      a2.~ |
      a4 r } a |
    e8 e e4 f8 f |
    g( a16 g f4) e |
    f d2~ |
    d2. |
    bf'2 bf4 |
    bf cs d |
    a2.~ |
    a |
    e2 f4 |
    g4( f) e |
    f d2~ |
    d2. |
    a'2 a4 |
    cs bf a |
    d2 e4 |
    f e d |
    e( f) g |
    g f e |
    d4.( a8) f'e|
    \end 2/4 d2
  }

acc = \chordmode {
  \partial 4 {s4}
  d2.:m |
  d:m |
  c: |
  d:m |
  a:m |
  a:m
  e:7 |
  a:m |
  f:  |
  \parenthesize c: |
  f2: c4:7|
  d2.:m |
  f2: c4:7 |
  d2.:m |
  g2:m a4:7 |
  d2.:m |
  g:m |
  d:m |
  d:m |
  a:7 |
  d:m |
  d:m |
  d:m |
  c:7 |
  f: |
  f: |
  g:m6 |
  a:7 |
  d:m |
  d:m |
  g:m |
  g:m |
  d:m |
  d:m |
  g:m6 |
  a:7 |
  d:m |
  d:m |
  a:7 |
  a:7 |
  d2:m c4: |
  bf2.: |
  g:m |
  a:7 |
  d2:m a4:7 |
  d2:m
  }

\score {
  <<
    \new ChordNames {
      \acc
    }
    \new Staff {
      \clef treble
      \key d \minor
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
