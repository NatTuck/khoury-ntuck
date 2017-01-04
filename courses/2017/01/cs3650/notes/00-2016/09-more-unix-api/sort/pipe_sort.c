
#include <unistd.h>
#include <assert.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>

char* words[] = {
    "one",
    "two",
    "three",
    "four",
    "five",
    "six"
};

void
sort(char** xs, int nn)
{
    int pipes[2];
    pipe(pipes);

    int cpid, rv;
    if ((cpid = fork())) {
        assert(rv != -1);

        close(pipes[0]);
        FILE* s_out = fdopen(pipes[1], "w");

        for (int ii = 0; ii < 6; ++ii) {
            fprintf(s_out, "%s\n", words[ii]);
        }
  
        fclose(s_out);

        waitpid(cpid, 0, 0);
    }
    else {
        close(pipes[1]);

        rv = close(0);
        assert(rv != -1);
        
        rv = dup(pipes[0]);
        assert(rv != -1);

        rv = execlp("sort", "sort", NULL);
        assert(rv != -1);
    }
}

int
main(int _ac, char* _av[])
{
    sort(words, 6);
    return 0;
}
