#ifndef SYM_TABLE_H
#define SYM_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum
{
    ENTERO,
    REAL,
    BOOLEANO,
    CARACTER,
    CADENA
} var_type;

typedef enum
{
    VARIABLE,
    FUNCTION,
    TYPE
} sym_type;

typedef struct
{
    char *name;
    int type;
} variable;

typedef union
{
    variable var;
    // function fun;
    // type tip;
} symbol;

typedef struct symbol_node
{
    symbol sym;
    int id;
    sym_type type;
    struct symbol_node *next;
} symbol_node;

typedef struct
{
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
int insert_TS(sym_table *, symbol, sym_type);

/**
 * Insertar una nueva varaible como símbolo de la tabla
 */
int insert_var_TS(sym_table *, char *, var_type);

/**
 * Comprueba la existencia de una variable del mismo nombre
 */
int exists_var(sym_table *, char *);

/**
 * Obtiene la referencia a la variable del mismo nombre
 */
symbol_node *get_var(sym_table *, char *);

#endif
