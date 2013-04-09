# This is a basic perl script to geocode addresses using InfoChimps' geocoding API.
# There are better ways to geocode and easier ways than this, but it was a good
# exercise in using Perl to hit an API. 
# Your infile needs to have one address on it per line. 
# Also, my perl code is not nearly this pretty. PerlTidy has been a huge help for that.


#!/opt/local/bin/perl5.12

use strict;
use WWW::Mechanize;
use warnings;

my $file    = $ARGV[0];
my $outfile = "outfile.txt";
open( FILE, "<$file" ) || die " Cannot open file $file : $!\n";
open( MYFILE, ">$outfile" );

my $url     = '';
my @data    = <FILE>;
my $addy    = '';
my $bareurl = '';
my $mech    = WWW::Mechanize->new( autocheck => 1 );
my $recnum  = 0;

$bareurl =
'http://api.infochimps.com/geo/utils/geolocate?apikey=YourAPIKeyGoesHere&f.address_text=';

foreach $addy (@data) {
    $url = $bareurl . $addy;
    $mech->get($url);

    print "\n";
    print MYFILE "\n";

    if ( $mech->content =~
        /([-]?[0-9]{1,3}\.[0-9]{1,30}\,[-]?[0-9]{1,3}\.[0-9]{1,30})/ )
    {
        my $latlon = $1;
        print $latlon. " ";
        print MYFILE $latlon . " ";
    }

    if ( $mech->content =~ /(\:0\.[0-9]{1,3})/ ) {
        my $confidence = $1;
        my ( $con1, $con2 ) = split( ":", $confidence );
        print $con2;
        print MYFILE $con2;
        if ( $con2 < 0.51 ) {
            print "\tLow confidence";
            print MYFILE "\tLow Confidence";
        }
        else {
            print "\tHigh confidence";
            print MYFILE "\tHigh Confidence";
        }

        #print "\n";
        #print MYFILE "\n";
        $recnum++;
        sleep(3);
    }

}
print "\n";
print $recnum . " records in total.\n";
print MYFILE $recnum . " records in total\n";
close FILE;
close MYFILE;
