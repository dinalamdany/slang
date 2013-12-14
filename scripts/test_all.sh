#!/bin/bash
#script that calls all other scripts
COMPILER="../compiler_v3"
"g++ output.cpp"
for TESTFILE in ../tests/*.sl;
do
	echo "$TESTFILE"
	"$COMPILER" < "$TESTFILE"

done
