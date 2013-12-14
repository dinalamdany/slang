#!/bin/bash
#script used for reg testing
COMPILER="../compiler_v3"
COMPFILE="temp_test"

for TESTFILE in ../tests/*.sl;
do
 	echo "	TESTING $TESTFILE"
	OUTFILENAME="${TESTFILE:0:-3}.output"
	TESTFILENAME="${TESTFILE:0:-3}.out"
	"$COMPILER" < "$TESTFILE"
	g++ output.cpp -o "$COMPFILE"
	./"$COMPFILE" > "$OUTFILENAME"
	#RESULTS=`./"$COMPFILE"`
	#RESULTS+="\n"
	#printf "$RESULTS" > "$OUTFILENAME"
	if (diff "$OUTFILENAME" "$TESTFILENAME") 
	then
		#echo "$OUTFILENAME matches $TESTFILENAME"
		echo "		OK"
	else
		#echo "$OUTFILENAME does not match $TESTFILENAME"
		echo "		BAD!"
	fi
	rm "$OUTFILENAME" output.cpp "$COMPFILE"
done

#COMPILER="../compiler_v2"
#COMPFILE="helloworld"
#FILENAME=".././tests/helloworld.sl"
#OUTFILENAME="helloworld.output"
#TESTFILENAME=".././tests/helloworld.out"

#"$COMPILER" < "$FILENAME"
#g++ output.cpp -o "$COMPFILE"
#./"$COMPFILE" > "$OUTFILENAME"
#RESULTS=`./"$COMPFILE"`
#RESULTS+="\n"
#printf "$RESULTS" > "$OUTFILENAME"
#if (diff "$OUTFILENAME" "$TESTFILENAME") 
#then
#	echo "$OUTFILENAME matches $TESTFILENAME"
#else
#	echo "$OUTFILENAME does not match $TESTFILENAME"
#fi
#
#rm "$OUTFILENAME" output.cpp "$COMPFILE"
