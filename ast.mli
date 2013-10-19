type op = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq |
And | Or | Not | Neg | Inc | Dec | Mod

type ident = 
  Ident of string

type expr =
  IntLit of int
  | FloatLit of float
  | StringLit of string
  | Variable of ident 
  | Unop of op * expr
  | Binop of expr * op * expr
  | Assign of string * expr
  | Noexpr

type stmt = 
      Block of stmt list
    | Expr of expr
    | Return of expr
    | If of expr * stmt * stmt
    | For of expr * expr * expr * stmt
    | Delay of expr * stmt
    | While of expr * stmt

type datatype = 
    Datatype of string

type decl = 
    Vdecl of datatype * ident 
    | VarAssignDecl of datatype * ident * expr
    
type func_decl = {
    return: string;
    fname : string;
    formals : decl list;
    locals : decl list;
    body : stmt list;
}

type program = func_decl list
