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
	sexpr * Type.var_type

type sdecl =
	VarDecl of datatype * ident
	| VarAssignDecl of datatype * ident * sexpr
	| ArrDecl of datatype * ident
	| ArrAssignDecl of datatype * ident * sexpr list

type decl = sdecl * Type.var_type

type sstmt = 
	Block of sstmt list
	| Expr of sexpr
	| Return of sexpr
	| If of sexpr * sstmt * sstmt
	| For of sexpr * sexpr * sexpr * sstmt
	| While of sexpr * sstmt
	| Declaration of sdecl
	| PropertyAssign of ident * ident * sexpr
	| Assign of ident * sexpr
	| ArrAssign of ident * sexpr list
	| ArrElemAssign of ident * int * sexpr
	| Terminate

type stmt = 
	sstmt * Type.var_type

type sevent =
	Event of sexpr * sstmt list

type event =
	sevent * Type.var_type

type sfunc_decl = {
		return: datatype;
		fname: ident;
		formals: formal list;
		body: sstmt list;
		}

type func_decl = 
	sfunc_decl * Type.var_type

type sthread = 
	Init of sevent list
	| Always of sevent list

type thread = 
	sthread * Type.var_type

type sprogram = 
	sfunc_decl list * (sdecl list * sthread list) * Type.var_type
