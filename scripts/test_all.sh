#!/bin/bash
#script that calls all other scripts

for SCRIPT in *.sh;
do
	if [ "$SCRIPT" != "test_all.sh" ]; then
		./"$SCRIPT"
	fi
done
