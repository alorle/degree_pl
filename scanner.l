%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include "structs.h"
#include "sym_table.h"
#include "quad_table.h"
#include "parser.tab.h"

void scanner_msg(const char *, ...);
%}

/* Alphabet */
UPPER               [A-Z]
LOWER               [a-z]
DIGIT               [0-9]
SPECIAL             ["/()=\[\]+*{},;.:\-_><]
NUMBER              {DIGIT}{DIGIT}*
CHAR                {UPPER}|{LOWER}

/* Tokens */
ID                  {CHAR}({CHAR}|{DIGIT})*
ID_BOOL             (b|B)({CHAR}|{DIGIT})*
LITERAL_INT         (\+|\-)?{NUMBER}*((e|E){NUMBER}*)?
LITERAL_REAL        (\+|\-)?{NUMBER}*(\.{NUMBER}*)?((e|E){NUMBER}*)?
LITERAL_BOOL        "verdadero"|"falso"
LITERAL_CHAR        \"{CHAR}\"
LITERAL_STR         \'([^']|(\/'))*'
COMMENT             \{([^}]|(\/\}))*\}

/* Reserved words */
R_ACCION            "accion"
R_ALGORITMO         "algoritmo"
R_BOOLEANO          "booleano"
R_CADENA            "cadena"
R_CARACTER          "caracter"
R_CONST             "const"
R_CONTINUAR         "continuar"
R_DE                "de"
R_DEV               "dev"
R_DIV               "div"
R_ES                "e/s"
R_ENT               "ent"
R_ENTERO            "entero"
R_FACCION           "faccion"
R_FALGORITMO        "falgoritmo"
R_FCONST            "fconst"
R_FFUNCION          "ffuncion"
R_FMIENTRAS         "fmientras"
R_FPARA             "fpara"
R_FSI               "fsi"
R_FTIPO             "ftipo"
R_FTUPLA            "ftupla"
R_FUNCION           "funcion"
R_FVAR              "fvar"
R_HACER             "hacer"
R_HASTA             "hasta"
R_MIENTRAS          "mientras"
R_MOD               "mod"
R_NO                "no"
R_O                 "o"
R_PARA              "para"
R_REAL              "real"
R_REF               "ref"
R_SAL               "sal"
R_SI                "si"
R_TABLA             "tabla"
R_TIPO              "tipo"
R_TUPLA             "tupla"
R_VAR               "var"
R_Y                 "y"

/* Operators */
OP_ASSIGNAMENT      ":="
OP_SEQU_COMPOS      ";"
OP_SEPARATOR        ","
OP_SUBRANGE         ".."
OP_VAR_TYPE_DEF     ":"
OP_THEN             "->"
OP_ELSE_IF          "\[\]"
OP_TYPE_DEFINITION  "="
OP_ARRAY_INIT       "\["
OP_ARRAY_CLOSE      "\]"
OP_DOT              "."
OP_REL              (<|>|=|<>|>=|<=)
OP_PAREN_OPEN       "("
OP_PAREN_CLOSE      ")"
OP_PLUS             "+"
OP_MINUS            "-"
OP_TIMES            "*"
OP_DIVIDE           "/"

/* Ignored */
SEPARATOR           " "|\t|\n

%option yylineno

%%

{COMMENT} {
    scanner_msg("COMMENT: %s", yytext);
    return TOK_COMMENT;
}

{OP_ASSIGNAMENT} {
    scanner_msg("OP asignación: %s", yytext);
    return TOK_OP_ASSIGNAMENT;
}

{OP_SEQU_COMPOS} {
    scanner_msg("OP composición secuencial: %s", yytext);
    return TOK_OP_SEQU_COMPOS;
}

{OP_SEPARATOR} {
    scanner_msg("OP separador: %s", yytext);
    return TOK_OP_SEPARATOR;
}

{OP_SUBRANGE} {
    scanner_msg("OP subrango: %s", yytext);
    return TOK_OP_SUBRANGE;
}

{OP_VAR_TYPE_DEF} {
    scanner_msg("OP definición de tipo de una variable: %s", yytext);
    return TOK_OP_VAR_TYPE_DEF;
}

{OP_THEN} {
    scanner_msg("OP entonces: %s", yytext);
    return TOK_OP_THEN;
}

{OP_ELSE_IF} {
    scanner_msg("OP si no si: %s", yytext);
    return TOK_OP_ELSE_IF;
}

