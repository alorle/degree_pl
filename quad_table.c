#include "quad_table.h"

void init_QT(quad_table *table) {
    table->size = 0;
}

void print_QT(quad_table *table) {
    int i;
    for (i = 0; i < table->size; i++) {
        printf("Cuadrupla # %2d: %s %2d (arg1) %2d (arg2) %2d (result)\n", i,
            operador_names[table->array[i].op],
            table->array[i].arg1,
            table->array[i].arg2,
            table->array[i].result);
    }
}

void insert_QT(quad_table *table, operador op, int arg1, int arg2, int result) {
    table->array[table->size].op = op;
    table->array[table->size].arg1 = arg1;
    table->array[table->size].arg2 = arg2;
    table->array[table->size].result = result;
    table->size += 1;
}
