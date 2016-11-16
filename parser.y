%{
#include <stdio.h>

FILE *yyin;

void yyerror(char *s);
%}

%union {
	char character;
	char *string;
    int boolean;
	double real;
	long int integer;
};

/* Tokens */
%token TOK_ID TOK_LITERAL_INT TOK_LITERAL_REAL TOK_LITERAL_BOOL TOK_LITERAL_CHAR TOK_LITERAL_STR TOK_COMMENT

/* Reserved words */
%token TOK_R_ACCION TOK_R_ALGORITMO TOK_R_BOOLEANO TOK_R_CADENA TOK_R_CARACTER TOK_R_CONST TOK_R_CONTINUAR TOK_R_DE TOK_R_DEV TOK_R_DIV TOK_R_ES TOK_R_ENT TOK_R_ENTERO TOK_R_FACCION TOK_R_FALGORITMO TOK_R_FCONST TOK_R_FFUNCION TOK_R_FMIENTRAS TOK_R_FPARA TOK_R_FSI TOK_R_FTIPO TOK_R_FTUPLA TOK_R_FUNCION TOK_R_FVAR TOK_R_HACER TOK_R_HASTA TOK_R_MIENTRAS TOK_R_MOD TOK_R_NO TOK_R_O TOK_R_PARA TOK_R_REAL TOK_R_REF TOK_R_SAL TOK_R_SI TOK_R_TABLA TOK_R_TIPO TOK_R_TUPLA TOK_R_VAR TOK_R_Y

/* Operators */
%token TOK_OP_ASSIGNAMENT TOK_OP_SEQU_COMPOS TOK_OP_SEPARATOR TOK_OP_SUBRANGE TOK_OP_VAR_TYPE_DEF TOK_OP_THEN TOK_OP_ELSE_IF TOK_OP_TYPE_DEFINITION TOK_OP_ARRAY_INIT TOK_OP_ARRAY_CLOSE

%%

desc_algoritmo: TOK_R_ALGORITMO TOK_ID TOK_R_FALGORITMO {
	printf("ALGORITMO con nombre %s\n", yylval.string);
};

%%

int main(int argc, char **argv) {
	++argv, --argc;
	
	yyin = (argc > 0) ? fopen(argv[0], "r") : stdin;

	if (yyin == NULL) {
        printf("I can't input file!");
        return -1;
	}
	
    yyparse();
}

void yyerror(char *s) {
    printf("ERROR: %s\n", s);
}