#!/usr/bin/perl -w

open F, '<', "$ARGV[0]" or die "$0: Can't open $ARGV[0]: $!\n";
while($stdin = <F>){
	push @input, $stdin;
}
close F;

foreach $current_line (@input){
	last if($current_line =~ s/^#!\/bin\/bash/#!\/usr\/bin\/perl -w/);
}

	
@variables = get_all_variables(@input);
$removedo = 0;
$removedone = 0;
$removethen = 0;
$removefi = 0;
foreach $current_line (@input){
	if($current_line =~ /echo /){
		$current_line = replace_echo($current_line);
		next;
	}
	if($removedo){
		$removedo -= ($current_line =~ s/[\t\s]*do[\t\s\n]*//);
	}
	if($removedone){
		if($current_line =~ /^([\t\s]*)done(.*)$/){
			$removedone--;
			$current_line = $1."\}".$2."\n";
		}
	}
	if($removethen){
		$removethen -= ($current_line =~ s/[\t\s]*then[\t\s\n]*//);
	}
	if($removefi){
		if($current_line =~ /^([\t\s]*)fi(.*)$/){
			$removefi--;
			$current_line = $1."\}".$2."\n";
		}
	}
	$current_line =~ s/else/\}else\{/g;
	if($current_line =~ /^([^\'\"\#]*)while(.*)/){
		$current_line =~ s/while \(\(/while \(/;
		$current_line =~ s/\)\)/\) \{/;
		$removedo++;
		$removedone++;
	}
	if($current_line =~ /^([^\'\"\#]*)if(.*)/){
		$current_line =~ s/if \(\(/if \(/;
		$current_line =~ s/\)\)/\) \{/;
		$removethen++;
		$removefi++;
	}
	
	foreach $element (@variables){
		#changes for variable initializations
		while($current_line =~ /^([\t\s]*)$element=(.*)/){
			$current_line = $1."\$".$element." = ".$2.";\n";
		}
		$current_line =~ s/[;]+\n$/;\n/;
		$current_line =~ s/\$\(\(//;
		$current_line =~ s/\)\)/;/;
		
		while($current_line =~ /(^[^\#]*[ \(])$element([ \);].*)/){
			$current_line = $1."\$".$element.$2."\n";
		}
	}
	

}

print @input;





sub get_all_variables{
	my(@result) = @_;
	undef @result;
	foreach $current_line (@input){
		if($current_line =~ /^([\t\s]*)(\w*)(=.*\n)$/){
			if(! contained($2, @result)){
				push @result, $2;
			}
		}
	}
	return @result;
}




sub replace_echo{
	my($line) = @_;
	$line =~ s/echo /print "/g;
	chomp $line;
	$line .= "\\n\";\n";
	return $line;
}


sub contained{
	my($tester, @array) = @_;
	foreach $element (@array){
		return 1 if($tester eq $element);
	}
	return 0;
}
		
