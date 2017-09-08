
#include <stdio.h>

int
foo()
{
    int aa = 35;
    int xs[10];
    int bb = 45;

    for (int ii = 0; ii < 20; ++ii) {
        xs[ii] = ii;
    }

    printf("aa = %d; bb = %d\n", aa, bb);

    return 27;
}

int
main(int _argc, char* _argv[]) 
{
    int yy = foo();
    printf("foo -> %d\n", yy);
    return 0;
}
