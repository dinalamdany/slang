{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '['      { LBRAC }
| ']'      { RBRAC }
| '{'      { LBRACE }
| '}'      { RBRACE }
| ';'      { SEMI }
| ':'      { COLON }
| ','      { COMMA }
| '.'      { DOT }
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| '='      { ASSIGN }
| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }
| "if"     { IF }
| "!"      { NOT }
| "&"      { AND }
| "|"      { OR }
| "#"      { DELAY }
| "++"     { INC }
| "--"     { DEC }
| "%"      { MOD }
| "else"   { ELSE }
| "for"    { FOR }
| "while"  { WHILE }
| "return" { RETURN }
| "func"   { FUNC }
| "main"   { MAIN }
| "init"   { INIT }
| "always" { ALWAYS }
| "Terminate" {TERMINATE}
| "bool"   {BOOLEAN}
| "string" {STRING}
| "int"    {INT}
| "float"  {FLOAT}
| "void"   {VOID}
| "object" {OBJECT}
| "true" | "false" as b { BOOL_LITERAL(bool_of_string b)}
| ['0'-'9']+ as lxm { INT_LITERAL(int_of_string lxm) }
| ((['0'-'9']+('.'['0'-'9']*|('.'?['0'-'9']*'e'('+'|'-')?))['0'-'9']*) | (['0'-'9']*('.'['0'-'9']*|('.'?['0'-'9']*'e'('+'|'-')?))['0'-'9']+)) 
    as lxm { FLOAT_LITERAL(float_of_string lxm) }
| eof { EOF }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| '"' (('\\' _  | [^'"'])* as lxm) '"'{ STRING_LITERAL(lxm) }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }
