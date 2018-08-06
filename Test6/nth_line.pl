#!/usr/bin/perl -w

open F, '<', "$ARGV[1]" or die "$0: Can't open $ARGV[1]: $!\n";
@input = <F>;
if($ARGV[0] <= @input){
	$output_string = '';
	for($counter = 0; $counter < $ARGV[0]; $counter++){
		$output_string = shift(@input);
	}
	print "$output_string";
}
close F;
