%{
#include <stdio.h>
#include "sym_table.h"
#include "quad_table.h"

FILE *yyin;

#define ENTERO 1
#define REAL 2
#define BOOLEANO 3
#define CARACTER 4
#define CADENA 5

struct operando_struct {
    int id;
    int tipo;
};

sym_table symTable;
quad_table quadTable;

void yyerror(char *s);
%}

/* Tokens */
%token <cadena> TOK_ID TOK_ID_BOOL <numero_entero> TOK_LITERAL_INT <numero_real> TOK_LITERAL_REAL <booleano> TOK_LITERAL_BOOL <caracter> TOK_LITERAL_CHAR <cadena> TOK_LITERAL_STR TOK_COMMENT

/* Reserved words */
%token TOK_R_ACCION TOK_R_ALGORITMO TOK_R_BOOLEANO TOK_R_CADENA TOK_R_CARACTER TOK_R_CONST TOK_R_CONTINUAR TOK_R_DE TOK_R_DEV TOK_R_DIV TOK_R_ES TOK_R_ENT TOK_R_ENTERO TOK_R_FACCION TOK_R_FALGORITMO TOK_R_FCONST TOK_R_FFUNCION TOK_R_FMIENTRAS TOK_R_FPARA TOK_R_FSI TOK_R_FTIPO TOK_R_FTUPLA TOK_R_FUNCION TOK_R_FVAR TOK_R_HACER TOK_R_HASTA TOK_R_MIENTRAS TOK_R_MOD TOK_R_NO TOK_R_O TOK_R_PARA TOK_R_REAL TOK_R_REF TOK_R_SAL TOK_R_SI TOK_R_TABLA TOK_R_TIPO TOK_R_TUPLA TOK_R_VAR TOK_R_Y

/* Operators */
%token TOK_OP_ASSIGNAMENT TOK_OP_SEQU_COMPOS TOK_OP_SEPARATOR TOK_OP_SUBRANGE TOK_OP_VAR_TYPE_DEF TOK_OP_THEN TOK_OP_ELSE_IF TOK_OP_TYPE_DEFINITION TOK_OP_ARRAY_INIT TOK_OP_ARRAY_CLOSE TOK_OP_DOT TOK_OP_REL TOK_OP_PAREN_OPEN TOK_OP_PAREN_CLOSE TOK_OP_PLUS TOK_OP_MINUS TOK_OP_TIMES TOK_OP_DIVIDE

%type <tipo> d_tipo
%type <tipo> tipo_base
%type <tipo> lista_id
%type <op> exp_a
%type <op> operando

%union {
    char caracter;
    char *cadena;
    int booleano;
    double numero_real;
    long int numero_entero;
    int tipo;
    struct operando_struct *op;
};

%%

desc_algoritmo:     TOK_R_ALGORITMO TOK_ID cabecera_alg bloque_alg TOK_R_FALGORITMO {
                        printf("PARSER || ALGORITMO con nombre %s\n", $2);
                    };

cabecera_alg:       decl_globales decl_a_f decl_ent_sal TOK_COMMENT {};

bloque_alg:         bloque TOK_COMMENT {};

decl_globales:      /* vacío */ {}
                    | declaracion_tipo decl_globales {
                        printf("PARSER || Declaración global de tipos\n");
                    }
                    | declaracion_const decl_globales {
                        printf("PARSER || Declaración global de constantes\n");
                    };

decl_a_f:           /* vacío */ {}
                    | accion_d decl_a_f {
                        printf("PARSER || Declaración de acciones\n");
                    }
                    | funcion_d decl_a_f {
                        printf("PARSER || Declaración de funciones\n");
                    };

bloque:             declaraciones instrucciones {
                        printf("PARSER || Bloque del algoritmo\n");
                    };

declaraciones:      /* vacío */ {}
                    | declaracion_tipo declaraciones {}
                    | declaracion_const declaraciones {}
                    | declaracion_var declaraciones {};

declaracion_tipo:   TOK_R_TIPO lista_d_tipo TOK_R_FTIPO TOK_OP_SEQU_COMPOS {
                        printf("PARSER || Declaración de tipos\n");
                    };

