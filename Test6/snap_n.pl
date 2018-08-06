#!/usr/bin/perl -w

while($line = <STDIN>){
	if(! $data{$line}){
		$data{$line} = 0;
	}
	if(++$data{$line} == $ARGV[0]){
		print "Snap: $line";
		exit;
	}
}

	
