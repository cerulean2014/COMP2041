#!/bin/bash

for FILE in *.jpg; do
	if [ -e "${FILE%jpg}png" ]; then
		echo ${FILE%jpg}png already exists
	else
		convert "$FILE" "${FILE%jpg}png"
		rm "$FILE"
	fi
	
done

