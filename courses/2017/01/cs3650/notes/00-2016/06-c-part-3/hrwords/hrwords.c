
#include <stdio.h>
#include <stdlib.h>

int
count_words(char* text)
{
    if (text[0] == '\0') {
        return 0;
    }
    
    int yy = 1;

    for (int ii = 0; text[ii] != '\0'; ++ii) {
        if (text[ii] == ' ') {
            yy += 1;
        }
    }

    return yy;
}

char** 
alloc_stra(int nn)
{
    char** yy = malloc(nn * sizeof(char*));
    for (int ii = 0; ii < nn; ++ii) {
        yy[ii] = 0;
    }
    return yy;
}

void
delete_stra(char** aa, int nn)
{
    for (int ii = 0; ii < nn; ++ii) {
        if (aa[ii]) {
            free(aa[ii]);
            aa[ii] = 0;
        }
    }

    free(aa);
}

int
word_len(char* text)
{
    int ii = 0;
    while (text[ii] != ' ' && text[ii] != '\0') {
        ii++;
    }
    return ii;
}

char**
split_words(char* text)
{
    int nn = count_words(text);
    char** xs = alloc_stra(nn);
 
    int jj = 0;
    for (int ii = 0; ii < nn; ++ii) {
        
    }

}

char*
reverse_words(char* text)
{
    char** words0 = split_words(text);
    char** words1 = reverse_stra(words0);
    char* revw = join_words(words1);
    delete_stra(words0);
    delete_stra(words1);
    return revw;
}

int
main(int _ac, char* _av[])
{
    while (true) {
        char*  text = 0;
        size_t size = 0;

        ssize_t rv = getline(&text, &size, stdin);
        if (rv == -1) {
            break;
        }

        printf("text: %s\n", text);

        char* revw = reverse_words(text);

        printf("revw: %s\n", revw);

        free(text);
        free(revw);
    }
}
