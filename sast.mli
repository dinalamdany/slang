open Ast
open Type

(* added to work with arrays *)
type scope = 
    Global
    | Local

type sident =
    ident * scope

type sval = 
	SExprVal of  sexpr
	| SArrVal of sexpr list

and sexpr = 
    SIntLit of int * datatype 
    | SBoolLit of bool * datatype
    | SFloatLit of float * datatype
    | SStringLit of string * datatype
    | SVariable of sident * datatype
    | SUnop of unop * expr * datatype
    | SBinop of expr * binop * expr * datatype
    | SArrElem of sident * int * datatype
    | SExprAssign of sident * expr * datatype
    | SCast of datatype * expr * datatype
    | SCall of sident * expr list * datatype

type sdecl =
	SVarDecl of datatype * sident (* put these inside decl_list for each timeblock *)
	(* changed sexpr to svalue *)
	| SVarAssignDecl of datatype * sident * sval (* v_assignment and put v_decl in timeblock decl_list*)

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
	| SAssign of sident * sexpr
	| SArrAssign of sident * sexpr list
	| SArrElemAssign of sident * int * sexpr
	| STerminate 

type sevent = 
    SEvent of int * sstmt list

type sthread =
    SInit of sevent list
    | SAlways of sevent list

type sprogram = 
	Prog of sfunc_decl list * (sdecl list * sthread list) 
