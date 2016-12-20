%{
#include <string.h>
#include "parser.tab.h"

typedef int bool;
#define TRUE 1
#define FALSE 0
%}

/* Alphabet */
UPPER				[A-Z]
LOWER				[a-z]
DIGIT    			[0-9]
SPECIAL				["/()=\[\]+*{},;.:\-_><]
NUMBER				{DIGIT}{DIGIT}*
CHAR				{UPPER}|{LOWER}

/* Tokens */
ID					{CHAR}({CHAR}|{DIGIT})*
ID_BOOL				(b|B)({CHAR}|{DIGIT})*
LITERAL_INT			(\+|\-)?{NUMBER}*((e|E){NUMBER}*)?
LITERAL_REAL		(\+|\-)?{NUMBER}*(\.{NUMBER}*)?((e|E){NUMBER}*)?
LITERAL_BOOL		"verdadero"|"falso"
LITERAL_CHAR		\"{CHAR}\"
LITERAL_STR			\'([^']|(\/'))*'
COMMENT				\{([^}]|(\/\}))*\}

/* Reserved words */
R_ACCION			"accion"
R_ALGORITMO			"algoritmo"
R_BOOLEANO			"booleano"
R_CADENA			"cadena"
R_CARACTER			"caracter"
R_CONST				"const"
R_CONTINUAR			"continuar"
R_DE				"de"
R_DEV				"dev"
R_DIV				"div"
R_ES				"e/s"
R_ENT				"ent"
R_ENTERO			"entero"
R_FACCION			"faccion"
R_FALGORITMO		"falgoritmo"
R_FCONST			"fconst"
R_FFUNCION			"ffuncion"
R_FMIENTRAS			"fmientras"
R_FPARA 			"fpara"
R_FSI   			"fsi"
R_FTIPO 			"ftipo"
R_FTUPLA			"ftupla"
R_FUNCION			"funcion"
R_FVAR  			"fvar"
R_HACER 			"hacer"
R_HASTA 			"hasta"
R_MIENTRAS			"mientras"
R_MOD   			"mod"
R_NO				"no"
R_O					"o"
R_PARA				"para"
R_REAL				"real"
R_REF				"ref"
R_SAL				"sal"
R_SI				"si"
R_TABLA				"tabla"
R_TIPO				"tipo"
R_TUPLA				"tupla"
R_VAR				"var"
R_Y					"y"

/* Operators */
OP_ASSIGNAMENT		":="
OP_SEQU_COMPOS		";"
OP_SEPARATOR		","
OP_SUBRANGE			".."
OP_VAR_TYPE_DEF		":"
OP_THEN				"->"
OP_ELSE_IF			"\[\]"
OP_TYPE_DEFINITION	"="
OP_ARRAY_INIT		"\["
OP_ARRAY_CLOSE		"\]"
OP_DOT				"."
OP_REL				(<|>|=|<>|>=|<=)
OP_PAREN_OPEN		"("
OP_PAREN_CLOSE		")"
OP_PLUS				"+"
OP_MINUS			"-"
OP_TIMES			"*"
OP_DIVIDE			"/"

/* Ignored */
SEPARATOR		" "|\t|\n

%%

{COMMENT} {
	printf("COMMENT: %s\n", yytext);
	return TOK_COMMENT;
}

{OP_ASSIGNAMENT} {
	printf("OP asignación: %s\n", yytext);
	return TOK_OP_ASSIGNAMENT;
}

{OP_SEQU_COMPOS} {
	printf("OP composición secuencial: %s\n", yytext);
	return TOK_OP_SEQU_COMPOS;
}

{OP_SEPARATOR} {
	printf("OP separador: %s\n", yytext);
	return TOK_OP_SEPARATOR;
}

{OP_SUBRANGE} {
	printf("OP subrango: %s\n", yytext);
	return TOK_OP_SUBRANGE;
}

{OP_VAR_TYPE_DEF} {
	printf("OP definición de tipo de una variable: %s\n", yytext);
	return TOK_OP_VAR_TYPE_DEF;
}

{OP_THEN} {
	printf("OP entonces: %s\n", yytext);
	return TOK_OP_THEN;
}

{OP_ELSE_IF} {
	printf("OP si no si: %s\n", yytext);
	return TOK_OP_ELSE_IF;
}

