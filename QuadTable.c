#include "QuadTable.h"

void InicializaQ(quad_table *tabla) {
    tabla->size = 0;
}

void ImprimeTablaQ(quad_table *tabla) {
    int i;
    for (i = 0; i < tabla->size; i++) {
        printf("QUAD #%d: ", i);
        printf("op: %d, ", tabla->array[i].op);
        printf("arg1: %d, ", tabla->array[i].arg1);
        printf("arg2: %d, ", tabla->array[i].arg2);
        printf("result: %d\n", tabla->array[i].result);
    }
}

void InsertarQ(quad_table *tabla, int op, int arg1, int arg2, int result) {
    tabla->array[tabla->size].op = op;
    tabla->array[tabla->size].arg1 = arg1;
    tabla->array[tabla->size].arg2 = arg2;
    tabla->array[tabla->size].result = result;
    tabla->size += 1;
}