declaracion_const:  TOK_R_CONST lista_d_cte TOK_R_FCONST TOK_OP_SEQU_COMPOS {
                        printf("PARSER || Declaración de constantes\n");
                    };

declaracion_var:    TOK_R_VAR lista_d_var TOK_R_FVAR TOK_OP_SEQU_COMPOS {
                        printf("PARSER || Declaración de variables\n");
                    };

lista_d_tipo:       /* vacío */ {}
                    | TOK_ID TOK_OP_TYPE_DEFINITION d_tipo TOK_OP_SEQU_COMPOS lista_d_tipo {
                        printf("PARSER || Declaración de tipo %d\n", $3);
                    };

d_tipo:             TOK_R_TUPLA lista_campos TOK_R_FTUPLA {
                        $$ = -1;
                    }
                    | TOK_R_TABLA TOK_OP_ARRAY_INIT expresion_t TOK_OP_SUBRANGE expresion_t TOK_OP_ARRAY_CLOSE TOK_R_DE d_tipo {
                        $$ = -1;
                    }
                    | TOK_ID {
                        $$ = -1;
                    }
                    | expresion_t TOK_OP_SUBRANGE expresion_t {
                        $$ = -1;
                    }
                    | TOK_R_REF d_tipo {
                        $$ = -1;
                    }
                    | tipo_base {
                        $$ = $1;
                    };

tipo_base:          TOK_R_ENTERO        {$$ = ENTERO;}
                    | TOK_R_REAL        {$$ = REAL;}
                    | TOK_R_BOOLEANO    {$$ = BOOLEANO;}
                    | TOK_R_CARACTER    {$$ = CARACTER;}
                    | TOK_R_CADENA      {$$ = CADENA;};

expresion_t:        expresion {}
                    | TOK_LITERAL_CHAR {
                        printf("PARSER || Expresión literal de tipo char: %c\n", $1);
                    };

lista_campos:       /* vacío */ {}
                    | TOK_ID TOK_OP_VAR_TYPE_DEF d_tipo TOK_OP_SEQU_COMPOS lista_campos {
                        printf("PARSER || Lista de campos\n");
                    };

lista_d_cte:        /* vacío */ {}
                    | TOK_ID TOK_OP_TYPE_DEFINITION literal TOK_OP_SEQU_COMPOS lista_d_cte {
                        printf("PARSER || Lista de constantes\n");
                    };

literal:            TOK_LITERAL_INT     { printf("PARSER || Literal entero: %ld\n", $1); }
                    | TOK_LITERAL_REAL  { printf("PARSER || Literal real: %f\n", $1); }
                    | TOK_LITERAL_BOOL  { printf("PARSER || Literal booleano: %d\n", $1); }
                    | TOK_LITERAL_CHAR  { printf("PARSER || Literal caracter: %c\n", $1); }
                    | TOK_LITERAL_STR   { printf("PARSER || Literal cadena: %s\n", $1); };

lista_d_var:        /* vacío */ {}
                    | lista_id TOK_OP_SEQU_COMPOS lista_d_var {
                        printf("PARSER || Lista de variables de tipo %d\n", $1);
                    };

lista_id:           TOK_ID TOK_OP_VAR_TYPE_DEF d_tipo {
                        if (insert_var_TS(&symTable, $1, $3) >= 0)
                            print_TS(&symTable);
                        else
                            yyerror("Variable ya definida anteriormente");
                        $$ = $3;
                    }
                    | TOK_ID_BOOL TOK_OP_VAR_TYPE_DEF d_tipo {
                        if (insert_var_TS(&symTable, $1, $3) >= 0)
                            print_TS(&symTable);
                        else
                            yyerror("Variable ya definida anteriormente");
                        $$ = $3;
                    }
                    | TOK_ID TOK_OP_SEPARATOR lista_id {
                        if (insert_var_TS(&symTable, $1, $3) >= 0)
                            print_TS(&symTable);
                        else
                            yyerror("Variable ya definida anteriormente");
                        $$ = $3;
                    }
                    | TOK_ID_BOOL TOK_OP_SEPARATOR lista_id {
                        if (insert_var_TS(&symTable, $1, $3) >= 0)
                            print_TS(&symTable);
                        else
                            yyerror("Variable ya definida anteriormente");
                        $$ = $3;
                    };

