.PHONY : compile
compile:
	ocamllex scanner.mll
	ocamlyacc parser.mly
	ocamlc -c ast.mli
	ocamlc -c parser.mli
	ocamlc -c scanner.ml
	ocamlc -c parser.ml

#I'm narcissistic
TONYOBJS = parser.cmo scanner.cmo codegenloop.cmo
codegenloop.cmo : codegenloop.ml
	ocamlc -c codegenloop.ml -o $@
codegenloop : $(TONYOBJS)
	ocamlc -o $@ $(TONYOBJS)

#Tack on your own targets
all: compile codegenloop

.PHONY : clean
clean:
	rm parser.ml codegenloop parser.mli scanner.ml *.cmo *.cmi 
