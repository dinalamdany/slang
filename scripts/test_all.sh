#!/bin/bash
#script that calls all other scripts

for TESTFILE in ../tests/*.sl;
do
	if [ "$TESTFILE" != "test_all.sh" ]; then
		./"$TESTFILE"
	fi
	echo "$TESTFILE"
done
