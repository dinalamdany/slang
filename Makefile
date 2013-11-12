default: all

.PHONY : compile
compile:
	ocamllex scanner.mll
	ocamlyacc parser.mly
	ocamlc -c ast.mli
	ocamlc -c parser.mli
	ocamlc -c scanner.ml
	ocamlc -c parser.ml

#OBJECTS
#I'm narcissistic
TONYOBJS = parser.cmo scanner.cmo codegenloop.cmo
CODEGENOBJS = parser.cmo scanner.cmo codegen.cmo
TESTEROBJS = parser.cmo scanner.cmo tester.cmo

codegenloop.cmo : codegenloop.ml
	ocamlc -c codegenloop.ml -o $@
codegenloop : $(TONYOBJS)
	ocamlc -o $@ $(TONYOBJS)
tester.cmo : tester.ml
	ocamlc -c tester.ml -o $@
tester : $(TESTEROBJS)
	ocamlc -o $@ $(TESTEROBJS)

#Tack on your own targets
.PHONY : all
all: compile codegenloop

.PHONY : clean
clean:
	rm -f parser.ml codegenloop parser.mli scanner.ml *.cmo *.cmi codegen 
