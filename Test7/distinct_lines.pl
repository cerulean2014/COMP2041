#!/usr/bin/perl -w

$counter = 0;
while ($line = <STDIN>){
	$counter++;
	$line = lc($line);
	$line =~ s/\s+/ /g;
	$line =~ s/^ //g;
	$line =~ s/ $//g;
	if(!contained($line, @array)){
		push @array, $line;
	}
	if(@array == $ARGV[0]){
		printf ("%d distinct lines seen after %d lines read.\n", $ARGV[0], $counter);
		exit;
	}
}

print "End of input reached after $counter lines read - $ARGV[0] different lines not seen.\n";

sub contained {
	my($tester, @data) = @_;
	foreach $element (@data){
		if($element eq $tester){
			return 1;
		}
	}
	return 0;
}
