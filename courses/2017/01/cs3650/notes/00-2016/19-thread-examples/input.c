#include <stdio.h>
#include <string.h>
#include <pthread.h>

char buffer[1000];
int  bptr = 0;

void*
input_thread(void* _arg)
{
    while (1) {
        int cc = getchar();
        if (cc == EOF) {
            break;
        }

        buffer[bptr++] = (char) cc;
    }

}

void*
output_thread(void* _arg)
{
    char tmp[1000];

    while (1) {
        if (buffer[bptr - 1] == '\n') {
            buffer[bptr] = 0;
            bptr = 0;
            strncpy(tmp, buffer, 1000);
            tmp[999] = 0;
            memset(buffer, 1000, 0);
    
            printf("[%s]\n", tmp);
        }
    }

    return 0;
}

int
main(int _ac, char* _av[])
{
    pthread_t ith;
    pthread_t oth;

    memset(buffer, 1000, 0);

    pthread_create(&ith, 0, input_thread, 0);
    pthread_create(&oth, 0, output_thread, 0);

    pthread_join(ith, 0);
    pthread_join(oth, 0);
    return 0;
}
