\version "2.18.2"
\language "english"
\include "../../../../templates/preamble.ly"
mel = \relative a' {
  \partial 8 { a8 }
  a c c e e a a c |
  c b b a e2 |
  c'8 b b a a g g f |
  f e e d d4 r8 d |
  d e e b' b a a gs |
  gs f f e e d d c |
  c d d c e d c b |
  c2. r8 a |
  
  a c c e e a a c |
  c b b a e2 |
  c'8 b b a a g g f |
  f e e d d4 r8 d |
  d e e b' b a a gs |
  gs f f e e d d c |
  c d d c e d c b |
  a2~ a8 e' a b |
  
  c4. b8 c b a gs |
  a4 e2. |
  a8 gs a gs a g f e |
  e( f) d2.
  d8 e e b' b a a gs |
  gs f f e e d d c |
  c d d c e d c b |
  c2~ c8 e a b |
  c4. b8 c b a gs |
  a4 e2 r8 e |
  a gs a gs a g f e |
  e( f) d2 r8 d |
  d e e b' b a a gs |
  gs f f e e d d c |
  c d d c e d c b |
  \end 7/8 a2. r8
}
    
acc = \chordmode {
  \partial 8 { s8 }
  \repeat unfold 2 {
    a1:m |
    a:m |
    a2:m a:7 |
    d4:m a:7  d2:m |
    e1: |
    e: |
    f2: e:7 |
  }
  \alternative{
    {a1:m |}
    {a2.:m e4:7 |}
  }
  \repeat unfold 2 {
    a2:m e:7 |
    a1:m |
    a:7 |
    d:m |
    e: |
    e: |
    f2: e:7 |}
  \alternative{
    {a2.:m e4:7 |}
    {a2.:m a8:m |}
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
      \tempo Moderato
      \new Voice = "melody" {
        \mel
        \bar "|."

      }
    }
    \new Lyrics \lyricsto "melody" {
      A kal -- te nakht a ne -- pel -- di -- ke fins -- ter u -- me -- tum,
      shteyt a yin -- ge -- le far -- tro -- yert un kukt zikh a -- rumת
      Fun re -- gn shitst im nor a vant,
      a ko -- shi -- kl halt er in hant,
      un zay -- ne oy -- gn be -- tn ye -- dn shtum. 
      
      Ikh hob shoyn nit keyn ko -- yekh mer a -- rum -- tsu -- geyn in gas,
      hun -- ge -- rik un op -- ge -- ri -- sn fu -- nem re -- gn nas.
      Ikh shlep a -- rum zikh fun ba -- gi -- nen,
      key -- ner git nit tsu far -- di -- nen,
      a -- le la -- khn, ma -- khn fun mir shpas.
      
      Ku -- pi -- tye koyft zhe, koyft zhe pa -- pi -- ro -- sn,
      tru -- ke -- ne, fun re -- gn nit far -- go -- sn.
      koyft zhe bi -- lik be -- ne -- mo -- nes,
      koyft un hot oyf mir rakh -- mo -- nes,
      ra -- te -- vet fun hun -- get mikh a -- tsind!
      
      Ku -- pi -- tye koyft zhe shve -- be -- lakh an -- ti -- kn,
      der -- mit vert ir a yo -- si -- ml derk -- vi -- kn.
      Um -- zisr mayn shra -- yen un mayn loy -- fn,
      key -- ner git bay mir nit koy -- fn,
      oys -- geyn vel ikh mu -- zn vi a hunt…
    }
  >>
}
