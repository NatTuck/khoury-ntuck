

#include <stdio.h>

#include "svec.h"

int
main(int _argc, char* _argv[])
{
    char line[100];
    svec* xs = make_svec();

    while (1) {
        char* rv = fgets(line, 96, stdin);
        if (!rv) {
            break;
        }

        svec_push_back(xs, line);
    }

    for (int ii = 0; ii < xs->size; ++ii) {
        int jj = xs->size - ii - 1;
        printf("%s", xs->data[jj]);
    }

    free_svec(xs);

    return 0;
}

