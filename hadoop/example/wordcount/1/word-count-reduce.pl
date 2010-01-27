#!/usr/bin/perl

use strict;
use warnings;

=pod
input: (tab sep)
  Thomson 1
  Thomson 1
  TR      1

output: (tab sep)
  Thomson 2
  TR      1
=cut

my $count        = 0;
my $previous_key = '';
while ( my $line = <> )
{
    chomp $line;
    my ( $key, $value ) = split( /\t/, $line );
    if ( $key eq $previous_key )
    {
        $count += $value;
    }
    else
    {
        print "$previous_key\t\$count\n";
        $previos_key = $key;
        $count       = $value;
    }
}

#print final key last
print "$previous_key\t\$count\n";
