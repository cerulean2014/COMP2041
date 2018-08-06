#!/usr/bin/perl -w

if(@ARGV != 2){
	die ("Usage: $0 <number of lines> <string>\n");
}
if($ARGV[0] !~ /^\d*$/){
	die ("$0: argument 1 must be a non-negative integer\n");
}

for($counter = 0; $counter < $ARGV[0]; $counter++){
	print "$ARGV[$#ARGV]\n";
}

#print(("$ARGV[1]\n") x $ARGV[0]);
