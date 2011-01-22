#!/usr/bin/perl

package Normalize::Reducer;

use Moose;
with 'Hadoop::Streaming::Reducer';

sub reduce
{
    my ( $self, $key, $values ) = @_;

    my @keys       = split( /\^/, $key );
    my $output_key = join( "\t", @keys );

    while( $values->has_next )
    {
        my $val          = $values->next;
        my @value        = split( /\^/, $val );
        my $output_value = join( "\t", @value );
        $self->emit( $output_key => $output_value );
    }
}

package main;
Normalize::Reducer->run;
