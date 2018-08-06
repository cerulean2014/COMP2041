#!/usr/bin/perl -w

$line = "hello";
$line =~ /(\d+)/g;
print $1;
