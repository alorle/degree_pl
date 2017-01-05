#include "bool_utils.h"

void backpatch(quad_table *table, bool_list list, int quad) {
    int i;

    for(i = 0; i < list.size; i++) {
        printf("Backpatching quad # %d with %d quad\n", list.array[i], quad);
        table->array[list.array[i]].result = quad;
    }
}

bool_list merge(bool_list lsA, bool_list lsB) {
    int i;
    bool_list list;

    list.size = lsA.size + lsB.size;
    list.array = malloc(list.size * sizeof(int));

    for(i = 0; i < lsA.size; i++) {
        list.array[i] = lsA.array[i];
    }

    for(i = 0; i < lsB.size; i++) {
        list.array[lsA.size + i] = lsB.array[i];
    }

    return list;
}

bool_list makelist(int quad) {
    bool_list list;
    list.size = 1;
    list.array = malloc(sizeof(int));
    list.array[0] = quad;
    return list;
}
