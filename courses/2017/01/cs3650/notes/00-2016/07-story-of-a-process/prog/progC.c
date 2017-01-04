#include <stdio.h>

int nums[] = {2, 4, 6, 8};

void
pi(int xx)
{
    printf("%d\n", xx);
}

void
pa(int* xs, int nn)
{
    for (int ii = 0; ii < nn; ++ii) {
        pi(xs[ii]);
    }
}

int
main(int _ac, char* _av[])
{
    pa(nums, 4);
    return 0;
}
