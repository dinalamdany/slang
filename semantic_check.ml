open Ast
open Sast
open Type

exception Error of string
(*NOTE: WILL END UP HAVING RECURSIVE ARRAYS AND THAT IS TERRIBLE --> add in a
 * check*)

(*a symbol table consisting of the parent as the variables*)
type symbol_table = {
	parent: symbol_table option;
	variables: (ident * datatype ) list
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

(* search for a function in our function table*)
let rec find_function (fun_scope: function_table) name = 
	List.find (fun (s,_,_,_) -> s=name) fun_scope.functions


(* check both sides of a binop are compatible *)
let check_binops op type1 type2 = match (op,type1,type2) with
	 (Or, Datatype(Int), Datatype(Int)) -> false
    | (And, Datatype(Int),Datatype(Int)) -> false
    | (_, Datatype(Int),Datatype(Int)) -> true
	|(Or, Datatype(Float), Datatype(Float)) -> false
	|(And, Datatype(Float), Datatype(Float)) -> false
	|(_, Datatype(Float), Datatype(Float)) -> true
	|(And, Datatype(Int), Datatype(Float)) -> false
	|(Or, Datatype(Int), Datatype(Float)) -> false
	|(_, Datatype(Int), Datatype(Float)) -> true
	|(And, Datatype(Float), Datatype(Int)) -> false
	|(Or, Datatype(Float), Datatype(Int)) -> false
	|(_, Datatype(Float), Datatype(Int)) -> true
	|(Equal, Datatype(Boolean), Datatype(Boolean)) ->true
	|(Neq, Datatype(Boolean), Datatype(Boolean)) ->true
	|(Or, Datatype(Boolean), Datatype(Boolean)) ->true
	|(And, Datatype(Boolean), Datatype(Boolean)) ->true
	|(_, Datatype(Boolean), Datatype(Boolean)) ->false
    |(Equal,Datatype(String),Datatype(String)) -> true
    | (Neq, Datatype(String),Datatype(String)) -> true
	|(_,_,_) -> false


let check_return_value op = match op with 
    Add -> Datatype(Float) (*fix this it's dumb, it sould do better matching *)
    | Sub -> Datatype(Float)
    | Mult -> Datatype(Float)
    | Div -> Datatype(Float)
    | Mod -> Datatype(Float)
    | _ -> Datatype(Boolean) 

(*extracts the type and name from a Formal declaration*)
let get_name_type_from_formal env = function
    Formal(datatype,ident) -> (ident,datatype)

    (*search for variable in global and local symbol tables*)
let find_variable env name =
	try List.find (fun (s,_) -> s=name) env.var_scope.variables
	with Not_found -> try List.find(fun (s,_) -> s=name) env.global_scope.variables
	with Not_found -> raise Not_found

(*Semantic checking on expressions*)
let rec check_expr env e = match e with
    IntLit(i) ->Datatype(Int)
    | BoolLit(b) -> Datatype(Boolean)
    | FloatLit(f) -> Datatype(Float)
    | StringLit(s) -> Datatype(String)
    | Variable(v) -> let (_,s_type) = try
        find_variable env v with Not_found ->
            raise (Error("Undeclared Identifier " )) in s_type
    | Unop(u, e) -> let t = check_expr env e in 
        (match u with
          Not -> if t = Datatype(Boolean) then t else raise (Error("Cannot negate a
         non-boolean value"))
        | _ -> if t = Datatype(Int) then t else if t = Datatype(Float) then t else
            raise (Error("Cannot perform operation on " )))
    | Binop(e1, b, e2) -> let t1 = check_expr env e1 and t2 = check_expr env e2 in if
        check_binops b t1 t2 then check_return_value b else raise(Error("Incompatible types with binary
        operator"));
    | ArrElem(id, index) -> Arraytype(Datatype(Int)) (*this is wrong *) 
    | Noexpr -> raise (Error ("Expression has no type"))
    | ExprAssign(id, e) -> let t1 = snd (find_variable env id) and t2 =
        check_expr env e 
        in (if not (t1 = t2) then (raise (Error("Mismatch in types for
        assignment")))); check_expr env e
    | Cast(ty, e) -> ty
    | Call(id, e) -> let (fname, fret, fargs, fbody) = try 
         find_function env.fun_scope id
           with Not_found ->
              raise (Error("Undeclared Function ")) in
                let el_tys = List.map (fun exp -> check_expr env exp) e in (*get list of types of the passed in args*)
                let fn_tys = List.map (fun farg-> snd get_name_type_from_formal env farg) fargs in
                (if not (el_tys = fn_tys) then
                    raise (Error("Mismatching types in function call")));
                    fret 

(*deal with arrays here*)
let get_typed_value env = function
   ExprVal(e) -> Expr(e, check_expr env e)  
   | ArrVal(e) -> Expr(e, check_expr env e)

let get_name_type_from_var env = function
    VarDecl(datatype,ident) -> (ident,datatype,None)
    | VarAssignDecl(datatype,ident,value) -> (ident,datatype, get_typed_value env value)
       
(*extracts the type from a datatype declaration*)
let rec get_type_from_datatype = function
	Datatype(t)->t
	|Arraytype(ty) ->Arraytype(get_type_from_datatype(ty))

(*extracts the stmt list from the event declaration*)
let rec get_stmts_from_event = function
	Event(i,stmts)->stmts

(*extracts event list from thread declaration*)
let rec get_events_from_thread = function
	Init(event) ->event
	|Always(event2) ->event2

(*function that adds variables to environment's var_scope for use in functions*)
let add_to_var_table env name t = 
	let new_vars = (name,t)::env.var_scope.variables in
	let new_sym_table = {parent = env.var_scope.parent; variables = new_vars} in
	let new_env = {env with var_scope = new_sym_table} in
	new_env

(*function that adds variables to environment's global_scope for use with main*)
let add_to_global_table env name t = 
	let new_vars = (name,t)::env.global_scope.variables in
	let new_sym_table = {parent=env.global_scope.parent; variables = new_vars} in
	let new_env = {env with global_scope = new_sym_table} in
	new_env

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
let add_var env var_declaration =
	let sym_table= match (env.location,var_declaration) with
		(main,VarDecl(t,name)) -> add_to_global_table env name t 
		|(main,VarAssignDecl(t,name,v)) -> add_to_global_table env name t 
		|(_,VarDecl(t,name)) -> add_to_var_table env name t 	
		|(_,VarAssignDecl(t,name,v)) -> add_to_var_table env name t in
		sym_table

(* checks the type of a variable in the symbol table*)
let check_var_type env v t =
	let(name,ty) = find_variable env v in
	if(t<>ty) then false else true

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
let initialize_globals (globals,env) variable_declaration = 
    match variable_declaration with
        VarDecl(datatype,ident) -> let (name,ty,_) = get_name_type_from_var env variable_declaration in
            let new_env = add_to_global_table env name ty in
            (SVarDecl(datatype,ident)::globals, new_env)
        | VarAssignDecl(datatype,ident, value) -> let (name,ty,value) =
            get_name_from_var env variable_declaration in
            let new_env = add_to_global_table env name ty in
            (SVarAssignDecl(datatype,ident,get_typed_value env
            value)::globals, new_env)

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
    (*This is not complete, have to do assignments and other things*)

(* Semantic checking on a function*)
let check_func env func_declaration =
	let new_locals = List.fold_left(fun a vs -> (get_name_type_from_formal env vs)::a)[] func_declaration.formals in
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
	    let (typed_globals, env) = List.fold_left(fun env globals-> initialize_globals (globals, env)) ([],empty_environment) globals in
	        let typed_functions = List.map(fun function_declaration -> check_func env function_declaration) env functions in
                let typed_threads = List.map(fun thread -> check_thread env
                thread) threads in
                    typed_functions, (typed_globals, typed_threads) temp_env
