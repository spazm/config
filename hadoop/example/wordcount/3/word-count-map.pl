#!/usr/bin/perl 

use strict;
use warnings;

while(<>)
{
    my @words = grep { $_ } split( /\W+/, $_);
    emit($_,1) for @words;
}

sub emit
{
    my( $key, $value ) = @_;
    print "$key\t$value\n";
}
