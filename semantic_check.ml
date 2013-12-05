open Ast
open Sast
open Type

type symbol_table = {
	parent: symbol_table option;
	variables: (string * Type.var_type) list
}

type function_table = {
	functions: (Type.var_type * string * Type.var_type list * stmt list) list
}

type translation_environment = {
	return_type: var_type;	(*function's return type*)
	return_seen: bool;		(*does the function have a return statement*)
	global_scope: symbol_table;	(*symbol table for global vairables*)
	var_scope: symbol_table; 	(*symbol table for local variables*)
	fun_scope: function_table;	(*symbol table for functions*)
}

(*function that adds variables to environment's var_scope for use in functions*)
let add_to_var_table env name t = 
	let new_vars = (s,t)::env.var_scope.variables in
	let new_sym_table = {parent = env.var_scope.parent; variables = new_vars} in
	let new_env = {env with var_scope = new_sym_table} in
	new_env

(*function that adds variables to environment's global_scope for use with main*)
let add_to_global_table env name t = 
	let new_vars = (s,t)::env.global_scope.variables in
	let new_sym_table = {parent=env.global_scope.parent; variables = new_vars} in
	let new_env = {env with global_scope = new_sym_table} in
	new_env

(*search for variable in global and local symbol tables*)
let find_variable env name =
	try List.find (fun (s,_,_,_) -> s=name) env.var_scope.variables
	with Not_found -> try List.find(fun (s,_,_,_) -> s=name) env.global_scope.variables
	with Not_found -> raise Not_found

(* search for a function in our function table*)
let rec find_function (fun_scope: function_table) name = 
	List.find (fun (s,_,_,_) -> s=name) fun_scope.functions

(* check both sides of a binop are compatible*)
let check_binops type1 type2 = match (type1,type2) with
	 (Int, Int) -> true
	|(Float, Float) -> true
	|(Int, Float) -> true
	|(Float, Int) -> true
	|(Boolean, Boolean) ->true
	|_ -> false

(* check both sides of an assignment are compatible*) 
let check_assignments type1 typ2 = match (type1, type2) with
	(Int, Int) -> true
	|(Float, Float) -> true
	|(Int, Float) -> true
	|(Float, Int) -> true
	|(Boolean, Boolean) -> true
	|(String, String) -> true
	|(Object, Object) -> true

(* add a function to the environment*)
let add_function env func_declaration =
	let f_table = env.fun_scope in
	let old_functions = f_table.functions
	let func_type=func_decl.  
