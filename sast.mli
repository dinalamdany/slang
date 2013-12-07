open Ast
open Type

type sexpr = 
	Expr of expr * datatype

type sdecl =
	SVarDecl of datatype * ident
	| SVarAssignDecl of datatype * ident * sexpr

type sfunc_decl =
	Func_Decl of func_decl * datatype

type sstmt = 
	SBlock of sstmt list
	| SExpr of sexpr
	| SReturn of sexpr
	| SIf of sexpr * sstmt * sstmt
	| SFor of sexpr * sexpr * sexpr * sstmt
	| SWhile of sexpr * sstmt
	| SDeclaration of sdecl
	| SPropertyAssign of ident * ident * sexpr 
	| SAssign of ident * sexpr
	| SArrAssign of ident * sexpr list
	| SArrElemAssign of ident * int * sexpr
	| STerminate 

type sevent = 
    SEvent of int * sstmt list

type sthread =
    SInit of sevent list
    | SAlways of sevent list

type sprogram = 
	Prog of sfunc_decl list * (sdecl list * sthread list) 
