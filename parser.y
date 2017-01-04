%{
#include <stdio.h>
#include <stdarg.h>
#include "structs.h"
#include "sym_table.h"
#include "quad_table.h"

extern int yylineno;
extern FILE *yyin;

sym_table symTable;
quad_table quadTable;

void debug_tables();
void debug_msg(const char *, ...);
void reduction_msg(const char *, ...);
void yyerror(const char *, ...);
%}

/* Tokens */
%token <cadena> TOK_ID TOK_ID_BOOL <numero_entero> TOK_LITERAL_INT <numero_real> TOK_LITERAL_REAL <booleano> TOK_LITERAL_BOOL <caracter> TOK_LITERAL_CHAR <cadena> TOK_LITERAL_STR TOK_COMMENT

/* Reserved words */
%token TOK_R_ACCION TOK_R_ALGORITMO TOK_R_BOOLEANO TOK_R_CADENA TOK_R_CARACTER TOK_R_CONST TOK_R_CONTINUAR TOK_R_DE TOK_R_DEV TOK_R_ES TOK_R_ENT TOK_R_ENTERO TOK_R_FACCION TOK_R_FALGORITMO TOK_R_FCONST TOK_R_FFUNCION TOK_R_FMIENTRAS TOK_R_FPARA TOK_R_FSI TOK_R_FTIPO TOK_R_FTUPLA TOK_R_FUNCION TOK_R_FVAR TOK_R_HACER TOK_R_HASTA TOK_R_MIENTRAS TOK_R_NO TOK_R_O TOK_R_PARA TOK_R_REAL TOK_R_REF TOK_R_SAL TOK_R_SI TOK_R_TABLA TOK_R_TIPO TOK_R_TUPLA TOK_R_VAR TOK_R_Y

/* Operators */
%token TOK_OP_ASSIGNAMENT TOK_OP_SEQU_COMPOS TOK_OP_SEPARATOR TOK_OP_SUBRANGE TOK_OP_VAR_TYPE_DEF TOK_OP_THEN TOK_OP_ELSE_IF TOK_OP_TYPE_DEFINITION TOK_OP_ARRAY_INIT TOK_OP_ARRAY_CLOSE TOK_OP_DOT TOK_OP_REL TOK_OP_PAREN_OPEN TOK_OP_PAREN_CLOSE
%left TOK_OP_PLUS TOK_OP_MINUS
%left TOK_R_MOD TOK_R_DIV
%left TOK_OP_TIMES TOK_OP_DIVIDE

%type <tipo> d_tipo
%type <tipo> tipo_base
%type <tipo> lista_id

%type <exp> expresion

%type <op_a> operando
%type <op_a> exp_a

%type <op_b> operando_b
%type <op_b> exp_b

%union {
    char caracter;
    char *cadena;
    int booleano;
    double numero_real;
    long int numero_entero;
    variable_tipo tipo;
    expresion exp;
    op_aritmetico op_a;
    op_booleano op_b;
};

%%

desc_algoritmo:     TOK_R_ALGORITMO TOK_ID cabecera_alg bloque_alg TOK_R_FALGORITMO {
                        reduction_msg("ALGORITMO con nombre %s", $2);
                    };

cabecera_alg:       decl_globales decl_a_f decl_ent_sal TOK_COMMENT {};

bloque_alg:         bloque TOK_COMMENT {};

decl_globales:      /* vacío */ {}
                    | declaracion_tipo decl_globales {
                        reduction_msg("Declaración global de tipos");
                    }
                    | declaracion_const decl_globales {
                        reduction_msg("Declaración global de constantes");
                    };

decl_a_f:           /* vacío */ {}
                    | accion_d decl_a_f {
                        reduction_msg("Declaración de acciones");
                    }
                    | funcion_d decl_a_f {
                        reduction_msg("Declaración de funciones");
                    };

bloque:             declaraciones instrucciones {
                        reduction_msg("Bloque del algoritmo");
                    };

declaraciones:      /* vacío */ {}
                    | declaracion_tipo declaraciones {}
                    | declaracion_const declaraciones {}
                    | declaracion_var declaraciones {};

declaracion_tipo:   TOK_R_TIPO lista_d_tipo TOK_R_FTIPO TOK_OP_SEQU_COMPOS {
                        reduction_msg("Declaración de tipos");
                    };

