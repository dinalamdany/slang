open Ast
(*open Printf*)
(*
let rec evalloop loop = match loop with
    Noexpr -> ""
  | For(expr1, expr2, expr3, stmt) -> "for"(*"for("^(evalloop expr1)^";"^(evalloop expr2)^";"^(evalloop expr3)^")\n{"^(evalloop stmt)*)^"}\n"
  | While(expr, stmt) -> "while"(*"while("^(evalloop expr)^")\n{"^(evalloop stmt)^"}\n"*)
*)

let rec test_function = function
  [] -> print_endline "no functions"
| h::t -> print_endline "func found " ; test_function t

let rec test_decl = function
  [] -> print_endline "no decls"
| h::t -> print_endline "decl found " ; test_decl t

let rec test_thread = function
  [] -> print_endline "no threads"
| h::t -> print_endline "thread found " ; test_thread t

let test_main (decl_list, thread_list) =
	test_decl decl_list;
	test_thread thread_list

let printTest (func_list, main) =
	test_function func_list;
	test_main main
let _ =
  let lexbuf = Lexing.from_channel stdin in
  let loopcode = Parser.program Scanner.token lexbuf in
  (*let testloop = evalloop loopcode in
  print_endline testloop*)
  printTest loopcode
