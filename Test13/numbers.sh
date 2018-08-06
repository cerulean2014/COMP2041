#!/bin/bash

start=$1
end=$2
while (($start <= $end)); do
	echo "$start" >> $3
	start=$((start+1))
done

