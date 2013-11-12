#!/bin/bash

STRING=""
FILENAME="./reg_test_results.txt"

#script runs tester on every slang file
for FILE in *.sl;
do
	RESULTS=`./tester "$FILE"`
	if [ "$RESULTS" ]; then
		STRING+="$RESULTS\n"
	else
		STRING+="$FILE	NO\n"
	fi
done

touch "$FILENAME"
#printf "$STRING" >> "$FILENAME" for append instead of overwrite
printf "$STRING" > "$FILENAME"
