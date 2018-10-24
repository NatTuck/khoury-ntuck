
#include <stdio.h>

#include "list.h"
#include "tokens.h"

int
main(int _ac, char* _av[])
{
    char line[80];

    while (fgets(line, 80, stdin)) {
        cell* xs = tokens(line);
        print_list(xs);
        printf("\n");
        free_list(xs);
    }

    return 0;
}
