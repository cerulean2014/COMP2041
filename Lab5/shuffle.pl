#!/usr/bin/perl -w

while($line = <STDIN>){
	push @input, $line;
}
# floating value will round down in array index
for($i = @input; $i > 0; $i--){
	$num = rand(2041) % $i;
	print $input[$num];
	splice(@input, $num, 1);
}
print @input;
