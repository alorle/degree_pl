#include "quad_table.h"

void init_QT(quad_table *table) {
    table->size = 0;
}

void print_QT(quad_table *table) {
    int i;
    for (i = 0; i < table->size; i++) {
        printf("QUAD #%d: ", i);
        printf("op: %d, ", table->array[i].op);
        printf("arg1: %d, ", table->array[i].arg1);
        printf("arg2: %d, ", table->array[i].arg2);
        printf("result: %d\n", table->array[i].result);
    }
}

void insert_QT(quad_table *table, int op, int arg1, int arg2, int result) {
    table->array[table->size].op = op;
    table->array[table->size].arg1 = arg1;
    table->array[table->size].arg2 = arg2;
    table->array[table->size].result = result;
    table->size += 1;
}
