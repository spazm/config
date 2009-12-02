#!/usr/bin/perl

use warnings;
use strict;

my $a=1;
my $b = 33;
my $long = 23;
my @foo = qw(
a b c
    d ee ff
        g hij klm
);

foreach my $foo (@foo){ $foo *= 2; $output{$foo}={ number => $n++, foo=>$foo}};
