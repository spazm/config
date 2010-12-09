#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Getopt::Long;
use Socket qw(inet_ntoa inet_aton);

## User Definable:
my $display_sorted = 0;
my $show_list      = 0;
my $show_header;
my $show_cooked_fields          = 0;
my $raw                         = 0;
my $help                        = 0;
my $separator                   = '\^';
my $read_fields_from_first_line = 0;

my @show_fields;
my @show_digits;
my @matches;
my $results = GetOptions( 
    'read-fields!' => \$read_fields_from_first_line,
    'sort!'        => \$display_sorted, 
    'fields=s'     => \@show_fields,
    'numbers=s'    => \@show_digits,
    'match=s'      => \@matches,
    'cook!'        => \$show_cooked_fields,
    'list!'        => \$show_list,
    'header!'      => \$show_header,
    'raw!'         => \$raw,
    'help!'        => \$help,
    'separator=s'  => \$separator,
);
_usage() if $help or !$results;

sub _usage
{
    die <<"USAGE";
USAGE:
  $0 [options] log_file [log_file2 log_file3 ...]

OPTIONS:
  --fields=site_id : include these fields by name. (merged with --numbers)
  --numbers=1,2,3  : include these fields by column number (zero based)
     can be used multiple times and can include multivalued data to be split on comma(,).

  --separator      : change field separator from "$separator"
  --match=         : match fields from log by field_name.
     field.=.dleif    : match on ==
     field.eq.dleif   : match on eq 
     field.ne.dleif   : match on ne 
     field.<.dleif    : match on  <
     field.>.dleif    : match on  >
     field.=~.dleif   : match on =~
     'field !~ dleif' : match on !~
     field is null    : match on field not defined
     field is not null: match on field defined
       . or space may be included around operators
       --match can be listed multiple times, results will be joined via AND
       quotes may be needed with !~ and =~ and = to prevent shell metaweirdness.

FLAGS:
  --list        : show in compact list form
  --header      : show header row (in list mode)
  --raw         : emit (matching) lines in the raw form found in the logfile.
  --cook        : add derived fields _ip and _created to default list of options
                  _ip and _created are available by name regardless of this flag
  --sort        : display data sorted by field name instead of field number
  --read-fields : data has a header line containing field names

  --help        : show this help;

USAGE
}


$show_header = !$show_list unless defined $show_header;

#allow --fields to appear multiple times and/or to have a comma sep list
@show_fields = map { split(/,/,$_) } @show_fields;
@show_digits = map { split(/,/,$_) } @show_digits;


## Configuration data:

my $convert_sub = {
    ip      => sub { my $in=shift||""; eval { !inet_aton( $in ) ? "" : inet_ntoa( inet_aton($in) ) } || ""; },
    created => sub { scalar localtime (shift || time ) },
};
my @convert_fields = map{ "_$_" } sort keys %$convert_sub;

my @fields = qw( 
            created             
            ip                  
            TOO_MUCH_DATA
    );

if ( $read_fields_from_first_line )
{
    $separator="\t";
    my $first_row = <>;
    chomp( $first_row);
    @fields = split( $separator, $first_row );
}


push @fields, @convert_fields if $show_cooked_fields;

my $field_count = @fields;
my %id_for_field = map { $fields[$_] => $_ } (0..$#fields);
if (!$show_cooked_fields)
{
    $id_for_field{ '_' . $_ } = -1 for @convert_fields
}

push @show_fields, map { $fields[$_] } @show_digits;
@show_fields = @fields unless @show_fields;


foreach my $match (@matches)
{
    my ($match_field, $op, $match_value);
    if ( $match =~ m/(\w+)\s*=+\s*(\d+)/ )
    {
        $match_field = $1;
        $op          = '==';
        $match_value = $2;
    }
    elsif ( $match =~ m/(\w+)\s*!=\s*(\d+)/ )
    {
        $match_field = $1;
        $op          = '!=';
        $match_value = $2;
    }
    elsif ( $match =~ m/(\w+)\s*(=~|!~)\s*(\S*)/ )
    {
        $match_field = $1;
        $op          = $2;
        $match_value = $3;
    }
    elsif ( $match =~ m/(\w+)\s*([<>])\s*(\d+)/ )
    {
        $match_field = $1;
        $op          = $2;
        $match_value = $3;
    }
    elsif ( $match =~ m/(\w+)[,\s]+(eq|ne)[,\s]+(.*)/ )
    {
        $match_field = $1;
        $op          = $2; 
        $match_value = $3;
    }
    elsif ( $match =~ m/(\w+)[,\s]+ is [,\s]? (not)? [,\s]+ null/ix )
    {
        $match_field = lc($1);
        $op          = 'def';
        $match_value = $2 ? 1 : 0 ;
    }
    else 
    {
        die "unknown match value [$match]"
    }
    my $match_index = $id_for_field{ $match_field };

    die "unknown match_field($match_field) in match( $match )" unless $match_index;

    $match
        = !defined ($op) ? undef
        : $op eq '==' ? sub { return  $_[0]->[$match_index] == $match_value }
        : $op eq '!=' ? sub { return  $_[0]->[$match_index] != $match_value }
        : $op eq '<'  ? sub { return  $_[0]->[$match_index]  < $match_value }
        : $op eq '>'  ? sub { return  $_[0]->[$match_index]  > $match_value }
        : $op eq 'eq' ? sub { return  $_[0]->[$match_index] eq $match_value }
        : $op eq 'ne' ? sub { return  $_[0]->[$match_index] ne $match_value }
        : $op eq 'def'? sub { return  (defined $_[0]->[$match_index]) == $match_value }
        : $op eq '=~' ? sub { my $qr = qr{$match_value}i ; return  $_[0]->[$match_index] =~ /$qr/ }
        : $op eq '!~' ? sub { my $qr = qr{$match_value}i ; return  $_[0]->[$match_index] !~ /$qr/ }
        : undef;
    #warn Dumper{ match => $match , match_field => $match_field, match_index=>$match_index, match_value => $match_value, op => $op };
}
my $match = !@matches 
    ? undef 
    : sub {
        foreach my $code (@matches)
        {
            return 0 unless $code->(@_);
        }
        return 1;
    };

while (<>)
{
    chomp;
    next if /^\s*$/;
    my @data = split( $separator, $_, $field_count );
    next if (defined $match && !$match->(\@data));
    my %row;
    for my $i ( 0 .. $field_count - 1 )
    {
        my $field = $fields[$i];
        my $val
            = defined $data[$i]
            ? $data[$i]
            : '(undef)';
        $row{$field} = $val;
    }
    add_derived( \%row );


    if( $raw ) 
    {
        print $_ . "\n";
    }
    elsif( $show_list )
    { 
        report_list (\%row);
    }
    else 
    {
        report( \%row, );
    }
}

sub add_derived 
{
    my $row = shift;
    $row->{ '_' . $_ } = $convert_sub->{$_}->( $row->{$_} )
      for keys %$convert_sub;
}

sub report
{
    my ($row) = @_;

    my @keys
        = $display_sorted
        ? (sort keys %$row)
        : (@show_fields);

    for my $key (@keys)
    {
        printf "%22s (%2d) : %s\n", $key, $id_for_field{ $key }, $row->{$key};
    }
    print "\n";
}

my $done_first=0;
sub report_list
{
    my ($row)=@_;
    my %row = %$row;
    my @keys
        = $display_sorted
        ? (sort keys %$row)
        : (@show_fields);

    if ( !$done_first++ && $show_header )
    {
        print join("\t", @keys), "\n";
    }
    print join( "\t" , @row{@keys}), "\n";
}
