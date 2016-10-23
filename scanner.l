
/* Alfabeto */
UPPER			[A-Z]
LOWER			[a-z]
DIGIT    		[0-9]
SPECIAL			["/()=\[\]+*{},;.:\-_><]
NUMBER			{DIGIT}{DIGIT}*
CHAR			{UPPER}|{LOWER}

/* Tokens */
ID				{CHAR}({CHAR}|{DIGIT})*
LITERAL_INT		(\+|\-)?{NUMBER}*((e|E){NUMBER}*)?
LITERAL_REAL	(\+|\-)?{NUMBER}*(.{NUMBER}*)?((e|E){NUMBER}*)?
LITERAL_BOOL	"verdadero"|"falso"
LITERAL_CHAR	\"{CHAR}\"
LITERAL_STR		\'([^']|(\/'))*'
COMMENT			\{([^}]|(\/\}))*\}
RESERVED		"accion"|"algoritmo"|"booleano"|"cadena"|"caracter"|"const"|"continuar"|"de"|"dev"|"div"|"ent"|"entero"|"e/s"|"faccion"|"falgoritmo"|"falso"|"fconst"|"ffuncion"|"fmientras"|"fpara"|"fsi"|"ftipo"|"ftupla"|"funcion"|"fvar"|"hacer"|"hasta"|"mientras"|"mod"|"no"|"o"|"para"|"real"|"ref"|"sal"|"si"|"tabla"|"tipo"|"tupla"|"var"|"verdadero"|"y"
OPERATORS		":="|";"|","|".."|":"|"->"|"\[\]"|"="|"\["|"\]"

/* No hacen falta */
SPACE			[\ ]
HT		    	[\t]
NL		    	[\n]

%%

{COMMENT} {
	printf("COMMENT: %s\n", yytext);
}

{LITERAL_INT} {
	printf("LITERAL_INT: %s\n", yytext);
}

{LITERAL_REAL} {
	printf("LITERAL_REAL: %s\n", yytext);
}

{LITERAL_BOOL} {
	printf("LITERAL_BOOL: %s\n", yytext);
}

{LITERAL_CHAR} {
	printf("LITERAL_CHAR: %s\n", yytext);
}

{LITERAL_STR} {
	printf("LITERAL_STR: %s\n", yytext);
}

{RESERVED} {
	printf("RESERVED: %s\n", yytext);
}

{OPERATORS}	{
	printf("OPERATOR: %s\n", yytext);
}

{ID} {
	printf("ID: %s\n", yytext);
}

{UPPER} {
	printf("UPPERCASE: %s\n", yytext);
}

{LOWER}	{
	printf("LOWERCASE: %s\n", yytext);
}

{DIGIT} {
	printf("DIGIT: %s\n", yytext);
}

{SPECIAL} {
	printf("SPECIAL: %s\n", yytext);
}

{SPACE} {}

{HT} {}

{NL} {}

. {}

%%

int main( int argc, char **argv ) {
	++argv, --argc;
	yyin = (argc > 0) ? fopen(argv[0], "r") : stdin;
	yylex();
}
