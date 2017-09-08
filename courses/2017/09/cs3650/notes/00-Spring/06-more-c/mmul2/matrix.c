#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "matrix.h"

Matrix* 
make_matrix(int nn)
{
    Matrix* mm = malloc(sizeof(Matrix));
    mm->size = nn;
    mm->data = malloc(nn * nn * sizeof(int));
    memset(mm->data, 0, nn * nn * sizeof(int));
    return mm;
}

void
free_matrix(Matrix* mm)
{
    free(mm->data);
    free(mm);
}

Matrix* 
matrix_mul(Matrix* aa, Matrix* bb)
{
    assert(aa->size == bb->size);
    int nn = aa->size;

    Matrix* cc = make_matrix(nn);

    for (int ii = 0; ii < nn; ++ii) {
        for (int jj = 0; jj < nn; ++jj) {
            cc->data[nn*ii + jj] = 0;

            for (int kk = 0; kk < nn; ++kk) {
                cc->data[nn*ii + jj] += aa->data[nn*ii + kk] * bb->data[nn*kk + jj];
            }
        }
    }

    return cc;
}

void 
print_matrix(Matrix* aa)
{
    int nn = aa->size;

    for (int ii = 0; ii < nn; ++ii) {
        for (int jj = 0; jj < nn; ++jj) {
            printf("%2d ", aa->data[nn*ii + jj]);
        }
        printf("\n");
    }
    printf("\n");
}

Matrix* 
random_matrix(int nn)
{
    Matrix* mm = make_matrix(nn);

    for (int ii = 0; ii < nn; ++ii) {
        for (int jj = 0; jj < nn; ++jj) {
            mm->data[nn*ii + jj] = rand() % 100; 
        }
    }
    
    return mm;
}


Matrix* 
ident_matrix(int nn)
{
    Matrix* mm = make_matrix(nn);

    for (int ii = 0; ii < nn; ++ii) {
        mm->data[nn*ii + ii] = 1;
    }
    
    return mm;
}

