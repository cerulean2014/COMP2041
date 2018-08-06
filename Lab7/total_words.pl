#!/usr/bin/perl -w

while($line = <STDIN>){
	chomp($line);
	@array = grep (/./, split(/[^a-zA-Z]/, $line));
	#use grep /./ to remove empty strings
	push @data, @array;
}
printf ("%d words\n", scalar @data);
