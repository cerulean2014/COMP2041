#!/usr/bin/perl -w

$url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/COMP9041.html";
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
	if($line =~ m/.*prerequisite.*/gi){
    	print $line;
    }
}
