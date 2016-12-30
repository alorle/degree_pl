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
        switch (temp->type)
        {
            case VARIABLE:
                printf("SYM %d as varaible: name %s, type %d\n", temp->id, temp->sym.var.name, temp->sym.var.type);
                break;
            default:
                fprintf(stderr, "ERROR: Unknown symbol type (%d)\n", temp->type);
        }
        temp = temp->next;
    }
}

int insert_TS(sym_table *table, symbol new_sym, sym_type type)
{
    symbol_node *temp = malloc(sizeof(symbol_node));
    temp->sym = new_sym;
    temp->id = table->size;
    temp->type = type;
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

int insert_var_TS(sym_table *table, char *name, int type)
{
    if (exists_var(table, name)) {
        return -1;
    }

    symbol new_sym;

    new_sym.var.name = (char *) malloc(sizeof(char) * strlen(name));
    strcpy(new_sym.var.name, name);
    new_sym.var.type = type;

    return insert_TS(table, new_sym, VARIABLE);
}

int exists_var(sym_table *table, char *name)
{
    return get_var(table, name) != NULL;
}

symbol_node *get_var(sym_table *table, char *name)
{
    symbol_node *temp = table->sym_list;

    while (temp != NULL) {
        if (temp->type == VARIABLE && strcmp(temp->sym.var.name, name) == 0) return temp;
        temp = temp->next;
    }

    return NULL;
}
