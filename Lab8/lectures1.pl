#!/usr/bin/perl -w

@given_courses = @ARGV;
if($ARGV[0] eq '-d'){
	$d_option = 1;
	shift @given_courses;
}else{
	$d_option = 0;
}
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
							push @detail, "$sem $course $day $i\n";
						}
					}
				}
			}
		}

	}
	close F;
}
if($d_option){
	print @detail;
}else{
	print @result;
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
	
