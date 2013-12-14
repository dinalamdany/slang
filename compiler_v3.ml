open Semantic_check
open Pretty_c_gen
open Gen_cpp

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Scanner.token lexbuf in
  let sast = Semantic_check.check_program ast in
  let c_sast = gen_pretty_c sast in
  let code = gen_program c_sast in
  let output = open_out "output.cpp" in
  output_string output code

(*
  let output = open_out "output.cpp" in
  output_string output code

let lexbuf = Lexing.from_channel stdin in\n
let program = Parser.program Scanner.token lexbuf in\n
let sast = Semantic_check.check_program program in\n
gen_pretty_c sast;;'*)
