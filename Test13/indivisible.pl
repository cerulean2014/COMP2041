#!/usr/bin/perl -w

undef @result;
while ($line = <STDIN>){
	@array = grep(/\d+/, split(/\s+/, $line));
	push @result, @array;
}
@result = sort {$a <=> $b} @result;
undef @output;
$i = 0;
while ($i < scalar @result){
	if(($i + 1 < scalar @result) && ($result[$i] == $result[$i + 1])){
		$i++;
		next;
	}
	$divisible = 0;
	$j = 0;
	while ($j < $i){
		if ($result[$i] % $result[$j] == 0){
			$divisible = 1;
			last;
		}
		$j++;
	}
	if ($divisible == 0){
		push @output, $result[$i];
	}
	$i++;
}
print "@output\n";
