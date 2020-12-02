#!/usr/bin/perl

my $inputfilename = '../input/day2.txt';
my $validcount = 0;

open(FH, '<', $inputfilename);

while(<FH>) {
    my ($timesfrom, $timesto, $letter, $password) = ($_ =~ m/(\d+)-(\d+)\s(\w):\s(\w+)/);

    my @times = ($password =~ m/\Q$letter/g);

    if (@times >= $timesfrom && @times <= $timesto) {
        $validcount++;
    }
}

print $validcount;
