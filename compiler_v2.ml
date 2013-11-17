open Ast
open Printf
let print = "print"

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

let gen_datatype = function
  Datatype(dtype) -> dtype

let gen_id = function
  Ident(id) -> id

(* Unop 
  binop
*)

let rec gen_expr = function
  IntLit(i) -> (string_of_int i)
| BoolLit(b) -> (string_of_bool b)
| FloatLit(f) -> (string_of_float f)
| StringLit(s) -> "\""^s^"\""
| Variable(ident) -> (gen_id ident)
| Unop(op, expr) -> string_of_op op ^ "( " ^ gen_expr expr ^ " )"
| Binop(expr1, op, expr2) ->  gen_expr expr1 ^ string_of_op op ^ gen_expr expr2
| ArrElem(ident, i) -> gen_id ident ^ "[" ^ string_of_int i ^ "]"
| Noexpr -> ""
| ExprVarAssignDecl(datatype, ident, expr) -> gen_datatype datatype ^ " " ^ gen_id ident ^ 
                                              " = " ^ gen_expr expr
| ExprAssign(ident, expr) -> gen_id ident ^ " = " ^ gen_expr expr
| Cast(datatype, expr) ->  "(" ^ gen_datatype datatype^ ") " ^ gen_expr expr
| Call(ident, expr_list) -> if ((gen_id ident) = print)
	then "std::cout << "^ String.concat ", " (List.map gen_expr expr_list)
	else (gen_id ident)^"("^ String.concat "," (List.map gen_expr expr_list)^");"
| ObjProp(ident1, ident2) -> gen_id ident1 ^ "." ^ gen_id ident2

let rec gen_vdecl = function
  Vdecl(datatype, id) -> (gen_datatype datatype)^ " " ^(gen_id id) ^ ";\n"
| VarAssignDecl(datatype, ident, expr) -> gen_datatype datatype ^ " " ^ gen_id ident ^
                                          " = " ^ gen_expr expr ^ ";\n"
| ArrDecl(datatype, ident) -> "vector<" ^ gen_datatype datatype ^ "> " ^ gen_id ident ^ ";\n"
| ArrAssignDecl(datatype, ident, expr_list) -> "vector<" ^ gen_datatype datatype ^ "> " ^ gen_id ident ^ " = " ^ 
                                               String.concat "" (List.map gen_expr expr_list)
| ObjDecl(ident) -> "//TODO: create struct-> object " ^ gen_id ident
| ObjAssignDecl(ident, vdecl) -> "//TODO: create struct-> object " ^ gen_id ident ^ " " ^ 
                                 String.concat "" (List.map gen_vdecl vdecl)

let rec gen_stmt = function
  Block(stmt_list) -> "{\n" ^ String.concat "" (List.map gen_stmt stmt_list) ^ "}\n"
| Expr(expr) -> gen_expr expr ^ ";\n"
| Return(expr) -> "return " ^ gen_expr expr ^ ";\n"
| If(expr, stmt1, stmt2) -> "if (" ^ gen_expr expr ^ ")\n" ^
                               gen_stmt stmt1 ^ "\n" ^
                               "else\n" ^ gen_stmt stmt2 ^ "\n"
| For(expr1, expr2, expr3, stmt) -> "for(" ^ gen_expr expr1 ^ ";" ^ gen_expr expr2 ^ ";" ^
                                    gen_expr expr3 ^ ")\n{\n" ^ gen_stmt stmt ^ "\n}\n"
| While(expr, stmt) -> "while(" ^ gen_expr expr ^ ") " ^ gen_stmt stmt ^ "\n"
| Declaration(vdecl) -> gen_vdecl vdecl
| PropertyAssign(ident1, ident2, expr) -> "//TODO: Find appropriate struct" ^ gen_id ident1 ^ "." ^ 
                                          gen_id ident2 ^ " = " ^ gen_expr expr ^ ";\n"
| Assign(ident, expr) -> gen_id ident ^ " = " ^ gen_expr expr ^ ";\n"
| ArrAssign(ident, expr_list) -> gen_id ident ^ " = [" ^ String.concat ", " (List.map gen_expr expr_list) ^ "];\n"
| ArrElemAssign(ident, i, expr) ->  gen_id ident ^ "[" ^ string_of_int i ^ "] = " ^ gen_expr expr ^ ";\n"
| Terminate -> "//TODO: go to appropriate 'end' function... -> return 0;\n"

let rec gen_event = function
  Event(expr, stmt_list) -> String.concat "" (List.map gen_stmt (List.rev stmt_list))

let rec gen_formal = function
  VFormal(datatype, id) -> gen_datatype datatype ^ " " ^ gen_id id  
| ObjFormal(ident) -> "//TODO gen object formal ->" ^ gen_id ident 
| ArrFormal(datatype, id) -> (gen_datatype datatype)^" "^(gen_id id)^"[]"

let gen_func func =
	gen_datatype func.return ^ " " ^ gen_id func.fname ^
  "(" ^ String.concat "," (List.map gen_formal func.formals) ^ ")\n{\n}\n"

let rec gen_vdecl_list = function
  [] -> ""(*print_endline "no decls"*)
| h::t -> (gen_vdecl h)^(gen_vdecl_list t)

let rec gen_thread = function
  Init(event_list) -> "//TODO: create struct-> INIT(\n" ^ String.concat "" (List.map gen_event event_list) ^ "\n//)\n"
| Always(event_list) -> "//TODO: create struct-> INIT(\n" ^ String.concat "" (List.map gen_event event_list) ^ "\n//)\n"

let gen_main (decl_list, thread_list) =
	"int main()\n{\n"^ gen_vdecl_list decl_list ^ String.concat "" (List.map gen_thread thread_list) ^ "return 0;\n}"

let gen_program (func_list, main) =
	"#include <iostream>\n#include <string>\nusing namespace std;\n" ^ 
  String.concat "" (List.map gen_func func_list) ^ 
  gen_main main

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let loopcode = Parser.program Scanner.token lexbuf in
  let code = gen_program loopcode in
  let output = open_out "output.cpp" in
  output_string output code
