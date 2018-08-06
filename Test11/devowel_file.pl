#!/usr/bin/perl -w

undef @result;
open F, '<', "$ARGV[0]" or die $!;
foreach $line (<F>){
	$line =~ s/[aeiou]//gi;
	push @result, $line;
}
close F;

open F, '>', "$ARGV[0]" or die $!;
print F @result;
close F;

