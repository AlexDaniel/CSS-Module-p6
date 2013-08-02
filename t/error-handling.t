#!/usr/bin/env perl6

# these tests check for conformance with error handling as outline in
# http://www.w3.org/TR/2011/REC-CSS2-20110607/syndata.html#parsing-errors

use Test;
use JSON::Tiny;

use CSS::Grammar::Test;
use CSS::Language::CSS3;

my $css_actions = CSS::Language::CSS3::Actions.new;

my $fh = open 't/error-handling.json', :r;

for ( $fh.lines ) {
    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }

    my ($rule, %test) = @( from-json($_) );
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = CSS::Language::CSS3.parse( $input, :rule($rule), :actions($css_actions));
    CSS::Grammar::Test::parse_tests($input, $p3, :rule($rule), :suite('css3 errors'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;