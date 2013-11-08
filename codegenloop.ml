open Ast
open Printf
(*
let rec evalloop loop = match loop with
    Noexpr -> ""
  | For(expr1, expr2, expr3, stmt) -> "for"(*"for("^(evalloop expr1)^";"^(evalloop expr2)^";"^(evalloop expr3)^")\n{"^(evalloop stmt)*)^"}\n"
  | While(expr, stmt) -> "while"(*"while("^(evalloop expr)^")\n{"^(evalloop stmt)^"}\n"*)
*)
let rec print_func func = function
  [] -> ""
(*| stuff -> print_endline stuff.return*)
let gen_datatype = function
  Datatype(dtype) -> dtype

let gen_id = function
  Ident(id) -> id

let rec gen_vdecl = function
  Vdecl(datatype, id) -> printf "%s %s;\n" (gen_datatype datatype) (gen_id id)
| VarAssignDecl(datatype, ident, expr) -> print_endline ""
| ArrDecl(datatype, ident) -> print_endline ""
| ArrAssignDecl(datatype, ident, expr_list) -> print_endline ""
| ObjDecl(ident) -> print_endline ""
| ObjAssignDecl(ident, decl) -> print_endline""

let rec test_function = function
  [] -> ""(*print_endline "no func"*)
| h::t -> ""(*print_endline "func found"*); test_function t

let rec gen_vdecl_list = function
  [] -> ""(*print_endline "no decls"*)
| h::t -> gen_vdecl h; gen_vdecl_list t

let rec test_thread = function
  [] -> ""(*print_endline "no threads"*)
| h::t -> ""(*print_endline "thread found "*) ; test_thread t

let test_main (decl_list, thread_list) =
	printf "int main()\n{\n";
	gen_vdecl_list decl_list;
	test_thread thread_list;
	printf "return 0;\n}"

let printTest (func_list, main) =
	test_function func_list;
	test_main main

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let loopcode = Parser.program Scanner.token lexbuf in
  (*let testloop = evalloop loopcode in
  print_endline testloop*)
  printTest loopcode
