#!/usr/bin/perl -w

# Starting point for COMP[29]041 assignment 1
# http://www.cse.unsw.edu.au/~cs2041/assignments/pypl
# Written by q.cheng@unsw.edu.au September 2017
# Acknowledgement for the starting codes from Andrew

undef @variables;
undef @brackets;
$lastline_spaces = "";
$thisline_spaces = "";
while ($line = <>) {
	if ($line =~ /^#!\/usr\/bin\/python/) {
        print "#!/usr/bin/perl -w\n";
        last;
	} else {
		print "#$line";
	}
}

while ($line = <>) {
	if (($line =~ /^\s*$/) || ($line =~ /^\s*(#|$)/)) {
        # Blank & comment lines can be passed unchanged
		print "$line";
		next;
	}
	
	$line = modify_sys ($line);
	$line =~ /^(\s*)\S/;
	# Finding and matching spaces to output "}" if needed
	
	if (defined $1) {$thisline_spaces = $1;}
	else {$thisline_spaces = "";}
	if (length ($thisline_spaces) > length ($lastline_spaces)) {
		push @brackets, $lastline_spaces."}";
	} elsif (length ($thisline_spaces) < length ($lastline_spaces)) {
		while (scalar (@brackets)) {
			$bracket = pop (@brackets);
			$bracket =~ /^(\s*)\S/;
			if (defined $1) { $current_spaces = $1; }
			else { $current_spaces = ""; }
			print $bracket, "\n";
			if ($current_spaces eq $thisline_spaces) {
				last;
			}
		}
	}	
	$lastline_spaces = $thisline_spaces;
	# Always save the last line's space for comparisons in next lines
	undef $output;
	
	
	if ($line =~ /^(\s*)(\w+)(\s*)=(\s*)sys.stdin.readlines()(.*)$/) {
		# Save variables if this line is a definition of variables
		push @variables, "\@$2" if (! contained("\@$2", @variables));
		print $1."undef \@$2;\n";
		print $1."while (\$input = <STDIN>) { push \@$2, \$input; }\n";
		next;
	
    } elsif ($line =~ /^(\s*)(\w+)(\W*)=(\s*)(.*)$/) {
		# Deal with variable initializations
		# Variables should be digital as assumed in requirements
		$output = $1;
		$name = $2;
		$space3 = $3;
		$space4 = $4;
		$rhs = $5;
		if ($rhs =~ /^\[.*\]/) {
			# $name is a name for a list/array
			push @variables, "\@".$name if (! contained("\@".$name, @variables));
			$output .= "\@".$name.$space3."=".$space4;
			$rhs =~ /^\[(.*)\]/;
			$output .= "(".modify_variables($1, @variables).")";
		} else {
			# Treat $name as a name of a variable otherwise
			push @variables, "\$".$name if (! contained("\$".$name, @variables));
			$output .= "\$".$name.$space3."=".$space4.modify_variables($rhs, @variables);
		}
		$output .= ";\n";

	} elsif ($line =~ /(\s*)(while|if|elif|else)\s*(.*):(.*)$/) {
		# For lines starting with while/if/elif/else
		undef @codes;
		$spaces = $1;
		$conditions = modify_variables ($3, @variables);
		$statements = $4;
		if ($2 eq "elif") {
			print $spaces."elsif "."($conditions) {\n";
		} elsif ($2 eq "else") {
			print $spaces."else {\n";
		} else {
			print "$spaces"."$2 "."($conditions) {\n";
		}
	
		if ($statements =~ /^\s*$/){
			# Multiple lines of while/if stataments cases
			next;
		} else {
			# Single line of while/if stataments cases
			@codes = split (";", $statements);
			$output = modify_singlelineconditions (@codes);
			$output .= "$spaces}"."\n";
		}


	} elsif ($line =~ /(\s*)for\s*(\w+)\s*in\s*(.*)\s*:(.*)$/) {
		# For "for" loop codes
		undef @codes;
		$spaces = $1;
		$conditions = $4;
		push @variables, "\$".$2 if (! contained ("\$".$2, @variables));
		$sets = modify_sets($3, @variables);
		$output =  "$spaces"."foreach "."\$$2 "."($sets) {"."\n";
		if ($conditions =~ /^\s*$/){
			# Multiple lines of while/if stataments cases
			$output = modify_finish($output);
			print $output;
			next;
		} else {
			# Single line of while/if stataments cases
			@codes = split (";", $conditions);
			$output .= modify_singlelineconditions (@codes);
			$output .= "$spaces}"."\n";
		}


	} elsif ($line =~ /^(\s*)print\((.*)\)\s*$/) {
	    # Can print variables or strings
	    $output = modify_prints ($2, @variables);
	    $output = $1.$output;


	} else {
		# Output the current line if it does not match any stataments above
	    $output = $line;
	}

	$output = modify_finish($output, @variables);
	print $output;
}

while ($left_brackets = pop (@brackets)) {
	print $left_brackets, "\n";
}




# The parts below are functions that were applied in the main program above.

sub contained {
	# This function is to check if $name contained in @data
	my ($name, @data) = @_;
	foreach $element (@data){
		if ($name eq $element) {
			return 1;
		}
	}
	return 0;
}

sub modify_variables {
	# This function is to modify arithmetic parts after "=";
	# Add "$" or "@" if it is a variable and do nothing otherwise.
	my ($string, @var_names) = @_;
	my $retstr = "";
	if ($string =~ /(\w+)(.*)$/) {
		while ($string =~ /^(\W*)(\w+)(.*)$/) {
			$buffer1 = $1;
			$buffer2 = $2;
			$buffer3 = $3;
			if (contained ("\$".$buffer2, @var_names)) {
				$retstr .= $buffer1."\$$buffer2";
			} elsif (contained ("\@".$buffer2, @var_names)) {
				if ($buffer3 =~ /^\s*\[(.*)\]/) {
					$retstr .= $buffer1."\$$buffer2";
				} else {
					$retstr .= $buffer1."\@$buffer2";
				}
			} else {
				$retstr .= $buffer1.$buffer2;
			}
			$string = $buffer3;
		}
		$retstr .= $buffer3;
		$retstr =~ s/\/\//\//g;
		return $retstr;
	}
	return $string;
}

sub modify_prints {
	# Deal with different situations after function print
	my ($input, @var_names) = @_;
    my $end_factor = "\\n";
	if ($input =~ /,\s*end\s*=\s*(.*)\s*$/) {
		$buffer = $1;
		if ($buffer =~ /^\'(.*)\'$/ || $buffer =~ /^\"(.*)\"$/) {
			$end_factor = $1;
			$input =~ s/,\s*end\s*=\s*(.*)\s*$//;
		}
	}
	
    if ($input =~ /^"(.*)"$/) {
    	# Print string
    	return "print \"".$1.$end_factor."\";\n";
    } elsif ($input =~ /^\s*$/) {
    	# 	Empty line
    	return "print \"$end_factor\";\n";
    } elsif ($input =~ /^"(.*)"\s*\%\s*(.*)$/) {
    	my $output_string = $1;
    	my $vars = $2;
    	my @saved_vars = '';
    	if ($vars =~ /^\((.*)\)(.*)$/) {
    		# Multiple/single variables
    		push @saved_vars, split(/,\s*/, $1);
    		my $retinfo = join(", \$", @saved_vars).$2;
    		return "printf (\"".$output_string.$end_factor."\"$retinfo);\n";
    	} else {
    		# Single variable
    		return "printf (\"".$output_string.$end_factor."\", \$$vars);\n";
    	}
    } else {
    	# Complicated situations like: print("The factorial of",num,"is",factorial)
    	my $retstr = "print ";
    	while ($input =~ /^(.*?)"(.*?)"(.*)$/) {
    		$retstr .= modify_variables($1, @var_names)."\"$2"."\"";
    		$input = $3;
    	}
    	$retstr .= modify_variables($input, @var_names).", \"$end_factor\";\n";
    	return $retstr;
    }
}

sub modify_sets {
	# Change variables inside range() to make it work well in perl
	my ($input, @var_names) = @_;
	my $retstr = "";
	if ($input =~ /^range\s*\((.*),\s*(.*)\)$/) {
		$end = $2;
		$start = modify_variables ($1, @var_names);
		if ($end =~ /^\d+$/) {
			$end = scalar ($end - 1);
		} else {
			$end = modify_variables ($end, @var_names)." - 1";
		}
		$retstr = "$start.."."$end";
		return $retstr;
	}
	return $input;
}

sub modify_sys {
	# Some translations done before actually processing translating methods
	my ($input) = @_;
	if ($input =~ /^\s*import/) {
		return "";
	}
	while ($input =~ /\Wint\s*\((.*)\)/) {
		$string = " $1";
		$input =~ s/\Wint\s*\(.*\)/$string/;
	}
	while ($input =~ /sys.stdout.write\((.*)\)/) {
		$string = "print($1, end='')";
		$input =~ s/sys.stdout.write\(.*\)/$string/;
	}
	return $input;
}

sub modify_finish {
	# The rest of translations which need to be done after processing
	my ($input, @var_names) = @_;
	$input =~ s/sys.stdin(.readline\(\)|)/<STDIN>/g;
	$input =~ s/break/last;/g;
	$input =~ s/continue/next;/g;
	
	while ($input =~ /^(\s*)(\w*).append\((\w*)\)(.*)$/) {
		$input = $1."push \@".$2.", ";
		if (contained("\$$3", @var_names)) {
			$input .= "\$";
		} elsif (contained("\@$3", @var_names)){
			$input .= "\@";
		}
		$input .= "$3".$4.";\n";
	}
	while ($input =~ /(.*)len\((\@\w+)\)(.*)$/) {
		$input = $1."scalar ".$2.$3."\n";
	}
	while ($input =~ /^(.*)\@(\w+).pop\((\d*)\)(.*)$/) {
		if ($3 eq '') {
			$index = "\@$2 - 1";
		} else {
			$index = $3;
		}
		$input = $1."splice(\@$2, ".$index.", 1);\n";
	}
	return $input;
}

sub modify_singlelineconditions {
	# Break single line conditions to multiple lines
	my (@codes) = @_;
	my $output = "";
	foreach $code (@codes) {
		$code =~ s/^\s*//;
		if ($code =~ /print\((.*?)\)/) {
			$code = modify_prints ($1, @variables);
		} else {
			$code = modify_variables($code, @variables).";\n";
		}
		$output .= $spaces."\t".$code;
	}
	return $output;
}
