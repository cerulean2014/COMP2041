#!/usr/bin/perl -w

$output = "$ARGV[0]";
$output =~ s/\\/\\\\/g;
$output =~ s/\"/\\\"/g;

print "\#!/usr/bin/python3\n\n";
@result = split("\n", $output);
foreach $element (@result){
	print "print(\"$element\")\n";
}
