#!/usr/bin/perl

package WordCount::Reducer;

use Moose;
with 'Hadoop::Streaming::Reducer';


###
# Given grouped rows of key\tvalue
# emit a list of key\tsum_of value
# ugly code, prints in two places, has to do cleanup at the end of the while loop.
# slightly better by abstracting the output side.
# what can we do for the input side? --> build an interator that returns key, [list of values]
# first, lets abstract out the reduce --> that's the interesting bit, and assume it will
#  be called on ($key, [values]);
# starting to see a pattern here.
#  * parse incoming file in map.
#  * output structured data (key\tvalue) from map
#  * read sorted lines in reduce.  
#  * map back to multiple values per key
#  * reduce a key and all its values
#  * output structured data (key\tvalue) from reduce.

sub reduce
{
    my ($self, $key, $values) = @_;
    my $count = 0;
    while( $values->has_next )
    {
        $count += $values->next;
    }
    $self->emit( $key => $count );
}

package main;
WordCount::Reducer->run;
