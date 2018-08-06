#!/bin/bash

for FILE in $@; do
	cat "$FILE" | while read line; do
		if [[ "$line" =~ \#include\ \"[a-zA-Z]*.h ]]; then
			header=`echo "$line"|sed 's/^#include "//'|sed 's/"$//'`
			found=0
			for FILEAGAIN in *.h; do
				if test "$header" = "$FILEAGAIN"; then
					found=1;
					break
				fi
			done
			if test $found -ne 1; then
				echo "$header included into $FILE does not exist"
			fi
		fi
	done
done
