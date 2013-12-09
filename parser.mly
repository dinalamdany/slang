%{ open Ast %}
%{ open Type %}
%token SEMI LPAREN RPAREN LBRACE RBRACE COMMA RBRAC LBRAC COLON DOT
%token PLUS MINUS TIMES DIVIDE ASSIGN 
%token NOT INC DEC
%token EQ NEQ LT LEQ GT GEQ OR AND MOD
%token RETURN IF ELSE FOR WHILE FUNC
%token <int> INT_LITERAL
%token <float> FLOAT_LITERAL
%token <bool> BOOL_LITERAL
%token <string> STRING_LITERAL TYPE ID
%token EOF
%token DELAY MAIN INIT ALWAYS
%token TERMINATE
%token BOOLEAN STRING INT FLOAT VOID OBJECT

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
%nonassoc LPAREN RPAREN LBRAC RBRAC

%start program
%type <Ast.program> program

%%

program:
    main {[],$1}
    | fdecl program { ($1 :: fst $2), snd $2 }

main:
    MAIN LPAREN RPAREN LBRACE vdecl_list timeblock_list RBRACE { $5, $6}
    
var_type:
	INT			{Int}
	|FLOAT		{Float}
	|BOOLEAN	{Boolean}
	|STRING		{String}

timeblock_list:
    /* nothing */ {[]}
    | timeblock_list timeblock { $2 :: $1 }

timeblock:
    INIT LBRACE events RBRACE {Init($3)}
    | ALWAYS LBRACE events RBRACE {Always($3)}

fdecl:
    FUNC var_type ID LPAREN formals_opt RPAREN LBRACE stmt_list RBRACE
    { { return = Datatype($2);
    fname = Ident($3);
    formals = $5;
    body = List.rev $8 }} 

formals_opt:
    /* nothing */ {[]}
    | formal_list { List.rev $1}

formal_list:
    param { [$1] }
    | formal_list COMMA param { $3 :: $1}

param:
    var_type ID { Formal(Datatype($1),Ident($2)) }
    | var_type ID LBRAC RBRAC {Formal(Arraytype(Datatype($1)),Ident($2))}

event:
    DELAY INT_LITERAL stmt_list {Event($2,$3)}

events:
    stmt_list {[ Event(0,List.rev $1)]} 
    | stmt_list event_list { Event(0, List.rev $1) :: $2}

event_list:
    event { [$1] }
    | event event_list { $1 :: $2 }

stmt_list: 
    /* nothing */ {[]}
    | stmt_list stmt { $2 :: $1 }

vdecl_list:
    /* nothing */ {[]}
    | vdecl SEMI vdecl_list { $1 :: $3 }

vdecl:
    var_type ID { VarDecl(Datatype($1),Ident($2)) }
    | var_type ID ASSIGN expr { VarAssignDecl(Datatype($1),Ident($2),ExprVal($4)) }
    | var_type ID LBRAC RBRAC { VarDecl(Arraytype(Datatype($1)),Ident($2))}
    | var_type ID LBRAC RBRAC ASSIGN LBRAC expr_list RBRAC {
        VarAssignDecl(Arraytype(Datatype($1)),Ident($2),ArrVal($7))}

expr_list:
    /* nothing */ { [] }
    | expr COMMA expr_list { $1 :: $3 }
    | expr { [$1] } 
 
stmt:
    expr SEMI { Expr($1)}
    | TERMINATE SEMI { Terminate }
    | RETURN expr SEMI { Return($2)}
    | LBRACE stmt_list RBRACE { Block(List.rev $2) }
    | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
    | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
    | FOR LPAREN expr_opt SEMI expr_opt SEMI expr_opt RPAREN stmt    
        { For($3, $5, $7, $9) }
    | WHILE LPAREN expr RPAREN stmt { While($3, $5) }
    | vdecl SEMI { Declaration($1) }
    | ID LBRAC INT_LITERAL RBRAC ASSIGN expr SEMI { ArrElemAssign(Ident($1), $3 ,$6)}
    | ID ASSIGN LBRAC expr_list RBRAC SEMI {ArrAssign(Ident($1),$4)}
    | ID ASSIGN expr SEMI { Assign(Ident($1), $3) }

 expr_opt:
    /* nothing */ { Noexpr }
    | ID ASSIGN expr { ExprAssign(Ident($1),$3)}
    | expr {$1}

expr:
  INT_LITERAL { IntLit($1)}
  | FLOAT_LITERAL { FloatLit($1)}
  | STRING_LITERAL { StringLit($1)}
  | BOOL_LITERAL {BoolLit($1)}
  | var_type LPAREN expr RPAREN { Cast(Datatype($1),$3)}
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
  | ID LBRAC INT_LITERAL RBRAC { ArrElem(Ident($1), $3)}
  | LPAREN expr RPAREN { $2 }
  | MINUS expr %prec UMINUS { Unop(Neg, $2) }
  | expr INC {Unop(Inc, $1)}
  | expr DEC {Unop(Dec, $1)}
  | expr AND expr {Binop($1, And, $3)}
  | expr OR expr {Binop($1, Or, $3)}
  | ID LPAREN expr_list RPAREN {Call(Ident($1), $3)}
  
