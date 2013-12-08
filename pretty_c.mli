open Ast

type name =
    Time_struct_name of string

type link =
    Link of string

type struct_obj =
    Time_struct_obj of name * link

type main = (*two link lists, init objects and always objects*)
    struct_obj list * link list * struct_obj list * link list

type structure =
    Time_struct of name * int * link * stmt list

type time_block =
    link * decl list * structure list (*struct list counts the number of blocks *)
                                      (*name = link append block # *)

type pretty_c =
    decl list * func_decl list * time_block list * main
