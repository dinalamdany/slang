#!/bin/bash
#script used for reg testing
COMPILER="../compiler"
COMPFILE="temp_test"

for TESTFILE in ../tests/*.sl;
do
 	echo "	TESTING $TESTFILE"
	LEN=$((${#TESTFILE}-3))
	OUTFILENAME="${TESTFILE:0:$LEN}.output"
	TESTFILENAME="${TESTFILE:0:$LEN}.out"
	"$COMPILER" < "$TESTFILE"
	g++ output.cpp -o "$COMPFILE"
	./"$COMPFILE" > "$OUTFILENAME"
	if (diff "$OUTFILENAME" "$TESTFILENAME") 
	then
		echo "		OK"
	else
		echo "		BAD!"
	fi
	rm "$OUTFILENAME" output.cpp "$COMPFILE"
done
