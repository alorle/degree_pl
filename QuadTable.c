#include "QuadTable.h"

void InicializaQ(struct tablaQuad *tabla) {
    tabla->size = 0;
    tabla->quadWrapper = NULL;
}

void ImprimeTablaQ(struct tablaQuad *tabla) {
    struct quadWrapper *temp = tabla->quadWrapper;
    if (tabla->size == 0 || tabla->quadWrapper == NULL) {
        printf("Tabla vacía\n");
        return;
    }

    while (temp != NULL)
    {
        printf("op: %d ", temp->quad.op);
        printf("result: %d ", temp->quad.result);
        printf("arg1: %d ", temp->quad.arg1);
        printf("arg2: %d\n", temp->quad.arg2);

        temp = temp->siguiente;
    }
}

void InsertarQ(struct tablaQuad *tabla, int op, int result, int arg1, int arg2) {
    while (tabla->quadWrapper != NULL)
    {
        tabla->quadWrapper = tabla->quadWrapper->siguiente;
    }

    tabla->quadWrapper = malloc (sizeof(struct quadWrapper *));

    tabla->quadWrapper->quad.op = op;
    tabla->quadWrapper->quad.result = result;
    tabla->quadWrapper->quad.arg1 = arg1;
    tabla->quadWrapper->quad.arg2 = arg2;
    tabla->quadWrapper->siguiente = NULL;

    tabla->size += 1;
}

int main(int argc, char **argv) {
    struct tablaQuad tablaCuadruplas;

	InicializaQ(&tablaCuadruplas);

	ImprimeTablaQ(&tablaCuadruplas);
    InsertarQ(&tablaCuadruplas, 1, 2, 3, 4);
	ImprimeTablaQ(&tablaCuadruplas);
    InsertarQ(&tablaCuadruplas, 1, 3, 3, 4);
	ImprimeTablaQ(&tablaCuadruplas);
    InsertarQ(&tablaCuadruplas, 1, 2, 4, 4);
	ImprimeTablaQ(&tablaCuadruplas);
    InsertarQ(&tablaCuadruplas, 1, 2, 3, 5);
	ImprimeTablaQ(&tablaCuadruplas);
    InsertarQ(&tablaCuadruplas, 1, 2, 3, 8);
	ImprimeTablaQ(&tablaCuadruplas);

    return 0;
}
