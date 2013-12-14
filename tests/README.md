##Tests
The tests are broken up and named with prefixes signifying which part of the LRM they are testing. The unit tests not only looks for acceptable code, but also checks for code that should not be accepted.

For example, program1.sl, program2.sl, program3.sl ... etc all test statements made under the "Program" description in the LRM.

Due to the nature of attempting to test every line of the LRM, there will be overlapping tests for the same errors.

Each test file should compile and produce a c++ program.  Each test file needs an accompanying .out file with the expected results.  IE.  test1.sl needs a test1.out file containing the expected program output

###Tester
The test script, test_all.sh, is located in slang/scripts

Usage: ./test_all.sh

Output:  The test script should give either an OK, or a BAD result.  BAD results follow differences between the expected output and the actual output of the program.