decl_ent_sal:       decl_ent {}
                    | decl_sal {}
                    | decl_ent decl_sal {};

decl_ent:           TOK_R_ENT lista_d_var {
                        printf("PARSER || Declaraciones de entrada\n");
                    };

decl_sal:           TOK_R_SAL lista_d_var {
                        printf("PARSER || Declaraciones de salida\n");
                    };

expresion:          exp_a {}
                    | exp_b {}
                    | funcion_ll {};

exp_a:              exp_a TOK_OP_PLUS exp_a {
                        printf("Sumando op1 %d de tipo %d con op2 %d de tipo %d\n", $1->id, $1->tipo, $3->id, $3->tipo);
                    }
                    | exp_a TOK_OP_MINUS exp_a {
                        printf("Restando op1 %d de tipo %d con op2 %d de tipo %d\n", $1->id, $1->tipo, $3->id, $3->tipo);
                    }
                    | exp_a TOK_OP_TIMES exp_a {
                        printf("Multiplicando op1 %d de tipo %d con op2 %d de tipo %d\n", $1->id, $1->tipo, $3->id, $3->tipo);
                    }
                    | exp_a TOK_OP_DIVIDE exp_a {
                        printf("Dividiendo op1 %d de tipo %d con op2 %d de tipo %d\n", $1->id, $1->tipo, $3->id, $3->tipo);
                    }
                    | exp_a TOK_R_MOD exp_a {
                        printf("Mod op1 %d de tipo %d con op2 %d de tipo %d\n", $1->id, $1->tipo, $3->id, $3->tipo);
                    }
                    | exp_a TOK_R_DIV exp_a {
                        printf("Div op1 %d de tipo %d con op2 %d de tipo %d\n", $1->id, $1->tipo, $3->id, $3->tipo);
                    }
                    | TOK_OP_PAREN_OPEN exp_a TOK_OP_PAREN_CLOSE {
                        // TODO
                    }
                    | operando {
                        // TODO
                    }
                    | TOK_LITERAL_INT {
                        // TODO
                    }
                    | TOK_LITERAL_REAL {
                        // TODO
                    }
                    | TOK_OP_MINUS exp_a {
                        // TODO
                    };

exp_b:              exp_b TOK_R_Y exp_b {
                        // TODO
                    }
                    | exp_b TOK_R_O exp_b {
                        // TODO
                    }
                    | TOK_R_NO exp_b {
                        // TODO
                    }
                    | operando_b {
                        // TODO
                    }
                    | TOK_LITERAL_BOOL {
                        // TODO
                    }
                    | expresion TOK_OP_REL expresion {
                        // TODO
                    }
                    | TOK_OP_PAREN_OPEN exp_b TOK_OP_PAREN_CLOSE {
                        // TODO
                    };

operando:           TOK_ID {
                        symbol_node *node = get_var(&symTable, $1);
                        $$->id = node->id;
                        $$->tipo = node->sym.var.type;
                    }
                    | operando TOK_OP_DOT operando {
                        // TODO
                    }
                    | operando TOK_OP_ARRAY_INIT expresion TOK_OP_ARRAY_CLOSE {
                        // TODO
                    }
                    | operando TOK_R_REF {
                        // TODO
                    };

operando_b:         TOK_ID_BOOL {
                        // TODO
                    }
                    | operando_b TOK_OP_DOT operando_b {
                        // TODO
                    }
                    | operando_b TOK_OP_ARRAY_INIT expresion TOK_OP_ARRAY_CLOSE {
                        // TODO
                    }
                    | operando_b TOK_R_REF {
                        // TODO
                    };

instrucciones:      instruccion TOK_OP_SEQU_COMPOS instrucciones {}
                    | instruccion {};

