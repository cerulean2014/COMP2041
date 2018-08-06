#!/usr/bin/perl -w

while($line = <STDIN>){
	chomp $line;
	$line =~ /(\d+) (\D+)/;
	$number = $1;
	$name = lc($2);
	
	$name =~ s/\s+/ /g;		#only keep one space
	$name =~ s/^\s//;
	$name =~ s/\s$//;		#remove starting and ending spaces
	$name =~ s/s$//;		#remove the trailing 's'
	
	
	if(! $data{$name}){		#if name does not exist in array, create a new one
		$data{$name}{'pods'} = 0;
		$data{$name}{'individuals'} = 0;
	}
	
	$data{$name}{'pods'} += 1;
	$data{$name}{'individuals'} += $number;
}

foreach $name (sort keys %data){
	print "$name observations: $data{$name}{'pods'} pods, $data{$name}{'individuals'} individuals\n";
}
