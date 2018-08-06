#!/usr/bin/perl -w

$url = "http://www.timetable.unsw.edu.au/current/$ARGV[0]KENS.html";
open F, "wget -q -O- $url|" or die $!;
while($line = <F>){
	if($line =~ /.*$ARGV[0].*/g){
		$line =~ s/.*href=\"//g;
		$line =~ s/.html.*//g;
		if(! contains($line, @courses)){
			push @courses, $line;
		}
	}
}
close F;
print @courses;

sub contains{
	my($tester, @array) = @_;
	foreach $element (@array){
		if($tester eq $element){
			return 1;
		}
	}
	return 0;
}
