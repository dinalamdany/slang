.PHONY : compile
compile:
	ocamllex scanner.mll
	ocamlyacc parser.mly
	ocamlc -c ast.mli
	ocamlc -c parser.mli
	ocamlc -c scanner.ml
	ocamlc -c parser.ml

.PHONY : clean
clean:
	rm parser.ml parser.mli scanner.ml *.cmo *.cmi 
