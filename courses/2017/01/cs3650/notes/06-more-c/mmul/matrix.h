#ifndef MATRIX_H
#define MATRIX_H

struct Matrix {
    int** data;
    int   size;
};

Matrix* make_matrix(int nn);
void    free_matrix();

Matrix* matrix_mul(Matrix* aa, Matrix* bb);
void    matrix_print(Matrix* aa);

Matrix* random_matrix(int nn);
Matrix* ident_matrix(int nn);

#endif
