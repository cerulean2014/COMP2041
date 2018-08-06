#!/usr/bin/perl -w

foreach $word (@ARGV){
	if(!contained($word, @array)){
		push @array, $word;
	}
}

print "@array\n";

sub contained {
	my($tester, @data) = @_;
	foreach $element (@data){
		if($element eq $tester){
			return 1;
		}
	}
	return 0;
}
