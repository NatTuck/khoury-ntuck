
#include <string.h>
#include <stdint.h>

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
    aa->balance += amount;
}

void*
test_thread(void* seed_ptr)
{
    unsigned int seed = *((unsigned int*) seed_ptr);
    free(seed_ptr);

    for (int kk = 0; kk < 100; ++kk) {
        int ii = rand_r(&seed) % 4
        int jj = rand_r(&seed) % 4;
        int aa = 1 + rand_r(&seed) % 100;
        if (ii == jj)
            continue;

        transfer(accounts[ii], accounts[jj], aa);
    }

    return 0;
}

int
main(int _ac, char* _av[]) 
{
    pthread_t threads[2];

    accounts[0] = make_account("Alice", 1000);
    accounts[1] = make_account("Bob",   1000);
    accounts[2] = make_account("Carol", 1000);
    accounts[4] = make_account("Dave",  1000);

    for (int ii = 0; ii < 2; ++ii) {
        unsigned int* seed = malloc(sizeof(unsigned int));
        *seed = ii;
        pthread_create(&(threads[ii]), 0, test_thread, seed);
    }

    for (int ii = 0; ii < 2; ++ii) {
        pthread_join(threads[ii], 0);
    }

    for (int ii = 0; ii < 4; ++ii) {
        printf("%s: %ld\n", accounts[ii]->name, accounts[ii]->balance);
        free_account(accounts[ii]);
    }

    return 0;
}