declaracion_const:  TOK_R_CONST lista_d_cte TOK_R_FCONST TOK_OP_SEQU_COMPOS {
                        reduction_msg("Declaración de constantes");
                    };

declaracion_var:    TOK_R_VAR lista_d_var TOK_R_FVAR TOK_OP_SEQU_COMPOS {
                        reduction_msg("Declaración de variables");
                    };

lista_d_tipo:       /* vacío */ {}
                    | TOK_ID TOK_OP_TYPE_DEFINITION d_tipo TOK_OP_SEQU_COMPOS lista_d_tipo {
                        reduction_msg("Declaración de tipo %s", variable_tipo_names[$3]);
                    };

d_tipo:             TOK_R_TUPLA lista_campos TOK_R_FTUPLA {
                        $$ = VAR_DESCONOCIDO;
                    }
                    | TOK_R_TABLA TOK_OP_ARRAY_INIT expresion_t TOK_OP_SUBRANGE expresion_t TOK_OP_ARRAY_CLOSE TOK_R_DE d_tipo {
                        $$ = VAR_DESCONOCIDO;
                    }
                    | TOK_ID {
                        $$ = VAR_DESCONOCIDO;
                    }
                    | expresion_t TOK_OP_SUBRANGE expresion_t {
                        $$ = VAR_DESCONOCIDO;
                    }
                    | TOK_R_REF d_tipo {
                        $$ = VAR_DESCONOCIDO;
                    }
                    | tipo_base {
                        $$ = $1;
                    };

tipo_base:          TOK_R_ENTERO        {$$ = VAR_ENTERO;}
                    | TOK_R_REAL        {$$ = VAR_REAL;}
                    | TOK_R_BOOLEANO    {$$ = VAR_BOOLEANO;}
                    | TOK_R_CARACTER    {$$ = VAR_CARACTER;}
                    | TOK_R_CADENA      {$$ = VAR_CADENA;};

expresion_t:        expresion {}
                    | TOK_LITERAL_CHAR {
                        reduction_msg("Expresión literal de tipo char: %c", $1);
                    };

lista_campos:       /* vacío */ {}
                    | TOK_ID TOK_OP_VAR_TYPE_DEF d_tipo TOK_OP_SEQU_COMPOS lista_campos {
                        reduction_msg("Lista de campos");
                    };

lista_d_cte:        /* vacío */ {}
                    | TOK_ID TOK_OP_TYPE_DEFINITION literal TOK_OP_SEQU_COMPOS lista_d_cte {
                        reduction_msg("Lista de constantes");
                    };

literal:            TOK_LITERAL_INT     { reduction_msg("Literal entero: %ld", $1); }
                    | TOK_LITERAL_REAL  { reduction_msg("Literal real: %f", $1); }
                    | TOK_LITERAL_BOOL  { reduction_msg("Literal booleano: %d", $1); }
                    | TOK_LITERAL_CHAR  { reduction_msg("Literal caracter: %c", $1); }
                    | TOK_LITERAL_STR   { reduction_msg("Literal cadena: %s", $1); };

lista_d_var:        /* vacío */ {}
                    | lista_id TOK_OP_SEQU_COMPOS lista_d_var {
                        reduction_msg("Lista de variables de tipo %s", variable_tipo_names[$1]);
                    };

lista_id:           TOK_ID TOK_OP_VAR_TYPE_DEF d_tipo {
                        if (insert_var_TS(&symTable, $1, $3) < 0)
                            yyerror("Variable '%s' de tipo %s ya definida anteriormente", $1, variable_tipo_names[$3]);
                        $$ = $3;
                    }
                    | TOK_ID_BOOL TOK_OP_VAR_TYPE_DEF d_tipo {
                        if (insert_var_TS(&symTable, $1, $3) < 0)
                            yyerror("Variable '%s' de tipo %s ya definida anteriormente", $1, variable_tipo_names[$3]);
                        $$ = $3;
                    }
                    | TOK_ID TOK_OP_SEPARATOR lista_id {
                        if (insert_var_TS(&symTable, $1, $3) < 0)
                            yyerror("Variable '%s' de tipo %s ya definida anteriormente", $1, variable_tipo_names[$3]);
                        $$ = $3;
                    }
                    | TOK_ID_BOOL TOK_OP_SEPARATOR lista_id {
                        if (insert_var_TS(&symTable, $1, $3) < 0)
                            yyerror("Variable '%s' de tipo %s ya definida anteriormente", $1, variable_tipo_names[$3]);
                        $$ = $3;
                    };

