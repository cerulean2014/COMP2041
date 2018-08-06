#!/usr/bin/perl -w

$string = "print (\"print \"print (\\\"#!/usr/bin/perl -w\\\")\\\n\";\")";
@array = split("\n", $string);
print scalar @array;

