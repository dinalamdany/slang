default: all

.PHONY : compile
compile:
	ocamllex scanner.mll
	ocamlyacc parser.mly
	ocamlc -c ast.mli
	ocamlc -c parser.mli
	ocamlc -c scanner.ml
	ocamlc -c parser.ml
	ocamlc -c sast.mli

#OBJECTS
#I'm narcissistic
TONYOBJS = parser.cmo scanner.cmo codegenloop.cmo
CODEGENOBJS = parser.cmo scanner.cmo codegen.cmo
TESTEROBJS = parser.cmo scanner.cmo tester.cmo
COMP1OBJS = parser.cmo scanner.cmo compiler_v1.cmo

codegenloop.cmo : codegenloop.ml
	ocamlc -c $< -o $@
codegenloop : $(TONYOBJS)
	ocamlc -o $@ $(TONYOBJS)
tester.cmo : tester.ml
	ocamlc -c $< -o $@
tester : $(TESTEROBJS)
	ocamlc -o $@ $(TESTEROBJS)
compiler_v1.cmo : compiler_v1.ml
	ocamlc -c $< -o $@
compiler_v1: $(COMP1OBJS)
	ocamlc -o $@ $(COMP1OBJS)

#Tack on your own targets
.PHONY : all
all: compile codegenloop

.PHONY : clean
clean:
	rm -f parser.ml codegenloop parser.mli scanner.ml *.cmo *.cmi codegen 
