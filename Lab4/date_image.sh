#!/bin/bash

infomation=`ls -l "$1"|cut -d' ' -f6-8`
convert -gravity south -pointsize 36 -draw "text 0,10 '$infomation'" "$1" "temporary_file.jpg"
rm "temporary_file.jpg"

#weird variable inside '' still works.
