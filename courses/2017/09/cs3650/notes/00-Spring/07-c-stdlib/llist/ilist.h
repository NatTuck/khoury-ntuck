#ifndef ILIST_H
#define ILIST_H

typedef struct I_cell {
    int head;
    struct I_cell* tail;
} I_cell;

I_cell* i_cons(int hd, I_cell* tl);
void    free_ilist(I_cell* lst);

#endif
