

// This program inputs lines of text from the user.
// For each line it reverses the words.
// e.g.
//    the quick brown fox
// becomes
//    fox brown quick the

#include <stdio.h>

void get_line(char*, int);

void
reverse_words(char* text)
{
    char temp[80];
    char* words[80];
    int ii = 0;
    int jj = 0;

    if (text[ii] != '\0' && text[ii] != ' ') {
        words[jj++] = text + 0;
    }

    while (text[ii] != '\0') {
        if (text[ii] == ' ') {
            text[ii] = '\0';
            
            if (text[ii + 1] != '\0') {
                words[jj++] = text + ii + 1;
            }
        }

        ii++;
    }

    for (jj--; jj >= 0; --jj) {
        printf("word: %s\n", words[jj]);
    }

    printf("words[0] = %s\n", words[0]);
}    

int
main(int _argc, char* _argv[])
{
    char text[80];

    while (1) {
        get_line(text, 80);
        if (text[0] == '\0') {
            break;
        }

        // string in 'text'
        reverse_words(text);
        printf("Reversed: %s\n", text);
    }

    return 0;
}


