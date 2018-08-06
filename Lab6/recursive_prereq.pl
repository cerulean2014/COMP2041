#!/usr/bin/perl -w

if($ARGV[0] eq '-r'){
	$coursename = $ARGV[1];
}else{
	$coursename = $ARGV[0];
}
push @result, $coursename;

while(@result){
	#print "we have @result till now, and shift.\n";
	$this = shift(@result);
	$checked = 0;
	for $checking (@preq_array){
		if($checking eq $this){
			$checked = 1;
			last;
		}
	}
	#print "course $this checked.\n";
	if($checked != 1){			#if this course has already been checked, then no need to push it again
		push @preq_array, $this;	#save checked preq into our final array
		$under = "http://www.handbook.unsw.edu.au/undergraduate/courses/2017/$this.html";
		$post = "http://www.handbook.unsw.edu.au/postgraduate/courses/2017/$this.html";
		open F, "wget -q -O- '$under' '$post'|" or die;
		while($line = <F>) {
			if($line =~ /.*Prerequisite.*/gi){
				chomp $line;
				$line =~ s/.*Prerequisite: //;
				$line =~ s/.*Prerequisites: //;
				$line =~ s/<.*$//;
				@pre = $line =~ /[A-Z]{4}[0-9]{4}/g;
				foreach $course (@pre) {
					$course =~ /[A-Z]{4}[0-9]{4}/g;
					if(defined $course){
						push @result, "$course";				#save got preq in an array
					}
				}
			}
		}
	}
	if(@ARGV == 1){
		foreach $course (sort @result){
			print "$course\n";
		}
		exit;
	}
}
shift(@preq_array);
foreach $course (sort @preq_array){
	print "$course\n";
}


