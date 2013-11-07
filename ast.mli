type op = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq |And | Or | Not | Neg | Inc | Dec | Mod

type ident = 
  Ident of string

type datatype = 
    Datatype of string

type expr =
  IntLit of int
  | BoolLit of bool
  | FloatLit of float
  | StringLit of string
  | Variable of ident 
  | Unop of op * expr
  | Binop of expr * op * expr
  | Assign of ident * expr
  | ArrAssign of ident * int * expr
  | ArrElem of ident * int 
  | Noexpr
  | Cast of datatype * expr
<<<<<<< HEAD
  | Call of string * expr list
=======

>>>>>>> 850aec69f358816b3bf47897e785799db2f25add
type decl = 
    Vdecl of datatype * ident 
    | VarAssignDecl of datatype * ident * expr
    | ArrDecl of datatype * ident 
    | ArrAssignDecl of datatype * ident * expr list
    | ObjDecl of ident
    | ObjAssignDecl of ident * decl list

type stmt = 
      Block of stmt list
    | Expr of expr
    | Return of expr
    | If of expr * stmt * stmt
    | For of expr * expr * expr * stmt
    | Delay of expr * stmt
    | While of expr * stmt
    | Declaration of decl 
    | PropertyAssign of ident * ident * expr
    | Terminate

type formal = 
    VFormal of datatype * ident 
    | ObjFormal of ident
    | ArrFormal of datatype * ident

type func_decl = {
    return: string;
    fname : string;
    formals : formal list;
    body : stmt list;
}

type thread = 
    Init of stmt list
    | Always of stmt list

type program = 
    func_decl list * (decl list * thread list)
