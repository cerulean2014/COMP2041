#!/bin/sh

if test $# -ne 2; then
	echo "Usage: ./echon.sh <number of lines> <string>"
	exit 1
elif ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "$0: argument 1 must be a non-negative integer"
    exit 1
fi

counter=0
while test $counter -lt $1
do
	echo $2
	counter=$(($counter+1))
done
exit 0
