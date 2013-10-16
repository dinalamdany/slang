%{ open Ast %}

%token SEMI LPAREN RPAREN LBRACE RBRACE COMMA
%token PLUS MINUS TIMES DIVIDE ASSIGN
%token EQ NEQ LT LEQ GT GEQ
%token RETURN IF ELSE FOR WHILE INT FUNC
%token <int> LITERAL
%token <string> ID
%token EOF

%nonassoc NOELSE
%nonassoc ELSE
%right ASSIGN
%left EQ NEQ
%left LT GT LEQ GEQ
%left PLUS MINUS
%left TIMES DIVIDE

%start program
%type <Ast.program> program

%%

program:
    /* nothing */ {[]}
    | program fdecl { $2 :: $1 } 
        
fdecl:
    FUNC ID LPAREN formals_opt RPAREN LBRACE vdecl_list stmt_list RBRACE
    { { fname = $2;
    formals = $4;
    locals = List.rev $7;
    body = List.rev $8 }} 

formals_opt:
    /* nothing */ {[]}
    | formal_list { List.rev $1}

formal_list:
    ID  { [$1] }
    | formal_list COMMA ID { $3 :: $1}

vdecl_list:
    /* nothing */ { [] }
    | vdecl_list vdecl {$2 :: $1}

vdecl:
    INT ID SEMI { $2}

stmt_list: 
    /* nothing */ {[]}
    | stmt_list stmt { $2 :: $1 }

stmt:
    expr SEMI { Expr($1)}
    | RETURN expr SEMI { Return($2)}
    | LBRACE stmt_list RBRACE { Block(List.rev $2) }
    | IF LPAREN expr RPAREN stmt %prec NOELSE { If($3, $5, Block([])) }
    | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
    | FOR LPAREN expr_opt SEMI expr_opt SEMI expr_opt RPAREN stmt    
        { For($3, $5, $7, $9) }
    | WHILE LPAREN expr RPAREN stmt { While($3, $5) }

expr_opt:
    /* nothing */ { Noexpr }
    | expr {$1}
expr:
    LITERAL          { Literal($1) }
  | ID               { Id($1) }
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
  | ID ASSIGN expr   { Assign($1, $3) }
  | LPAREN expr RPAREN { $2 }

