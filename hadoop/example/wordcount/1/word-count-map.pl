#!/usr/bin/perl 

use strict;
use warnings;

while(<>)
{
    my @words = split( /\W+/, $_);
    print "$_\t1\n" for grep { $_ } @words;
}
