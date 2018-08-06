#!/usr/bin/perl -w

$under = "http://www.handbook.unsw.edu.au/undergraduate/courses/2017/$ARGV[0].html";
$post = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/$ARGV[0].html";

open F, "wget -q -O- '$under' '$post'|" or die;
while ($line = <F>) {
	if($line =~ /.*Prerequisite.*/gi){
		chomp $line;
		$line =~ s/.*Prerequisite: //;
		$line =~ s/.*Prerequisites: //;
		$line =~ s/<.*$//;
		@pre = $line =~ /[A-Z]{4}[0-9]{4}/g;
		#print "@pre\n";
		foreach $course (@pre) {
			#print "course is $course\n";
			$course =~ /[A-Z]{4}[0-9]{4}/g;
			print "$course\n";
		}
    }
}


