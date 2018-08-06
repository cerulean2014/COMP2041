#!/bin/bash

for FILE in *.htm; do
	if [[ -e "${FILE%htm}html" ]]; then
		echo "${FILE%htm}html exists"
		exit 1
	fi
	mv "$FILE" "${FILE%htm}html"
done

