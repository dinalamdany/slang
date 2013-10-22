%{ open Ast %}

%token SEMI LPAREN RPAREN LBRACE RBRACE COMMA RBRAC LBRAC COLON DOT
%token PLUS MINUS TIMES DIVIDE ASSIGN 
%token NOT INC DEC
%token EQ NEQ LT LEQ GT GEQ OR AND MOD
%token RETURN IF ELSE FOR WHILE INT FUNC
%token <int> INT_LITERAL
%token <float> FLOAT_LITERAL
%token <string> STRING_LITERAL TYPE ID
%token EOF
%token DELAY MAIN INIT ALWAYS
%token OBJECT TERMINATE

%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
%left EQ NEQ
%left LT GT LEQ GEQ
%left AND OR
%left PLUS MINUS
%left TIMES DIVIDE MOD
%right NOT
%right UMINUS DEC INC

%start program
%type <Ast.program> program

%%

program:
    main {[],$1}
    | fdecl program { ($1 :: fst $2), snd $2 }

main:
    MAIN LPAREN RPAREN LBRACE vdecl_list timeblock_list RBRACE { $5, $6}
    
timeblock_list:
    /* nothing */ {[]}
    | timeblock_list timeblock { $2 :: $1 }

timeblock:
    INIT LBRACE stmt_list RBRACE {Init($3)}
    | ALWAYS LBRACE stmt_list RBRACE {Always($3)}

fdecl:
    FUNC TYPE ID LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
    { { return = $2;
    fname = $3;
    formals = $5;
    body = List.rev $8 }} 

formals_opt:
    /* nothing */ {[]}
    | formal_list { List.rev $1}

formal_list:
    vdecl { [$1] }
    | formal_list COMMA vdecl { $3 :: $1}

stmt_list: 
    /* nothing */ {[]}
    | stmt_list stmt { $2 :: $1 }

delay:
    INT_LITERAL {IntLit($1)}
    | FLOAT_LITERAL { FloatLit($1)}
    | ID { Variable(Ident($1))}

vdecl_list:
    /* nothing */ {[]}
    | vdecl_list vdecl { $2 :: $1 }

vdecl:
    TYPE ID SEMI { Vdecl(Datatype($1),Ident($2)) }
    | TYPE ID ASSIGN expr SEMI { VarAssignDecl(Datatype($1),Ident($2),$4) }
    | TYPE ID LBRAC RBRAC SEMI {
        ArrDecl(Datatype($1),Ident($2))}
    | TYPE ID LBRAC RBRAC ASSIGN LBRAC expr_list RBRAC SEMI {
        ArrAssignDecl(Datatype($1),Ident($2),$7)}
    | OBJECT ID SEMI { ObjDecl(Ident($2))}
    | OBJECT ID ASSIGN OBJECT LPAREN property_list RPAREN SEMI { ObjAssignDecl(Ident($2), $6)}

property_list:
    /* nothing */ {[]}
    | property COMMA property_list { $1 :: $3}

property:
    TYPE ID {Vdecl(Datatype($1),Ident($2))}
    | TYPE ID LBRAC RBRAC { ArrDecl(Datatype($1),Ident($2))} 
    | TYPE ID COLON expr {VarAssignDecl(Datatype($1),Ident($2), $4)}
    | TYPE ID LBRAC RBRAC ASSIGN LBRAC expr_list RBRAC {ArrAssignDecl(Datatype($1),Ident($2),$7)}

expr_list:
    /* nothing */ { [] }
    | expr COMMA expr_list { $1 :: $3 }
 
stmt:
    expr SEMI { Expr($1)}
    | DELAY delay stmt { Delay($2,$3)}
    | TERMINATE { Terminate }
    | RETURN expr SEMI { Return($2)}
    | LBRACE stmt_list RBRACE { Block(List.rev $2) }
    | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
    | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
    | FOR LPAREN expr_opt SEMI expr_opt SEMI expr_opt RPAREN stmt    
        { For($3, $5, $7, $9) }
    | WHILE LPAREN expr RPAREN stmt { While($3, $5) }
    | vdecl { Declaration($1) }
    | ID DOT ID ASSIGN expr SEMI {PropertyAssign(Ident($1),Ident($3), $5)}

expr_opt:
    /* nothing */ { Noexpr }
    | expr {$1}

expr:
  INT_LITERAL { IntLit($1)}
  | FLOAT_LITERAL { FloatLit($1)}
  | STRING_LITERAL { StringLit($1)}
  | ID { Variable(Ident($1)) }
  | expr PLUS   expr { Binop($1, Add,   $3) }
  | expr MINUS  expr { Binop($1, Sub,   $3) }
  | expr TIMES  expr { Binop($1, Mult,  $3) }
  | expr DIVIDE expr { Binop($1, Div,   $3) }
  | expr EQ     expr { Binop($1, Equal, $3) }
  | expr NEQ    expr { Binop($1, Neq,   $3) }
  | expr LT     expr { Binop($1, Less,  $3) }
  | expr LEQ    expr { Binop($1, Leq,   $3) }
  | expr GT     expr { Binop($1, Greater,  $3) }
  | expr GEQ    expr { Binop($1, Geq,   $3) }
  | expr MOD    expr { Binop($1, Mod, $3)}
  | ID ASSIGN expr   { Assign(Ident($1), $3) }
  | ID LBRAC INT_LITERAL RBRAC ASSIGN expr { ArrAssign(Ident($1), $3 ,$6)}
  | ID LBRAC INT_LITERAL RBRAC { ArrElem(Ident($1), $3)}
  | LPAREN expr RPAREN { $2 }
  | MINUS expr %prec UMINUS { Unop(Neg, $2) }
  | expr INC {Unop(Inc, $1)}
  | expr DEC {Unop(Dec, $1)}
  | expr AND expr {Binop($1, And, $3)}
  | expr OR expr {Binop($1, Or, $3)}
