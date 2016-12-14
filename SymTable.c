#include <string.h>
#include <stdio.h>
#include "SymTable.h"
#include <stdlib.h>

struct tablaSym *ultimo;
int sid = 0;

void Inicializa(struct tablaSym **tabla)
{

    *tabla = NULL;
    ultimo = NULL;
    sid = 0;
}

void ImprimeTabla(struct tablaSym **tabla)
{
    struct tablaSym *temp;
    temp = *tabla;

    while (temp->siguiente != NULL)
    {
        printf("nombre: %s ", temp->simb.var.name);
        printf("tipo: %d ", temp->simb.var.type);
        printf("id: %d\n", temp->simb.var.id);

        temp = temp->siguiente;
    }

    printf("nombre: %s ", temp->simb.var.name);
    printf("tipo: %d ", temp->simb.var.type);
    printf("id: %d\n", temp->simb.var.id);
}

void InsertarNuevo(struct tablaSym **tabla, struct tablaSym *nuevaCosa)
{

    //union tablaSym *puntTemp;

    if (*tabla == NULL)
    {
        //primer elemento de la lista de unions
        *tabla = nuevaCosa;
        ultimo = *tabla;
        // *tabla = ultimo;
    }
    else
    {
        ultimo->siguiente = nuevaCosa;
        nuevaCosa->siguiente = NULL;
        ultimo = ultimo->siguiente;
    }
}

void InsertarVariable(struct tablaSym **tabla, char *nombre, int tipo)
{
    if (!(Existe(nombre, *tabla)))
    {
        struct tablaSym *temp = (struct tablaSym *)malloc(sizeof(struct tablaSym));

        temp->siguiente = NULL;
        temp->simb.var.name = (char *)malloc(sizeof(char) * strlen(nombre));
        strcpy(temp->simb.var.name, nombre);
        temp->simb.var.type = tipo;
        temp->simb.var.id = sid;
        InsertarNuevo(tabla, temp);
        sid = sid + 1;
    }
}

int Existe(char *name, struct tablaSym *tabla)
{
    if (tabla == NULL)
    {
        return 0;
    }
    struct tablaSym *temp;
    temp = tabla;
    //ImprimeTabla(&temp);
    int found = 0;
    while (temp->siguiente != NULL && !(found))
    {
        if (!strcmp(temp->simb.var.name, name))
        {
            return 1;
        }
        temp = temp->siguiente;
    }
    if (temp->siguiente == NULL)
    {
        if (!strcmp(temp->simb.var.name, name))
        {
            return 1;
        }
    }
    return 0;
}

//funcion que busca un elemento en la tabla y lo devuelve
union simbolo *BuscarElemento(char *name, struct tablaSym *tabla)
{
    if (tabla == NULL)
    {
        return NULL;
    }
    struct tablaSym *temp;
    temp = tabla;
    //ImprimeTabla(&temp);
    int found = 0;
    while (temp->siguiente != NULL && !(found))
    {
        if (!strcmp(temp->simb.var.name, name))
        {
            return &(temp->simb);
        }
        temp = temp->siguiente;
    }
    if (temp->siguiente == NULL)
    {
        if (!strcmp(temp->simb.var.name, name))
        {
            return &(temp->simb);
        }
    }
    return NULL;
}

//void InsertarFuncion ( union tablaSym *tabla, .... , .... , ..... ,)

//void InsertarTipo ( union tablaSym *tabla, ... , .... , ....)
