#!/bin/bash

for file in $*
do
	display $file
	echo -n "Address to e-mail this image to? "
	read email
	echo -n "Message to accompany image? "
	read message
	echo "$file sent to $email"
	echo $message|mutt -s "$file!" -e 'set copy=no' -a $file -- $email
done
