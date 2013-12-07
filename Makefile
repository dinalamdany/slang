default: all

.PHONY : compile
compile:
	ocamllex scanner.mll
	ocamlc -c type.mli
	ocamlyacc parser.mly
	ocamlc -c ast.mli
	ocamlc -c pretty_c.mli
	ocamlc -c parser.mli
	ocamlc -c scanner.ml
	ocamlc -c parser.ml
	ocamlc -c sast.mli
	ocamlc -c pretty_c.mli
	ocamlc -c pretty_c_gen.ml
	ocamlc -c semantic_check.ml

#OBJECTS
#I'm narcissistic
TONYOBJS = parser.cmo scanner.cmo codegenloop.cmo
CODEGENOBJS = parser.cmo scanner.cmo codegen.cmo
SLANGOBJS = parser.cmo scanner.cmo scanner_tester.cmo parser_tester.cmo slang.cmo
COMP1OBJS = parser.cmo scanner.cmo compiler_v1.cmo
COMP2OBJS = parser.cmo scanner.cmo compiler_v2.cmo
GENCPPOBJS = parser.cmo scanner.cmo gen_cpp.cmo
TESTEROBJS = parser.cmo scanner.cmo tester.cmo
PCGOBJS = parser.cmo scanner.cmo pretty_c_gen.cmo

scanner_tester.cmo : scanner_tester.ml
	ocamlc -c $< -o $@
parser_tester.cmo : parser_tester.ml
	ocamlc -c $< -o $@
codegenloop.cmo : codegenloop.ml
	ocamlc -c $< -o $@
codegenloop : $(TONYOBJS)
	ocamlc -o $@ $(TONYOBJS)
slang.cmo : slang.ml
	ocamlc -c $< -o $@
slang : $(SLANGOBJS)
	ocamlc -o $@ $(SLANGOBJS)
gen_cpp.cmo : gen_cpp.ml
	ocamlc -c $< -o $@
gen_cpp: $(GENCPPOBJS)
	ocamlc -o $@ $(GENCPPOBJS)
compiler_v2.cmo : compiler_v2.ml
	ocamlc -c $< -o $@
compiler_v2: $(COMP2OBJS)
	ocamlc -o $@ $(COMP2OBJS)
compiler_v1.cmo : compiler_v1.ml
	ocamlc -c $< -o $@
compiler_v1: $(COMP1OBJS)
	ocamlc -o $@ $(COMP1OBJS)
tester.cmo : tester.ml
	ocamlc -c tester.ml -o $@
tester : $(TESTEROBJS)
	ocamlc -o $@ $(TESTEROBJS)
pretty_c_gen.cmo : pretty_c_gen.ml
	ocamlc -c $< -o $@
pretty_c_gen: $(PCGOBJS)
	ocamlc -o $@ $(PCGOBJS)



#Tack on your own targets
.PHONY : all
all: compile 

.PHONY : clean
clean:
	rm -f parser.ml codegenloop parser.mli scanner.ml *.cmo *.cmi codegen slang compiler_v1 compiler_v2 pretty_c_gen
