use v6;

grammar CSS::Vocabulary::CSS1 {

    # allow color names and define our vocabulary
    token named-color {:i [aqua | black | blue | fuchsia | gray | green | lime | maroon | navy | olive | purple | red | silver | teal | white | yellow] & <ident> }
    rule color:sym<named> {<named-color>}

    # Fonts
    # - font-family: [[<family-name> | <generic-family>],]* [<family-name> | <generic-family>]
    token font-family {:i [ serif | sans\-serif | cursive | fantasy | monospace] & <generic-family=.ident> || <family-name=.ident> | <family-name=.string> }
    rule decl:sym<font-family> {:i (font\-family) ':' [ <font-family> [ ',' <font-family> ]*
                                                        | <inherit> || <bad_args> ] }

    # - font-style: normal | italic | oblique
    token font-style {:i [ normal | bold | oblique ] & <ident> }
    rule decl:sym<font-style> {:i (font\-style) ':' [ <font-style> | <inherit> || <bad_args> ] }

    # - font-variant: normal | small-caps
    token font-variant {:i [ normal | small\-caps ] & <ident>}
    rule decl:sym<font-variant> {:i (font\-variant) ':' [ <font-variant>
                                                          | <inherit> || <bad_args> ] }
   # - font-weight: normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900
    token font-weight {:i [ normal | bold | bolder | lighter ] & <ident>
                           | [ 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 ] & <num> }
    rule decl:sym<font-weight> {:i (font\-weight) ':' [ <font-weight>
                                                        | <inherit> || <bad_args> ] }

    # - font-size: <absolute-size> | <relative-size> | <length> | <percentage>
    token absolute-size {i: [x?x\-]?small | medium | [x?x\-]?large & <ident> }
    token relative-size {:i [ larger | smaller ] & <ident> }
    token font-size {:i <absolute-size> | <relative-size> | <length> | <percentage> }
    rule decl:sym<font-size> {:i (font\-size) ':' [ <font-size>
                                                    | <inherit> || <bad_args> ] }
    # - font: [ <font-style> || <font-variant> || <font-weight> ]? <font-size> [ / <line-height> ]? <font-family>
    rule decl:sym<font> {:i (font) ':' [
                              [  <font-style> | <font-variant> | <font-weight> ]* <font-size> [ '/' <line-height> ]? <font-family>
                              | <inherit> || <bad_args> ] }
                             
    # - color: <color>
    # Backgrounds
    # - background-color: <color> | transparent
    token background-color {:i <color> | fixed & <ident> }
    rule decl:sym<background-color> {:i (background\-color) ':' [
                                          <background-color>
                                          | <inherit> || <bad_args> ]}

    # - background-image: <url> | none
    token background-image {:i <url> | fixed & <ident> }
    rule decl:sym<background-image> {:i (background\-image) ':' [
                                          <background-image>
                                          | <inherit> || <bad_args> ]}

    # - background-repeat: repeat | repeat-x | repeat-y | no-repeat
    token background-repeat {:i [ repeat[\-[x|y]]? | no\-repeat ] & <ident> }
    rule decl:sym<background-repeat> {:i (background\-repeat) ':' [
                                          <background-repeat>
                                          | <inherit> || <bad_args> ]}


    # - background-attachment: scroll | fixed
    token background-attachment {:i [ scroll | fixed ] & <ident> }
    rule decl:sym<background-attachment> {:i (background\-attachment) ':' [
                                               <background-attachment>
                                               | <inherit> || <bad_args> ]}

    # - background-position: [<percentage> | <length>]{1,2} | [top | center | bottom] || [left | center | right]
    rule background-position {:i [ <percentage> | <length> ]**1..2
                                    | [ top | center | bottom ] & <ident>
                                    [[ left | center | right ] & <ident> ]?}

    rule decl:sym<background-position> {:i (background\-position) ':' [
                                             <background-position>
                                             | <inherit> || <bad_args> ]}

    # - background: <background-color> || <background-image> || <background-repeat> || <background-attachment> || <background-position>
    rule decl:sym<background> {:i (background) ':' [
                                    [ <background-color> | <background-image> | <background-repeat> | <background-attachment> | <background-position> ]+
                                             | <inherit> || <bad_args> ]}


    # Text
    # - word-spacing: normal | <length>
    # - letter-spacing: normal | <length>
   rule decl:sym<*-spacing> {:i ([word|letter]\-spacing) ':' [
                                  normal & <ident> | <length>
                                  | <inherit> || <bad_args> ]}

    # - text-decoration: none | [ underline || overline || line-through || blink ]
    rule decl:sym<text-decoration> {:i (text\-decoration) ':' [
                                         none & <ident>
                                         | [[ underline | overline | line\-through | blink ] & <ident> ]+

                                 | <inherit> || <bad_args> ]}
    # - vertical-align: baseline | sub | super | top | text-top | middle | bottom | text-bottom | <percentage>
    rule decl:sym<vertical-align> {:i (vertical\-align) ':' [
                                         [ baseline | sub | super | top | text\-top | middle | bottom | text\-bottom ] & <ident>
                                         | <percentage>
                                         | <inherit> || <bad_args> ]}
    

    # - text-transform: capitalize | uppercase | lowercase | none
    rule decl:sym<text-transform> {:i (text\-transform) ':' [
                                        [ capitalize | uppercase | lowercase | none ] & <ident>
                                        | <inherit> || <bad_args> ]}

    # - text-align: left | right | center | justify
    rule decl:sym<text-align> {:i (text\-align) ':' [
                                    [ left | right | center | justify ] & <ident>
                                    | <inherit> || <bad_args> ]}

    # - text-indent: <length> | <percentage>
    rule decl:sym<text-indent> {:i (text\-indent) ':' [
                                     <length> | <percentage>
                                     | <inherit> || <bad_args> ]}

    # - line-height: normal | <number> | <length> | <percentage>
    token line-height {:i normal & <ident> | <num> | <length> | <percentage> }
    rule decl:sym<line-height> {:i (line\-height) ':' [
                                     <line-height>
                                     | <inherit> || <bad_args> ]}

    # - margin-top: <length> | <percentage> | auto
    # - margin-right: <length> | <percentage> | auto
    # - margin-bottom: <length> | <percentage> | auto
    # - margin-left: <length> | <percentage> | auto
    rule decl:sym<margin-*> {:i (margin\-[top|right|bottom|left]) ':' [
                                  <length> | <percentage> | auto & <ident> 
                                  | <inherit> || <bad_args> ]}

    # - margin: [ <length> | <percentage> | auto ]{1,4}
    rule decl:sym<margin> {:i (margin) ':' [
                                [ <length> | <percentage> | auto & <ident> ] ** 1..4
                                | <inherit> || <bad_args> ]}

    # - padding-top: <length> | <percentage>
    # - padding-right: <length> | <percentage>
    # - padding-bottom: <length> | <percentage>
    # - padding-left: <length> | <percentage>
    rule decl:sym<padding-*> {:i (padding\-[top|right|bottom|left]) ':' [
                                   <length> | <percentage>
                                   | <inherit> || <bad_args> ]}
 
    # - padding: [ <length> | <percentage> ]{1,4}
    rule decl:sym<padding> {:i (padding) ':' [
                                 [ <length> | <percentage> ] ** 1..4
                                 | <inherit> || <bad_args> ]}

    # - border-top-width: thin | medium | thick | <length>
    # - border-right-width: thin | medium | thick | <length>
    # - border-bottom-width: thin | medium | thick | <length>
    # - border-left-width: thin | medium | thick | <length>
    rule decl:sym<border-*-width> {:i (border\-[top|right|bottom|left]\-width) ':' [
                                        [ thin | medium | thick ] & <ident>
                                        | <length>
                                        | <inherit> || <bad_args> ]}

    # - border-width: [thin | medium | thick | <length>]{1,4}
    rule decl:sym<border-width> {:i (border\-width) ':' [
                                      [ [ thin | medium | thick ] & <ident>
                                        | <length> ] ** 1..4
                                      | <inherit> || <bad_args> ]}

    # - border-color: <color>{1,4}
    rule decl:sym<border-color> {:i (border\-color) ':' [
                                      [ <color> ] ** 1..4
                                      | <inherit> || <bad_args> ]}

    # - border-style: none | dotted | dashed | solid | double | groove | ridge | inset | outset
    token border-style {:i [ none | dotted | dashed | solid | double | groove | ridge | inset | outset ] & <ident> }
    rule decl:sym<border-style> {:i (border\-style) ':' [
                                      <border-style>
                                      | <inherit> || <bad_args> ]}

    # - border-top: <border-width> || <border-style> || <color>
    # - border-right: <border-width> || <border-style> || <color>
    # - border-bottom: <border-width> || <border-style> || <color>
    # - border-left: <border-width> || <border-style> || <color>   
    # - border: <border-width> || <border-style> || <color>
    rule decl:sym<border-*> {:i (border[\-[top|right|bottom|left]]?) ':' [
                                  [ <border-width> | <border-style> ]* <color>
                                  | <inherit> || <bad_args> ]}

    # Positioning etc
    # - width: <length> | <percentage> | auto
    # - height: <length> | <percentage> | auto
    # - float: left | right | none
    # - clear: none | left | right | both
    # - display: block | inline | list-item | none
    # - white-space: normal | pre | nowrap
    # - list-style-type: disc | circle | square | decimal | lower-roman | upper-roman | lower-alpha | upper-alpha | none
    # - list-style-image: <url> | none
    # - list-style-position: inside | outside
    # - list-style: <keyword> || <position> || <url>
    # - position: absolute | relative | static
    # - left: <length> | <percentage> | auto
    # - top: <length> | <percentage> | auto
    # - clip: <shape> | auto
    # - overflow: none | clip | scroll
    # - z-index: auto | <integer>
    # - visibility: inherit | visible | hidden
    # - page-break-before: auto | allways | left | right
    # - page-break-after: auto | allways | left | right
    # - size: <length>{1,2} | auto | portrait | landscape
    # - marks: crop || cross | none

}
