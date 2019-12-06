\version "2.18.2"
\language "english"
\include "templates/preamble.ly"
mel = \relative a' {
  \partial 8 { g8 }
  g bf bf d d g g bf |
  bf a a g d2 |
  bf'8 a a g g f f ef |
  ef d d c c4 r8 c |
  c d d a' a g g fs |
  fs ef ef d d c c bf |
  bf c c bf d c bf a |
  bf2. r8 g |
  
  g bf bf d d g g bf |
  bf a a g d2 |
  bf'8 a a g g f f ef |
  ef d d c c4 r8 c |
  c d d a' a g g fs |
  fs ef ef d d c c bf |
  bf c c bf d c bf a |
  g2~ g8 d' g a |
  
  bf4. a8 bf a g fs |
  g4 d2. |
  g8 fs g fs g f ef d |
  d( ef) c2.
  c8 d d a' a g g fs |
  fs ef ef d d c c bf |
  bf c c bf d c bf a |
  bf2~ bf8 d g a |
  bf4. a8 bf a g fs |
  g4 d2 r8 d |
  g fs g fs g f ef d |
  d( ef) c2 r8 c |
  c d d a' a g g fs |
  fs ef ef d d c c bf |
  bf c c bf d c bf a |
  \end 7/8 g2. r8
}
    
acc = \chordmode {
  \partial 8 { s8 }
  \repeat unfold 2 {
    g1:m |
    g:m |
    g2:m g:7 |
    c4:m g:7  c2:m |
    d1: |
    d: |
    ef2: d:7 |
  }
  \alternative{
    {g1:m |}
    {g2.:m d4:7 |}
  }
  \repeat unfold 2 {
    g2:m d:7 |
    g1:m |
    g:7 |
    c:m |
    d: |
    d: |
    ef2: d:7 |}
  \alternative{
    {g2.:m d4:7 |}
    {g2.:m g8:m |}
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