instruccion:        TOK_R_CONTINUAR {}
                    | asignacion {}
                    | alternativa {}
                    | iteracion {}
                    | accion_ll {};

asignacion:         operando TOK_OP_ASSIGNAMENT expresion {
                        printf("PARSER || Asignación de un operando aritmético\n");
                    }
                    | operando_b TOK_OP_ASSIGNAMENT expresion {
                        printf("PARSER || Asignación de un operando booleano\n");
                    };

alternativa:        TOK_R_SI expresion TOK_OP_THEN instrucciones lista_opciones TOK_R_FSI {
                        printf("PARSER || Instrucción SI\n");
                    };

lista_opciones:     /* vacío */ {}
                    | TOK_OP_ELSE_IF expresion TOK_OP_THEN instrucciones lista_opciones {
                        printf("PARSER || Instrucción SI NO\n");
                    };

iteracion:          it_cota_fija {}
                    | it_cota_exp {};

it_cota_fija:       TOK_R_PARA TOK_ID TOK_OP_ASSIGNAMENT expresion TOK_R_HASTA expresion TOK_R_HACER instrucciones TOK_R_FPARA {
                        printf("PARSER || Instrucción PARA con cota fija\n");
                    };

it_cota_exp:        TOK_R_MIENTRAS expresion TOK_R_HACER instrucciones TOK_R_FMIENTRAS {
                        printf("PARSER || Instrucción PARA con expresión como cota\n");
                    };

accion_d:           TOK_R_ACCION a_cabecera bloque TOK_R_FACCION {
                        printf("PARSER || Acción\n");
                    };

funcion_d:          TOK_R_FUNCION f_cabecera bloque TOK_R_DEV expresion TOK_R_FFUNCION {
                        printf("PARSER || Función\n");
                    };

a_cabecera:         TOK_ID TOK_OP_PAREN_OPEN d_par_form TOK_OP_PAREN_CLOSE TOK_OP_SEQU_COMPOS {
                        printf("PARSER || Cabecera de acción con nombre %s\n", $1);
                    };

f_cabecera:         TOK_ID TOK_OP_PAREN_OPEN lista_d_var TOK_OP_PAREN_CLOSE TOK_R_DEV d_tipo TOK_OP_SEQU_COMPOS {
                        printf("PARSER || Cabecera de función con nombre %s\n", $1);
                    };

d_par_form:         /* vacío */ {}
                    | d_p_form TOK_OP_SEQU_COMPOS d_par_form {
                        printf("PARSER ||d_par_form\n");
                    };

d_p_form:           TOK_R_ENT lista_id TOK_OP_VAR_TYPE_DEF d_tipo {
                        printf("PARSER || d_p_form\n");
                    }
                    | TOK_R_SI lista_id TOK_OP_VAR_TYPE_DEF d_tipo {
                        printf("PARSER || d_p_form\n");
                    }
                    | TOK_R_ES lista_id TOK_OP_VAR_TYPE_DEF d_tipo {
                        printf("PARSER || d_p_form\n");
                    };

accion_ll:          TOK_ID TOK_OP_PAREN_OPEN l_ll TOK_OP_PAREN_CLOSE {
                        printf("PARSER || accion_ll: %s\n", $1);
                    };

funcion_ll:         TOK_ID TOK_OP_PAREN_OPEN l_ll TOK_OP_PAREN_CLOSE {
                        printf("PARSER || funcion_ll: %s\n", $1);
                    };

l_ll:               expresion TOK_OP_SEPARATOR l_ll {
                        printf("PARSER || l_ll\n");
                    }
                    | expresion {
                        printf("PARSER || l_ll\n");
                    };

%%

int main(int argc, char **argv) {
    ++argv, --argc;

    yyin = (argc > 0) ? fopen(argv[0], "r") : stdin;

    if (yyin == NULL) {
        printf("PARSER || I can't input file!");
        return -1;
    }

    init_TS(&symTable);
    init_QT(&quadTable);

    yyparse();
}

void yyerror(char *s) {
    fprintf(stderr, "\033[31mERROR: %s\033[0m\n", s);
}
