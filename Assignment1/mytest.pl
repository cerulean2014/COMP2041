#!/usr/bin/perl -w

# Taken and modified from https://www.programiz.com/python-programming/examples/prime-number
# Python program to check if the input number is prime or not
$num = 17;
# You can use the line below to check if you wish :)
$num = <STDIN>;
$is_prime = 1;
# prime numbers are greater than 1
if ($num > 1) {
   # check for factors
   foreach $i (2..$num - 1) {
       if (($num % $i) == 0) {
           print "It is not a prime number\n";
           print $i,"times",$num/$i,"is",$num, "\n";
           $is_prime = 0;
           last;
       }
   }
   if ($is_prime == 1) {
       print "It is a prime number\n";
       
   }
}
else {
   # if input number is less than
   # or equal to 1, it is not prime
   print "It is not a prime number\n";
}
