#!/usr/bin/perl -w

#question, @input = <STDIN> will produce one more space at the beginning after 2nd line.

$counter = 0;
$pods = 0;
while($line = <STDIN>) {
	chomp $line;
	$line =~ /(\d+) (\D+)/;
	$number = $1;
	$name = $2;
	if($name eq $ARGV[0]){
		$pods += 1;
		$counter += $number;
	}
}
print "$ARGV[0] observations: $pods pods, $counter individuals\n";

