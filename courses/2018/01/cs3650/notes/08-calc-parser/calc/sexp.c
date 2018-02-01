
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

sexp*
make_numb(int nn)
{
    numb* yy = malloc(sizeof(numb));
    yy->kind = KIND_NUMB;
    yy->refs = 1;
    yy->numb = nn;
    return (sexp*) yy;
}

sexp*
make_oper(int cc)
{
    numb* yy = malloc(sizeof(oper));
    yy->kind = KIND_OPER;
    yy->refs = 1;
    yy->oper = cc;
    return (sexp*) yy;
}

sexp*
cons(sexp* hd, sexp* tl)
{
    retain(hd);
    retain(tl);

    numb* yy = malloc(sizeof(cell));
    yy->kind = KIND_CELL;
    yy->refs = 1;
    yy->head = hd;
    yy->tail = tl;
    return (sexp*) yy;
}

sexp*
clone(sexp* xx)
{
    retain(xx);
    return xx;
}

void
release(sexp* se)
{
    se->refs -= 1;
    if (se->refs <= 0) {
        if (se->kind == KIND_CELL) {
            cell* xs = (cell*)se;
            release(xs->head);
            release(xs->tail);
        }
        free(se);
    }
}

void
retain(sexp* se)
{
    se->refs += 1;
}

sexp*
car(sexp* se)
{
    assert(se->kind == KIND_CELL);
    cell* xs = (cell*)se;
    retain(xs->head);
    return xs->head;
}

sexp*
cdr(sexp* se)
{
    assert(se->kind == KIND_CELL);
    cell* xs = (cell*)se;
    retain(xs->tail);
    return xs->tail;
}

void
print_sexp(sexp* se)
{
    if (se->kind == KIND_NUMB) {
        numb* nn = (numb*)se;
        printf("%d", nn->numb);
    }
    else if(se->kind == KIND_OPER) {
        oper* oo = (oper*)se;
        printf("%c", oo->oper);
    }
    else if(se->kind == KIND_CELL) {
        cell* xs = (cell*)se;
        printf("(");
        while (xs) {
            print_sexp(xs->first);
            xs = (cell*)xs->rest;
            if (xs) {
                printf(" ");
            }
        }
        printf(")");
    }
}
