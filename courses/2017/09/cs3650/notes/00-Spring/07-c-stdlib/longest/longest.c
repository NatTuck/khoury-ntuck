
#include <stdio.h>

char* names[] = {
    "Alice",
    "Bob",
    "Caroline",
    "Dave",
};

int
string_length(char* xs)
{
    int yy = 0;
    while (*(xs++)) {
        yy++;
    }
    return yy;
}

char*
longest(char* xs[], int nn)
{
    char* big = xs[0];

    for (int ii = 1; ii < nn; ++ii) {
        if (string_length(big) < string_length(xs[ii])) {
            big = xs[ii];
        }
    }

    return big;
}

int
main(int argc, char* argv[])
{
    printf("longest name is: %s\n", longest(names, 4));
    return 0;
}

