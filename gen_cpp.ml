open Ast
open Printf
open Pretty_c
open Type

let print = "print"
let prefix_global_var = "u_"
let prefix_event = "event_"
let prefix_event_list = "event_q_"
let code_event_base = "struct " ^ prefix_event^
  " {\n\tunsigned int time;\n\tvirtual unsigned int get_time() {};\n\t" ^
  "virtual void foo() {};\n\tvirtual ~"^ prefix_event ^ "() {};\n};\n"
let code_event_list = "struct "^ prefix_event_list ^
  " {\n\tbool empty() {return event_q.empty();}\n\t" ^ 
  prefix_event ^ "* pop() {\n\t\t" ^
  prefix_event ^ " *front = event_q.front();\n\t\t" ^
  "event_q.pop_front();\n\t\treturn front;\n\t}\n\t" ^
  "void add(unsigned int time_, " ^ prefix_event ^
  " *obj_) {\n\t\tbool eol = true;\n\t\tstd::deque<" ^
  prefix_event ^ "*>::iterator it;\n\t\tif (obj_ == NULL)\n\t\t\treturn;" ^
  "\n\t\tfor (it = event_q.begin(); it != event_q.end(); it++) " ^
  "{\n\t\t\tif ((*it)->get_time() > time_) {\n\t\t\t\t" ^
  "event_q.insert(it, obj_);\n\t\t\t\teol = false;\n\t\t\t\tbreak;" ^
  "\n\t\t\t}\n\t\t}\n\t\tif (eol) {\n\t\t\tevent_q.push_back(obj_);" ^
  "\n\t\t}\n\t}\n\tprivate:\n\t\tstd::deque<" ^
  prefix_event ^ "*> event_q;\n};\n" ^ prefix_event_list ^ " event_q;\n"
let code_directives = "#include <iostream>\n#include <string>\n#include <deque>\n#include <vector>\n#include <cstdlib>\n"
let code_event_list_do = "while(!event_q.empty()) {\n\tevent_q.pop()->foo();\n\t}\n"
let header = code_directives^code_event_base^code_event_list
(*let _ = print_endline header*)

let gen_id = function
  Ident(id) -> id

let gen_name = function
  Time_struct_name(s) -> s

let gen_link = function
  Link(s) -> s

let gen_unop = function
  Neg -> "-"
| Inc -> "++"
| Dec -> "--"
| Not -> "!"

let gen_binop = function
  Add -> "+"
| Sub -> "-"
| Mult -> "*"
| Div -> "/"
| Equal -> "=="
| Neq -> "!="
| Less -> "<"
| Leq -> "<="
| Greater -> ">"
| Geq -> ">="
| Mod -> "%"
| And -> "&&"
| Or -> "||"

let gen_var_type = function
  Int -> "int"
| Float -> "float"
| String -> "std::string"
| Boolean -> "bool"
| Void -> "void"

let rec gen_datatype = function
  Datatype(var_type) -> gen_var_type var_type
| Arraytype(datatype) -> "std::vector<" ^ gen_datatype datatype ^ ">"

let rec gen_formal formal prefix = match formal with
  Formal(datatype, id) -> gen_datatype datatype ^ " " ^ prefix ^ gen_id id

let rec gen_expr expr prefix = match expr with
  IntLit(i) -> string_of_int i
| BoolLit(b) -> string_of_bool b
| FloatLit(f) -> string_of_float f
| StringLit(s) -> "\"" ^ s ^ "\""
| Variable(ident) -> prefix ^ gen_id ident
| Unop(unop, expr) -> gen_unop unop ^ "(" ^ gen_expr expr prefix ^ ")"
| Binop(expr1, binop, expr2) -> gen_expr expr1 prefix ^ gen_binop binop ^
    gen_expr expr2 prefix
| ArrElem(ident, i) -> prefix ^ gen_id ident ^ "[" ^ string_of_int i ^ "]"
| Noexpr -> ""
| ExprAssign(ident, expr) -> prefix ^ gen_id ident ^ " = " ^ gen_expr expr prefix
| Cast(datatype, expr) -> "(" ^ gen_datatype datatype^ ") " ^ gen_expr expr prefix
| Call(ident, expr_list) -> if ((gen_id ident) = print)
    then "std::cout << "^ gen_expr_list expr_list prefix ^ "std::endl"
    else prefix ^ gen_id ident ^ "(" ^ gen_expr_list expr_list prefix ^ ")"

