open Ast
open Sast
open Type

type symbol_table = {
	parent: symbol_table option;
	variables: (ident * datatype * bool) list
}

type function_table = {
	functions: (ident * datatype*formal list * stmt list) list
}

type translation_environment = {
	return_type: datatype;	(*function's return type*)
	return_seen: bool;		(*does the function have a return statement*)
	location: string;		(*init, always, main, or function name*)
	global_scope: symbol_table;	(*symbol table for global vairables*)
	var_scope: symbol_table; 	(*symbol table for local variables*)
	fun_scope: function_table;	(*symbol table for functions*)
}

(*function that adds variables to environment's var_scope for use in functions*)
let add_to_var_table env name t is_array = 
	let new_vars = (name,t,is_array)::env.var_scope.variables in
	let new_sym_table = {parent = env.var_scope.parent; variables = new_vars} in
	let new_env = {env with var_scope = new_sym_table} in
	new_env

(*function that adds variables to environment's global_scope for use with main*)
let add_to_global_table env name t is_array= 
	let new_vars = (name,t,is_array)::env.global_scope.variables in
	let new_sym_table = {parent=env.global_scope.parent; variables = new_vars} in
	let new_env = {env with global_scope = new_sym_table} in
	new_env

(*search for variable in global and local symbol tables*)
let find_variable env name =
	try List.find (fun (s,_,_) -> s=name) env.var_scope.variables
	with Not_found -> try List.find(fun (s,_,_) -> s=name) env.global_scope.variables
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
	|(_,_) -> false

(* check both sides of an assignment are compatible*) 
let check_assignments type1 type2 = match (type1, type2) with
	(Int, Int) -> true
	|(Float, Float) -> true
	|(Int, Float) -> true
	|(Float, Int) -> true
	|(Boolean, Boolean) -> true
	|(String, String) -> true
	|(Object, Object) -> true
	|(_,_) -> false

(* add a function to the environment*)
let add_function env func_declaration =
	let f_table = env.fun_scope in
	let old_functions = f_table.functions in
	let func_name=func_declaration.fname in
	let func_type=func_declaration.return in
	let func_formals=func_declaration.formals in
	let func_body=func_declaration.body in
	let new_functions = (func_name, func_type, func_formals, func_body)::old_functions in
	let new_fun_scope = {functions = new_functions} in
	let new_env = {env with fun_scope = new_fun_scope} in
	new_env

(* add a value to the symbol table*)
let add_var env var_declaration is_array=
	let sym_table= match (env.location,var_declaration) with
		(main,VarDecl(t,name)) -> add_to_global_table env name t is_array 
		|(main,VarAssignDecl(t,name,v)) -> add_to_global_table env name t is_array 
		|(_,VarDecl(t,name)) -> add_to_var_table env name t is_array 	
		|(_,VarAssignDecl(t,name,v)) -> add_to_var_table env name t is_array in
		sym_table

(* checks the type of a variable in the symbol table*)
let check_var_type env v t is_array=
	let(name,ty,t_is_array) = find_variable env v in
	if(t<>ty) then false else if (is_array<>t_is_array) then false else true

let get_name_type_from_var vs = 
	let (t, n) = vs in (t, n) 

(* Semantic checking on a function *)
let check_funcs env func_declaration =
	let env = add_function env func_declaration in
	let new_locals = List.fold_left (fun a vs -> (get_name_type_from_var vs)::a) [] func_declaration.formals in
	let new_var_scope = {parent = Some(env.var_scope); variables = new_variables} in
	let new_env = {return_type = func_declaration.return; return_seen = false; location = func_declaration.fname; global_scope = env.global_scope; var_scope = new_var_scope; fun_scope = env.fun_scope} in
	let (stbody, final_env) = get_env_for_stmt new_env function_declaration.body in
	let _ = check_final_env final_env in
	let sfuncdecl = ({ return = function_declaration.return_type; fname = function_declaration.fname; formals = function_declaration.formals; body = func_declaration.body }, func_declaration.return_type) in
	Func_Decl(sfuncdecl)