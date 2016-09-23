#include <stdio.h>

void
get_line(char* line, int max_size)
{
    int ii = 0;

    while (1) {
        int cc = getchar();

        if (cc == EOF || cc == '\n') {
            break;
        }

        if (ii < max_size - 1) {
            line[ii] = (char) cc;
        }

        ii++;
    }

    ii = ii < max_size - 1 ? ii : max_size - 1;
    line[ii] = '\0';
}
