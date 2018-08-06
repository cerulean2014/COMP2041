#!/usr/bin/perl -w

open F, '<', "$ARGV[0]" or die "$0: Can't open $ARGV[1]: $!\n";
foreach $line (<F>){
	push @input, $line;
}
close F;
if(@input == 0){
	exit;
}
if(@input %2 == 0){
	print "$input[@input/2 - 1]";
}
print "$input[@input/2]";
