open Ast
open Printf

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

let rec gen_function_list = function
  [] -> ""(*print_endline "no func"*)
| h::t -> ""(*print_endline "func found"*); gen_function_list t

let rec gen_vdecl_list = function
  [] -> ""(*print_endline "no decls"*)
| h::t -> gen_vdecl h; gen_vdecl_list t

let rec gen_thread_list = function
  [] -> ""(*print_endline "no threads"*)
| h::t -> ""(*print_endline "thread found "*) ; gen_thread_list t

let gen_main (decl_list, thread_list) =
	printf "int main()\n{\n";
	gen_vdecl_list decl_list;
	gen_thread_list thread_list;
	printf "return 0;\n}"

let gen_program (func_list, main) =
	gen_function_list func_list;
	gen_main main

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let loopcode = Parser.program Scanner.token lexbuf in
  gen_program loopcode
