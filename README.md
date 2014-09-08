CSS::Module
=============

CSS::Module is a property-specific validator and parser for CSS Levels 1, 2.1 and  3.

This module aims to be reference implementation of [CSS Snapshot 2010](http://www.w3.org/TR/2011/NOTE-css-2010-20110512/).

It implements the following grammars and actions:

- `CSS::Module::CSS1` + `CSS::Module::CSS1::Actions`
- `CSS::Module::CSS21` + `CSS::Module::CSS21::Actions`
- `CSS::Module::CSS3` + `CSS::Module::CSS3::Actions`

`CSS::Module::CSS3` is composed from the following extension modules.

- `CSS::Module::CSS3::Colors`     - CSS 3.0 Colors (@color-profile)
- `CSS::Module::CSS3::Fonts`      - CSS 3.0 Fonts (@font-face)
- `CSS::Module::CSS3::Selectors`  - CSS 3.0 Selectors
- `CSS::Module::CSS3::Namespaces` - CSS 3.0 Namespace (@namespace)
- `CSS::Module::CSS3::Media`      - CSS 3.0 Media (@media)
- `CSS::Module::CSS3::PagedMedia` - CSS 3.0 Paged Media (@page)
- `CSS::ModuleX::CSS21`           - the full set of CSS21 properties

Installation
------------
This module works with Rakudo Star 2014.09 or better [download from http://rakudo.org/downloads/star/ - don't forget the final `make install`]:

Ensure that `perl6` and `panda` are available on your path, e.g. :

    % export PATH=~/src/rakudo-star-2013.02/install/bin:$PATH

You can then use `panda` to test and install `CSS::Module`:

    % panda install CSS::Module

To try parsing some content:

    % perl6 -MCSS::Module::CSS21 -e"say CSS::Module::CSS21.parse('h1 {margin:2pt; color: blue}')"

Examples
--------

- parse CSS2.1:

    ```
    use v6;
    use CSS::Module::CSS21;
    use CSS::Module::CSS21::Actions;

    my $css = 'H1 { color: blue; foo: bar; background-color: zzz }';

    my $actions =  CSS::Module::CSS21::Actions.new;
    my $p = CSS::Module::CSS21.parse($css, :actions($actions));
    note $_ for $actions.warnings;
    say "declaration: " ~ $p.ast[0]<ruleset><declarations>.perl;
    # output:
    # unknown property: foo - declaration dropped
    # usage background-color: <color> | transparent | inherit
    # declaration: {"color" => {"expr" => ["color" => {"r" => 0, "g" => 0, "b" => 255}]}}
    ```

- It's possible to compose custom classes for diffrent feature sets. This example creates MyCSS3Subset and class MyCSS3Subset::Actions comprising CSS2.1 properties + CSS3 Selectors + CSS3 Colors:

    ```
    use v6;

    use CSS::Module::CSS21::Actions;
    use CSS::Module::CSS21;

    use CSS::Module::CSS3::Colors;
    use CSS::Module::CSS3::Selectors;
    use CSS::Module::CSS3::_Base;

    grammar MyCSS3Subset::CSS3
        is MyCSS3Subset::Colors
        is CSS::Module::CSS3::Fonts
        is CSS::ModuleX::CSS21
        is CSS::Module::CSS3::_Base
    {};

    class MyCSS3Subset::Actions
        is CSS::Module::CSS3::Colors::Actions
        is CSS::Module::CSS3::Fonts::Actions
        is CSS::ModuleX::CSS21::Actions
        is CSS::Module::CSS3::_Base::Actions
    {};
    ```

Property Definitions
--------------------
Property definitions are built from the sources in the (etc) directory using the CSS::Specification tools. These implement the [W3C Property Definition Syntax](https://developer.mozilla.org/en-US/docs/Web/CSS/Value_definition_syntax).

For example [CSS::Module:CSS1::Spec::Grammar](lib/CSS/Module/CSS1/Spec/Grammar.pm), [CSS::Module:CSS1::Spec::Actions](lib/CSS/Module/CSS1/Spec/Actions.pm) and [CSS::Module:CSS1::Spec::Interface](lib/CSS/Module/CSS1/Spec/Interface.pm) are generated from [etc/css1-properties.txt](etc/css1-properties.txt).

See [Build.pm](Build.pm).

See Also
========
- [CSS::Specification](https://github.com/p6-css/perl6-CSS-Specification) - property definition syntax
- [CSS::Grammar](https://github.com/p6-css/perl6-CSS-Grammar) - base grammars
- [CSS::Drafts](https://github.com/p6-css/perl6-CSS-Drafts) - CSS draft extension modules

References
==========
- CSS Snapshot 2010 - http://www.w3.org/TR/2011/NOTE-css-2010-20110512/
- CSS1 - http://www.w3.org/TR/2008/REC-CSS1-20080411/#css1-properties
- CSS21 - http://www.w3.org/TR/2011/REC-CSS2-20110607/propidx.html
- CSS3
  - CSS Color Module Level 3 - http://www.w3.org/TR/2011/REC-css3-color-20110607/
  - CSS Fonts Module Level 3 - http://www.w3.org/TR/2013/WD-css3-fonts-20130212/
  - CSS3 Namespaces Module - http://www.w3.org/TR/2011/REC-css3-namespace-20110929/
  - CSS3 Media Query Extensions - http://www.w3.org/TR/2012/REC-css3-mediaqueries-20120619/
  - CSS3 Module: Paged Media - http://www.w3.org/TR/2006/WD-css3-page-20061010/
  - CSS Selectors Module Level 3 - http://www.w3.org/TR/2011/REC-css3-selectors-20110929/


