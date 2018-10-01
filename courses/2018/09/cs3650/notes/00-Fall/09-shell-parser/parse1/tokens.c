#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "list.h"
#include "tokens.h"

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

cell*
tokens(char* text)
{
    char tokn[80];
    cell* ys = 0;

    int ii = 0;
    while (ii < strlen(text)) {
        if (isspace(text[ii])) {
            ii++;
            continue;
        }

        if (isdigit(text[ii])) {
            copy_next_token(text + ii, tokn, isdigit);
            // tokn is "47"
            ys = cons(make_numb(atoi(tokn)), ys);
            ii += strlen(tokn);
        }

        if (ispunct(text[ii])) {
            ys = cons(make_oper(text[ii]), ys);
            ii++;
        }
    }

    cell* zs = reverse(ys);
    free_list(ys);
    return zs;
}

