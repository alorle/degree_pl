#ifndef SYM_TABLE_H
#define SYM_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

void init_TS(sym_table *);

void print_TS(sym_table *);

int insert_TS(sym_table *, symbol, sym_type);

int insert_var_TS(sym_table *, char *, int);

int exists_var(sym_table *, char *);

symbol_node *get_var(sym_table *, char *);

#endif
