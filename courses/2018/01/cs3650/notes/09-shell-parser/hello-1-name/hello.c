#include <stdio.h>


int
main(int _ac, char* _av[])
{
    char name[80];
    printf("Name?\n");
    fgets(name, 80, stdin);
    printf("Hello, %s\n", name);
    return 0;
}
