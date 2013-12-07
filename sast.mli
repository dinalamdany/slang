open Ast
open Type

(*type sexpr =
	IntLit of int
	| BoolLit of bool
	| StringList of string
	| Variable of ident
	| Unop of unop * sexpr
	| Binop of sexpr * binop * sexpr
	| ArrElem of ident * int
	| Noexpr
	| ExprAssign of ident* sexpr
	| Cast of datatype * sexpr
	| Call of ident * sexpr list
	| ObjProp of ident * ident
*)
type sexpr = 
	Expr of expr * datatype

type sdecl =
	SVarDecl of datatype * ident
	| SVarAssignDecl of datatype * ident * sexpr

(*type sfunc_decl = {
		return: datatype;
		fname: ident;
		formals: formal list;
		body: stmt list;
		}
*)
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

(*type sstmt = 
	Stmt of sstmt * datatype*)

type sevent = 
    Event of int * sstmt list

type sthread =
    Init of sevent list
    | Always of sevent list

type sprogram = 
	Prog of sfunc_decl list * (sdecl list * sthread list) 
