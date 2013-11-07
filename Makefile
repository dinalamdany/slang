.PHONY : compile
compile:
	ocamllex scanner.mll
	ocamlyacc parser.mly
	ocamlc -c ast.mli
	ocamlc -c parser.mli
	ocamlc -c scanner.ml
	ocamlc -c parser.ml

#I'm narcissistic
TONYOBJS = parser.cmo scanner.cmo codegenloop.cmo codegen.cmo
TONYOBJS = parser.cmo scanner.cmo codegenloop.cmo
TESTEROBJS = parser.cmo scanner.cmo tester.cmo
codegenloop.cmo : codegenloop.ml
	ocamlc -c codegenloop.ml -o $@
codegenloop : $(TONYOBJS)
	ocamlc -o $@ $(TONYOBJS)
codegen.cmo: codegen.ml
	ocamlc -c codegen.ml -o $@
codegen: $(TONYOBJS)
	ocamlc -o $@ $(TONYOBJS)

#Tack on your own targets
all: compile codegenloop codegen
tester.cmo : tester.ml
	ocamlc -c tester.ml -o $@
tester : $(TESTEROBJS)
	ocamlc -o $@ $(TESTEROBJS)

#Tack on your own targets
.PHONY : all
all: compile codegenloop codegen

.PHONY : clean
clean:
	rm parser.ml codegenloop parser.mli scanner.ml *.cmo *.cmi codegen 
