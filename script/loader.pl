#!/usr/bin/perl
use strict;
use warnings;
use IO::Dir;
use Thread::Pool;
use Data::Printer;
use Thread::Semaphore;
use Getopt::Long;

my $workers = 5;
my $maxjobs = 25;
my $minjobs = 15;

GetOptions(
    'workers|w=i' => \$workers,
    'maxjobs|m=i' => \$maxjobs,
    'minjobs|n=i' => \$minjobs,
);

###### FUNCTION #######

#Processor flow, here we do everything we need to do with the files incoming
sub processorFlow;



###### VARIABLES #######
my $pool = Thread::Pool->new(
    {
        optimize => 'cpu', # default: 'memory'
        do => \&processorFlow,
        frequency => 1000,
        autoshutdown => 1, # default: 1 = yes
        workers => $workers,     # default: 1
        maxjobs => $maxjobs,     # default: 5 * workers
        minjobs => $minjobs,      # default: maxjobs / 2
    });


###### MAIN #######
my $inputDir = IO::Dir->new('/home/guillermo/S950/workspace/personal/CDR-Loader/input');
while(defined(my $line = $inputDir->read)){
    $pool->job($line);
}

$pool->shutdown;

## FUNCTIONS ##
sub processorFlow; {
    my @data = @_; sleep int(rand(10)); p @data; return;
}


