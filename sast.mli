open Ast
open Type

(* added to work with arrays *)
type sval = 
	SExprVal of  sexpr
	| SArrVal of sexpr list

and sexpr = 
	SExpr of expr * datatype

type sdecl =
	SVarDecl of datatype * ident
	(* changed sexpr to svalue *)
	| SVarAssignDecl of datatype * ident * sval
	(* There is no way to work with arrays with the following *)
	(* | SVarAssignDecl of datatype * ident * sexpr *)

type sfunc_decl =
	Func_Decl of func_decl * datatype

type sstmt = 
	SBlock of sstmt list
	| SSExpr of sexpr
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
