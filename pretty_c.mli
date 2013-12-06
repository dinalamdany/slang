open Ast 

type name =
    Init_name of string
    | Always_name of string

type link =
    Link of string
        
type struct_obj=
    Init_obj of name
    | Always_obj of name * link 

type main =
    struct_obj list * struct_obj list * link list

type structure =
    Init of name * int * stmt list
    | Always of name * int * link * stmt list

type time_block =
    link * decl list * structure list

 type pretty_c =
    decl list * func_decl list * time_block list * main


