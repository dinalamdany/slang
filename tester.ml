open Ast

let _ =
  let lexbuf = Lexing.from_channel (open_in Sys.argv.(1)) in
  let code = Parser.program Scanner.token lexbuf in
  Printf.printf "%s	OK\n" Sys.argv.(1)
