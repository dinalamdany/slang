open Ast 
open Sast
open Pretty_c

(* ------------ Helpers -------------- *)

(* Counters *)
let inc1 prefix =
   let count = ref (-1) in
   fun () ->
     incr count;
     prefix ^ string_of_int !count

(* Global counter functions *)
let init_count = inc1 "init_"
let always_count = inc1 "always_"

(* Main_lists type *)
type main_lists = {
  mutable so: struct_obj list;
  mutable l1: link list;
  mutable l2: link list;
  mutable v_decls: decl list;
}

(* 'Global variable' for lists in main *)
let m_lists = {so=[]; l1=[]; l2=[]; v_decls=[]};;

(* ----------- Begin Pretty_c_gen functions --------------  *)

(* Statement declaration *)

let gen_ident = function
  SIdent(ident,scope) -> ident

let rec gen_expr = function
  SIntLit(i,datatype) -> IntLit(i)
| SBoolLit(b, datatype) -> BoolLit(b)
| SFloatLit(f,datatype) -> FloatLit(f)
| SStringLit(s,datatype) -> StringLit(s)
| SVariable(sident, datatype) -> Variable(gen_ident sident)
| SUnop(unop, sexpr, datatype)-> Unop(unop, gen_expr sexpr)
| SBinop(sexpr, binop, sexpr2, datatype) -> Binop(gen_expr sexpr, binop, gen_expr sexpr2)
| SArrElem(sident, i, datatype) -> ArrElem(gen_ident sident, IntLit(i))
| SExprAssign(sident, sexpr, datatype) -> ExprAssign(gen_ident sident, gen_expr sexpr)
| SCast(datatype, sexpr, datatype2) -> Cast(datatype, gen_expr sexpr)
| SCall(sident, sexpr_list, datatype) -> Call(gen_ident sident, List.map gen_expr sexpr_list)

let gen_val = function
SExprVal(sexpr) -> ExprVal(gen_expr sexpr)
| SArrVal(sexpr_list) -> ArrVal(List.map gen_expr sexpr_list)

let gen_decl = function
  SVarDecl(datatype, sident) -> VarDecl(datatype, gen_ident sident)
| SVarAssignDecl(datatype, sident, sval) -> VarAssignDecl(datatype, gen_ident sident, (gen_val sval))

let rec gen_stmt  = function
SBlock(sstmt_list) -> Block(List.map gen_stmt sstmt_list)
| SSExpr(sexpr) -> Expr(gen_expr sexpr)
| SReturn(sexpr) -> Return(gen_expr sexpr)
| SIf(sexpr ,sstmt1, sstmt2)-> If(gen_expr sexpr, gen_stmt sstmt1, gen_stmt sstmt2)
| SFor(sexpr1, sexpr2, sexpr3, sstmt)-> For(gen_expr sexpr1, gen_expr sexpr2, gen_expr sexpr3, gen_stmt sstmt)
| SWhile(sexpr1, sstmt) -> While(gen_expr sexpr1, gen_stmt sstmt)
| SDeclaration(sdecl) -> Declaration(gen_decl sdecl)
| SAssign(sident, sexpr) -> Assign(gen_ident sident, gen_expr sexpr)
| SArrAssign(sident, sexpr_list) -> ArrAssign(gen_ident sident, List.map gen_expr sexpr_list)
| SArrElemAssign(sident, i, sexpr) -> ArrElemAssign(gen_ident sident, IntLit(i), gen_expr sexpr)
| STerminate -> Terminate

(* Section for special v_decl filtering *)

let rec gen_tb_expr = function
  SIntLit(i,datatype) -> IntLit(i)
| SBoolLit(b, datatype) -> BoolLit(b)
| SFloatLit(f,datatype) -> FloatLit(f)
| SStringLit(s,datatype) -> StringLit(s)
| SVariable(sident, datatype) -> Variable(gen_ident sident)
| SUnop(unop, sexpr, datatype)-> Unop(unop, gen_expr sexpr)
| SBinop(sexpr, binop, sexpr2, datatype) -> Binop(gen_tb_expr sexpr, binop, gen_tb_expr sexpr2)
| SArrElem(sident, i, datatype) -> ArrElem(gen_ident sident, IntLit(i))
| SExprAssign(sident, sexpr, datatype) -> ExprAssign(gen_ident sident, gen_tb_expr sexpr)
| SCast(datatype, sexpr, datatype2) -> Cast(datatype, gen_tb_expr sexpr)
| SCall(sident, sexpr_list, datatype) -> Call(gen_ident sident, List.map gen_tb_expr sexpr_list)

