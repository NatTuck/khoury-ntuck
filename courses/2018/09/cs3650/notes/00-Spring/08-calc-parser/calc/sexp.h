#ifndef CALC_SEXP_H
#define CALC_SEXP_H

#define KIND_NUMB 0
#define KIND_OPER 1
#define KIND_CELL 2

typedef struct sexp sexp;

struct sexp {
    int kind;
    int refs;
};

typedef struct numb {
    int kind;
    int refs;
    int numb;
} numb;

typedef struct oper {
    int kind;
    int refs;
    int oper;
} oper;

typedef struct cell {
    int kind;
    int refs;
    sexp* head;
    sexp* tail;
} cell;

sexp* make_numb(int nn);
sexp* make_oper(int cc);
sexp* cons(sexp* hd, sexp* tl);
sexp* clone(sexp* xx);

void release(sexp* se);
void retain(sexp* se);

sexp* car(sexp* se);
sexp* cdr(sexp* se);
sexp* pop(sexp* se);

sexp* reverse(sexp* se);
int length(sexp* se);

char* display(sexp* se);
void print_sexp(sexp* se);

#endif
