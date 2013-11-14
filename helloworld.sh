#!/bin/bash
#script for testing helloworld

COMPFILE="helloworld"
FILENAME="./tests/helloworld.sl"
OUTFILENAME="./tests/helloworld.output"
TESTFILENAME="./tests/helloworld.out"

./compiler_v1 < "$FILENAME"
g++ output.cpp -o "$COMPFILE"
./"$COMPFILE" > "$OUTFILENAME"
RESULTS=`./"$COMPFILE"`
RESULTS+="\n"
printf "$RESULTS" > "$OUTFILENAME"
if (diff "$OUTFILENAME" "$TESTFILENAME") 
then
	echo "$FILENAME matches $OUTFILENAME"
else
	echo "$FILENAME does not match $OUTFILENAME"
fi

rm "$OUTFILENAME" output.cpp "$COMPFILE"
