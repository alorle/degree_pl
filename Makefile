scanner:
	flex -i --outfile=scanner.c scanner.l

parser:
	bison -d -v parser.y

compiler: parser scanner
	gcc parser.tab.c scanner.c SymTable.c quad_table.c -lfl -o compiler

test1: compiler
	./compiler program1.alg

test2: compiler
	./compiler program2.alg

test3: compiler
	./compiler program3.alg

clean:
	rm -rf scanner scanner.c scanner.o parser parser.tab.c parser.tab.h parser.output compiler
