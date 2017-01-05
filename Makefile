PARSER_SRC = parser.y
PARSER_OUT = parser.tab.c
PARSER_OBJS = parser.tab.c parser.tab.h parser.output parser
PARSER_FLAGS = -d -v

SCANNER_SRC = scanner.l
SCANNER_OUT = scanner.c
SCANNER_OBJS = scanner.c scanner.o scanner
SCANNER_FLAGS = -i

LIBS = $(PARSER_OUT) $(SCANNER_OUT) sym_table.c quad_table.c bool_utils.c -lfl
OUT = compiler

all:    compiler
debug:  compiler

debug:  DEBUG=-DDEBUG

parser:
	bison $(PARSER_FLAGS) $(PARSER_SRC)

scanner:
	flex $(SCANNER_FLAGS) --outfile=$(SCANNER_OUT) $(SCANNER_SRC)

compiler: parser scanner
	gcc -o $(OUT) $(DEBUG) $(LIBS)

test1: compiler
	./$(OUT) program1.alg

test2: compiler
	./$(OUT) program2.alg

test3: compiler
	./$(OUT) program3.alg

clean:
	rm -rf $(SCANNER_OBJS) $(PARSER_OBJS) $(OUT)
