#ifndef MATRIX_H
#define MATRIX_H

typedef struct Matrix {
    int** data;
    int   size;
} Matrix;

Matrix* make_matrix(int nn);
void    free_matrix(Matrix* mm);

Matrix* matrix_mul(Matrix* aa, Matrix* bb);
void    print_matrix(Matrix* aa);

Matrix* random_matrix(int nn);
Matrix* ident_matrix(int nn);

#endif
