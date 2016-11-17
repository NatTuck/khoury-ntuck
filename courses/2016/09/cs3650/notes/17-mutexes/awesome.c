#include <pthread.h>
#include <stdio.h>
#include <assert.h>
#include <unistd.h>

pthread_mutex_t mutex_a;
pthread_mutex_t mutex_b;

void*
thread_a(void* arg)
{
    printf("Hello from Thread A.\n");

    pthread_mutex_lock(&mutex_a);
    sleep(1);
    pthread_mutex_lock(&mutex_b);

    printf("Doing important work in Thread A.\n");

    pthread_mutex_unlock(&mutex_b);
    pthread_mutex_unlock(&mutex_a);

    return 0;
}

void*
thread_b(void* arg)
{
    printf("Hello from Thread B.\n");
    pthread_mutex_lock(&mutex_b);
    sleep(1);
    pthread_mutex_lock(&mutex_a);
    
    printf("Doing important work in Thread A.\n");

    pthread_mutex_unlock(&mutex_a);
    pthread_mutex_unlock(&mutex_b);
    return 0;
}

int
main(int _ac, char* _av[])
{
    int rv;
    pthread_t tt_a, tt_b;

    printf("Spawning some threads.\n");

    pthread_mutex_init(&mutex_a, 0);
    pthread_mutex_init(&mutex_b, 0);

    pthread_create(&tt_a, 0, thread_a, 0);
    pthread_create(&tt_b, 0, thread_b, 0);

    printf("Threads spawned.\n");

    pthread_join(tt_a, 0);
    pthread_join(tt_b, 0);

    printf("Threads done.\n");

    return 0;
}
