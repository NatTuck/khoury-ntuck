
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

char**
reverse_string_array(char** xs, int nn)
{
    char** ys = malloc(nn * sizeof(char*));
    for (int ii = 0; ii < nn; ++ii) {
        ys[nn - ii - 1] = xs[ii];
    }
    return ys;
}

void
print_string_array(char** xs, int nn)
{
    for (int ii = 0; ii < nn; ++ii) {
        write(1, xs[ii], strlen(xs[ii]));
        write(1, "\n", 1);
    }
}

int
main(int argc, char* argv[])
{
    char* aa[5];
    aa[0] = "one";
    aa[1] = "two";
    aa[2] = "three";
    aa[3] = "four";
    aa[4] = "five";

    char** bb = reverse_string_array(aa, 5);
    print_string_array(bb, 5);
    free(bb);
    return 0;
}