decl_ent_sal:       decl_ent {}
                    | decl_sal {}
                    | decl_ent decl_sal {};

decl_ent:           TOK_R_ENT lista_d_var {
                        reduction_msg("Declaraciones de entrada");
                    };

decl_sal:           TOK_R_SAL lista_d_var {
                        reduction_msg("Declaraciones de salida");
                    };

expresion:          exp_a {
                        $$.tipo = EXP_ARITMETICO;
                        $$.a.id = $1.id;
                        $$.a.tipo = $1.tipo;
                    }
                    | exp_b {
                        $$.tipo = EXP_BOOLEANO;
                        $$.b.verdadero = $1.verdadero;
                        $$.b.falso = $1.falso;
                    }
                    | funcion_ll {};

exp_a:              exp_a TOK_OP_PLUS exp_a {
                        if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_ENTERO) {
                            debug_msg("Suma entera");

                            int result = insert_var_TS(&symTable, "", VAR_ENTERO);
                            insert_QT(&quadTable, OP_SUMA_ENTERO, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_ENTERO;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_REAL) {
                            debug_msg("Suma real");

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_SUMA_REAL, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_REAL) {
                            debug_msg("Suma real con el primer operador ENTERO");

                            int op1 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $1.id, OP_NULL, op1);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_SUMA_REAL, op1, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_ENTERO) {
                            debug_msg("Suma real con el segundo operador ENTERO");

                            int op2 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $3.id, OP_NULL, op2);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_SUMA_REAL, $1.id, op2, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else {
                            yyerror("Tipos %s y %s no compatibles para el operador suma",
                                variable_tipo_names[$1.tipo], variable_tipo_names[$3.tipo]);
                        }
                    }
                    | exp_a TOK_OP_MINUS exp_a {
                        if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_ENTERO) {
                            debug_msg("Resta entera");

                            int result = insert_var_TS(&symTable, "", VAR_ENTERO);
                            insert_QT(&quadTable, OP_RESTA_ENTERO, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_ENTERO;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_REAL) {
                            debug_msg("Resta real");

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_RESTA_REAL, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_REAL) {
                            debug_msg("Resta real con el primer operador ENTERO");

                            int op1 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $1.id, OP_NULL, op1);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_RESTA_REAL, op1, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_ENTERO) {
                            debug_msg("Resta real con el segundo operador ENTERO");

                            int op2 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $3.id, OP_NULL, op2);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_RESTA_REAL, $1.id, op2, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else {
                            yyerror("Tipos %s y %s no compatibles para el operador resta",
                                variable_tipo_names[$1.tipo], variable_tipo_names[$3.tipo]);
                        }
                    }
                    | exp_a TOK_OP_TIMES exp_a {
                        if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_ENTERO) {
                            debug_msg("Multiplicación entera");

                            int result = insert_var_TS(&symTable, "", VAR_ENTERO);
                            insert_QT(&quadTable, OP_PRODUCTO_ENTERO, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_ENTERO;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_REAL) {
                            debug_msg("Multiplicación real");

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_PRODUCTO_REAL, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_REAL) {
                            debug_msg("Multiplicación real con primer operador ENTERO");

                            int op1 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $1.id, OP_NULL, op1);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_PRODUCTO_REAL, op1, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_ENTERO) {
                            debug_msg("Multiplicación real con segundo operador ENTERO");

                            int op2 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $3.id, OP_NULL, op2);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_PRODUCTO_REAL, $1.id, op2, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else {
                            yyerror("Tipos %s y %s no compatibles para el operador producto",
                                variable_tipo_names[$1.tipo], variable_tipo_names[$3.tipo]);
                        }
                    }
                    | exp_a TOK_OP_DIVIDE exp_a {
                        if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_ENTERO) {
                            debug_msg("Divisón real entre ENTEROS");

                            int op1 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $1.id, OP_NULL, op1);

                            int op2 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $3.id, OP_NULL, op2);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_DIVISION_REAL, op1, op2, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_REAL) {
                            debug_msg("Divisón real entre REALES");

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_DIVISION_REAL, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_REAL) {
                            debug_msg("Divisón real entre ENTERO y REAL");

                            int op1 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $1.id, OP_NULL, op1);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_DIVISION_REAL, op1, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else if ($1.tipo == VAR_REAL && $3.tipo == VAR_ENTERO) {
                            debug_msg("Divisón real entre REAL y ENTERO");

                            int op2 = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_ENTERO2REAL, $3.id, OP_NULL, op2);

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_DIVISION_REAL, $1.id, op2, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else {
                            yyerror("Tipos %s y %s no compatibles para el operador divisón real",
                                variable_tipo_names[$1.tipo], variable_tipo_names[$3.tipo]);
                        }
                    }
                    | exp_a TOK_R_MOD exp_a {
                        if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_ENTERO) {
                            debug_msg("Módulo");

                            int result = insert_var_TS(&symTable, "", VAR_ENTERO);
                            insert_QT(&quadTable, OP_MODDULO, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_ENTERO;
                        } else {
                            yyerror("Tipos %s y %s no compatibles para el operador módulo",
                                variable_tipo_names[$1.tipo], variable_tipo_names[$3.tipo]);
                        }
                    }
                    | exp_a TOK_R_DIV exp_a {
                        if ($1.tipo == VAR_ENTERO && $3.tipo == VAR_ENTERO) {
                            debug_msg("Divisón entera");

                            int result = insert_var_TS(&symTable, "", VAR_ENTERO);
                            insert_QT(&quadTable, OP_DIVISION_ENTERO, $1.id, $3.id, result);

                            $$.id = result;
                            $$.tipo = VAR_ENTERO;
                        } else {
                            yyerror("Tipos %s y %s no compatibles para el operador divisón entera",
                                variable_tipo_names[$1.tipo], variable_tipo_names[$3.tipo]);
                        }
                    }
                    | TOK_OP_PAREN_OPEN exp_a TOK_OP_PAREN_CLOSE {
                        $$ = $2;
                    }
                    | operando {
                        $$ = $1;
                    }
                    | TOK_LITERAL_INT {
                        $$.id = insert_var_TS(&symTable, "", VAR_ENTERO);
                        $$.tipo = VAR_ENTERO;
                    }
                    | TOK_LITERAL_REAL {
                        $$.id = insert_var_TS(&symTable, "", VAR_REAL);
                        $$.tipo = VAR_REAL;
                    }
                    | TOK_OP_MINUS exp_a {
                        if ($2.tipo == VAR_ENTERO) {
                            debug_msg("Cambio de signo entero");

                            int result = insert_var_TS(&symTable, "", VAR_ENTERO);
                            insert_QT(&quadTable, OP_MENOS_ENTERO, $2.id, OP_NULL, result);

                            $$.id = result;
                            $$.tipo = VAR_ENTERO;
                        } else if ($2.tipo == VAR_REAL) {
                            debug_msg("Cambio de signo real");

                            int result = insert_var_TS(&symTable, "", VAR_REAL);
                            insert_QT(&quadTable, OP_MENOS_REAL, $2.id, OP_NULL, result);

                            $$.id = result;
                            $$.tipo = VAR_REAL;
                        } else {
                            yyerror("Tipo %s no compatible para el operador menos",
                                variable_tipo_names[$2.tipo]);
                        }
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
                        $$.id = node->id;
                        $$.tipo = node->sym.var.tipo;
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
                        if ($3.tipo == EXP_ARITMETICO && $1.tipo == $3.a.tipo) {
                            debug_msg("Asignación aritmética");
                            insert_QT(&quadTable, OP_ASIGNACION, $3.a.id, OP_NULL, $1.id);
                        } else
                            yyerror("No se puede asignar un valor de tipo %s a una variable de tipo %s",
                                variable_tipo_names[$3.a.tipo], variable_tipo_names[$1.tipo]);
                    }
                    | operando_b TOK_OP_ASSIGNAMENT expresion {
                        if ($3.tipo == EXP_BOOLEANO) {
                            debug_msg("Asignación booleana");
                            $1.verdadero = $3.b.verdadero;
                            $1.falso = $3.b.falso;
                        } else
                            yyerror("No se puede asignar un valor de tipo %s a una variable de tipo BOOLEANO",
                                variable_tipo_names[$3.a.tipo]);
                    };

