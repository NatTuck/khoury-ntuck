#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "matrix.h"

int
main(int _ac, char* _av[])
{
    srand(getpid());

    Matrix* aa = ident_matrix(4);
    printf("== Matrix A ==\n");
    print_matrix(aa);

    Matrix* bb = random_matrix(4);
    printf("== Matrix B ==\n");
    print_matrix(bb);
    
    Matrix* cc = matrix_mul(aa, bb);
    printf("== Matrix C ==\n");
    print_matrix(cc);

    free_matrix(aa);
    free_matrix(bb);
    free_matrix(cc);

    return 0;
}
