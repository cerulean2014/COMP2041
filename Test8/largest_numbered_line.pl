#!/usr/bin/perl -w

foreach $line (<STDIN>){
	push @input, $line;
	@num = $line =~ /(-?\d+(\.\d+)?)/g;
	push @numbers, find_largest(filter(@num));
}
$largest = -1;
$largest = find_largest(@numbers);

if($largest >= 0){
	for($i = 0; $i < @input; $i++){
		if($numbers[$i] == $largest){
			print $input[$i];
		}
	}
}




#find largest number in one line
sub find_largest {
	my(@array) = @_;
	#print "finding largest number among @array\n";
	$comparer = -1;
	foreach $element(@array){
		if($element > $comparer){
			$comparer = $element;
		}
	}
	return $comparer;
}

sub filter {
	my(@array) = @_;
	undef @newarray;
	foreach $element (@array){
		if(defined $element){
			push @newarray, $element;
		}
	}
	return @newarray;
}
