#ifndef QUAD_TABLE_H
#define QUAD_TABLE_H

#include <stdio.h>
#include "structs.h"

#define OP_NULL -1

typedef struct {
    operador op;
    int arg1;
    int arg2;
    int result;
} quad;

typedef struct {
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
 * Insertar nueva cuadrupla y devuelve el nuevo id
 */
int insert_QT(quad_table *, operador, int, int, int);

#endif
