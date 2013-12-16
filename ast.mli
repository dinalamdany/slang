open Type

type binop = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq | Mod | And | Or
type unop = Neg | Inc | Dec | Not

type ident = 
  Ident of string

type datatype = 
  Datatype of Type.var_type |
  Arraytype of datatype 

type expr =
  IntLit of int
  | BoolLit of bool
  | FloatLit of float
  | StringLit of string
  | Variable of ident 
  | Unop of unop * expr
  | Binop of expr * binop * expr
  | ArrElem of ident * expr
  | ExprAssign of ident * expr
  | Cast of datatype * expr
  | Call of ident * expr list

type value = 
  ExprVal of expr
  | ArrVal of expr list 

and decl = 
  VarDecl of datatype * ident 
  | VarAssignDecl of datatype * ident * value

type stmt = 
    Block of stmt list
  | Expr of expr
  | Return of expr
  | If of expr * stmt * stmt
  | For of expr * expr * expr * stmt
  | While of expr * stmt
  | Declaration of decl 
  | Assign of ident * expr
  | ArrAssign of ident * expr list
  | ArrElemAssign of ident * expr * expr
  | Terminate

type event = 
    Event of int * stmt list 
    
type formal = 
  Formal of datatype * ident 

type func_decl = {
  return: datatype;
  fname : ident;
  formals : formal list;
  body : stmt list;
}

type thread = 
  Init of event list
  | Always of event list

type program = 
  func_decl list * (decl list * thread list)
