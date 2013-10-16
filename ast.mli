type op = Add | Sub | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq |
And | Or | Not | Neg

type expr =
    Literal of int
  | Id of string
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

type func_decl = {
    fname : string;
    formals : string list;
    locals : string list;
    body : stmt list;
}

type program = func_decl list
