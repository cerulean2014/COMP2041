#!/usr/bin/perl -w

undef @numbers;
foreach $element (@ARGV){
	push @numbers, $element;
}
@numbers = sort {$a <=> $b} @numbers;
print $numbers[@numbers/2], "\n";
