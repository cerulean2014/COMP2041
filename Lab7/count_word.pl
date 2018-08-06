#!/usr/bin/perl -w

while($line = <STDIN>){
	$line = lc ($line);
	chomp($line);
	@array = grep (/./, (split(/[^a-zA-Z]/, $line)));
	push @data, @array;
}

$target = lc ($ARGV[0]);
$counter = 0;
foreach $word (@data){
	if ($word eq $target){
		$counter++;
	}
}
print "$target occurred $counter times\n";
