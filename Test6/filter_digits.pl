#!/usr/bin/perl -w

foreach $line (<STDIN>){
	$line =~ s/\d//g;
	print "$line";
}

=def
while($line = <STDIN>){
	$line =~ s/\d//g;
	push @output, $line;
}
while($out = shift(@output)){
	print $out;
}

or
while($line = <STDIN>){
	$line =~ s/\d//g;
	print $line;
}

foreach reads and store whole file, then change it one line by one line,
while reads a line, changes a line
