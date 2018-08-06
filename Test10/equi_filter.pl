#!/usr/bin/perl -w

foreach $line(<STDIN>){
	@words = grep(/./, split(" ", $line));
	undef @result;
	foreach $thing (@words){
		undef %data;
		$buffer = $thing;
		while($thing =~ /\w/){
			$thing =~ /^(\S)(.*)$/;
			if(!$data{lc $1}){
				$data{lc $1} = 1;
			}else{
				$data{lc $1}++;
			}
			$thing = $2;
		}
		$last = -1;
		foreach $element(keys %data){
			$equalwith = 1;
			if($last == -1){
				$last = $data{$element};
				next;
			}
			if($last != $data{$element}){
				$equalwith = 0;
				last;
			}
		}
		push @result, $buffer if($equalwith);
	}
	print "@result\n";
}
