(* scanner_utils.ml - This utility is used for testing purposes.     *)
(* It outputs the results of the scanner (tokens) into string form   *)


open Scanner
open Parser

(* generate a string for each token. *)
let token_to_string token = 
   (match token with             
      | LPAREN ->
           "LEFT_PAREN\n"
      | RPAREN ->
           "RIGHT_PAREN\n"
      | LBRAC  ->                    
           "LEFT_BRAC\n"
      | RBRAC  ->
           "RIGHT_RBRAC\n"
      | LBRACE ->
           "LEFT_BRACE\n"
      | RBRACE ->
           "RIGHT_BRACE\n"
      | SEMI ->                          (* Punctuation *)
           "SEMICOLON\n"       
      | COLON ->
           "COLON\n"
      | COMMA ->
           "COMMA\n"
      | DOT ->
           "DOT\n"
      | OBJECT ->
           "OBJECT\n"
      | PLUS ->													(* Arithmetic *)
           "PLUS\n"											
      | MINUS ->
           "MINUS\n"
      | TIMES ->
           "TIMES\n"
      | DIVIDE  ->
           "DIVIDE\n"
      | MOD  ->
           "MOD\n"					
      | ASSIGN ->												(* Assignment *)
           "ASSIGN\n"
      | EQ ->														(* Comparison Logic *)
           "EQUAL\n"									
      | NEQ ->
           "NOT_EQUAL\n"	
      | LT ->
           "LESS_THAN\n"
      | LEQ ->
           "LESS_THAN_OR_EQUAL\n"
      | GT  ->
           "GREATER_THAN\n"
      | GEQ ->
           "GREATER_THAN_OR_EQUAL\n"
      | AND ->													(* Boolean Logic *)
           "AND\n"
      | NOT ->
           "NOT\n"
      | OR ->
           "OR\n"
      | INC ->
           "INC\n"
      | DEC ->
           "DEC\n"
      | RETURN ->												(* Control Flow*)
           "RETURN\n"
      | DELAY ->
           "DELAY\n"
      | IF ->
           "IF\n"
      | ELSE ->
           "ELSE\n"
      | FOR ->
           "FOR\n"
      | WHILE ->
           "WHILE\n"
	    | FUNC ->
           "FUNC\n"				
      | MAIN ->
           "MAIN\n"
      | TYPE t ->													(* Data Types *)
           "TYPE: ^ " ^ t ^ "\n"
	    | INIT ->
           "INIT\n"
      | ALWAYS ->
           "ALWAYS\n"
      | TERMINATE ->
           "TERMINATE\n"
      | INT_LITERAL i ->										(* Literals/Constants *)
           "INT_LITERAL: " ^ string_of_int(i) ^ "\n"
      | FLOAT_LITERAL f ->
           "FLOAT_LITERAL: " ^ string_of_float(f) ^ "\n"
      | STRING_LITERAL s ->
           "STRING_LITERAL: " ^ s ^ "\n"
      | BOOL_LITERAL b ->
           "BOOL_LITERAL: " ^ string_of_bool(b) ^ "\n"
      | ID id ->													(* Variables *)
           "ID: " ^ id ^ "\n"	
      | EOF ->														(* End of File *)
           "END_OF_FILE\n"	)


(* Generate a string for a set of tokens *)
let string_of_tokens tokens =
   let token_list = List.map token_to_string tokens in
   String.concat "" token_list
