
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

// Note: intptr_t

typedef struct Account {
    char* name;
    long  balance;
    pthread_mutex_t lock;
} Account;

Account* accounts[4];

Account*
make_account(char* name, long balance)
{
    Account* acc = malloc(sizeof(Account));
    acc->name = strdup(name);
    acc->balance = balance;
    return acc;
}

void
free_account(Account* acc)
{
    free(acc->name);
    free(acc);
}

int
transfer(Account* aa, Account* bb, long amount)
{
    if (aa->balance < amount) {
        return -1;
    }

    aa->balance -= amount;
    bb->balance += amount;
}

void*
test_thread(void* seed_ptr)
{
    unsigned int seed = *((unsigned int*) seed_ptr);
    free(seed_ptr);

    for (int kk = 0; kk < 10000; ++kk) {
        int ii = rand_r(&seed) % 4;
        int jj = rand_r(&seed) % 4;
        int aa = 1 + rand_r(&seed) % 100;

        if (ii == jj) {
            continue;
        }

        transfer(accounts[ii], accounts[jj], aa);
    }

    return 0;
}

int
main(int _ac, char* _av[]) 
{
    pthread_t threads[10];

    accounts[0] = make_account("Alice", 100000);
    accounts[1] = make_account("Bob",   100000);
    accounts[2] = make_account("Carol", 100000);
    accounts[3] = make_account("Dave",  100000);

    for (int ii = 0; ii < 10; ++ii) {
        unsigned int* seed = malloc(sizeof(unsigned int));
        *seed = ii + getpid();
        pthread_create(&(threads[ii]), 0, test_thread, seed);
    }

    for (int ii = 0; ii < 10; ++ii) {
        pthread_join(threads[ii], 0);
    }

    long sum = 0;
    for (int ii = 0; ii < 4; ++ii) {
        sum += accounts[ii]->balance;
        printf("%s:\t%ld\n", accounts[ii]->name, accounts[ii]->balance);
        free_account(accounts[ii]);
    }

    printf("\nSum:\t%ld\n", sum);

    return 0;
}