(*semicolon and newline handled in gen_stmt because blocks dont have semicolon*)
and gen_stmt stmt prefix = match stmt with
  Block(stmt_list) -> "{\n" ^ gen_stmt_list stmt_list prefix ^ "\n}\n"
| Expr(expr) -> gen_expr expr prefix ^ ";\n"
| Return(expr) -> "return " ^ gen_expr expr prefix ^ ";\n"
| If(expr, stmt1, stmt2) -> "if (" ^ gen_expr expr prefix ^ ")\n" ^ 
    gen_stmt stmt1 prefix ^ "else " ^ gen_stmt stmt2 prefix
| For(expr1, expr2, expr3, stmt) -> "for (" ^ gen_expr expr1 prefix ^ "; " ^ 
    gen_expr expr2 prefix ^ "; " ^ gen_expr expr3 prefix ^ ")\n" ^
    gen_stmt stmt prefix
| While(expr, stmt) -> "while (" ^ gen_expr expr prefix ^ ")\n" ^
    gen_stmt stmt prefix ^ ";\n"
| Declaration(decl) -> gen_decl decl prefix ^ ";\n"
| Assign(ident, expr) -> prefix ^ gen_id ident ^ " = " ^ gen_expr expr prefix ^ ";\n"
| ArrAssign(ident, expr_list) -> prefix ^ gen_id ident ^ ".clear();\n" ^
     (gen_array_expr_list expr_list ident prefix) ^ ";\n"
| ArrElemAssign(ident, i, expr) -> prefix ^ gen_id ident ^
    "[" ^ string_of_int i ^ "] = " ^ gen_expr expr prefix ^ ";\n"
| Terminate -> "exit(0)"

(*semicolon and newline handled in gen_decl since array decl assignment is actually vector push_back*)
and gen_decl decl prefix = match decl with
  VarDecl(datatype, id) -> gen_datatype datatype ^ " " ^ prefix ^ gen_id id  ^ ";\n"
| VarAssignDecl(datatype, ident, value) ->  gen_datatype datatype ^ " " ^ prefix ^
    gen_id ident ^ (gen_value value ident prefix)

and gen_value value ident prefix = match value with
  ExprVal(expr) -> " = " ^ gen_expr expr prefix ^ ";\n"
| ArrVal(expr_list) -> ";\n" ^ (gen_array_expr_list expr_list ident prefix)

and gen_array_expr_list expr_list ident prefix = match expr_list with
 [] -> ""
| h::[] -> prefix ^ gen_id ident ^ ".push_back(" ^ gen_expr h prefix ^");\n"
| h::t -> prefix ^ gen_id ident ^ ".push_back(" ^ gen_expr h prefix
  ^ ");\n" ^ (gen_array_expr_list t ident prefix)

and gen_func func prefix =
  gen_datatype func.return ^ " " ^ prefix ^ gen_id func.fname ^
  "(" ^ gen_formal_list func.formals prefix ^ 
  ") {\n" ^ gen_stmt_list func.body prefix ^ "}\n"

and gen_decl_list decl_list prefix = match decl_list with
 [] -> ""
| h::[] -> gen_decl h prefix
| h::t -> gen_decl h prefix ^ gen_decl_list t prefix

and gen_func_list func_list prefix = match func_list with
 [] -> ""
| h::[] -> gen_func h prefix
| h::t -> gen_func h prefix ^ gen_func_list t prefix

and gen_formal_list formal_list prefix = match formal_list with
 [] -> ""
| h::[] -> gen_formal h prefix
| h::t -> gen_formal h prefix ^ ", " ^ gen_formal_list t prefix

and gen_stmt_list stmt_list prefix = match stmt_list with
 [] -> ""
| h::[] -> gen_stmt h prefix
| h::t -> gen_stmt h prefix ^ gen_stmt_list t prefix

and gen_expr_list expr_list prefix = match expr_list with
 [] -> ""
| h::[] -> prefix ^ gen_expr h prefix
| h::t -> prefix ^ gen_expr h prefix ^ ", " ^ gen_expr_list t prefix

