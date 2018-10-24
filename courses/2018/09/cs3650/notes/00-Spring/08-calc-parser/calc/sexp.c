
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "sexp.h"

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
    oper* yy = malloc(sizeof(oper));
    yy->kind = KIND_OPER;
    yy->refs = 1;
    yy->oper = cc;
    return (sexp*) yy;
}

sexp*
cons(sexp* hd, sexp* tl)
{
    cell* yy = malloc(sizeof(cell));
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
    if (se == 0) {
        return;
    }

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
    if (se) {
        se->refs += 1;
    }
}

sexp*
car(sexp* se)
{
    assert(se && se->kind == KIND_CELL);
    cell* xs = (cell*)se;
    retain(xs->head);
    return xs->head;
}

sexp*
cdr(sexp* se)
{
    assert(se && se->kind == KIND_CELL);
    cell* xs = (cell*)se;
    return xs->tail;
}

sexp*
pop(sexp* se)
{
    assert(se && se->kind == KIND_CELL);
    cell* xs = (cell*)se;
    release(xs->head);
    return xs->tail;
}

static
sexp*
reverse1(sexp* xs, sexp* ys)
{
    if (xs == 0) {
        return ys;
    }

    return reverse1(cdr(xs), cons(car(xs), ys));
}

int
length(sexp* se)
{
    if (se == 0) {
        return 0;
    }

    assert(se && se->kind == KIND_CELL);
    return 1 + length(cdr(se));
}

sexp*
reverse(sexp* xs)
{
    return reverse1(xs, 0);
}

void
print_sexp(sexp* se)
{
    if (se == 0) {
        printf("()");
        return;
    }

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
            print_sexp(xs->head);
            xs = (cell*)xs->tail;
            if (xs) {
                printf(" ");
            }
        }
        printf(")");
    }
}
