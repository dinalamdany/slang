open Ast

let string_of_op = function
  Add -> "+"
| Sub -> "-"
| Mult -> "*"
| Div -> "/"
| Equal -> "+"
| Neq -> "!"
| Less -> "<"
| Leq -> "<="
| Greater -> ">"
| Geq -> ">="
| And -> "&"
| Or -> "|"
| Not -> "!="
| Neg -> "!"
| Inc -> "++"
| Dec -> "--"
| Mod -> "%"

let string_of_ident = function
  Ident(id) -> id

let string_of_datatype = function
  Datatype(dtype) -> dtype

let rec string_of_expr = function
  IntLit(i) -> string_of_int i
| BoolLit(b) -> string_of_bool b
| FloatLit(f) -> string_of_float f
| StringLit(s) -> s
| Variable(ident) -> string_of_ident ident
| Unop(op, expr) -> string_of_op op ^ string_of_expr expr
| Binop(expr1, op, expr2) -> string_of_expr expr1 ^ " " ^ string_of_op op ^ " " ^ string_of_expr expr2 
| ArrElem(ident, i) -> string_of_ident ident ^ "[" ^ string_of_int i ^ "]"
| Noexpr -> ""
| ExprVarAssignDecl(datatype, ident, expr) -> string_of_datatype datatype ^ " " ^ string_of_ident ident ^ 
                                              " = " ^ string_of_expr expr
| ExprAssign(ident, expr) -> string_of_ident ident ^ " = " ^ string_of_expr expr 
| Cast(datatype, expr) -> string_of_datatype datatype^ " " ^ string_of_expr expr
| Call(ident, expr_list) -> string_of_ident ident ^ "(" ^ 
                            String.concat "," (List.map string_of_expr expr_list) ^")"
| ObjProp(ident1, ident2) -> string_of_ident ident1 ^ " : " ^ string_of_ident ident2

let rec string_of_vdecl = function
  Vdecl(datatype, id) -> (string_of_datatype datatype)^" "^(string_of_ident id)^";\n"
| VarAssignDecl(datatype, ident, expr) -> string_of_datatype datatype ^ " " ^ string_of_ident ident ^
                                          string_of_expr expr ^ ";\n"
| ArrDecl(datatype, ident) -> string_of_datatype datatype ^ " " ^ string_of_ident ident ^"[];\n"
| ArrAssignDecl(datatype, ident, expr_list) -> string_of_datatype datatype ^ " " ^ string_of_ident ident ^
                                               String.concat "" (List.map string_of_expr expr_list)
| ObjDecl(ident) -> "object " ^ string_of_ident ident ^ "\n"
| ObjAssignDecl(ident, vdecl) -> "object " ^ string_of_ident ident ^ " " ^ 
                                 String.concat "" (List.map string_of_vdecl vdecl)

let rec string_of_stmt = function
  Block(stmt_list) -> String.concat "" (List.map string_of_stmt stmt_list)
| Expr(expr) -> string_of_expr expr ^ ";\n"
| Return(expr) -> "return " ^ string_of_expr expr ^ ";\n"
| If(expr, stmt1, stmt2) -> "if (" ^ string_of_expr expr ^ ")\n" ^
                               "{\n" ^ string_of_stmt stmt1 ^ "}\n" ^
                               "else\n{\n" ^ string_of_stmt stmt2 ^ "}\n"
| For(expr1, expr2, expr3, stmt) -> "for(" ^ string_of_expr expr1 ^ ";" ^ string_of_expr expr2 ^ ";" ^
                                    string_of_expr expr3 ^ ")\n{\n" ^ string_of_stmt stmt ^ "\n}\n"
| Delay(expr, stmt) -> "# " ^ string_of_expr expr ^ " " ^ string_of_stmt stmt 
| While(expr, stmt) -> "while(" ^ string_of_expr expr ^ "){\n" ^ string_of_stmt stmt ^ "}\n"
| Declaration(vdecl) -> string_of_vdecl vdecl
| PropertyAssign(ident1, ident2, expr) -> string_of_ident ident1 ^ string_of_ident ident2 ^ string_of_expr expr
| Assign(ident, expr) -> string_of_ident ident ^ string_of_expr expr
| ArrAssign(ident, expr_list) -> string_of_ident ident ^ String.concat "" (List.map string_of_expr expr_list)
| ArrElemAssign(ident, i, expr) -> string_of_ident ident ^ "[" ^ string_of_int i ^ "] " ^ string_of_expr expr
| Terminate -> "terminate"

let rec string_of_formals = function
  VFormal(datatype, id) -> (string_of_datatype datatype)^" "^(string_of_ident id)  
| ObjFormal(ident) -> string_of_ident ident
| ArrFormal(datatype, id) -> (string_of_datatype datatype)^" "^(string_of_ident id)^"[]"

let string_of_fdecl func =
  (string_of_datatype func.return) ^" "^ (string_of_ident func.fname)^
  "(" ^ String.concat ", " (List.map string_of_formals func.formals)^ ")\n" ^
  "{\n" ^ String.concat "" (List.map string_of_stmt func.body) ^"}\n"

let rec string_of_thread = function
  Init(stmt_list) -> "init{\n" ^ String.concat "" (List.map string_of_stmt stmt_list) ^ "}\n"
| Always(stmt_list) -> "always{\n" ^ String.concat "" (List.map string_of_stmt stmt_list) ^ "}\n"

let string_of_main (decl_list, thread_list) =
  "int main(){\n" ^
  String.concat "" (List.map string_of_vdecl decl_list) ^ 
  String.concat "" (List.map string_of_thread thread_list) ^ "}"

let string_of_program (funcs, main) =
  String.concat "" (List.map string_of_fdecl funcs) ^ "\n" ^
  string_of_main main ^ "\n"