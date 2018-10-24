
#include <assert.h>

#include "sexp.h"

sexp*
infix_to_postfix(sexp* xs)
{
    sexp* stack = 0;
    sexp* ys = 0;

    for (; xs != 0; xs = cdr(xs)) {
        sexp* xx = car(xs);
        release(xx);

        if (xx->kind == KIND_NUMB) {
            ys = cons(xx, ys);
            continue;
        }

        assert(xx->kind == KIND_OPER);

        oper* op = (oper*)xx;
        if (op->oper == ')') {
            while (1) {
                sexp* head = car(stack);
                oper* hh = (oper*) head;
                stack = pop(stack);
                if (hh->oper == '(') {
                    release(head);
                    break;
                }
                else {
                    ys = cons(head, ys);
                }
            }
            continue;
        }

        if (op->oper == '+' || op->oper == '-') {
            while (stack) {
                sexp* head = car(stack);
                oper* hh = (oper*) head;
                if (hh->oper == '*' || hh->oper == '/') {
                    ys = cons(head, ys);
                    stack = pop(stack);
                }
                else {
                    release(head);
                    break;
                }
            }
        }

        stack = cons(xx, stack);
    }

    for (sexp* it = stack; it != 0; it = cdr(it)) {
        ys = cons(car(it), ys);
    }

    sexp* zs = reverse(ys);
    release(ys);
    release(stack);
    return zs;
}

sexp*
prefix_to_tree(sexp** pre, int* ii, int nn)
{
    assert(*ii < nn);

    sexp* vv = pre[*ii];
    *ii += 1;

    if (vv->kind == KIND_OPER) {
        sexp* aa = prefix_to_tree(pre, ii, nn);
        sexp* bb = prefix_to_tree(pre, ii, nn);
        sexp* cc = 0;
        cc = cons(aa, cc);
        cc = cons(bb, cc);
        cc = cons(vv, cc);
        return cc;
    }
    else {
        return vv;
    }
}

sexp*
postfix_to_sexp(sexp* post)
{
    sexp* pre = reverse(post);
    int nn = length(pre);
    sexp* xs[nn];

    int ii = 0;
    for (sexp* it = pre; it != 0; it = cdr(it)) {
        sexp* vv = car(it);
        xs[ii++] = car(it);
    }
    release(pre);

    ii = 0;
    return prefix_to_tree(xs, &ii, nn);
}

sexp*
parse(sexp* xs)
{
    sexp* ys = infix_to_postfix(xs);
    sexp* zs = postfix_to_sexp(ys);
    release(ys);
    return zs;
}


