#ifndef QUAD_TABLE_H
#define QUAD_TABLE_H

#include <stdio.h>

#define OP_NULL -1


typedef enum
{
    QT_SUMA,
    QT_RESTA,
    QT_DIV_ENT,
    QT_DIV_REAL,
    QT_MULT,
    QT_MOD,
    QT_MINUS,
    QT_ASSIG
} operation;

typedef struct
{
    operation op;
    int arg1;
    int arg2;
    int result;
} quad;

typedef struct
{
    int size;
    quad array[100];
} quad_table;

/**
 * Inicializar la tabla de cuadruplas a null
 */
void init_QT(quad_table *);

/**
 * Imprimir la tabla de cuadruplas completa
 */
void print_QT(quad_table *);

/**
 * Insertar nueva cuadrupla
 */
void insert_QT(quad_table *, operation, int, int, int);

#endif
