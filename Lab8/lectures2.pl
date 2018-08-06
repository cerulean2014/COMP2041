#!/usr/bin/perl -w

#0 = nothing, 1 = d, 2 = t
@given_courses = @ARGV;
if($ARGV[0] eq '-d'){
	$option = 1;
	shift @given_courses;
}elsif($ARGV[0] eq '-t'){
	$option = 2;
	shift @given_courses;
}else{
	$option = 0;
}

$X1 = 0;
$S1 = 0;
$S2 = 0;

foreach $course (@given_courses){
	open F, "wget -q -O- 'http://timetable.unsw.edu.au/current/$course.html'|" or die $!;
	while($line = <F>){
		if($line =~ /<td class="data"><a href="#(S[12]|X1)-[0-9]+">Lecture<\/a><\/td>/gi){
			$sem = $1;
			for($i = 0; $i < 6; $i++){
				$line = <F>;
			}
			$data = extract($line);
			if($data ne "\n" &&  (! exist("$course: $sem $data", @result))){
				push @result, "$course: $sem $data";
				@matches = $data =~ /[a-z]{3} [0-9]{2}:[0-9]{2} - [0-9]{2}:[0-9]{2}/gi;
				foreach $element (@matches){
					#print "$element\n";
					($day, $start, $end) = $element =~ /([a-z]{3}) ([0-9]{2}):[0-9]{2} - ([0-9]{2}):[0-9]{2}/i;
					$start = remove0($start);
					$end = remove0($end);
					for($i = $start; $i < $end; $i++){
						if(! exist("$sem $course $day $i\n", @detail)){
							${$sem} = 1;
							push @detail, "$sem $course $day $i\n";
						}
					}
				}
			}
		}

	}
	close F;
}


foreach $course(@given_courses){
	# check s1
	for($time = 9; $time <= 20; $time++){
		$S1data{'Mon'}{$time} += count($course, 'S1', 'Mon', $time, @detail);
		$S1data{'Tue'}{$time} += count($course, 'S1', 'Tue', $time, @detail);
		$S1data{'Wed'}{$time} += count($course, 'S1', 'Wed', $time, @detail);
		$S1data{'Thu'}{$time} += count($course, 'S1', 'Thu', $time, @detail);
		$S1data{'Fri'}{$time} += count($course, 'S1', 'Fri', $time, @detail);
	}
	# check s2
	for($time = 9; $time <= 20; $time++){
		$S2data{'Mon'}{$time} += count($course, 'S2', 'Mon', $time, @detail);
		$S2data{'Tue'}{$time} += count($course, 'S2', 'Tue', $time, @detail);
		$S2data{'Wed'}{$time} += count($course, 'S2', 'Wed', $time, @detail);
		$S2data{'Thu'}{$time} += count($course, 'S2', 'Thu', $time, @detail);
		$S2data{'Fri'}{$time} += count($course, 'S2', 'Fri', $time, @detail);
	}
	# check x1
	for($time = 9; $time <= 20; $time++){
		$S1data{'Mon'}{$time} += count($course, 'X1', 'Mon', $time, @detail);
		$S1data{'Tue'}{$time} += count($course, 'X1', 'Tue', $time, @detail);
		$S1data{'Wed'}{$time} += count($course, 'X1', 'Wed', $time, @detail);
		$S1data{'Thu'}{$time} += count($course, 'X1', 'Thu', $time, @detail);
		$S1data{'Fri'}{$time} += count($course, 'X1', 'Fri', $time, @detail);
	}
}



if($option == 0){
	print @result;
}elsif($option == 1){
	print @detail;
}elsif($option == 2){
	if($S1){
		print "S1	Mon	Tue	Wed	Thu	Fri\n";
		for($time = 9; $time <= 20; $time++){
			$timewith0 = fill0($time);
			print "$timewith0:00";
			foreach $workingday ("Mon", "Tue", "Wed", "Thu", "Fri"){
				if($S1data{$workingday}{$time} == 0){
					$S1data{$workingday}{$time} = ' ';
				}
				printf ("\t%2s", $S1data{$workingday}{$time});
			}
			print "\n";
		}
	}
	if($S2){
		print "S2	Mon	Tue	Wed	Thu	Fri\n";
		for($time = 9; $time <= 20; $time++){
			$timewith0 = fill0($time);
			print "$timewith0:00";
			foreach $workingday ("Mon", "Tue", "Wed", "Thu", "Fri"){
				if($S2data{$workingday}{$time} == 0){
					$S2data{$workingday}{$time} = ' ';
				}
				printf ("\t%2s", $S2data{$workingday}{$time});
			}
			print "\n";
		}
	}
	if($X1){
		print "X1	Mon	Tue	Wed	Thu	Fri\n";
		for($time = 9; $time <= 20; $time++){
			$timewith0 = fill0($time);
			print "$timewith0:00";
			foreach $workingday ("Mon", "Tue", "Wed", "Thu", "Fri"){
				if($X1data{$workingday}{$time} == 0){
					$X1data{$workingday}{$time} = ' ';
				}
				printf ("\t%2s", $X1data{$workingday}{$time});
			}
			print "\n";
		}
	}
}

sub extract {
	my($coursename) = @_;
	$coursename =~ s/^[ ]*<td class="data">//;
	$coursename =~ s/<\/td>$//;
	return $coursename;
}

sub exist {
	my($tester, @array) = @_;
	for $element (@array){
		if($tester eq $element){
			return 1;
		}
	}
	return 0;
}

sub remove0 {
	my($word) = @_;
	$word =~ s/^[0]*//g;
	return $word;
}

sub fill0 {
	my($word) = @_;
	if($word < 10){
		$word = "0$word";
	}
	return $word;
}

sub count {
	my($testing_course, $sem, $day, $time, @detail) = @_;
	$counter = 0;
	foreach $element (@detail){
		if($element eq "$sem $testing_course $day $time\n"){
			#print "found $element";
			$counter++;
		}
	}
	return $counter;
}

