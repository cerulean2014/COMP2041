#!/usr/bin/perl -w
foreach $arg (@ARGV) {
    if($arg eq "--version"){
        print "$0: version 0.1\n";
        exit 0;
    } else {
    	# read from files supplied as command line arguments
        push @files, $arg;
    }
}

#can adjust the number of lines displayed via an optional first argument -N
$num_line = 10;
if(@files > 0 && $files[0] =~ /^-\d*/){
	$num_line = substr(shift(@files), 1);
}

if(@ARGV == 0){
	while ($line = <STDIN>){
		push @lines, $line;
	}
	$total_line_num = @lines;
	#display the last N lines of each file (default N = 10)
	$diff_num = $total_line_num - $num_line;
	if($diff_num > 0){
		for(; $diff_num > 0; $diff_num--){
			shift(@lines);
		}
	}
	print @lines;
}else{
	foreach $f (@files) {
		#display the error message tail.pl: can't open FileName for any unreadable file
		open F, '<', $f or die "$0: Can't open $f: $!\n";

		#if there is more than one named file, separate each by ==> FileName <==
		if(@files > 1){
			print "==> $f <==\n";
		}
		$total_line_num = `wc -l < $f`;
		@lines = <F>;

		#display the last N lines of each file (default N = 10)
		$diff_num = $total_line_num - $num_line;
		if($diff_num > 0){
			for(; $diff_num > 0; $diff_num--){
				shift(@lines);
			}
		}
		print @lines;
		close F;
	}
}