{OP_TYPE_DEFINITION} {
    scanner_msg("OP creación de tipo: %s", yytext);
    return TOK_OP_TYPE_DEFINITION;
}

{OP_ARRAY_INIT} {
    scanner_msg("OP inicio de array: %s", yytext);
    return TOK_OP_ARRAY_INIT;
}

{OP_ARRAY_CLOSE} {
    scanner_msg("OP fin de array: %s", yytext);
    return TOK_OP_ARRAY_CLOSE;
}

{OP_DOT} {
    scanner_msg("OP punto: %s", yytext);
    return TOK_OP_DOT;
}

{OP_REL} {
    scanner_msg("OP relacional: %s", yytext);
    return TOK_OP_REL;
}

{OP_PAREN_OPEN} {
    scanner_msg("OP inicio de parentesis: %s", yytext);
    return TOK_OP_PAREN_OPEN;
}

{OP_PAREN_CLOSE} {
    scanner_msg("OP fin de parentesis: %s", yytext);
    return TOK_OP_PAREN_CLOSE;
}

{OP_PLUS} {
    scanner_msg("OP más: %s", yytext);
    return TOK_OP_PLUS;
}

{OP_MINUS} {
    scanner_msg("OP menos: %s", yytext);
    return TOK_OP_MINUS;
}

{OP_TIMES} {
    scanner_msg("OP multiplicación: %s", yytext);
    return TOK_OP_TIMES;
}

{OP_DIVIDE} {
    scanner_msg("OP división: %s", yytext);
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

    scanner_msg("LITERAL_INT: %ld", value);

    yylval.numero_entero = value;
    return TOK_LITERAL_INT;
}

{LITERAL_REAL} {
    double value = atof(yytext);
    scanner_msg("LITERAL_REAL: %f", value);

    yylval.numero_real = value;
    return TOK_LITERAL_REAL;
}

{LITERAL_BOOL} {
    bool value = FALSE;
    if (strcmp(yytext, "verdadero") == 0) {
        value = TRUE;
    }

    scanner_msg("LITERAL_BOOL: %s (%d)", yytext, value);

    yylval.booleano = value;
    return TOK_LITERAL_BOOL;
}

{LITERAL_CHAR} {
    char value = yytext[1];
    scanner_msg("LITERAL_CHAR: %c", value);

    yylval.caracter = value;
    return TOK_LITERAL_CHAR;
}

{LITERAL_STR} {
    char* value = yytext+1;
    value[strlen(value) - 1] = '\0';
    scanner_msg("LITERAL_STR: %s", value);

    yylval.cadena = value;
    return TOK_LITERAL_STR;
}

{R_ACCION} {
    scanner_msg("RESERVED: accion = %s", yytext);
    return TOK_R_ACCION;
}

{R_ALGORITMO} {
    scanner_msg("RESERVED: algoritmo = %s", yytext);
    return TOK_R_ALGORITMO;
}

{R_BOOLEANO} {
    scanner_msg("RESERVED: booleano = %s", yytext);
    return TOK_R_BOOLEANO;
}

{R_CADENA} {
    scanner_msg("RESERVED: cadena = %s", yytext);
    return TOK_R_CADENA;
}

{R_CARACTER} {
    scanner_msg("RESERVED: caracter = %s", yytext);
    return TOK_R_CARACTER;
}

{R_CONST} {
    scanner_msg("RESERVED: const = %s", yytext);
    return TOK_R_CONST;
}

{R_CONTINUAR} {
    scanner_msg("RESERVED: continuar = %s", yytext);
    return TOK_R_CONTINUAR;
}

{R_DE} {
    scanner_msg("RESERVED: de = %s", yytext);
    return TOK_R_DE;
}

R_DEV {
    scanner_msg("RESERVED: dev = %s", yytext);
    return TOK_R_DEV;
}

{R_DIV} {
    scanner_msg("RESERVED: div = %s", yytext);
    return TOK_R_DIV;
}

{R_ES} {
    scanner_msg("RESERVED: es = %s", yytext);
    return TOK_R_ES;
}

{R_ENT} {
    scanner_msg("RESERVED: ent = %s", yytext);
    return TOK_R_ENT;
}

{R_ENTERO} {
    scanner_msg("RESERVED: entero = %s", yytext);
    return TOK_R_ENTERO;
}

