#!/usr/bin/perl -w

foreach $line (<STDIN>){
	chomp($line);
	@array = split(/ /, $line);
	@array = sort @array;
	print "@array\n";
}
