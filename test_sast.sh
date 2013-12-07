#!/bin/bash
set -e

# This script will parse and scan STDIN into an AST, which it then prints.
# 
# Usage:
# cat tests/arithmetic1.sl | ./test_sast.sh
#
# It contains many kludges.

#scons -c > /dev/null
#scons > /dev/null

PARSE='
open Ast;;\n
open Type;;\n
open Sast;;\n
\n
let lexbuf = Lexing.from_channel stdin in\n
let program = Parser.program Scanner.token lexbuf in\n
Semantic_check.check_program program;;'
(echo -e $PARSE; cat -) | ocaml scanner.cmo parser.cmo semantic_check.cmo

