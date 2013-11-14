#!/bin/bash
#script for testing helloworld

COMPILER="../compiler_v1"
COMPFILE="helloworld"
FILENAME=".././tests/helloworld.sl"
OUTFILENAME="helloworld.output"
TESTFILENAME=".././tests/helloworld.out"

"$COMPILER" < "$FILENAME"
g++ output.cpp -o "$COMPFILE"
./"$COMPFILE" > "$OUTFILENAME"
RESULTS=`./"$COMPFILE"`
RESULTS+="\n"
printf "$RESULTS" > "$OUTFILENAME"
if (diff "$OUTFILENAME" "$TESTFILENAME") 
then
	echo "$OUTFILENAME matches $TESTFILENAME"
else
	echo "$OUTFILENAME does not match $TESTFILENAME"
fi

rm "$OUTFILENAME" output.cpp "$COMPFILE"
