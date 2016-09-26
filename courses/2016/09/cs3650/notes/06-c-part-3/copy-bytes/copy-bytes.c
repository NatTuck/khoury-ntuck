
#include <stdio.h>

void
copy_bytes(void* dst, void* src, int size)
{
    char* dd = (char*) dst;
    char* pp = (char*) src;

    while (pp != src + size) {
        *(dd++) = *(pp++);
    }
}

int
main(int _argc, char* _argv[])
{
    int aa[] = {1, 2, 3, 4};
    int bb[4];

    copy_bytes(bb, aa, 4*sizeof(int));

    for (int ii = 0; ii < 4; ++ii) {
        printf("aa[%d] = %d; bb[%d] = %d\n", ii, aa[ii], ii, bb[ii]);
    }
}
