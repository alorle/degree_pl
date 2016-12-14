#ifndef SymTable_h
#define SymTable_h

struct variable
{
    char *name;
    int type;
    int id;
};

struct tablaSym
{
    union simbolo {
        struct variable var;
        //struct funcion fun;
        //struct tipo tip;
    } simb;
    struct tablaSym *siguiente;
};

//funciones a exportar

//inicializacion de tabla

void Inicializa(struct tablaSym **tabla);

//insertar variable en tabla
void InsertarVariable(struct tablaSym **, char *, int);

//falta insertar tipo e insertar funcion

//funcion para mostrar la tabla completa y ver que tiene
void ImprimeTabla(struct tablaSym **tabla);

void InsertarNuevo(struct tablaSym **tabla, struct tablaSym *nuevaCosa);

//funcion que comprueba si un elemento existe o no en la tabla, dado su nombre
int Existe(char *name, struct tablaSym *tabla);

union simbolo *BuscarElemento(char *name, struct tablaSym *tabla);

#endif
