#!/usr/bin/perl -w

foreach $course (@ARGV){
	open F, "wget -q -O- 'http://timetable.unsw.edu.au/current/$course.html'|" or die $!;
	while($line = <F>){
		if($line =~ /<td class="data"><a href="#(S[12]|X1)-[0-9]+">Lecture<\/a><\/td>/gi){
			$sem = $1;
			for($i = 0; $i < 6; $i++){
				$line = <F>;
			}
			$data = extract($line);
			if($data ne "\n"){
				push @result, "$course: $sem $data" if (! exist("$course: $sem $data", @result));
			}
		}

	}
	close F;
}
print @result;

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
