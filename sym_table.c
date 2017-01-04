#include "sym_table.h"

void init_TS(sym_table *table)
{
    table->size = 0;
    table->sym_list = NULL;
    last = table->sym_list;
}

void print_TS(sym_table *table)
{
    symbol_node *temp = table->sym_list;

    while (temp != NULL)
    {
        switch (temp->tipo)
        {
            case SYM_VARIABLE:
                if (strcmp("", temp->sym.var.nombre) == 0)
                    printf("Símbolo # %2d: variable temporal de tipo %s\n",
                        temp->id, variable_tipo_names[temp->sym.var.tipo]);
                else
                    printf("Símbolo # %2d: variable %s de tipo %s\n",
                        temp->id, temp->sym.var.nombre, variable_tipo_names[temp->sym.var.tipo]);
                break;
            default:
                fprintf(stderr, "ERROR: símbolo # %2d de tipo desconocido\n", temp->tipo);
        }
        temp = temp->next;
    }
}

int insert_TS(sym_table *table, symbol new_sym, sym_tipo tipo)
{
    symbol_node *temp = malloc(sizeof(symbol_node));
    temp->sym = new_sym;
    temp->id = table->size;
    temp->tipo = tipo;
    temp->next = NULL;

    if (table->sym_list == NULL) {
        table->sym_list = temp;
        last = table->sym_list;
    } else {
        last->next = temp;
        last = last->next;
    }

    table->size += 1;

    return last->id;
}

int insert_var_TS(sym_table *table, char *name, variable_tipo tipo)
{
    if (strcmp("", name) != 0 && exists_var(table, name)) {
        return -1;
    }

    symbol new_sym;

    new_sym.var.nombre = (char *) malloc(sizeof(char) * strlen(name));
    strcpy(new_sym.var.nombre, name);
    new_sym.var.tipo = tipo;

    return insert_TS(table, new_sym, SYM_VARIABLE);
}

int exists_var(sym_table *table, char *name)
{
    return get_var(table, name) != NULL;
}

symbol_node *get_var(sym_table *table, char *name)
{
    symbol_node *temp = table->sym_list;

    while (temp != NULL) {
        if (temp->tipo == SYM_VARIABLE && strcmp(temp->sym.var.nombre, name) == 0) return temp;
        temp = temp->next;
    }

    return NULL;
}