let gen_tb_decl = function
  SVarDecl(datatype, sident) -> m_lists.v_decls <- VarDecl(datatype, gen_ident sident) :: m_lists.v_decls;
                                VarDecl(datatype, gen_ident sident)
| SVarAssignDecl(datatype, sident, sval) -> m_lists.v_decls <- VarDecl(datatype, gen_ident sident) :: m_lists.v_decls;
                                            VarAssignDecl(datatype, gen_ident sident, (gen_val sval))

let rec gen_tb_stmt  = function
SBlock(sstmt_list) -> Block(List.map gen_tb_stmt sstmt_list)
| SSExpr(sexpr) -> Expr(gen_tb_expr sexpr)
| SReturn(sexpr) -> Return(gen_tb_expr sexpr)
| SIf(sexpr ,sstmt1, sstmt2)-> If(gen_tb_expr sexpr, gen_tb_stmt sstmt1, gen_tb_stmt sstmt2)
| SFor(sexpr1, sexpr2, sexpr3, sstmt)-> For(gen_tb_expr sexpr1, gen_tb_expr sexpr2, gen_tb_expr sexpr3, gen_tb_stmt sstmt)
| SWhile(sexpr1, sstmt) -> While(gen_tb_expr sexpr1, gen_tb_stmt sstmt)
| SDeclaration(sdecl) -> Declaration(gen_tb_decl sdecl)
| SAssign(sident, sexpr) -> Assign(gen_ident sident, gen_tb_expr sexpr)
| SArrAssign(sident, sexpr_list) -> ArrAssign(gen_ident sident, List.map gen_tb_expr sexpr_list)
| SArrElemAssign(sident, i, sexpr) -> ArrElemAssign(gen_ident sident, IntLit(i), gen_tb_expr sexpr)
| STerminate -> Terminate

let gen_tb_vdecls = function
  SEvent(delay, sstmt_list) -> List.map gen_tb_stmt sstmt_list

(* Receives the link, creates a current name (i.e. init_0_block_1).
  Then creates the time struct with the name, the delay from event *)
let gen_structure curr_name_f link = function
  SEvent(delay, sstmt_list) -> let name = Time_struct_name(curr_name_f ()) in (* Counter *)
                                 m_lists.so <- Time_struct_obj(name, link) :: m_lists.so; (*adding to main list*)
                                 Time_struct(name, delay, link, List.rev sstmt_list)

(* Receives sthread, creates Link for init or always,
  sends this link as parameter for gen_structure function *)
let gen_time_block = function 
  SInit(sthread) -> m_lists.v_decls <- []; (* Reset v_decl list *)
    let curr_link_str = init_count () in let curr_name_f = inc1 (curr_link_str ^ "_block_") in (*Counters*)
      let link = Link(curr_link_str) in m_lists.l1 <- link :: m_lists.l1; (*adding to main list*)
        let partial_gen_struct = gen_structure curr_name_f link in
          List.map gen_tb_vdecls sthread;
          Time_block(link, m_lists.v_decls, List.map partial_gen_struct (List.rev sthread))
| SAlways(sthread) -> m_lists.v_decls <- []; (* Reset v_decl list *)
    let curr_link_str = always_count () in let curr_name_f = inc1 (curr_link_str ^ "_block_") in (*Counters*)
      let link = Link(curr_link_str) in m_lists.l2 <- link :: m_lists.l2; (*adding to main list*)
        let partial_gen_struct = gen_structure curr_name_f link in
          List.map gen_tb_vdecls sthread;
          Time_block(link, m_lists.v_decls, List.map partial_gen_struct (List.rev sthread))                     

let gen_func = function
  SFunc_Decl(sfuncstr, datatype) -> {return=sfuncstr.sreturn; fname=sfuncstr.sfname; 
                                    formals=sfuncstr.sformals; body= List.map gen_stmt (List.rev sfuncstr.sbody)}

(* Main function to generate a pretty_c *)
let gen_pretty_c = function 
  Prog(sfunc_decl_list, (sdecl_list, sthread_list)) -> 
    let func_list = List.map gen_func sfunc_decl_list in (* Functions *)
    let decl_list = List.map gen_decl sdecl_list in (* Declarations *)
    let time_block_list = List.map gen_time_block (List.rev sthread_list) in (* Time Blocks *)
    let main = Main(List.rev m_lists.so, List.rev m_lists.l1, List.rev m_lists.l2) in (* Main *)
      Pretty_c(decl_list, func_list, time_block_list, main) (* Pretty_c *)
