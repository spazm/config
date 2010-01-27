#!/usr/bin/perl 

package WordCount::Mapper;

use Moose;
with 'Hadoop::Streaming::Mapper';

sub map
{
    my ( $self, $key, $value ) = @_;
    my @words = grep { $_ } split( /\W+/, $value);
    $self->emit($_,1) for @words;
}

package main;
WordCount::Mapper->run;
