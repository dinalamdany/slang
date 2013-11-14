open Ast
open Printf
let print = "print"

let gen_datatype = function
  Datatype(dtype) -> dtype

let gen_id = function
  Ident(id) -> id

let rec gen_expr = function
  IntLit(i) -> (string_of_int i)
| BoolLit(b) -> (string_of_bool b)
| FloatLit(f) -> (string_of_float f)
| StringLit(s) -> "\""^s^"\""
| Variable(ident) -> (gen_id ident)
| Unop(op, expr) -> ""
| Binop(expr, op, expr2) -> ""
| ArrElem(ident, i) -> "" 
| Noexpr -> ""
| ExprVarAssignDecl(datatype, ident, expr) -> ""
| ExprAssign(ident, expr) -> ""
| Cast(datatype, expr) -> ""
| Call(ident, expr_list) -> if ((gen_id ident) = print)
	then "std::cout << "^(gen_expr_list expr_list)
	else (gen_id ident)^"("^(gen_expr_list expr_list)^")"
| ObjProp(ident, ident2) -> ""

and gen_expr_list = function
 [] -> ""
| h::[] -> gen_expr h
| h::t -> (gen_expr h)^", "^(gen_expr_list t)

let rec gen_stmt = function
  Block(stmt_list) -> ""
| Expr(expr) -> (gen_expr expr)^";\n"
| Return(expr) -> ""
| If(expr, stmt, stmt2) -> ""
| For(expr, expr2, expr3, stmt) -> ""
| While(expr, stmt) -> ""
| Declaration(decl) -> ""
| PropertyAssign(ident, ident2, expr) -> ""
| Assign(ident, expr) -> ""
| ArrAssign(ident, expr_list) -> ""
| ArrElemAssign(ident, i, expr) -> ""
| Terminate -> ""

let rec gen_stmt_list = function
 [] -> ""
| h::[] -> gen_stmt h
| h::t -> (gen_stmt h)^(gen_stmt_list t)

let rec gen_event = function
  Event(expr, stmt_list) -> (*(gen_expr expr)^*)(gen_stmt_list stmt_list)     

let rec gen_event_list = function
 [] -> ""
| h::[] -> gen_event h
| h::t -> (gen_event h)^(gen_event_list t)

let rec gen_formal = function
  VFormal(datatype, id) -> (gen_datatype datatype)^" "^(gen_id id)  
| ObjFormal(ident) -> ""
| ArrFormal(datatype, id) -> (gen_datatype datatype)^" "^(gen_id id)^"[]"

let rec gen_vdecl = function
  Vdecl(datatype, id) -> (gen_datatype datatype)^" "^(gen_id id)^";\n"
| VarAssignDecl(datatype, ident, expr) -> ""
| ArrDecl(datatype, ident) -> (gen_datatype datatype)^" "^(gen_id ident)^"[];\n"
| ArrAssignDecl(datatype, ident, expr_list) -> ""
| ObjDecl(ident) -> ""
| ObjAssignDecl(ident, decl) -> ""

let rec gen_formal_list = function
  [] -> ""
| h::[] -> gen_formal h
| h::t -> (gen_formal h)^", "^(gen_formal_list t)

let gen_func func =
	(gen_datatype func.return)^" "^(gen_id func.fname)^"("^(gen_formal_list func.formals)^")\n{\n}\n"

let rec gen_function_list = function
  [] -> ""(*print_endline "no func"*)
| h::t -> (gen_func h)^(gen_function_list t)

let rec gen_vdecl_list = function
  [] -> ""(*print_endline "no decls"*)
| h::t -> (gen_vdecl h)^(gen_vdecl_list t)

let rec gen_thread = function
  Init(event_list) -> gen_event_list event_list
| Always(event_list) -> gen_event_list event_list

let rec gen_thread_list = function
  [] -> ""(*print_endline "no threads"*)
| h::t -> (gen_thread h)^(gen_thread_list t)

let gen_main (decl_list, thread_list) =
	"int main()\n{\n"^(gen_vdecl_list decl_list)^(gen_thread_list thread_list)^"return 0;\n}"

let gen_program (func_list, main) =
	"#include <iostream>\n#include <string>\nusing namespace std;\n"^(gen_function_list func_list)^(gen_main main)

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let loopcode = Parser.program Scanner.token lexbuf in
  let code = gen_program loopcode in
  let output = open_out "output.cpp" in
  output_string output code
