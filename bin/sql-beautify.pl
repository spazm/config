#!/usr/bin/perl

use warnings;
use strict;
use SQL::Beautify;

local $/;
my $sql = SQL::Beautify->new( 
    query => <STDIN>, 
    spaces => 4, 
    break => "\n" 
);
print $sql->beautify;
