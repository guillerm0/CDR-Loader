#!/usr/bin/perl -w
use strict;
use warnings;
use IO::Dir;
use Thread::Pool;
use Data::Printer;
use Thread::Semaphore;
use Getopt::Long;
use lib './lib';
use CDR::Loader::TapLoader;
use Config::General;

###### VARIABLES #######
my $workers = 5;
my $maxjobs = 25;
my $minjobs = 15;

my $configLoader = Config::General->new(
    -ConfigFile => "./config/application.cfg"
);
my %config = $configLoader->getall;

my $pool = Thread::Pool->new({
    optimize => 'cpu', # default: 'memory'
    do => 'CDR::Loader::TapLoader::processFlow',
    frequency => 1000,
    autoshutdown => 1, # default: 1 = yes
    workers => $workers,     # default: 1
    maxjobs => $maxjobs,     # default: 5 * workers
    minjobs => $minjobs,     # default: maxjobs / 2
});
my $inputDir = IO::Dir->new($config{'inputDir'});
###### FUNCTION #######


####### MAIN #######
while(defined(my $line = $inputDir->read)){
    print "creating thread for ".$line."\n";
    $pool->job($line, \%config);
}
$pool->shutdown;