let gen_time_block_header link =
  "unsigned int " ^ link ^ "_time = 0;\nstruct " ^ link ^
  "_link_ : public event_ {\n\tvirtual void set_next(" ^ link ^
  "_link_ *n){};\n};\nstd::vector<" ^ link ^ "_link_*> " ^ link ^ "_list;\n"

let rec gen_struct = function
  Time_struct(name, i, link, stmt_list) -> "struct " ^ gen_name name ^
    " : public " ^ gen_link link ^ "_link_ {\n\tunsigned int time;\n\t" ^
    gen_name name ^ "() : time(" ^ string_of_int i ^
    ") {}\n\tunsigned int get_time() {return time;}\n\t" ^ gen_link link ^
    "_link_ *next;\n\tvoid set_next(" ^ gen_link link ^
    "_link_ *n) {next = n;};\n\t" ^ "void foo() {\n" ^
    gen_stmt_list stmt_list (gen_link link) ^
    gen_link link ^ "_time += next->get_time();\n\t" ^
    "event_q.add(" ^ gen_link link ^ "_time, next);\n\t}\n};"

and gen_struct_list struct_list = match struct_list with
 [] -> ""
| h::[] -> gen_struct h ^ "\n"
| h::t -> gen_struct h ^ "\n" ^ gen_struct_list t

let rec gen_time_block (link, decl_list, struct_list) =
  (gen_decl_list decl_list link) ^ gen_time_block_header link ^
  gen_struct_list struct_list 

and gen_time_block_list = function
 [] -> ""
| h::[] -> gen_time_block h
| h::t -> gen_time_block h  ^ "\n" ^ gen_time_block_list t

let gen_struct_obj = function
  Time_struct_obj(name, link) -> gen_name name ^ " " ^ gen_name name ^ "obj;\n\t" ^
    gen_link link ^ "_list.push_back(&" ^ gen_name name ^ "obj;)\n\t"

let gen_init_linker = function
  Link(s) -> "for (int i = 0; i < " ^ s ^ "_list.size(); i++)\n\t" ^
    "{\n\t\tif (i != " ^ s ^ "_list.size()-1)\n\t\t\t" ^ 
    s ^ "_list[i]->set_next(" ^ s ^ "_list[i+1]);\n\t\telse\n\t\t\t" ^
    s ^ "_list[i]->set_next(NULL);\n\t}"

let gen_always_linker = function
  Link(s) -> "for (int i = 0; i < " ^ s ^ "_list.size(); i++)\n\t" ^
    "{\n\t\tif (i != " ^ s ^ "_list.size()-1)\n\t\t\t" ^ 
    s ^ "_list[i]->set_next(" ^ s ^ "_list[i+1]);\n\t\telse\n\t\t\t" ^
    s ^ "_list[i]->set_next(" ^ s ^ "_list[0]);\n\t}"

let rec gen_init_linker_list = function
 [] -> ""
| h::[] -> gen_init_linker h
| h::t -> gen_init_linker h ^ gen_init_linker_list t

let rec gen_always_linker_list = function
 [] -> ""
| h::[] -> gen_always_linker h
| h::t -> gen_always_linker h ^ gen_always_linker_list t

let rec gen_struct_obj_list = function
 [] -> ""
| h::[] -> gen_struct_obj h
| h::t -> gen_struct_obj h ^ gen_struct_obj_list t

(*all arguments are lists*)
let gen_main (time_block_obj_l, init_link_l, always_link_l) =
  gen_struct_obj_list time_block_obj_l ^ 
  gen_init_linker_list init_link_l ^
  gen_always_linker_list always_link_l

let gen_program (global_decl_list, global_func_list, time_block_list, main) =
  header ^
  gen_decl_list global_decl_list prefix_global_var ^
  gen_func_list global_func_list prefix_global_var ^
  gen_time_block_list time_block_list ^ "\nint main() {\n\t" ^
  gen_main main ^
  code_event_list_do ^ "return 0;\n}"
(*
let _ = 
  let target_code = gen_program pretty_c_ast in
  print_endline target_code
*)
(*let _ = print_endline (gen_time_block_header "always1")*)
