default: all

.PHONY : compile
compile:
	ocamlc -c type.mli
	ocamlc -c ast.mli
	ocamlyacc parser.mly
	ocamlc -c parser.mli
	ocamlc -c parser.ml
	ocamllex scanner.mll
	ocamlc -c scanner.ml
	ocamlc -c sast.mli
	ocamlc -c semantic_check.ml
	ocamlc -c pretty_c.mli
	ocamlc -c pretty_c_gen.ml
	ocamlc -c gen_cpp.ml
	ocamlc -c compiler.ml
	ocamlc -o compiler parser.cmo scanner.cmo semantic_check.cmo pretty_c_gen.cmo gen_cpp.cmo compiler.cmo
COMPILEROBJS = parser.cmo scanner.cmo semantic_check.cmo pretty_c_gen.cmo gen_cpp.cmo compiler.cmo

slang.cmo : slang.ml
	ocamlc -c $< -o $@
slang : $(COMPILEROBJS)
	ocamlc -o $@ $(COMPILEROBJS)
gen_cpp.cmo : gen_cpp.ml
	ocamlc -c $< -o $@
gen_cpp: $(COMPILEROBJS)
	ocamlc -o $@ $(COMPILEROBJS)
compiler.cmo : compiler.ml
	ocamlc -c $< -o $@
compiler: $(COMPILEROBJS)
	ocamlc -o $@ $(COMPILEROBJS)
pretty_c_gen.cmo : pretty_c_gen.ml
	ocamlc -c $< -o $@
pretty_c_gen: $(COMPILEROBJS)
	ocamlc -o $@ $(COMPILEROBJS)
semantic_check.cmo : semantic_check.ml
	ocamlc -c $< -o $@



#Tack on your own targets
.PHONY : all
all: compile 

.PHONY : clean
clean:
	rm -f parser.ml codegenloop parser.mli scanner.ml *.cmo *.cmi codegen slang compiler_v1 compiler_v2 pretty_c_gen gen_cpp compiler
