open Ast
open Printf

let rec code_gen expr =
	match expr with
		Call(func_name, param_list) ->
			match func_name with
				"print" -> "cout<<("^(pull_params param_list)^");"
and pull_params = function
	param_list -> "("^(String.concat "," (List.map code_gen param_list))^")"
	
