#ifndef QuadTable_h
#define QuadTable_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct quad
{
    int op;
    int result;
    int arg1;
    int arg2;
};

struct quadWrapper
{
    struct quad quad;
    struct quadWrapper *siguiente;
};

struct tablaQuad
{
    int size;
    struct quadWrapper *quadWrapper;
};

/**
 * Inicializar la tabla de cuadruplas a null
 */
void InicializaQ(struct tablaQuad *);

/**
 * Imprimir la tabla de cuadruplas completa
 */
void ImprimeTablaQ(struct tablaQuad *);

/**
 * Insertar nueva cuadrupla
 */
void InsertarQ(struct tablaQuad *, int, int, int, int);

#endif