{OP_TYPE_DEFINITION} {
	printf("OP creación de tipo: %s\n", yytext);
	return TOK_OP_TYPE_DEFINITION;
}

{OP_ARRAY_INIT} {
	printf("OP inicio de array: %s\n", yytext);
	return TOK_OP_ARRAY_INIT;
}

{OP_ARRAY_CLOSE} {
	printf("OP fin de array: %s\n", yytext);
	return TOK_OP_ARRAY_CLOSE;
}

{OP_DOT} {
	printf("OP punto: %s\n", yytext);
	return TOK_OP_DOT;
}

{OP_REL} {
	printf("OP relacional: %s\n", yytext);
	return TOK_OP_REL;
}

{OP_PAREN_OPEN} {
	printf("OP inicio de parentesis: %s\n", yytext);
	return TOK_OP_PAREN_OPEN;
}

{OP_PAREN_CLOSE} {
	printf("OP fin de parentesis: %s\n", yytext);
	return TOK_OP_PAREN_CLOSE;
}

{OP_PLUS} {
	printf("OP más: %s\n", yytext);
	return TOK_OP_PLUS;
}

{OP_MINUS} {
	printf("OP menos: %s\n", yytext);
	return TOK_OP_MINUS;
}

{OP_TIMES} {
	printf("OP multiplicación: %s\n", yytext);
	return TOK_OP_TIMES;
}

{OP_DIVIDE} {
	printf("OP división: %s\n", yytext);
	return TOK_OP_DIVIDE;
}

{LITERAL_INT} {
	int i;
	long int value = atoi(yytext);
	long int exponent = 0;

	for (i = 0; i < strlen(yytext); i++) {
		if (yytext[i] == 'e' || yytext[i] == 'E') {
			exponent = atoi(yytext+i+1);
			break;
		}
	}

	for (i = 0; i < exponent; i++) {
		value *= 10;
	}

	printf("LITERAL_INT: %ld\n", value);

	yylval.numero_entero = value;
	return TOK_LITERAL_INT;
}

{LITERAL_REAL} {
	double value = atof(yytext);
	printf("LITERAL_REAL: %f\n", value);
	
	yylval.numero_real = value;
	return TOK_LITERAL_REAL;
}

{LITERAL_BOOL} {
	bool value = FALSE;
	if (strcmp(yytext, "verdadero") == 0) {
		value = TRUE;
	}

	printf("LITERAL_BOOL: %s (%d)\n", yytext, value);
	
	yylval.booleano = value;
	return TOK_LITERAL_BOOL;
}

{LITERAL_CHAR} {
	char value = yytext[1];
	printf("LITERAL_CHAR: %c\n", value);
	
	yylval.caracter = value;
	return TOK_LITERAL_CHAR;
}

{LITERAL_STR} {
	char* value = yytext+1;
	value[strlen(value) - 1] = '\0';
	printf("LITERAL_STR: %s\n", value);
	
	yylval.cadena = value;
	return TOK_LITERAL_STR;
}

{R_ACCION} {
	printf("RESERVED: accion = %s\n", yytext);
	return TOK_R_ACCION;
}

{R_ALGORITMO} {
	printf("RESERVED: algoritmo = %s\n", yytext);
	return TOK_R_ALGORITMO;
}

{R_BOOLEANO} {
	printf("RESERVED: booleano = %s\n", yytext);
	return TOK_R_BOOLEANO;
}

{R_CADENA} {
	printf("RESERVED: cadena = %s\n", yytext);
	return TOK_R_CADENA;
}

{R_CARACTER} {
	printf("RESERVED: caracter = %s\n", yytext);
	return TOK_R_CARACTER;
}

{R_CONST} {
	printf("RESERVED: const = %s\n", yytext);
	return TOK_R_CONST;
}

{R_CONTINUAR} {
	printf("RESERVED: continuar = %s\n", yytext);
	return TOK_R_CONTINUAR;
}

{R_DE} {
	printf("RESERVED: de = %s\n", yytext);
	return TOK_R_DE;
}

R_DEV {
	printf("RESERVED: dev = %s\n", yytext);
	return TOK_R_DEV;
}

{R_DIV} {
	printf("RESERVED: div = %s\n", yytext);
	return TOK_R_DIV;
}

{R_ES} {
	printf("RESERVED: es = %s\n", yytext);
	return TOK_R_ES;
}

