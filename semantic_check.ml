open Ast
open Sast
open Type

exception Error of string

(*extracts the type and name from a Formal declaration*)
let get_name_type_from_var = function
	Formal(datatype,ident) -> (ident, datatype,false)
(*write a similar function that matches var and varassigns to name, type, and what is on the right*)

(*extracts the type from a datatype declaration*)
let rec get_type_from_datatype = function
	Datatype(t)->t
	|Arraytype(ty) ->get_type_from_datatype(ty)

(*extracts the stmt list from the event declaration*)
let rec get_stmts_from_event = function
	Event(i,stmts)->stmts

(*extracts event list from thread declaration*)
let rec get_events_from_thread = function
	Init(event) ->event
	|Always(event2) ->event2

(*a symbol table consisting of the parent as the variables*)
type symbol_table = {
	parent: symbol_table option;
	variables: (ident * datatype * bool) list
}

(*a function table containing function definitions*)
type function_table = {
	functions: (ident * var_type*formal list * stmt list) list
}

(*our environment*)
type translation_environment = {
	return_type: var_type;	(*function's return type*)
	return_seen: bool;		(*does the function have a return statement*)
	location: string;		(*init, always, main, or function name, used for global or local checking*)
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
	let func_type=get_type_from_datatype func_declaration.return in
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

(* Checks that a function returned if it was supposed to*)
let check_final_env env =
	(if(false = env.return_seen && env.return_type <> Void) then
		raise (Error("Missing Return Statement")));
	true

(* Default Table and Environment Initializations *)
let empty_table_initialization = {parent=None; variables =[]}
let empty_function_table_initialization = {functions=[]}
let empty_environment = {return_type = Void; return_seen = false; location="main"; global_scope = empty_table_initialization; var_scope = empty_table_initialization; fun_scope = empty_function_table_initialization}

(*Add functions to the environment *)
let initialize_functions env function_declaration = 
	let new_env = add_function env function_declaration in
	new_env

(* Add global variables to the environment *)
let initialize_globals env variable_declaration = 
	let (n,t,b) = get_name_type_from_var variable_declaration in
	check_types t   
	let new_env = add_to_global_table env n t b in
	new_env

(*Semantic checking on expressions*)
let rec check_expr env e = match e with
	|IntLit(i) ->Datatype(Int)

(*converts expr to sexpr*)
let rec retrieve_sexpr env e =
	let type1= check_expr env e in
	Expr(e,type1)

(*Semantic checking on a stmt*)
let rec check_stmt env stmt = match stmt with
	|Block(stmt_list) ->
		let new_var_scope = {parent=Some(env.var_scope);variables=[]} in
		let new_env = {env with var_scope=new_var_scope} in
		let getter(env,acc) s =
			let (st, ne) = check_stmt env s in
			(ne, st::acc) in
		let (ls,st) = List.fold_left(fun e s -> getter e s) (new_env,[]) stmt_list in
		let revst = List.rev st in
		(SBlock(revst),ls)
	|Expr(e) ->
		let _ = check_expr env e in
		(SExpr(retrieve_sexpr env e),env)
	|Return(e) ->
		let type1=check_expr env e in
		(if not(type1=Datatype(env.return_type)) then
			raise (Error("Incompatible Return Type")));
		let new_env = {env with return_seen=true} in
		(SReturn(retrieve_sexpr env e),new_env)
	|If(e,s1,s2)->
		let t=get_type_from_datatype(check_expr env e) in
		(if not (t=Boolean) then
			raise (Error("If predicate must be a boolean")));
		let (st1,new_env1)=check_stmt env s1
		and (st2, new_env2)=check_stmt env s2 in
		let ret_seen=(new_env1.return_seen&&new_env2.return_seen) in
		let new_env = {env with return_seen=ret_seen} in
		(SIf((retrieve_sexpr env e),st1,st2),new_env)
	|For(e1,e2,e3,s) ->
		let t1=get_type_from_datatype(check_expr env e1)
		and t2= get_type_from_datatype(check_expr env e2)
		and t3=get_type_from_datatype(check_expr env e3) in
		(if not (t1=Int && t3=Int && t2=Boolean) then
			raise (Error("Improper For loop format")));
		let(st,new_env)=check_stmt env s in
		(SFor((retrieve_sexpr env e1),(retrieve_sexpr env e2), (retrieve_sexpr env e3), st),new_env)
	|While(e,s) ->
		let t=get_type_from_datatype(check_expr env e) in
		(if not(t=Boolean) then
			raise (Error("Improper While loop format")));
		let (st, new_env)=check_stmt env s in
		(SWhile((retrieve_sexpr env e), st),new_env)

(* Semantic checking on a function*)
let check_func env func_declaration =
	let new_locals = List.fold_left(fun a vs -> (get_name_type_from_var vs)::a)[] func_declaration.formals in
	let new_var_scope = {parent=Some(env.var_scope); variables = new_locals} in
	let new_env = {return_type = get_type_from_datatype func_declaration.return; return_seen=false; location="in_func"; global_scope = env.global_scope; var_scope = new_var_scope; fun_scope = env.fun_scope} in
	let final_env  =List.fold_left(fun env stmt -> snd (check_stmt env stmt)) new_env func_declaration.body in
	let _=check_final_env final_env in
	let sfuncdecl = ({return = func_declaration.return; fname = func_declaration.fname; formals = func_declaration.formals; body = func_declaration.body}) in
	Func_Decl(sfuncdecl,func_declaration.return)

(*Semantic checking on events *)
let check_event env event_declaration = 
	let statements = get_stmts_from_event event_declaration in
	let final_env = List.fold_left(fun env stmt -> snd(check_stmt env stmt)) env statements
	in final_env

(* Semantic checking on threads*)
let check_thread env thread_declaration =
	let events = get_events_from_thread thread_declaration in
	let final_env = List.fold_left(fun env event -> check_event env event) env events in
	final_env

(*Semantic checking on a program*)
let check_program program =
	let (functions,( globals, threads)) = program in
	let env=List.fold_left(fun env globals -> initialize_globals env globals) empty_environment functions in
	let temp_env = List.map(fun function_declaration -> check_func env function_declaration) functions in
	temp_env		
