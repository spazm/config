#!/usr/bin/perl 

package Normalize::Mapper;

use Data::Dumper;
use Moose;
with 'Hadoop::Streaming::Mapper';
has [qw( current_record current_value )] => ( is => 'rw' );

our $sep = '^';
our @field_names = qw( date ip path user );

sub map
{
    my ( $self, $line ) = @_;
    $self->parse_line( $line );
    $self->process();
    $self->output();
}

sub parse_line
{
    my( $self, $line ) = @_;
    my @fields = split( /\^/ , $line );
    my %current;
    @current{ @field_names } = @fields;
    $self->current_record( \%current );
}

sub process
{
    my $self    = shift;
    my $current = $self->current_record();

    my $clean;
    $clean->{geo}     = get_geo( $current->{ip} );
    $clean->{user_id} = get_userid( $current->{user} );
    $self->current_value( $clean );
}

sub get_geo
{    #stub
    my $ip = shift;
    return "US";
}

sub get_userid
{    
    my $user = shift;
    return length($user);;
}

sub output
{
    my $self    = shift;
    my $current = $self->current_record;
    my $values  = $self->current_value;

    my $key        = join( $sep, @$current{@field_names} );
    my @value_keys = sort keys %$values;
    my $value      = join( $sep, @$values{@value_keys} );

    $self->emit( $key, $value );
}

package main;
Normalize::Mapper->run;
