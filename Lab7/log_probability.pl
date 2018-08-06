#!/usr/bin/perl -w
foreach $file (glob "lyrics/*.txt") {
	$counter = 0;
	open F, '<', $file or die;
	undef @data;
	while($line = <F>){
		$line = lc ($line);
		chomp($line);
		@array = grep (/./, (split(/[^a-zA-Z]/, $line)));
		push @data, @array;
	}
	$target = lc ($ARGV[0]);
	foreach $word (@data){
		if ($word eq $target){
			$counter++;
		}
	}
	$file =~ s/lyrics\///g;
	$file =~ s/.txt//g;
	$file =~ s/_/ /g;
	$result{$file}{'total'} = scalar (@data);
	$result{$file}{'occur'} = $counter;
	close F;
}

foreach $name (sort keys %result){
	printf ("log((%d+1)/ %d) = %.4f %s\n", $result{$name}{'occur'}, $result{$name}{'total'}, log(($result{$name}{'occur'}+1)/$result{$name}{'total'}), $name);
}
