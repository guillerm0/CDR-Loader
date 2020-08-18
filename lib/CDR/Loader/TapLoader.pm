package CDR::Loader::TapLoader;
use strict;
use warnings;
use Moo;
use TAP3::Tap3edit;
use Try::Tiny;
use File::Copy;
use Data::Printer;

sub processFlow {
    my $file = shift;
    my $config = shift;

    try{
       my $tap = TAP3::Tap3edit->new();
       $tap->decode($config->{'inputDir'}."/".$file) or die $tap->error;

        ##############Logic here to manipulate data#############
        p $tap->structure;
    }catch{
        print "Could not decode file moving to error dir ".$file."\n";
        move($config->{'inputDir'}."/".$file, $config->{'errorDir'}."/".$file);
    }finally{
        # unlink $config->{'inputDir'}."/".$file;
    }
}

1;