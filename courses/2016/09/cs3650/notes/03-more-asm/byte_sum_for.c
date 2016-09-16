
#include <alloca.h>
#include <stdio.h>

const char* text = "hello";

int
main(int argc, char* argv[])
{
    int sum = 0; 
    for (int ii = 0; text[ii] != 0; ++ii) {
        sum += (int) text[ii];
    }

    printf("Sum is: %d\n", sum);

    return 0;
}
