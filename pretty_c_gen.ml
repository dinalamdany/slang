open Type
open Ast
open Sast
open Pretty_c
open Printf
open Semantic_check
let print = "print"

(* Section for counters *)

let inc1 prefix =
   let count = ref (-1) in
   fun () ->
     incr count;
     prefix ^ string_of_int !count

let init_count = inc1 "init_"
let always_count = inc1 "always_"
let func_count = inc1 "func_"

(* 
(* Counter Test *) 
let () = print_endline (init_count ())  (* 0 *)
let () = print_endline (init_count ())  (* 1 *)

let () = print_endline (always_count ())  (* 0 *)
let () = print_endline (init_count ())  (* 2 *)
let () = print_endline (always_count ())  (* 1 *)

 *)

(* ----------- Actual code --------------  *)

let gen_expr = function
  SExpr(expr, datatype) -> expr

let gen_val = function
SExprVal(sexpr) -> ExprVal(gen_expr sexpr)
| SArrVal(sexpr_list) -> ArrVal(List.map gen_expr sexpr_list)

let gen_decl = function
  SVarDecl(datatype, ident) -> VarDecl(datatype, ident)
| SVarAssignDecl(datatype, ident, sval) -> VarAssignDecl(datatype, ident, (gen_val sval))

let gen_func sfunc_decl_list = function
  Func_Decl(func_decl, datatype) -> func_decl

(*Code is commented for type checking the different parts of of the Pretty_c *)
let gen_pretty_c prog = function 
  Prog(sfunc_decl_list, (sdecl_list, sthread_list)) -> 
    (* List.map gen_func sfunc_decl_list (*func_decl list*) *)
    List.map gen_decl sdecl_list (*decl list*)

(* let _ = 
  let lexbuf = Lexing.from_channel stdin in
  let sabstract_syntax_tree = Semantic_check.check_program (Parser.program Scanner.token lexbuf) in
  let pretty_c = gen_pretty_c sabstract_syntax_tree in
    pretty_c *)