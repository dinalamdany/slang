#!/bin/bash

STRING=""
OUT=""
FILENAME="./reg_test_results.txt"
OUTFILENAME="./reg_test_results."
#script runs tester on every slang file
for FILE in *.sl;
do
	RESULTS=`./tester "$FILE"`
	if [ "$RESULTS" ]; then
		STRING+="$RESULTS\n"
	else
		STRING+="$FILE	exception\n"
	fi
done

touch "$FILENAME"
#printf "$STRING" >> "$FILENAME" for append instead of overwrite
printf "$STRING" > "$FILENAME"

#create single .out file from all output
touch "$OUTFILENAME"
cat *.out >> "$OUTFILENAME"

