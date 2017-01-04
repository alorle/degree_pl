#ifndef SYM_TABLE_H
#define SYM_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"

typedef enum {
    SYM_VARIABLE,
    SYM_FUNCION,
    SYM_TIPO
} sym_tipo;

typedef struct {
    char *nombre;
    variable_tipo tipo;
} variable;

typedef union {
    variable var;
    // funcion fun;
    // tipo tip;
} symbol;

typedef struct symbol_node {
    int id;
    sym_tipo tipo;
    symbol sym;
    struct symbol_node *next;
} symbol_node;

typedef struct {
    int size;
    symbol_node *sym_list;
} sym_table;

symbol_node *last;

/**
 * Inicializar la tabla de símbolos
 */
void init_TS(sym_table *);

/**
 * Imprimir la tabla de símbolos completa
 */
void print_TS(sym_table *);

/**
 * Insertar un nuevo símbolo en la tabla
 */
int insert_TS(sym_table *, symbol, sym_tipo);

/**
 * Insertar una nueva varaible como símbolo de la tabla
 */
int insert_var_TS(sym_table *, char *, variable_tipo);

/**
 * Comprueba la existencia de una variable del mismo nombre
 */
int exists_var(sym_table *, char *);

/**
 * Obtiene la referencia a la variable del mismo nombre
 */
symbol_node *get_var(sym_table *, char *);

#endif
