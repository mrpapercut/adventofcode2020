#!/usr/bin/perl
use File::Spec;
use Cwd qw/abs_path/;

my ($volume, $directory, $file) = File::Spec->splitpath(abs_path($0));

my $inputfilename = $directory . 'day2.txt';
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
