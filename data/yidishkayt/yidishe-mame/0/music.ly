
\version "2.18.2"
\language "english"
\include "../../templates/preamble.ly"

mel = \relative d' {
    \partial 8 {d8} |
    g g a a bf bf c c |
    d d ef c d4~d8 d, |
    g g a a bf bf c c |
    bf bf a g a4~a8 f |
    bf bf c c df df ef ef |
    df df ef df c4~c8 c |
    df df c c bf bf a a |
    bf bf c bf a4. d,8 |
    g g a a bf bf c c |
    d d ef c d2 |
    ef ef8 d c ef |
    d2 bf |
    a4 gs8 a bf4 a |
    d\fermata \breathe d, g8d g4 |
    \repeat volta 2 {
      bf2 g~ |
      g8 bf a bf c bf a g |
      a1~ |
      a8 r d,4 a'8 d, a'4 |
      c2 a~ |
      a8 c bf c d c bf a |
      bf1~ |
      bf8 r bf4 c d |
      ef ef ef ef |
      ef f8 ef d4 cs |
      d1~ |
      d4 g, a bf |
      c c c c |
      c d8c bf a g a |
      bf1~ |
      bf8 r d,4 g8 d g4 |
      bf2 g~ |
      g8 bf a bf c bf a g |
      a1~ |
      a8 r d,4 a'8 d, a'4 |
      c2 a~ |
      a8 c bf c d c bf a |
      bf1~ |
      bf2 c4 d |
      ef f8 ef d4 c8 d |
      ef4 c c bf8 c |
      d4 ef8 d c4 bf8 c |
      d4 bf bf a8 bf |
      c4 d8 c bf4 a8 g |
      g'2 ef |
    }
      \alternative {
        {
          d4( ef8 d c bf) a( d) |
          g,4 d g8 d g4
        }
        {
          r4 d( ef) d |
          \end 7/8 g2. r8
        }
      }
    }

acc = \chordmode {
  \partial 8 { s8 }
  g1:m |
  g:m |
  g:m |
  g2:m d4.: f8:7 |
  bf1:m |
  bf2:m f:7 |
  bf1:m |
  ef2:m f4.:7 d8: |
  g1:m |
  g2:m d:7 |
  c1:m |
  g:m |
  c:m |
  d2:7 g:m |
  \repeat volta 2 {
    g1:m |
    g2:m c:m6 |
    d2: c:m6 |
    d1:7 |
    c:m6 |
    c2:m6 d:7 |
    g1:m |
    g:m |
    c:m |
    f: |
    bf: |
    bf: |
    c:m |
    d:7 |
    g:m |
    g:m |
    g:m |
    g2:m c:m6 |
    d: c:m6 |
    d1:7 |
    c:m6 |
    c2:m6 d:7 |
    g1:m |
    g:m |
    c:m |
    c:m |
    g:m |
    g:m |
    c:m |
    ef2: c:m|
  }
  \alternative {
    { 
      d1:7 |
      g:m
    }
    {
      d:7 |
      g8*7:m
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
      \key g \minor
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