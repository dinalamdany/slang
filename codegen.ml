open Ast
open Printf


let rec code_gen_expr expr =
	match expr with
		Call(func_name, param_list) ->
			match func_name with
				"print" -> "cout<<("^(pull_params param_list)^");"
and pull_params = function
	param_list -> "("^(String.concat "," (List.map code_gen param_list))^")"

let rec code_gen_stmt stmt=

let pull_decl_list param_list =
let pull_decl (expr, ID) = 
	expr^" "^id
in
String.concat","(List.map pull_decl_list param_list)

let pull_locals local_list=
let pull_decl(expr, ID) = 
	expr^" "^id
in
match param_list with
	| [] -> ""
	|_ ->(String.concat ";\n" (List.map pull_decl param_list))^";"

let code_gen_funcdecl func_decl=
let func_type = code_gen_expr(func_decl.func_type) in
let func_name = func_decl.func_name in
let formal_list = (pull_decl_list func_decl.formal_list) in
let locals = pull_locals func_decl.locals in
let body = String.concat "\n" (List.map code_gen_stmt func_decl.body) in
match func_name with
	"main" -> func_type^" "^func_name^" "^"("^formal_list^")\n{\n"^locals^"\n"^body^"\n}"


