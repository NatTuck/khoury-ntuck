#include <stdio.h>
#include <alloca.h>

#define SIZE 3

const int MM1_[SIZE][SIZE] = 
  { { 1, 0, 0 },
    { 0, 1, 0 },
    { 0, 0, 1 } };
const int MM2_[SIZE][SIZE] = 
  { { 0, 1, 2 },
    { 0, 0, 1 },
    { 0, 0, 0 } };

void
print_matrix(int** mm, int nn)
{
    for (int ii = 0; ii < nn; ++ii) {
        for (int jj = 0; jj < nn; ++jj) {
            printf("%d ", mm[ii][jj]);
        }
        printf("\n");
    }
}

void
mmul(int** cc, int** aa, int** bb, int nn)
{
    for (int ii = 0; ii < nn; ++ii) {
        for (int jj = 0; jj < nn; ++jj) {
            cc[ii][jj] = 0;
            for (int kk = 0; kk < nn; ++kk) {
                cc[ii][jj] += aa[ii][kk] * bb[kk][jj];
            }
        }
    }
}

int
main(int _argc, char* _argv[])
{
    int** cc = alloca(sizeof(int*) * SIZE);
    for (int ii = 0; ii < SIZE; ++ii) {
        cc[ii] = alloca(sizeof(int) * SIZE);
    }

    mmul(cc, MM1, MM2, SIZE);

    print_matrix(cc, SIZE);

    return 0;
}
