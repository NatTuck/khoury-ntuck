
#include <stdio.h>
#include <unistd.h>

void
run_echo(int nn) {
    char tmp[20];

    sprintf(tmp, "%d", nn);
    execlp("echo", "echo", "echo", tmp, NULL);

    if (NULL != 0) {
        printf("Null is not zero.\n");
    }
}


int
main(int _ac, char* _av[])
{
    int pids[10];

    printf("Spawning some echos.\n");

    for (int ii = 0; ii < 10; ++ii) {
        int pid;

        if ((pid = fork())) {
            pids[ii] = pid;
        }
        else {
            run_echo(ii);
        }
    }
    
    printf("Echos are done.\n");

    return 0;
}