alternativa:        TOK_R_SI expresion TOK_OP_THEN instrucciones lista_opciones TOK_R_FSI {
                        reduction_msg("Instrucción SI");
                    };

lista_opciones:     /* vacío */ {}
                    | TOK_OP_ELSE_IF expresion TOK_OP_THEN instrucciones lista_opciones {
                        reduction_msg("Instrucción SI NO");
                    };

iteracion:          it_cota_fija {}
                    | it_cota_exp {};

it_cota_fija:       TOK_R_PARA TOK_ID TOK_OP_ASSIGNAMENT expresion TOK_R_HASTA expresion TOK_R_HACER instrucciones TOK_R_FPARA {
                        reduction_msg("Instrucción PARA con cota fija");
                    };

it_cota_exp:        TOK_R_MIENTRAS expresion TOK_R_HACER instrucciones TOK_R_FMIENTRAS {
                        reduction_msg("Instrucción PARA con expresión como cota");
                    };

accion_d:           TOK_R_ACCION a_cabecera bloque TOK_R_FACCION {
                        reduction_msg("Acción");
                    };

funcion_d:          TOK_R_FUNCION f_cabecera bloque TOK_R_DEV expresion TOK_R_FFUNCION {
                        reduction_msg("Función");
                    };

a_cabecera:         TOK_ID TOK_OP_PAREN_OPEN d_par_form TOK_OP_PAREN_CLOSE TOK_OP_SEQU_COMPOS {
                        reduction_msg("Cabecera de acción con nombre %s", $1);
                    };

