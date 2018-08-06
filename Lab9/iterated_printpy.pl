#!/usr/bin/perl -w

exit if($ARGV[0] < 0);


$output = argv_to_python($ARGV[1]);
for($counter = 1; $counter <= $ARGV[0]; $counter++){
	$output = perl_to_python(python_to_perl($output));
}

print $output;

sub argv_to_python{
	my($input) = @_;
	$input =~ s/\\/\\\\/g;
	$input =~ s/\"/\\\"/g;
	undef @strings;
	undef @result;
	@strings = split("\n", $input);
	foreach $element (@strings){
		push @result, "print(\"$element\")\n";
	}
	return "#!/usr/bin/python3\n".join("", @result);
}

sub python_to_perl{
#return perl program
	my($input) = @_;
	#traverse it line by line first
	undef @output;
	@lines = split(/\n/, $input);
	foreach $singleline (@lines){
		undef $retval;
		@parts = split(/\\/, $singleline);
		$counter = 0;
		foreach $element (@parts){
			if($counter){
				$retval .= "\\".$element;
			}else{
				$retval = $element;
			}
			$counter++;
		}
		$retval .= "\\\\n";
		$retval = "print \"".$retval."\";\n";
		if($retval =~ s/[\\]*\"/\"/g){
			$retval = modify_quotes($retval, "\"");
		}
		#print "now, retval is: $retval";
		push @output, $retval;
	}
	$result = "#!/usr/bin/perl -w\n".join("", @output);
	print "to perl: $result\n";
	return $result;
}

sub perl_to_python{
	#return python program
	my($input) = @_;
	$input =~ s/\\\"/\"/g;
	@topology = split("\"", $input);
	$retval = join("\\\"", @topology);
	@lines = split("\n", $retval);
	foreach $element (@lines){
		$element = "print \(\"".$element."\"\)\n";
		$element =~ s/[\\]+\"/\"/g;
		$element = modify_quotes($element, "\"");
	}
	$retval = join("", @lines);
	
	$result = "#!/usr/bin/python3\n".$retval;
	print "to python: $result\n";
	return $result;
}

sub modify_quotes{
	my($input, $seperator) = @_;
	@array = split($seperator, $input);
	#print "in sentece: $input,\n";
	#printf ("there are %d quotes inside.\n", scalar @array);
	undef @checked;
	for($start = 0; (!contains($start, @checked)); $start++){
		$end = scalar(@array) - $start - 2;
		#print "start = $start, end = $end\n";
		$array[$start] .= dashes($start, $seperator);
		$array[$end] .= dashes($start, $seperator);
		
		push @checked, $start;
		push @checked, $end;
	}
	return join("", @array);
}

sub contains{
	my($tester, @array) = @_;
	foreach $element (@array){
		if($tester == $element){
			return 1;
		}
	}
	return 0;
}

sub dashes{
	my($order, $string) = @_;
	$mul = 1;
	for($i = 0; $i < $order; $i++){
		$mul *= 2;
	}
	$output = "\\" x ($mul - 1);
	return $output.$string;
}

