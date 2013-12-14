open Ast
open Type

(* added to work with arrays *)
type scope = 
    Global
    | Local
    | Function

type sident =
    SIdent of ident * scope

type sval = 
	SExprVal of  sexpr
	| SArrVal of sexpr list

and sexpr = 
    SIntLit of int * datatype 
    | SBoolLit of bool * datatype
    | SFloatLit of float * datatype
    | SStringLit of string * datatype
    | SVariable of sident * datatype
    | SUnop of unop * sexpr * datatype
    | SBinop of sexpr * binop * sexpr * datatype
    | SArrElem of sident * int * datatype
    | SExprAssign of sident * sexpr * datatype
    | SCast of datatype * sexpr * datatype
    | SCall of sident * sexpr list * datatype

type sdecl =
	SVarDecl of datatype * sident (* put these inside decl_list for each timeblock *)
	(* changed sexpr to svalue *)
	| SVarAssignDecl of datatype * sident * sval (* v_assignment and put v_decl in timeblock decl_list*)

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

type sfuncstr = {
  sreturn: datatype;
  sfname : ident;
  sformals : formal list;
  sbody : sstmt list;
}

type sfunc_decl =
	SFunc_Decl of sfuncstr * datatype

type sevent = 
    SEvent of int * sstmt list

type sthread =
    SInit of sevent list
    | SAlways of sevent list

type sprogram = 
	Prog of sfunc_decl list * (sdecl list * sthread list) 
