#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "sexp.h"

// The plan:
//  - Tokenize arithmetic expressons.
//  - e.g. "3+44" => ["3", "+", "44"]

typedef int (*cpred)(int); 

void
copy_next_token(char* text, char* tokn, cpred pred)
{
    int ii = 0;
    while (text[ii] && pred(text[ii])) {
        tokn[ii] = text[ii];
        ii++;
    }

    tokn[ii] = 0;
}

sexp*
tokens(char* text)
{
    sexp* ys = 0;

    char tokn[80];

    int ii = 0;
    int nn = strlen(text);

    while (ii < nn) {
        if (isspace(text[ii])) {
            ii++;
            continue;
        }

        if (isdigit(text[ii])) {
            copy_next_token(text + ii, tokn, isdigit);
            ys = cons(make_numb(atoi(tokn)), ys);
            ii += strlen(tokn);
            continue;
        }

        if (ispunct(text[ii])) {
            ys = cons(make_oper(text[ii]), ys);
            ii++;
            continue;
        }
    }

    sexp* zs = reverse(ys);
    release(ys);
    return zs;
}

