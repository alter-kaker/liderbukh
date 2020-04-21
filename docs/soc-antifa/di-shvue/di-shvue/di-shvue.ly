
\header {
  poet = "טעקסט: ש. אנ־סקי"
  title = "די שבֿועה"
  subtitle = "Di Shvue"
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


mel-a = \relative d'' {
  a4 c8. c16 b4 a8. a16 |
  b4 b8. b16 b4 r |
  b d8. d16 c4 b8. a16 |
  c4 c8. c16 c4 r8 c |
  c4  e8. e16 d4 c8. c16 |
  b4 d8. d16 c4( b8.) b16 |
  a8( b) c e d( c) b a |
  e'4 e8. e16 e4 r8 e |
  a( e)f d c4 b8. b16 |
  a4 c8 e a,4 r |
  g'4 f8 e a( g f e) |
  d4 d8 d g( f e) d |
  e4 g8. g16 f4( e16) r16 a,8  |
  d4 d8 d  d( b) c d |
  e4 f8 d c4 b8. a16 |
  a'4 a8 a a( e) f d |
  e4 f8 d c4 b |
  a c8( e) a,2 
}
acc-a = \chordmode {
  a1:m |
  e:7 |
  e:7 |
  a:m |
  c: |
  e:7 |
  a2:m d:m |
  e1:7 |
  a4:m d:m e2:7 |
  a1:m |
  a:7 |
  d2:m g:7 |
  c: d4:m a:7 |
  d2:m e:7 |
  a4:m d:m  e2:7 |
  a:m  a4:m d:m |
  a:m d:m  e2:7 |
  a4:m e:7 a2:m
}

\score {
  <<
    \new ChordNames {
        \acc-a

        }
    \new Staff {
      \clef treble
      \key a \minor
      \time 4/4
      \tempo Moderato
      \new Voice = "melody" {
        \mel-a 
        \bar "|."
      }
    }
    \new Lyrics \lyricsto "melody" {
      Bri -- der un shves -- ter fun ar -- bet un noyt,
      a -- le vos zay -- nen tse -- zeyt on tse -- shpreyt_—
      tsu -- za -- men, tsu -- za -- men, di fon zi iz greyt, __
      zi fla -- tert fun tso -- rn, fun blut iz zi royt,
      a shvu -- e! a shvu -- e oyf le -- bn un toyt!
      Hi -- ml un erd __  vet undz oys -- he -- ren, __
      ey -- des veln zayn __ di likh -- ti -- ke shte -- rn,
      a shvu -- e fun blut un a shvu -- e fun tre -- ren!
      mir shve -- rn, mir shve -- rn, mir shve -- rn!
    }
  >>
}

