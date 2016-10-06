
#include <unistd.h>
#include <assert.h>
#include <stdio.h>

char* words[] = {
    "one",
    "two",
    "three",
    "four",
    "five",
    "six"
};

void
run_sort(int to_fd, int fr_fd)
{
    int rv;
    if ((rv = fork())) {
        assert(rv != -1);
    }
    else {
        //rv = close(0);
        assert(rv != -1);

        //rv = dup(to_fd);
        assert(rv != -1);

        rv = close(1);
        assert(rv != -1);
        
        rv = dup(fr_fd);
        assert(rv != -1);

        rv = execlp("sort", "sort", NULL);
        assert(rv != -1);
    }
}

int
main(int _ac, char* _av[])
{
    int to_sort[2];
    int fr_sort[2];

    pipe(to_sort);
    pipe(fr_sort);

    run_sort(to_sort[0], fr_sort[1]);
    close(to_sort[0]);
    close(fr_sort[1]);

    FILE* s_out = fdopen(to_sort[1], "w");
    FILE* s_in  = fdopen(fr_sort[0], "r");

    for (int ii = 0; ii < 6; ++ii) {
        fprintf(s_out, "%s\n", words[ii]);
        fprintf(stdout, "sent: %s\n", words[ii]);
    }
   
    fclose(s_out);

    char temp[80];
    for (int ii = 0; ii < 6; ++ii) {
        fgets(temp, 80, s_in);
        printf("%s", temp);
    }

    fclose(s_in);

    return 0;
}
