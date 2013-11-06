open Parser

type action =  Tester | Scanner | Ast

let _ =
	(* Read argument and assign to "action" *)
  let action = if Array.length Sys.argv > 1 then
    List.assoc Sys.argv.(1) [ ("-t", Tester);
                              ("-s", Scanner);
                              ("-a", Ast)
                            ]
	(* User "Tester" by default if no argument is provided *)
  else Tester in                             
	
  match action with
  	Tester -> 	  let lexbuf = Lexing.from_channel stdin in
				  let code = Parser.program Scanner.token lexbuf in
				  print_string "OK"
  | Scanner ->    let lexbuf = Lexing.from_channel stdin in
	              let rec loop token  =
	                (match token with
	                   | EOF -> []
	                   | _ as t -> t::loop (Scanner.token lexbuf)) in
	              let tokens = loop (Scanner.token lexbuf) in
	              let output = Scanner_tester.string_of_tokens tokens in
	              print_string output
  | Ast ->   	  let lexbuf = Lexing.from_channel stdin in
				  let abstract_syntax_tree = Parser.program Scanner.token lexbuf in
				  let output = Parser_tester.string_of_program abstract_syntax_tree in
				  print_string output