#!/bin/env perl

use strict;
use warnings;

my $people = [
    {
        first_name => 'Tommy',
        last_name  => 'Stanton',
        website    => 'tommystanton.com',
    },
    {
        first_name => 'Andrew',
        last_name  => 'Grangaard',
        website    => 'lowlevelmanager.com',
    },

];

foreach my $person (@$people) {
format STDOUT =
Name: @<<<<<<<<<<<<<<<<<<        
(sprintf '%s %s', $person->{first_name}, $person->{last_name})
Website: @<<<<<<<<<<<<<<<<<<<<<<<
$person->{website}

.
write;
}
