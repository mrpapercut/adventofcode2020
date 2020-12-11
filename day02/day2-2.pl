#!/usr/bin/perl
use File::Spec;
use Cwd qw/abs_path/;

my ($volume, $directory, $file) = File::Spec->splitpath(abs_path($0));

my $inputfilename = $directory . 'day2.txt';
my $validcount = 0;

open(FH, '<', $inputfilename);

while(<FH>) {
    my ($firstpos, $secondpos, $letter, $password) = ($_ =~ m/(\d+)-(\d+)\s(\w):\s(\w+)/);

    my $match = 0;

    my $pos1 = substr($password, $firstpos - 1, 1);
    my $pos2 = substr($password, $secondpos - 1, 1);

    if (ord($pos1) == ord($letter)) {
        $match++;
    }

    if (ord($pos2) == ord($letter)) {
        $match++;
    }
    
    if ($match == 1) {
        $validcount++;
    }
}

print $validcount;
