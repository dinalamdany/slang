open Ast 

type name =
    Init_name of string
    | Always_name of string 

type link = 
    Link of name

type main =
    name list * name list

type structure =
    Init of name * int * func_decl
    | Always of name * int * link * func_decl

type pretty_c = 
    decl list * func_decl list * structure list * main

  

