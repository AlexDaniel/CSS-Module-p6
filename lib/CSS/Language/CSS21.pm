use v6;

# specification: http://www.w3.org/TR/2011/REC-CSS2-20110607/propidx.html

use CSS::Grammar::CSS21;

grammar CSS::Language::CSS21:ver<20110607.000> 
    is CSS::Grammar::CSS21 {

    # For handling undimensioned numbers
    token length:sym<num> {<num><!before ['%'|\w]>}

    # allow color names and define our vocabulary
    token named-color {:i [aqua | black | blue | fuchsia | gray | green | lime | maroon | navy | olive | purple | red | silver | teal | white | yellow] & <ident> }
    rule color:sym<named> {<named-color>}
 
    # --- Functions --- #

    rule function:sym<attr>     {:i'attr(' [ <attribute_name=.ident> <type_or_unit=.ident>? [ ',' <fallback=.ident> ]? || <any_args>] ')'}
    rule function:sym<counter>  {:i'counter(' [ <ident> [ ',' <ident> ]* || <any_args> ] ')'}
    rule function:sym<counters> {:i'counters(' [ <ident> [ ',' <string> ]? || <any_args> ] ')' }

    # --- Properties --- #

    # - azimuth: <angle> | [[ left-side | far-left | left | center-left | center | center-right | right | far-right | right-side ] || behind ] | leftwards | rightwards | inherit
     rule decl:sym<azimuth> {:i (azimuth) ':' [
                                  <angle>
                                  | [
                                       [ [ [ left\-side | far\-left | left | center\-left | center | center\-right | right | far\-right | right\-side ] & <lr=.ident>  ]
                                        | behind & <behind=.ident>  ]**1..2
                                  ]
                                  | [ $<dl>=leftwards | $<dr>=rightwards ] & <delta=.ident>
                                  | <inherit> || <any_args> ] }

    # - background-attachment: scroll | fixed | inherit
    token background-attachment {:i [ scroll | fixed ] & <ident> }
    rule decl:sym<background-attachment> {:i (background\-attachment) ':' [
                                               <background-attachment>
                                               | <inherit> || <any_args> ]}

    # - background-color: <color> | transparent | inherit
    token background-color {:i <color> | transparent & <ident> }
    rule decl:sym<background-color> {:i (background\-color) ':' [
                                          <background-color>
                                          | <inherit> || <any_args> ]}

    # - background-image: <url> | none | inherit
    token background-image {:i <url> | none & <ident> }
    rule decl:sym<background-image> {:i (background\-image) ':' [
                                          <background-image>
                                          | <inherit> || <any_args> ]}

    # - background-position: [ [ <percentage> | <length> | left | center | right ] [ <percentage> | <length> | top | center | bottom ]? ] | [ [ left | center | right ] || [ top | center | bottom ] ] | inherit
    # refactored as [ <percentage> | <length> | left | center | right ] || [ <percentage> | <length> | top | center | bottom ] | inherit
    rule background-position {:i  [ 
                                   [ <percentage> | <length> | [ left | center | right ] & <ident>  ] 
                                   | [ <percentage> | <length> | [ top | center | bottom ] & <ident>  ]
                                  ]**1..2 }
    rule decl:sym<background-position> {:i (background\-position) ':' [
                                             <background-position>
                                             | <inherit> || <any_args> ]}

    # - background-repeat: repeat | repeat-x | repeat-y | no-repeat
    token background-repeat {:i [ repeat[\-[x|y]]? | no\-repeat ] & <ident> }
    rule decl:sym<background-repeat> {:i (background\-repeat) ':' [
                                          <background-repeat>
                                          | <inherit> || <any_args> ]}


    # - background: <background-color> || <background-image> || <background-repeat> || <background-attachment> || <background-position> | inherit
    rule decl:sym<background> {:i (background) ':' [
                                    [ <background-color> | <background-image> | <background-repeat> | <background-attachment> | <background-position> ]**1..5
                                             | <inherit> || <any_args> ]}

    # - border-collapse: collapse | separate | inherit
    rule decl:sym<border-collapse> {:i (border\-collapse) ':' [ [ collapse | separate ] & <ident>  | <inherit> || <any_args> ] }

    # - border-color: [ <color> | transparent ]{1,4} | inherit
    rule border-color { <color> | transparent & <ident>  }
    rule decl:sym<border-color> {:i (border\-color) ':' [
                                      [ <border-color> ] ** 1..4
                                      | <inherit> || <any_args> ]}

    # - border-spacing: <length> <length>? | inherit
    rule decl:sym<border-spacing> {:i (border\-spacing) ':' [ <length> <length>? | <inherit> || <any_args> ] }

    # - border-style: none | dotted | dashed | solid | double | groove | ridge | inset | outset
    token border-style {:i [ none | dotted | dashed | solid | double | groove | ridge | inset | outset ] & <ident> }
    rule decl:sym<border-style> {:i (border\-style) ':' [
                                      <border-style> ** 1..4
                                      | <inherit> || <any_args> ]}

    # - border-top|border-right|border-bottom|border-left: [ <border-width> || <border-style> || 'border-top-color' ] | inherit
    token border-width {:i [ thin | medium | thick ] & <ident> | <length> }
    rule decl:sym<border-*> {:i (border\-[top|right|bottom|left]) ':' [ [ [ <border-width> | <border-style> | <border-color> ]**1..3 ] | <inherit> || <any_args> ] }

   # - border-top-color|border-right-color|border-bottom-color|border-left-color: <color> | transparent | inherit
    rule decl:sym<border-*-color> {:i (border\-[top|right|bottom|left]\-color) ':' [ <border-top-color>  | <inherit> || <any_args> ] }

    # - border-top-style|border-right-style|border-bottom-style|border-left-style: <border-style> | inherit
    rule decl:sym<border-*-style> {:i (border\-[top|right|bottom\|left]\-style) ':' [ <border-style> | <inherit> || <any_args> ] }

    # - border-top-width|border-right-width|border-bottom-width|border-left-width: <border-width> | inherit
    rule decl:sym<border-*-width> {:i (border\-[top|rightbottom|left]\-width) ':' [ <border-width> | <inherit> || <any_args> ] }

    # - border-width: <border-width>{1,4} | inherit
    rule decl:sym<border-width> {:i (border\-width) ':' [ <border-width>**1..4 | <inherit> || <any_args> ] }

    # - border: [ <border-width> || <border-style> || 'border-top-color' ] | inherit
    rule decl:sym<border> {:i (border) ':' [ [ [ <border-width> | <border-style> | <border-top-color> ]**1..3 ] | <inherit> || <any_args> ] }

    # - bottom: <length> | <percentage> | auto | inherit
    rule decl:sym<bottom> {:i (bottom) ':' [ <length> | <percentage> | auto & <ident>  | <inherit> || <any_args> ] }

    # - caption-side: top | bottom | inherit
    rule decl:sym<caption-side> {:i (caption\-side) ':' [ [ top | bottom ] & <ident>  | <inherit> || <any_args> ] }

    # - clear: none | left | right | both | inherit
    rule decl:sym<clear> {:i (clear) ':' [ [ none | left | right | both ] & <ident>  | <inherit> || <any_args> ] }

    # - clip: <shape> | auto
    # interim <shape> token. need to be properly prototyped, etc
    token shape {:i'<?before rect('<function>}
    rule decl:sym<clip> {:i (clip) ':' [
                              <shape>
                              | auto  & <ident>
                              | <inherit> || <any_args> ]}


    # - color: <color> | inherit
    rule decl:sym<color> {:i (color) ':' [ <color> | <inherit> || <any_args> ] }

    # - content: normal | none | [ <string> | <uri> | <counter> | attr(<identifier>) | open-quote | close-quote | no-open-quote | no-close-quote ]+ | inherit
    rule decl:sym<content> {:i (content) ':' [ [ normal | none ] & <ident>  | [ [ <string> | <uri> | <counter> | <?before 'attr('><function> | [ open\-quote | close\-quote | no\-open\-quote | no\-close\-quote ] & <ident>  ] ]+ | <inherit> || <any_args> ] }

    # - counter-increment: [ <identifier> <integer>? ]+ | none | inherit
    rule decl:sym<counter-increment> {:i (counter\-increment) ':' [ [ <identifier> <integer>? ]+ | none & <ident>  | <inherit> || <any_args> ] }

    # - counter-reset: [ <identifier> <integer>? ]+ | none | inherit
    rule decl:sym<counter-reset> {:i (counter\-reset) ':' [ [ <identifier> <integer>? ]+ | none & <ident>  | <inherit> || <any_args> ] }

    # - cue-after: <uri> | none | inherit
    rule decl:sym<cue-after> {:i (cue\-after) ':' [ <uri> | none & <ident>  | <inherit> || <any_args> ] }

    # - cue-before: <uri> | none | inherit
    rule decl:sym<cue-before> {:i (cue\-before) ':' [ <uri> | none & <ident>  | <inherit> || <any_args> ] }

    # - cue: [ 'cue-before' || 'cue-after' ] | inherit
    rule decl:sym<cue> {:i (cue) ':' [ [ [ <cue-before> | <cue-after> ]**1..2 ] | <inherit> || <any_args> ] }

    # - cursor: [ [<uri> ,]* [ auto | crosshair | default | pointer | move | e-resize | ne-resize | nw-resize | n-resize | se-resize | sw-resize | s-resize | w-resize | text | wait | help | progress ] ] | inherit
    rule decl:sym<cursor> {:i (cursor) ':' [ [ [ <uri> ',' ]* [ [ auto | crosshair | default | pointer | move | e\-resize | ne\-resize | nw\-resize | n\-resize | se\-resize | sw\-resize | 's-resize' | w\-resize | text | wait | help | progress ] & <ident>  ] ] | <inherit> || <any_args> ] }

    # - direction: ltr | rtl | inherit
    rule decl:sym<direction> {:i (direction) ':' [ [ ltr | rtl ] & <ident>  | <inherit> || <any_args> ] }

    # - display: inline | block | list-item | inline-block | table | inline-table | table-row-group | table-header-group | table-footer-group | table-row | table-column-group | table-column | table-cell | table-caption | none | inherit
    rule decl:sym<display> {:i (display) ':' [ [ inline | block | list\-item | inline\-block | table | inline\-table | table\-row\-group | table\-header\-group | table\-footer\-group | table\-row | table\-column\-group | table\-column | table\-cell | table\-caption | none ] & <ident>  | <inherit> || <any_args> ] }

    rule decl:sym<elevation> {:i (elevation) ':' [
                                   <angle>
                                   | $<tilt>=[below | level | above]
                                   | $<delta>=[ $<dh>=higher | $<dl>=lower ]
                                   | <inherit> || <any_args> ]}

    # - empty-cells: show | hide | inherit
    rule decl:sym<empty-cells> {:i (empty\-cells) ':' [ [ show | hide ] & <ident>  | <inherit> || <any_args> ] }

    # - float: left | right | none | inherit
    rule decl:sym<float> {:i (float) ':' [ [ left | right | none ] & <ident>  | <inherit> || <any_args> ] }

    # - font-family: [[ <family-name> | <generic-family> ] [, <family-name> | <generic-family> ]* ] | inherit
    rule decl:sym<font-family> {:i (font\-family) ':' [ [ [ [ <family-name> | <generic-family> ] ] [ [ ', ' <family-name> | <generic-family> ] ]* ] | <inherit> || <any_args> ] }

    # - font-size: <absolute-size> | <relative-size> | <length> | <percentage> | inherit
    rule decl:sym<font-size> {:i (font\-size) ':' [ <absolute-size> | <relative-size> | <length> | <percentage> | <inherit> || <any_args> ] }

    # - font-style: normal | italic | oblique | inherit
    rule decl:sym<font-style> {:i (font\-style) ':' [ [ normal | italic | oblique ] & <ident>  | <inherit> || <any_args> ] }

    # - font-variant: normal | small-caps | inherit
    rule decl:sym<font-variant> {:i (font\-variant) ':' [ [ normal | small\-caps ] & <ident>  | <inherit> || <any_args> ] }

    # - font-weight: normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | inherit
    rule decl:sym<font-weight> {:i (font\-weight) ':' [ [ normal | bold | bolder | lighter ] & <ident>  | [ 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 ] & <num>  | <inherit> || <any_args> ] }

    # - font: [ [ 'font-style' || 'font-variant' || 'font-weight' ]? 'font-size' [ / 'line-height' ]? 'font-family' ] | caption | icon | menu | message-box | small-caption | status-bar | inherit
    rule decl:sym<font> {:i (font) ':' [ [ [ [ <font-style> | <font-variant> | <font-weight> ]**1..3 ]? <font-size> [ '/ ' <line-height> ]? <font-family> ] | [ caption | icon | menu | message\-box | small\-caption | status\-bar ] & <ident>  | <inherit> || <any_args> ] }

    # - height: <length> | <percentage> | auto | inherit
    rule decl:sym<height> {:i (height) ':' [ <length> | <percentage> | auto & <ident>  | <inherit> || <any_args> ] }

    # - left: <length> | <percentage> | auto | inherit
    rule decl:sym<left> {:i (left) ':' [ <length> | <percentage> | auto & <ident>  | <inherit> || <any_args> ] }

    # - letter-spacing: normal | <length> | inherit
    rule decl:sym<letter-spacing> {:i (letter\-spacing) ':' [ normal & <ident>  | <length> | <inherit> || <any_args> ] }

    # - line-height: normal | <number> | <length> | <percentage> | inherit
    rule decl:sym<line-height> {:i (line\-height) ':' [ normal & <ident>  | <number> | <length> | <percentage> | <inherit> || <any_args> ] }

    # - list-style-image: <uri> | none | inherit
    rule decl:sym<list-style-image> {:i (list\-style\-image) ':' [ <uri> | none & <ident>  | <inherit> || <any_args> ] }

    # - list-style-position: inside | outside | inherit
    rule decl:sym<list-style-position> {:i (list\-style\-position) ':' [ [ inside | outside ] & <ident>  | <inherit> || <any_args> ] }

    # - list-style-type: disc | circle | square | decimal | decimal-leading-zero | lower-roman | upper-roman | lower-greek | lower-latin | upper-latin | armenian | georgian | lower-alpha | upper-alpha | none | inherit
    rule decl:sym<list-style-type> {:i (list\-style\-type) ':' [ [ disc | circle | square | decimal | decimal\-leading\-zero | lower\-roman | upper\-roman | lower\-greek | lower\-latin | upper\-latin | armenian | georgian | lower\-alpha | upper\-alpha | none ] & <ident>  | <inherit> || <any_args> ] }

    # - list-style: [ 'list-style-type' || 'list-style-position' || 'list-style-image' ] | inherit
    rule decl:sym<list-style> {:i (list\-style) ':' [ [ [ <list-style-type> | <list-style-position> | <list-style-image> ]**1..3 ] | <inherit> || <any_args> ] }

    # - margin-right|margin-left: <margin-width> | inherit
    # - margin-top|margin-bottom: <margin-width> | inherit
    rule decl:sym<margin-*> {:i (margin\-[right|left|bottom|top]) ':' [ <margin-width> | <inherit> || <any_args> ] }

    # - margin: <margin-width>{1,4} | inherit
    rule decl:sym<margin> {:i (margin) ':' [ <margin-width>**1..4 | <inherit> || <any_args> ] }

    # - max-height: <length> | <percentage> | none | inherit
    rule decl:sym<max-height> {:i (max\-height) ':' [ <length> | <percentage> | none & <ident>  | <inherit> || <any_args> ] }

    # - max-width: <length> | <percentage> | none | inherit
    rule decl:sym<max-width> {:i (max\-width) ':' [ <length> | <percentage> | none & <ident>  | <inherit> || <any_args> ] }

    # - min-height: <length> | <percentage> | inherit
    rule decl:sym<min-height> {:i (min\-height) ':' [ <length> | <percentage> | <inherit> || <any_args> ] }

    # - min-width: <length> | <percentage> | inherit
    rule decl:sym<min-width> {:i (min\-width) ':' [ <length> | <percentage> | <inherit> || <any_args> ] }

    # - orphans: <integer> | inherit
    rule decl:sym<orphans> {:i (orphans) ':' [ <integer> | <inherit> || <any_args> ] }

    # - outline-color: <color> | invert | inherit
    rule decl:sym<outline-color> {:i (outline\-color) ':' [ <color> | invert & <ident>  | <inherit> || <any_args> ] }

    # - outline-style: <border-style> | inherit
    rule decl:sym<outline-style> {:i (outline\-style) ':' [ <border-style> | <inherit> || <any_args> ] }

    # - outline-width: <border-width> | inherit
    rule decl:sym<outline-width> {:i (outline\-width) ':' [ <border-width> | <inherit> || <any_args> ] }

    # - outline: [ 'outline-color' || 'outline-style' || 'outline-width' ] | inherit
    rule decl:sym<outline> {:i (outline) ':' [ [ [ <outline-color> | <outline-style> | <outline-width> ]**1..3 ] | <inherit> || <any_args> ] }

    # - overflow: visible | hidden | scroll | auto | inherit
    rule decl:sym<overflow> {:i (overflow) ':' [ [ visible | hidden | scroll | auto ] & <ident>  | <inherit> || <any_args> ] }

    # - padding-top|padding-right|padding-bottom|padding-left: <padding-width> | inherit
    rule decl:sym<padding-*> {:i (padding\-[top|right|bottom|left]) ':' [ <padding-width> | <inherit> || <any_args> ] }

    # - padding: <padding-width>{1,4} | inherit
    rule decl:sym<padding> {:i (padding) ':' [ <padding-width>**1..4 | <inherit> || <any_args> ] }

    # - page-break-after: auto | always | avoid | left | right | inherit
    rule decl:sym<page-break-after> {:i (page\-break\-after) ':' [ [ auto | always | avoid | left | right ] & <ident>  | <inherit> || <any_args> ] }

    # - page-break-before: auto | always | avoid | left | right | inherit
    rule decl:sym<page-break-before> {:i (page\-break\-before) ':' [ [ auto | always | avoid | left | right ] & <ident>  | <inherit> || <any_args> ] }

    # - page-break-inside: avoid | auto | inherit
    rule decl:sym<page-break-inside> {:i (page\-break\-inside) ':' [ [ avoid | auto ] & <ident>  | <inherit> || <any_args> ] }

    # - pause-after: <time> | <percentage> | inherit
    rule decl:sym<pause-after> {:i (pause\-after) ':' [ <time> | <percentage> | <inherit> || <any_args> ] }

    # - pause-before: <time> | <percentage> | inherit
    rule decl:sym<pause-before> {:i (pause\-before) ':' [ <time> | <percentage> | <inherit> || <any_args> ] }

    # - pause: [ [<time> | <percentage>]{1,2} ] | inherit
    rule decl:sym<pause> {:i (pause) ':' [ [ [ [ <time> | <percentage> ] ]**1..2 ] | <inherit> || <any_args> ] }

    # - pitch-range: <number> | inherit
    rule decl:sym<pitch-range> {:i (pitch\-range) ':' [ <number> | <inherit> || <any_args> ] }

    # - pitch: <frequency> | x-low | low | medium | high | x-high | inherit
    rule decl:sym<pitch> {:i (pitch) ':' [ <frequency> | [ x\-low | low | medium | high | x\-high ] & <ident>  | <inherit> || <any_args> ] }

    # - play-during: <uri> [ mix || repeat ]? | auto | none | inherit
    rule decl:sym<play-during> {:i (play\-during) ':' [ <uri> [ [ mix & <ident>  | repeat & <ident>  ]**1..2 ]? | [ auto | none ] & <ident>  | <inherit> || <any_args> ] }

    # - position: static | relative | absolute | fixed | inherit
    rule decl:sym<position> {:i (position) ':' [ [ static | relative | absolute | fixed ] & <ident>  | <inherit> || <any_args> ] }

    # - quotes: [<string> <string>]+ | none | inherit
    rule decl:sym<quotes> {:i (quotes) ':' [ [ <string> <string> ]+ | none & <ident>  | <inherit> || <any_args> ] }

    # - richness: <number> | inherit
    rule decl:sym<richness> {:i (richness) ':' [ <number> | <inherit> || <any_args> ] }

    # - right: <length> | <percentage> | auto | inherit
    rule decl:sym<right> {:i (right) ':' [ <length> | <percentage> | auto & <ident>  | <inherit> || <any_args> ] }

    # - speak-header: once | always | inherit
    rule decl:sym<speak-header> {:i (speak\-header) ':' [ [ once | always ] & <ident>  | <inherit> || <any_args> ] }

    # - speak-numeral: digits | continuous | inherit
    rule decl:sym<speak-numeral> {:i (speak\-numeral) ':' [ [ digits | continuous ] & <ident>  | <inherit> || <any_args> ] }

    # - speak-punctuation: code | none | inherit
    rule decl:sym<speak-punctuation> {:i (speak\-punctuation) ':' [ [ code | none ] & <ident>  | <inherit> || <any_args> ] }

    # - speak: normal | none | spell-out | inherit
    rule decl:sym<speak> {:i (speak) ':' [ [ normal | none | spell\-out ] & <ident>  | <inherit> || <any_args> ] }

    # - speech-rate: <number> | x-slow | slow | medium | fast | x-fast | faster | slower | inherit
    rule decl:sym<speech-rate> {:i (speech\-rate) ':' [ <number> | [ x\-slow | slow | medium | fast | x\-fast | faster | slower ] & <ident>  | <inherit> || <any_args> ] }

    # - stress: <number> | inherit
    rule decl:sym<stress> {:i (stress) ':' [ <number> | <inherit> || <any_args> ] }

    # - table-layout: auto | fixed | inherit
    rule decl:sym<table-layout> {:i (table\-layout) ':' [ [ auto | fixed ] & <ident>  | <inherit> || <any_args> ] }

    # - text-align: left | right | center | justify | inherit
    rule decl:sym<text-align> {:i (text\-align) ':' [ [ left | right | center | justify ] & <ident>  | <inherit> || <any_args> ] }

    # - text-decoration: none | [ underline || overline || line-through || blink ] | inherit
    rule decl:sym<text-decoration> {:i (text\-decoration) ':' [ none & <ident>  | [ [ underline & <ident>  | overline & <ident>  | line\-through & <ident>  | blink & <ident>  ]**1..4 ] | <inherit> || <any_args> ] }

    # - text-indent: <length> | <percentage> | inherit
    rule decl:sym<text-indent> {:i (text\-indent) ':' [ <length> | <percentage> | <inherit> || <any_args> ] }

    # - text-transform: capitalize | uppercase | lowercase | none | inherit
    rule decl:sym<text-transform> {:i (text\-transform) ':' [ [ capitalize | uppercase | lowercase | none ] & <ident>  | <inherit> || <any_args> ] }

    # - top: <length> | <percentage> | auto | inherit
    rule decl:sym<top> {:i (top) ':' [ <length> | <percentage> | auto & <ident>  | <inherit> || <any_args> ] }

    # - unicode-bidi: normal | embed | bidi-override | inherit
    rule decl:sym<unicode-bidi> {:i (unicode\-bidi) ':' [ [ normal | embed | bidi\-override ] & <ident>  | <inherit> || <any_args> ] }

    # - vertical-align: baseline | sub | super | top | text-top | middle | bottom | text-bottom | <percentage> | <length> | inherit
    rule decl:sym<vertical-align> {:i (vertical\-align) ':' [ [ baseline | sub | super | top | text\-top | middle | bottom | text\-bottom ] & <ident>  | <percentage> | <length> | <inherit> || <any_args> ] }

    # - visibility: visible | hidden | collapse | inherit
    rule decl:sym<visibility> {:i (visibility) ':' [ [ visible | hidden | collapse ] & <ident>  | <inherit> || <any_args> ] }

    # - voice-family: [[<specific-voice> | <generic-voice> ],]* [<specific-voice> | <generic-voice> ] | inherit
    rule decl:sym<voice-family> {:i (voice\-family) ':' [ [ [ [ <specific-voice> | <generic-voice> ] ] ',' ]* [ [ <specific-voice> | <generic-voice> ] ] | <inherit> || <any_args> ] }

    # - volume: <number> | <percentage> | silent | x-soft | soft | medium | loud | x-loud | inherit
    rule decl:sym<volume> {:i (volume) ':' [ <number> | <percentage> | [ silent | x\-soft | soft | medium | loud | x\-loud ] & <ident>  | <inherit> || <any_args> ] }

    # - white-space: normal | pre | nowrap | pre-wrap | pre-line | inherit
    rule decl:sym<white-space> {:i (white\-space) ':' [ [ normal | pre | nowrap | pre\-wrap | pre\-line ] & <ident>  | <inherit> || <any_args> ] }

    # - widows: <integer> | inherit
    rule decl:sym<widows> {:i (widows) ':' [ <integer> | <inherit> || <any_args> ] }

    # - width: <length> | <percentage> | auto | inherit
    rule decl:sym<width> {:i (width) ':' [ <length> | <percentage> | auto & <ident>  | <inherit> || <any_args> ] }

    # - word-spacing: normal | <length> | inherit
    rule decl:sym<word-spacing> {:i (word\-spacing) ':' [ normal & <ident>  | <length> | <inherit> || <any_args> ] }

    # - z-index: auto | <integer> | inherit
    rule decl:sym<z-index> {:i (z\-index) ':' [ auto & <ident>  | <integer> | <inherit> || <any_args> ] }

}

