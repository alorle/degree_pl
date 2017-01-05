#ifndef BOOL_UTILS_H
#define BOOL_UTILS_H

#include <stdlib.h>
#include "structs.h"
#include "quad_table.h"

void backpatch(quad_table *, bool_list, int);

bool_list merge(bool_list, bool_list);

bool_list makelist(int);

#endif
