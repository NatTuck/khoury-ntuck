
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>


pthread_key_t t_state;

typedef struct state {
    int th_id;
    int count;
} state;

void
add_n()
{
    state* st = pthread_getspecific(t_state);
    st->count += st->th_id;
}

void
print_count()
{
    state* st = pthread_getspecific(t_state);
    printf("Thread %d, count = %d\n", st->th_id, st->count);
}

void*
thread_main(void* arg)
{
    state* st = malloc(sizeof(state));
    st->th_id = *((int*)arg);
    st->count = 0;
    free(arg);

    pthread_setspecific(t_state, st);

    for (int ii = 0; ii < 10; ++ii) {
        add_n();
    }

    print_count();

    free(st);
}


int
main(int _ac, char* _av[])
{
    pthread_t threads[4];

    pthread_key_create(&t_state, 0);

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

