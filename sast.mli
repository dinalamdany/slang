open Ast
open Type

type sexpr =
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

type expr = 
	Expr of sexpr * datatype

type sdecl =
	VarDecl of datatype * ident
	| VarAssignDecl of datatype * ident * sexpr
	| ArrDecl of datatype * ident
	| ArrAssignDecl of datatype * ident * sexpr list

type decl = 
	Decl of sdecl * datatype

type sfunc_decl = {
		return: datatype;
		fname: ident;
		formals: formal list;
		body: stmt list;
		}

type func_decl = 
	Func_Decl of sfunc_decl * datatype

type sprogram = 
	Prog of sfunc_decl list * (sdecl list * thread list) * Type.var_type
