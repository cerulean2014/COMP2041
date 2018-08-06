#!/usr/bin/perl -w
	
#why can't the program display "$ARGV[0]" as song?.txt but song0.txt?
foreach $song (@ARGV){
	#print "we are opening $song\n";
	open F, '<', $song or die "$0: Can't open $song: $!\n";
	undef @{$song};
	while($line = <F>){
		$line = lc ($line);
		chomp($line);
		@array = grep (/./, (split(/[^a-zA-Z]/, $line)));
		push @{$song}, @array;
	}
	close F;
}

#only read each file once
foreach $artist (glob "lyrics/*.txt") { #test for each artist
	#print "reading $artist\n";
	open F, '<', $artist or die;
	undef @data;
	while($line = <F>){
		$line = lc ($line);
		chomp($line);
		@array = grep (/./, (split(/[^a-zA-Z]/, $line)));
		push @data, @array;
	}
	$artist =~ s/lyrics\///g;
	$artist =~ s/.txt//g;
	$artist =~ s/_/ /g;
	close F;
	
	$counter = 0;
	foreach $song (@ARGV){
		$result{$song}{$artist} = 0;
		foreach $singleword (@{$song}){
			$counter = 0;
			foreach $word (@data){
				if($word eq $singleword){
					$counter++;
				}
			}
			$result{$song}{$artist} += log(($counter+1)/scalar @data); #total probability that this song appears in an artist
		
		}
	}
}

foreach $songname (sort keys %result){ #in each song, find the largest number then print
	foreach $artist (sort {$result{$songname}{$b} <=> $result{$songname}{$a}} keys %{$result{$songname}}) {
		printf ("%s most resembles the work of %s (log-probability=%.1f)\n", $songname, $artist, $result{$songname}{$artist});
		last;
		#print "$Array{$#Array};
	}
	
}


