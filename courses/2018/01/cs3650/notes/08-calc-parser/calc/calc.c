
#include <stdio.h>

#include "sexp.h"
#include "calc.h"

int
main(int _ac, char* _av[])
{
    char line[128];

    while (fgets(line, 128, stdin)) {
        sexp* toks = tokens(line);
        sexp* expr = parse(toks);
        print_sexp(expr);
        printf("\n");
        release(toks);
        release(expr);
    }

    return 0;
}

