open Ast

(* Slang return types *)
type sl_ret = 
    RInt
  | RFloat
  | RString
  | RBool
  | RVoid
  | RObject

(* Slang type definitions *)
type sl_var = 
    Int
  | Float
  | String
  | Bool
  | Object

(* Expressions *)
type sexpr = 
  ExprType of expr * sl_ret

(* Declarations *)
type sdecl = 
  Vdecl of datatype * ident * sl_var
  | VarAssignDecl of datatype * ident * sexpr * sl_var
  | ArrDecl of datatype * ident * sl_var
  | ArrAssignDecl of datatype * ident * sexpr list * sl_var  
  | ObjDecl of ident * sl_var
  | ObjAssignDecl of ident * sdecl list * sl_var

(* Statements *)
type sstmt = 
    Block of sstmt list
  | Expr of sexpr
  | Return of sexpr
  | If of sexpr * sstmt * sstmt
  | For of sexpr * sexpr * sexpr * sstmt
  | Delay of sexpr * sstmt
  | While of sexpr * sstmt
  | Declaration of sdecl 
  | PropertyAssign of ident * ident * sexpr
  | Assign of ident * sexpr
  | ArrAssign of ident * sexpr list
  | ArrElemAssign of ident * int * sexpr
  | Terminate

(* Formals in function declaration *)
type sformal = 
  VFormal of datatype * ident * sl_var 
  | ObjFormal of ident * sl_var
  | ArrFormal of datatype * ident * sl_var

type sfunc_decl = {
  return: datatype * sl_var;
  fname : ident;
  formals : sformal list;
  body : sstmt list;
}

type sprogram = 
  sfunc_decl list * (sdecl list * thread list)