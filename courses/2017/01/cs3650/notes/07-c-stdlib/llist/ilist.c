
#include <stdlib.h>

#include "ilist.h"

I_cell* 
i_cons(int hd, I_cell* tl)
{
    I_cell* lst = malloc(sizeof(I_cell));
    lst->head = hd;
    lst->tail = tl;
    return lst;
}

void 
free_ilist(I_cell* lst)
{
    if (lst == 0) {
        return;
    }

    free_ilist(lst->tail);
    free(lst);
}

