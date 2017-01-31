#include <stdio.h>

#include "ilist.h"

int
main(int _ac, char* _av[])
{
    I_cell* xs = 0;

    for (int ii = 0; ii < 10; ++ii) {
        xs = i_cons(ii, xs);
    }

    I_cell* it = xs;
    for (I_cell* it = xs; it != 0; it = it->tail) {
        printf("%d\n", it->head);
    }

    free_ilist(xs);

    return 0;
}
