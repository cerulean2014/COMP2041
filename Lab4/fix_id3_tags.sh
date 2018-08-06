#!/bin/bash
#set -x

for path in "$@"; do
	album=`echo "$path"|cut -d'/' -f2`
	year=`echo "$path"|cut -d',' -f2|sed 's/^ //'`
	for file in "$path"/*.mp3; do
		name=${file#"$path/"}
		track=`echo "$name"|awk -F' - ' '{print $1}'|sed 's/ $//'`
		title=`echo "$name"|awk -F' - ' '{print $2}'|sed 's/^ //'`
		artist=`echo "$name"|awk -F' - ' '{print $3}'|sed 's/.mp3$//'|sed 's/^ //'`

		id3 "$path/$name" -t "$title" -T "$track" -a "$artist" -A "$album" -y "$year" > /dev/null
	done
done
