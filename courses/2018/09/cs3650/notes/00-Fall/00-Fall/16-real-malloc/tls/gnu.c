
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>


typedef struct state {
    int th_id;
    int count;
} state;

__thread state st;

void
add_n()
{
    st.count += st.th_id;
}

void
print_count()
{
    printf("Thread %d, count = %d\n", st.th_id, st.count);
}

void*
thread_main(void* arg)
{
    st.th_id = *((int*)arg);
    st.count = 0;
    free(arg);

    for (int ii = 0; ii < 10; ++ii) {
        add_n();
    }

    print_count();
}


int
main(int _ac, char* _av[])
{
    pthread_t threads[4];

    for (int ii = 0; ii < 4; ++ii) {
        int* arg = malloc(sizeof(int));
        *arg = ii;
        pthread_create(&(threads[ii]), 0, thread_main, arg);
    }


    for (int ii = 0; ii < 4; ++ii) {
        pthread_join(threads[ii], 0);
    }

    return 0;
}

