#!/usr/bin/perl
use strict;
use warnings;
use IO::Dir;
use Thread::Pool;
use Data::Printer;
use Thread::Semaphore;
###### FUNCTION #######

#Processor flow, here we do everything we need to do with the files incoming
sub processorFlow {
    my @data = @_; sleep int(rand(10)); p @data
}
###### VARIABLES #######
my $activeWorkerSmaphore = my $s = Thread::Semaphore->new();
my $activeWorkers:shared = 0;

my $pool = Thread::Pool->new(
    {
        optimize => 'cpu', # default: 'memory'

        pre => sub {$activeWorkerSmaphore->down(); $activeWorkers+=1; $activeWorkerSmaphore->up();},
        do => \&processorFlow,
        post => sub {$activeWorkerSmaphore->down(); $activeWorkers-=1; $activeWorkerSmaphore->up();},
        # monitor => sub { print "monitor with $_\n"},
        frequency => 1000,
        autoshutdown => 1, # default: 1 = yes
        workers => 10,     # default: 1
        maxjobs => 50,     # default: 5 * workers
        minjobs => 5,      # default: maxjobs / 2
    });

###### MAIN #######
my $inputDir = IO::Dir->new('/home/guillermo/S950/workspace/personal/CDR-Loader/input');
while(defined(my $line = $inputDir->read)){
    $pool->job($line);
}

while($activeWorkers != 0){
    print $activeWorkers."\n";
    sleep 1;
}




