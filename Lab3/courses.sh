#!/bin/bash

#initialize 2 very long websites

UG="http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr="
PG="http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr="

Name=$1
first=`echo $Name|cut -c1`
Year=2017
wget -q -O- $UG$first $PG$first|sed "s/.*$Year\///"|sed 's/.html\">/ /'|sed 's/<.*$//'|sed 's/^$//'|egrep ^$Name | sed "s/ $//"|sort -n|uniq

