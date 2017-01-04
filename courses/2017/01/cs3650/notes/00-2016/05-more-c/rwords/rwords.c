#include <stdio.h>

void get_line(char*, int);

int
copy_string(char* dst, char* src)
{
    int count = 0;
    while (*src != '\0') {
        *(dst++) = *(src++);
        count++;
    }
    return count;
}

void
reverse_words(char* text)
{
    char temp[80];
    char* words[80];

    // First, find the words.
    int jj = 0;
    for (int ii = 0; text[ii] != '\0'; ++ii) {
        // skip any spaces
        while (text[ii] == ' ') {
            ++ii;
        }

        // found a word
        words[jj++] = text + ii;

        // skip any letters
        while (text[ii] != ' ' && text[ii] != '\0') {
            ++ii;
        }

        if (text[ii] != '\0') {
            text[ii] = '\0';
            ++ii;
        }
    }

    printf("Block: %s\n", text);

    // Now reverse them.
    char* pp = temp;
    for (; jj >= 0; --jj) {
        pp += copy_string(pp, words[jj]);
    }

    copy_string(text, temp);
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

        printf("Got line: [%s]\n", text);
        
        reverse_words(text);

        printf("reversed: %s\n", text);
    }

    return 0;
}
