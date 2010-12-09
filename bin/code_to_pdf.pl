#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use Pod::Usage;
our $VERSION = (qw$Revision: 14319 $)[-1];

my $output_dir   = "$ENV{HOME}/public_html/pdf/";
my $dry_run      = 0;
my $verbose      = 0;
my $relative_dir = "";
my $help;
my $man;
my $version;
my $line_numbers;

my $result = GetOptions(
    "directory|dir=s"           => \$output_dir,
    "relative-directory|rdir=s" => \$relative_dir,
    "dry-run|n"                 => \$dry_run,
    "verbose|v"                 => \$verbose,
    "line_numbers|C:i"          => \$line_numbers,

    "version" => \$version,
    "help"    => \$help,
    "man"     => \$man,
);

(print "Version $VERSION\n\n" and exit 0 ) if $version;
pod2usage(2) unless $result;
pod2usage(1) if $help;
pod2usage(-exitstatus => 0, -verbose => 2) if $man;

#make sure relative_dir and output_dir have trailing slash.
$relative_dir .= '/' if ( $relative_dir && $relative_dir !~ m{/$} );
$output_dir   .= '/' if ( $output_dir !~ m{/$} );
$output_dir   .= $relative_dir if $relative_dir;

system( 'mkdir', '-p', $output_dir);

#enscript -MLetter sched.pl -Gr2 -p sched.ps

my $enscript = 'enscript';
my @default_args = qw( -MLetter -Gr2);
if ( defined $line_numbers )
{
    my $flag  
        = $line_numbers
        ? '-C' . $line_numbers
        : '-C'
        ;
    push @default_args, ( $flag );
}

my $ps2pdf = 'ps2pdf';

foreach my $file (@ARGV)
{
    my $output_file = my $input_file = $file;
    my @args = @default_args;
    #$output_file =~ s/(.*)\..*?$/$1/;
    $output_file .= ".pdf";
    $output_file = $output_dir . $output_file;
    print "$input_file -> $output_file\n";
    push @args, qw( --color -Eperl ) if $input_file =~ m/\.p[lm]$/i;
    push @args, qw( --color -Eperl ) if $input_file =~ m/\.t$/i;
    push @args, ( "--title",  $file );
    my $command
        = "$enscript @args '$input_file' -p - | $ps2pdf - '$output_file'";
    print "$command\n" if $verbose;
    system $command unless $dry_run;
}

__END__
=head1 NAME

code_to_pdf.pl - Create pdf from text file via enscript -2Gr.

=head1 SYNOPSIS

Converts text file to pdf for printing or display.  Output pdf is two-up with single header.
Date, pagenumber and filename appear in header/footer.

The created pdf is put into an output directory.  By default this under public_html.

code_to_pdf <options> [file]

 Options:
   --directory=<dir>            absolute path to output dir
   --relative_directory=<dir>   relative path from output dir.

 Flags:
   --dry-run         show the command but do not execute.
   --verbose         increase verbosity

   --help            brief help message
   --man             full documentation

=head1 OPTIONS

=over 8

=item B<--directory|dir>

Absolute path to pdf output directory.

=item B<--relative-directory|rdir>

Relative path to append to --directory absolute path.

=item B<--dry-run|--nodry-run>

Show command without executing. 

=item B<--verbose|--noverbose>

Set|Clear verbosity.  

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=item B<-version>

Prints the version number and exits.

=back

=head1 DESCRIPTION

B<This Program> will convert text files to formated outut in pdf format, using (n)enscript -2Gr.    The file is converted to ps via enscript and then converted to pdf via ps2pdf.

The output pdf will have the same name as the input file, with any extension replaced with '.pdf' and will be located in the output directory specified by --directory and --relative-directory.
=cut
