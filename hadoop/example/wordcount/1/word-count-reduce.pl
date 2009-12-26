#!/usr/bin/perl

use strict;
use warnings;

=pod
Thomson 1
Thomson 1
TR      1
=cut

###
# Given grouped rows of key\tvalue
# emit a list of key\tsum_of value
# ugly code, prints in two places, has to do cleanup at the end of the while loop.

my $previous = '';
my $count =0;
while(my $line = <>)
{
    chomp $line;
    my ($key, $value ) = split( /\t/, $line );
    if ( $key eq $previous )
    {
        $count += $value;
    }
    else
    {
        print "$previous\t$count\n" if $previous;
        $count = $value;
        $previous = $key
    }
}
print "$previous\t$count\n"
