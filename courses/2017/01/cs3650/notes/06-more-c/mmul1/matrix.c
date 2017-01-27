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
    mm->data = malloc(nn * sizeof(int*));

    for (int ii = 0; ii < nn; ++ii) {
        mm->data[ii] = malloc(nn * sizeof(int));
        memset(mm->data[ii], 0, nn * sizeof(int));
    }

    return mm;
}

void
free_matrix(Matrix* mm)
{
    for (int ii = 0; ii < mm->size; ++ii) {
        free(mm->data[ii]);
    }

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
            cc->data[ii][jj] = 0;

            for (int kk = 0; kk < nn; ++kk) {
                cc->data[ii][jj] += aa->data[ii][kk] * bb->data[kk][jj];
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
            printf("%2d ", aa->data[ii][jj]);
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
            mm->data[ii][jj] = rand() % 100; 
        }
    }
    
    return mm;
}


Matrix* 
ident_matrix(int nn)
{
    Matrix* mm = make_matrix(nn);

    for (int ii = 0; ii < nn; ++ii) {
        mm->data[ii][ii] = 1;
    }
    
    return mm;
}

