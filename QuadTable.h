#ifndef QuadTable_h
#define QuadTable_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    int op;
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
void InicializaQ(quad_table *);

/**
 * Imprimir la tabla de cuadruplas completa
 */
void ImprimeTablaQ(quad_table *);

/**
 * Insertar nueva cuadrupla
 */
void InsertarQ(quad_table *, int, int, int, int);

#endif