{R_FACCION} {
    scanner_msg("RESERVED: faccion = %s", yytext);
    return TOK_R_FACCION;
}

{R_FALGORITMO} {
    scanner_msg("RESERVED: falgoritmo = %s", yytext);
    return TOK_R_FALGORITMO;
}

{R_FCONST} {
    scanner_msg("RESERVED: fconst = %s", yytext);
    return TOK_R_FCONST;
}

{R_FFUNCION} {
    scanner_msg("RESERVED: ffuncion = %s", yytext);
    return TOK_R_FFUNCION;
}

{R_FMIENTRAS} {
    scanner_msg("RESERVED: fmientras = %s", yytext);
    return TOK_R_FMIENTRAS;
}

{R_FPARA} {
    scanner_msg("RESERVED: fpara = %s", yytext);
    return TOK_R_FPARA;
}

{R_FSI} {
    scanner_msg("RESERVED: fsi = %s", yytext);
    return TOK_R_FSI;
}

{R_FTIPO} {
    scanner_msg("RESERVED: ftipo = %s", yytext);
    return TOK_R_FTIPO;
}

{R_FTUPLA} {
    scanner_msg("RESERVED: ftupla = %s", yytext);
    return TOK_R_FTUPLA;
}

{R_FUNCION} {
    scanner_msg("RESERVED: funcion = %s", yytext);
    return TOK_R_FUNCION;
}

{R_FVAR} {
    scanner_msg("RESERVED: fvar = %s", yytext);
    return TOK_R_FVAR;
}

{R_HACER} {
    scanner_msg("RESERVED: hacer = %s", yytext);
    return TOK_R_HACER;
}

{R_HASTA} {
    scanner_msg("RESERVED: hasta = %s", yytext);
    return TOK_R_HASTA;
}

{R_MIENTRAS} {
    scanner_msg("RESERVED: mientras = %s", yytext);
    return TOK_R_MIENTRAS;
}

{R_MOD} {
    scanner_msg("RESERVED: mod = %s", yytext);
    return TOK_R_MOD;
}

{R_NO} {
    scanner_msg("RESERVED: no = %s", yytext);
    return TOK_R_NO;
}

{R_O} {
    scanner_msg("RESERVED: o = %s", yytext);
    return TOK_R_O;
}

{R_PARA} {
    scanner_msg("RESERVED: para = %s", yytext);
    return TOK_R_PARA;
}

{R_REAL} {
    scanner_msg("RESERVED: real = %s", yytext);
    return TOK_R_REAL;
}

{R_REF} {
    scanner_msg("RESERVED: ref = %s", yytext);
    return TOK_R_REF;
}

{R_SAL} {
    scanner_msg("RESERVED: sal = %s", yytext);
    return TOK_R_SAL;
}

{R_SI} {
    scanner_msg("RESERVED: si = %s", yytext);
    return TOK_R_SI;
}

{R_TABLA} {
    scanner_msg("RESERVED: tabla = %s", yytext);
    return TOK_R_TABLA;
}

{R_TIPO} {
    scanner_msg("RESERVED: tipo = %s", yytext);
    return TOK_R_TIPO;
}

{R_TUPLA} {
    scanner_msg("RESERVED: tupla = %s", yytext);
    return TOK_R_TUPLA;
}

{R_VAR} {
    scanner_msg("RESERVED: var = %s", yytext);
    return TOK_R_VAR;
}

{R_Y} {
    scanner_msg("RESERVED: y = %s", yytext);
    return TOK_R_Y;
}

{ID_BOOL} {
    scanner_msg("ID_BOOL: %s", yytext);
    yylval.cadena = (char *) malloc (sizeof(char) * strlen(yytext));
    strcpy(yylval.cadena, yytext);
    return TOK_ID_BOOL;
}

{ID} {
    scanner_msg("ID: %s", yytext);
    yylval.cadena = (char *) malloc (sizeof(char) * strlen(yytext));
    strcpy(yylval.cadena, yytext);
    return TOK_ID;
}

{SPECIAL} {
    scanner_msg("SPECIAL: %s", yytext);
}

{SEPARATOR} {}

. {}

%%

void scanner_msg(const char *format, ...) {
#if DEBUG
    va_list args;
    fprintf(stdout, "SCANNER: ");
    va_start(args, format);
    vfprintf(stdout, format, args);
    va_end(args);
    fprintf(stdout, "\n");
#endif
}
