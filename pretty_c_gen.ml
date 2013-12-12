open Type
open Ast
open Sast
open Pretty_c
open Printf
open Semantic_check
let print = "print"

(* Counters *)

let inc1 prefix =
   let count = ref (-1) in
   fun () ->
     incr count;
     prefix ^ string_of_int !count

(* Main_lists type *)
type main_lists = {
  mutable so: struct_obj list;
  mutable l1: link list;
  mutable l2: link list;
}

(* 'Global' variable for lists in main *)
let m_lists = {so=[]; l1=[]; l2=[]};;

(* 
(* Counter Test *) 
let init_count = inc1 "init_"
let always_count = inc1 "always_"

let () = print_endline (init_count ())  (* 0 *)
let () = print_endline (init_count ())  (* 1 *)

let () = print_endline (always_count ())  (* 0 *)
let () = print_endline (init_count ())  (* 2 *)
let () = print_endline (always_count ())  (* 1 *)

 *)

(* ----------- Begin Pretty_c_gen functions --------------  *)

let gen_expr = function
  SExpr(expr, datatype) -> expr

let gen_val = function
SExprVal(sexpr) -> ExprVal(gen_expr sexpr)
| SArrVal(sexpr_list) -> ArrVal(List.map gen_expr sexpr_list)

let gen_decl = function
  SVarDecl(datatype, ident) -> VarDecl(datatype, ident)
| SVarAssignDecl(datatype, ident, sval) -> VarAssignDecl(datatype, ident, (gen_val sval))

let rec gen_stmt  = function
SBlock(sstmt_list) -> Block(List.map gen_stmt sstmt_list)
| SSExpr(sexpr) -> Expr(gen_expr sexpr)
| SReturn(sexpr) -> Return(gen_expr sexpr)
| SIf(sexpr ,sstmt1, sstmt2)-> If(gen_expr sexpr, gen_stmt sstmt1, gen_stmt sstmt2)
| SFor(sexpr1, sexpr2, sexpr3, sstmt)-> For(gen_expr sexpr1, gen_expr sexpr2, gen_expr sexpr3, gen_stmt sstmt)
| SWhile(sexpr1, sstmt) -> While(gen_expr sexpr1, gen_stmt sstmt)
| SDeclaration(sdecl) -> Declaration(gen_decl sdecl)
| SAssign(ident, sexpr) -> Assign(ident, gen_expr sexpr)
| SArrAssign(ident, sexpr_list) -> ArrAssign(ident, List.map gen_expr sexpr_list)
| SArrElemAssign(ident, i, sexpr) -> ArrElemAssign(ident, i, gen_expr sexpr)
| STerminate -> Terminate

(* Receives the link, creates a current name (i.e. init_1_block_1).
  Then creates the time struct with the name, the delay from event *)
let gen_structure counter link = function
  SEvent(delay, sstmt_list) -> let curr_name = inc1 (counter ^ "_block_") () in
                                 let name = Time_struct_name(curr_name) in 
                                   m_lists.so <- Time_struct_obj(name, link) :: m_lists.so; (*adding to main list*)
                                   Time_struct(name, delay, link, List.map gen_stmt sstmt_list)

(* Receives sthread, creates Link for either init or always,
  sends this link as parameter for gen_structure function *)
(*  TODO: v_Decls for timeblocks are currently empty lists... Whats the actual value? *)
let gen_time_block = function 
  SInit(sthread) -> let curr_count = inc1 "init_" () in
                      let link = Link(curr_count) in m_lists.l1 <- link :: m_lists.l1; (*adding to main list*)
                        let partial_gen_struct = gen_structure curr_count link in
                          Time_block(link, [], List.map partial_gen_struct sthread)
| SAlways(sthread) -> let curr_count = inc1 "always_" () in
                        let link = Link(curr_count) in m_lists.l2 <- link :: m_lists.l2; (*adding to main list*)
                          let partial_gen_struct = gen_structure curr_count link in
                            Time_block(link, [], List.map partial_gen_struct sthread)                        

let gen_func = function
  Func_Decl(func_decl, datatype) -> func_decl

(* TODO: lists in main are not being populated. The lines where the lists have to be populated are
   commented in the gen_time_block, and gen_structure functions *)
(* Main function to generate a pretty_c *)
let gen_pretty_c prog = function 
  Prog(sfunc_decl_list, (sdecl_list, sthread_list)) -> 
    let func_list = List.map gen_func sfunc_decl_list in (* Functions *)
    let decl_list = List.map gen_decl sdecl_list in (* Declarations *)
    let time_block_list = List.map gen_time_block  sthread_list in (* Time Blocks *)
    let main = Main(m_lists.so, m_lists.l1, m_lists.l2) in (* Main *)
      Pretty_c(decl_list, func_list, time_block_list, main)
