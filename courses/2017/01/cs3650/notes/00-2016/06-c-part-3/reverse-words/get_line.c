#include <stdio.h>

void
get_line(char* line, int size)
{
    int ii = 0;

    while (1) {
        int cc = getchar();

        if (cc == EOF || cc == '\n') {
            break;
        }

        if (ii < size - 1) {
            line[ii] = (char) cc;
        }

        ii += 1;
    }

    ii = ii < size ? ii : size - 1;
    line[ii] = '\0';
}