f_cabecera:         TOK_ID TOK_OP_PAREN_OPEN lista_d_var TOK_OP_PAREN_CLOSE TOK_R_DEV d_tipo TOK_OP_SEQU_COMPOS {
                        reduction_msg("Cabecera de función con nombre %s", $1);
                    };

d_par_form:         /* vacío */ {}
                    | d_p_form TOK_OP_SEQU_COMPOS d_par_form {
                        reduction_msg("d_par_form");
                    };

d_p_form:           TOK_R_ENT lista_id TOK_OP_VAR_TYPE_DEF d_tipo {
                        reduction_msg("d_p_form");
                    }
                    | TOK_R_SI lista_id TOK_OP_VAR_TYPE_DEF d_tipo {
                        reduction_msg("d_p_form");
                    }
                    | TOK_R_ES lista_id TOK_OP_VAR_TYPE_DEF d_tipo {
                        reduction_msg("d_p_form");
                    };

accion_ll:          TOK_ID TOK_OP_PAREN_OPEN l_ll TOK_OP_PAREN_CLOSE {
                        reduction_msg("accion_ll: %s", $1);
                    };

funcion_ll:         TOK_ID TOK_OP_PAREN_OPEN l_ll TOK_OP_PAREN_CLOSE {
                        reduction_msg("funcion_ll: %s", $1);
                    };

l_ll:               expresion TOK_OP_SEPARATOR l_ll {
                        reduction_msg("l_ll");
                    }
                    | expresion {
                        reduction_msg("l_ll");
                    };

%%

int main(int argc, char **argv) {
    ++argv, --argc;

    yyin = (argc > 0) ? fopen(argv[0], "r") : stdin;

    if (yyin == NULL) {
        reduction_msg("I can't input file!");
        return -1;
    }

    init_TS(&symTable);
    init_QT(&quadTable);

    yyparse();

    debug_tables();

    return 0;
}

void debug_tables() {
#if DEBUG
    fprintf(stdout, "\033[36m-----------------------------------------------------------------------\033[0m\n");
    fprintf(stdout, "\033[36m\nDEBUG: Quad Table\033[0m\n");
    print_QT(&quadTable);
    fprintf(stdout, "\033[36m\nDEBUG: Sym Table \033[0m\n");
    print_TS(&symTable);
    fprintf(stdout, "\033[36m-----------------------------------------------------------------------\033[0m\n");
#endif
}

void debug_msg(const char *format, ...) {
#if DEBUG
    va_list args;
    fprintf(stdout, "\033[36mDEBUG: ");
    va_start(args, format);
    vfprintf(stdout, format, args);
    va_end(args);
    fprintf(stdout, "\033[0m\n");
#endif
}

void reduction_msg(const char *format, ...) {
#if DEBUG
    va_list args;
    fprintf(stdout, "\033[32mREDUCCION: ");
    va_start(args, format);
    vfprintf(stdout, format, args);
    va_end(args);
    fprintf(stdout, "\033[0m\n");
#endif
}

void yyerror(const char *format, ...) {
    va_list args;
    fprintf(stderr, "\033[31mERROR en la linea %d: ", yylineno);
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    fprintf(stderr, "\033[0m\n");
}
