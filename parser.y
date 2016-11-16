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
%token TOK_ID
%token TOK_LITERAL_INT
%token TOK_LITERAL_REAL
%token TOK_LITERAL_BOOL
%token TOK_LITERAL_CHAR
%token TOK_LITERAL_STR
%token TOK_COMMENT

/* Reserved words */
%token TOK_R_ACCION
%token TOK_R_ALGORITMO
%token TOK_R_BOOLEANO
%token TOK_R_CADENA
%token TOK_R_CARACTER
%token TOK_R_CONST
%token TOK_R_CONTINUAR
%token TOK_R_DE
%token TOK_R_DEV
%token TOK_R_DIV
%token TOK_R_ES
%token TOK_R_ENT
%token TOK_R_ENTERO
%token TOK_R_FACCION
%token TOK_R_FALGORITMO
%token TOK_R_FCONST
%token TOK_R_FFUNCION
%token TOK_R_FMIENTRAS
%token TOK_R_FPARA
%token TOK_R_FSI
%token TOK_R_FTIPO
%token TOK_R_FTUPLA
%token TOK_R_FUNCION
%token TOK_R_FVAR
%token TOK_R_HACER
%token TOK_R_HASTA
%token TOK_R_MIENTRAS
%token TOK_R_MOD
%token TOK_R_NO
%token TOK_R_O
%token TOK_R_PARA
%token TOK_R_REAL
%token TOK_R_REF
%token TOK_R_SAL
%token TOK_R_SI
%token TOK_R_TABLA
%token TOK_R_TIPO
%token TOK_R_TUPLA
%token TOK_R_VAR
%token TOK_R_Y

/* Operators */
%token TOK_OP_ASSIGNAMENT
%token TOK_OP_SEQU_COMPOS
%token TOK_OP_SEPARATOR
%token TOK_OP_SUBRANGE
%token TOK_OP_VAR_TYPE_DEF
%token TOK_OP_THEN
%token TOK_OP_ELSE_IF
%token TOK_OP_TYPE_DEFINITION
%token TOK_OP_ARRAY_INIT
%token TOK_OP_ARRAY_CLOSE

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