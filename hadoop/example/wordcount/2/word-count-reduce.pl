#!/usr/bin/perl

use strict;
use warnings;

=pod
input:
  Thomson 1
  Thomson 1
  TR      1

output:
  Thomson 2
  TR      1
=cut

###
# Given grouped rows of key\tvalue
# emit a list of key\tsum_of value
# ugly code, prints in two places, has to do cleanup at the end of the while loop.
# slightly better by abstracting the output side.
# what can we do for the input side? --> build an interator that returns key, [list of values]
# first, lets abstract out the reduce --> that's the interesting bit, and assume it will
#  be called on ($key, [values]);

my $previous;
my $values=[];
while ( my $line = <> )
{
    chomp $line;
    my ( $key, $value ) = split( /\t/, $line );
    if ( defined $previous and $key eq $previous )
    {
        push @$values, $value;
    }
    else
    {
        reduce( $previous, $values ) if defined $previous;
        $values   = [$value];
        $previous = $key;
    }
}
reduce( $previous, $values );

sub reduce
{
    my ($key, $values) = @_;
    my $count = 0;
    $count += $_ for @$values;
    emit( $key, $count );
}

sub emit
{
    my ( $key, $value ) = @_;
    print "$key\t$value\n";
}
