# Slang Reference Manual 

## Description 
Slang is a discrete event simulation language. It allows for a programmer to schedule events at discrete times, and have those events executed based on an event queue ordered by start time. 

## Program
A program is a single file consisting of functions, defined and written above the main block, and a main block. The main block consists of at least one (or more) of an init block and an always block. An init block consists of statements that are to be executed sequentially from time 0. An always block consists of code to be continually run until program termination.

## Execution 
The simulator processes events in the event queue by removing all the events for the current time and processing them. During the processing, more events may be created (such as by functions) and placed in the proper place in the queue for later processing. When all the events of the current time have been processed, the simulator advances time and processes the next events at the front of the queue.

## Whitespace 
Slang is whitespace-ambivalent, meaning that whitespace does not affect the program.

## Comments 
Multiline comments in Slang start with /* and terminate with the next */. Multiline comments do not nest.

## Data Types 

### Int 
An int is a 32-bit signed integer. 

### Float 
A float is a 64-bit signed floating-point number. 

### Boolean  
A boolean value defined using the keywords true or false. 

### String 
A string is a sequence of characters. String literals are placed between double quotes.

## Operators 
Integers are automatically cast to floats when necessary. If an arithmetic operator is used on two integers, the result is an integer, otherwise it is a float. 

###Arithmetic 
* + addition, addition, and String concatenation. 
* - subtraction and unary negation. 
* \* multiplication.
* / division
* % modulo

\*, /, and % operators have precedence over + and -

### Assignment  
= Assigns value of right hand side to the left hand side. Assignment has right to left precedence.

### Comparison 
* == equal to. Compares values of two items. In order for two Objects to be equal, they must be the same object.
* != not equal to
* > greater than
* < less than
* >= greater than or equal to
* <= less than or equal to

### Logical 
* ! unary and logical not
* & logical and
* | logical or

## Blocks and Control Flow 

### Blocks 
A block is defined inside curly braces, which can include a possibly-empty list of statements.

### If-else 

Slang accepts:
    *if expression block
    *if expression block else block
where expression evaluates to a boolean value

### Iteration 
Slang has for-loops and while loops. 
A for loop can be:
    *starting assignment; boolean loop condition expression; assignment for advancing to next iteration {
        block
    }

*or an empty for;; {
    block
}, which is infinite

A while loop is:
    while condition {
        block
    }

## Return 

The return keyword accepts an expression, function call, or nothing, and exists out of the smallest containing function or calling block. 

## TO ADD 
Scoping rules
by value/reference
objects

