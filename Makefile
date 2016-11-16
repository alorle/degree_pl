scanner:
	flex -i --outfile=scanner.c scanner.l
	gcc scanner.c -o scanner -lfl

parser:
	bison parser.y
	gcc parser.tab.c -o parser

compiler:
	bison -d parser.y
	flex -i --outfile=scanner.c scanner.l
	gcc parser.tab.c scanner.c -lfl -o compiler

test-scanner: scanner
	./scanner scanner.input

test-parser: parser
	./parser

clean:
	rm -rf scanner scanner.c scanner.o parser parser.tab.c parser.tab.h compiler

all: scanner parser

test-all: test