{R_ENT} {
	printf("RESERVED: ent = %s\n", yytext);
	return TOK_R_ENT;
}

{R_ENTERO} {
	printf("RESERVED: entero = %s\n", yytext);
	return TOK_R_ENTERO;
}

{R_FACCION} {
	printf("RESERVED: faccion = %s\n", yytext);
	return TOK_R_FACCION;
}

{R_FALGORITMO} {
	printf("RESERVED: falgoritmo = %s\n", yytext);
	return TOK_R_FALGORITMO;
}

{R_FCONST} {
	printf("RESERVED: fconst = %s\n", yytext);
	return TOK_R_FCONST;
}

{R_FFUNCION} {
	printf("RESERVED: ffuncion = %s\n", yytext);
	return TOK_R_FFUNCION;
}

{R_FMIENTRAS} {
	printf("RESERVED: fmientras = %s\n", yytext);
	return TOK_R_FMIENTRAS;
}

{R_FPARA} {
	printf("RESERVED: fpara = %s\n", yytext);
	return TOK_R_FPARA;
}

{R_FSI} {
	printf("RESERVED: fsi = %s\n", yytext);
	return TOK_R_FSI;
}

{R_FTIPO} {
	printf("RESERVED: ftipo = %s\n", yytext);
	return TOK_R_FTIPO;
}

{R_FTUPLA} {
	printf("RESERVED: ftupla = %s\n", yytext);
	return TOK_R_FTUPLA;
}

{R_FUNCION} {
	printf("RESERVED: funcion = %s\n", yytext);
	return TOK_R_FUNCION; 
}

{R_FVAR} {
	printf("RESERVED: fvar = %s\n", yytext); 
	return TOK_R_FVAR;
}

{R_HACER} {
	printf("RESERVED: hacer = %s\n", yytext); 
	return TOK_R_HACER;
}

{R_HASTA} {
	printf("RESERVED: hasta = %s\n", yytext); 
	return TOK_R_HASTA;
}

{R_MIENTRAS} {
	printf("RESERVED: mientras = %s\n", yytext); 
	return TOK_R_MIENTRAS;
}

{R_MOD} {
	printf("RESERVED: mod = %s\n", yytext); 
	return TOK_R_MOD;
}

{R_NO} {
	printf("RESERVED: no = %s\n", yytext); 
	return TOK_R_NO;
}

{R_O} {
	printf("RESERVED: o = %s\n", yytext); 
	return TOK_R_O;
}

{R_PARA} {
	printf("RESERVED: para = %s\n", yytext); 
	return TOK_R_PARA;
}

{R_REAL} {
	printf("RESERVED: real = %s\n", yytext); 
	return TOK_R_REAL;
}

{R_REF} {
	printf("RESERVED: ref = %s\n", yytext); 
	return TOK_R_REF;
}

{R_SAL} {
	printf("RESERVED: sal = %s\n", yytext); 
	return TOK_R_SAL;
}

{R_SI} {
	printf("RESERVED: si = %s\n", yytext); 
	return TOK_R_SI;
}

{R_TABLA} {
	printf("RESERVED: tabla = %s\n", yytext); 
	return TOK_R_TABLA;
}

{R_TIPO} {
	printf("RESERVED: tipo = %s\n", yytext);
	//TODO: ¿ como pasamos el tipo ?
	return TOK_R_TIPO;
}

{R_TUPLA} {
	printf("RESERVED: tupla = %s\n", yytext);
	return TOK_R_TUPLA;
}

{R_VAR} {
	printf("RESERVED: var = %s\n", yytext);
	return TOK_R_VAR;
}

{R_Y} {
	printf("RESERVED: y = %s\n", yytext);
	return TOK_R_Y;
}

{ID_BOOL} {
	printf("ID_BOOL: %s\n", yytext);
	yylval.cadena = (char *) malloc (sizeof(char) * strlen(yytext));
	strcpy(yylval.cadena, yytext);
	return TOK_ID_BOOL;
}

{ID} {
	printf("ID: %s\n", yytext);
	yylval.cadena = (char *) malloc (sizeof(char) * strlen(yytext));
	strcpy(yylval.cadena, yytext);
	return TOK_ID;
}

{SPECIAL} {
	printf("SPECIAL: %s\n", yytext);
}

. {
}

%%
