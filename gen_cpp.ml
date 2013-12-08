open Ast
open Printf
open Pretty_c
open Type

let print = "print"
let prefix_global_var = "u_"
(*let prefix_array_temp = "a_"*)
let prefix_event = "event_"
let prefix_event_list = "event_q_"
(*let prefix_always = "always"^string_of_int always_counter)^"_"
let prefix_always_block = prefix_always^"block"^(string_of_int always_block_counter)^"_"
let prefix_init = "init"^(string_of_int init_counter)^"_"
let prefix_init_block = prefix_init^"block"^(string_of_int init_block_counter)^"_"*)
let code_event_base = "struct "^prefix_event^
  " {\n\tunsigned int time;\n\tvirtual unsigned int get_time(){};\n\tvirtual void foo(){};\n\tvirtual ~"^
  prefix_event^"(){};\n};\n"
let code_event_list = "struct "^
  prefix_event_list^" {\n\tbool empty(){return event_q.empty();}\n\t"^prefix_event^
  "* pop() {\n\t\t"^prefix_event^" *front = event_q.front();\n\t\tevent_q.pop_front();\n\t\treturn front;\n\t}\n\tvoid add(unsigned int time_, "^
  prefix_event^
  " *obj_) {\n\t\tbool eol = true;\n\t\tstd::deque<"^prefix_event^
  "*>::iterator it;\n\t\tif (obj_ == NULL)\n\t\t\treturn;\n\t\tfor (it = event_q.begin(); it != event_q.end(); it++) {\n\t\t\tif ((*it)->get_time() > time_) {\n\t\t\t\tevent_q.insert(it, obj_);\n\t\t\t\teol = false;\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t\tif (eol) {\n\t\t\tevent_q.push_back(obj_);\n\t\t}\n\t}\n\tprivate:\n\t\tstd::deque<"^
  prefix_event^"*> event_q;\n};\n"^prefix_event_list^" event_q;"
let code_directives = "#include <iostream>\n#include <string>\n#include <deque>\n#include <vector>\n#include <cstdlib>\n"
let code_event_list_do = "while(!event_q.empty()) {\n\tevent_q.pop()->foo();\n}\n"
let header = code_directives^code_event_base^code_event_list
(*let _ = print_endline header*)

let gen_id = function
  Ident(id) -> id

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

let rec gen_expr expr prefix = match expr with
  IntLit(i) -> string_of_int i
| BoolLit(b) -> string_of_bool b
| FloatLit(f) -> string_of_float f
| StringLit(s) -> "\"" ^ s ^ "\""
| Variable(ident) -> prefix ^ gen_id ident
| Unop(unop, expr) -> gen_unop unop ^ "(" ^ gen_expr expr prefix ^ ")"
| Binop(expr1, binop, expr2) -> gen_expr expr1 prefix ^ gen_binop binop ^ gen_expr expr2 prefix
| Noexpr -> ""
| ArrElem(ident, i) -> prefix ^ gen_id ident ^ "[" ^ string_of_int i ^ "]"
| ExprAssign(ident, expr) -> prefix ^ gen_id ident ^ " = " ^ gen_expr expr prefix
| Cast(datatype, expr) -> "(" ^ gen_datatype datatype^ ") " ^ gen_expr expr prefix
| Call(ident, expr_list) -> if ((gen_id ident) = print)
        then "std::cout << "^ gen_expr_list expr_list prefix ^ "std::endl"
        else prefix ^ gen_id ident ^ "(" ^ gen_expr_list expr_list prefix ^ ");"

and gen_expr_list expr_list prefix = match expr_list with
 [] -> ""
| h::[] -> prefix ^ gen_expr h prefix
| h::t -> prefix ^ gen_expr h prefix ^ ", " ^ gen_expr_list t prefix

let rec gen_array_expr_list expr_list ident prefix = match expr_list with
 [] -> ""
| h::[] -> prefix ^ gen_id ident ^ ".push_back(" ^ gen_expr h prefix ^");\n"
| h::t -> prefix ^ gen_id ident ^ ".push_back(" ^ gen_expr h prefix
  ^ ");\n" ^ (gen_array_expr_list t ident prefix)

let gen_value value ident prefix = match value with
  ExprVal(expr) -> " = " ^ gen_expr expr prefix ^ ";\n"
| ArrVal(expr_list) -> ";\n" ^ (gen_array_expr_list expr_list ident prefix)


let rec gen_decl decl prefix = match decl with
  VarDecl(datatype, id) -> gen_datatype datatype ^ " " ^ prefix ^ gen_id id  ^ ";\n"
| VarAssignDecl(datatype, ident, value) -> 
    gen_datatype datatype ^ " " ^ prefix ^ gen_id ident ^ (gen_value value ident prefix)

let rec gen_decl_list decl_list prefix = match decl_list with
 [] -> ""
| h::[] -> gen_decl h prefix
| h::t -> (gen_decl h prefix)^(gen_decl_list t prefix)

let gen_program (global_decl_list, global_func_list, time_block_list, main) =
  header^
  gen_decl_list global_decl_list prefix_global_var
  (*^
  String.concat "" (List.map gen_global_decl global_decl_list)^
  String.concat "" (List.map gen_global_func global_func_list)^
  String.concat "" (List.map gen_time_block time_block_list)^
  gen_main main*)
let pretty_c_ast = ([], [], [], []) (*dummy object, replace with real pretty_c ast*)
let _ = 
  let target_code = gen_program pretty_c_ast in
  print_endline target_code
