#!/usr/bin/perl 

package WordCount::Mapper;

use Moose;
with 'Hadoop::Streaming::Mapper';

sub map
{
    my ( $self, $line ) = @_;
    my @words = grep { $_ } split( /\W+/, $line);
    $self->emit($_,1) for @words;
}

package main;
WordCount::Mapper->run;
