#!/bin/bash

#initialize 2 very long websites
UG="http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=O"
PG="http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=O"

wget -q -O- $UG|grep OPTM
