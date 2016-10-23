scanner:
	flex --outfile=scanner.c scanner.l
	gcc scanner.c -o scanner -lfl

test: scanner
	./scanner scanner.input

clean:
	rm -rf scanner scanner.c 

all: scanner

test-all: test
