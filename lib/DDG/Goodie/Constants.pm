package DDG::Goodie::Constants;
# ABSTRACT: Various Math and Physics constants.
use DDG::Goodie;
use YAML::XS qw( LoadFile );

zci answer_type => "constants";
zci is_cached   => 1;

name "Constants";
description "Provides the value, unit, symbol and other information for Mathematical and Scientific constants";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
category "formulas";
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Constants.pm";
attribution github => ["Roysten", "Roy van der Vegt"],
            github => ["hemanth", "Hemanth.HM"],
            twitter => "gnumanth";

my $constants = LoadFile(share("constants.yml"));

#loop through constants
foreach my $name (keys %$constants) {
    #obtain to constant with name $keyword
    my $constant = $constants->{$name};

    #add aliases as separate triggers
    foreach my $alias (@{$constant->{'aliases'}}) {
        $constants->{$alias} = $constant;
    }
}

my @triggers = keys %{$constants};
triggers startend => @triggers;

# Handle statement
handle query_lc => sub {
    my $constant = $constants->{$_};
    return unless my $val = $constant->{'value'};

    #fallback to plain answer if html is not present
    my $result = $val->{'html'} ? $val->{'html'} : $val->{'plain'};

    return $result, structured_answer => {
        input     => [],
        operation => $constant->{'name'},
        result    => $result
    };
};

1;
