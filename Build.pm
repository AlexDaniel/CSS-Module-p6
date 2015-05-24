use v6;

use CSS::Specification::Build;
use Panda::Builder;
use Panda::Common;

class Build is Panda::Builder {

    method build($where) {

        indir $where, {

            my $props;

            for (<etc css1-properties.txt> => <CSS1>,
                 <etc css21-properties.txt> => <CSS21>,
                 <etc css3x-font-properties.txt> => <CSS3 Fonts>,
                 <etc css3x-font-@fontface-properties.txt> => <CSS3 Fonts AtFontFace>,
                 <etc css3x-paged-media.txt> => <CSS3 PagedMedia>,
                ) {
                my ($input-spec, $class-isa) = .kv;
                my $level = do given $class-isa[0] {
                    when 'CSS1'  {1.0}
                    when 'CSS21' {2.1}
                    default      {3.0}
                };

                for :interface<Interface>,
                    :actions<Actions> ,
                    :grammar<Grammar> {
                    my ($type, $subclass) = .kv;
                    my $name = (<CSS Module>, @$class-isa, <Spec>, $subclass).flat.join('::');

                    my $class-dir = $*SPEC.catdir(<lib CSS Module>, @$class-isa, <Spec>);
                    mkdir $class-dir;

                    my $class-path = $*SPEC.catfile( $class-dir, $subclass~'.pm' );

                    my $input-path = $*SPEC.catfile( |@$input-spec );
                    say "Building $input-path => $name";
                    {
                        my $*IN = open $input-path, :r;
                        my $*OUT = open $class-path, :w;

                        CSS::Specification::Build::generate( $type, $name );
                    }

                    my @summary = CSS::Specification::Build::summary( :$input-path );
                    for @summary {
                        my %detail = %$_;
                        my $prop-name = %detail<name>:delete;
                        $props{$prop-name}{.key} = .value
                            for %detail.pairs;
                        $props{$prop-name}<level> //= $level;
                    }
                }
            }
            my $class-dir = $*SPEC.catdir(<lib CSS Module>);
            my $class-path = $*SPEC.catfile( $class-dir, 'MetaData.pm' );
            my $class-name = 'CSS::Module::MetaData';
            say "Building $class-name";
            {
                my $*OUT = open $class-path, :w;
                say 'use v6;';
                say "#  -- DO NOT EDIT --";
                say "# generated by: $*PROGRAM_NAME {@*ARGS}";
                say '';
                say "module $class-name \{";
                say "    our \$property = {$props.perl};";
                say '}';
            }
        }
    }
}

# Build.pm can also be run standalone 
sub MAIN(Str $working-directory = '.' ) {
    Build.new.build($working-directory);
}
