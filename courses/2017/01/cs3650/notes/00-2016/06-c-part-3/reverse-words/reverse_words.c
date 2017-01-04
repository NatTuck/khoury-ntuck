
#include <stdio.h>

void get_line(char*, int);

int
copy_word(char* dst, char* src)
{
    /* Copy from src to dst until space or null */
    int ii = 0;
    while (src[ii] != '\0' && src[ii] != ' ') {
        dst[ii] = src[ii];
        ii++;
    }
    return ii;
}

void
reverse_words(char* text)
{
    /* Buffer to copy words to. */
    char temp[80];

    /* Move to null at end of input. */
    int ii = 0;
    while (text[ii] != 0) ii++;

    /* Move backwards through input, starting from the
     * last non-null character. */
    int jj = 0;
    while (--ii >= 0) {
        if (text[ii] == ' ') {
            /* On space, copy the word after that space into temp. */
            jj += copy_word(&(temp[jj]), &(text[ii + 1]));
            /* Because we hit a space, this isn't the first word.
             * Therefore, we should put a space after it. */
            temp[jj++] = ' ';
        }
    }

    /* At this point, we haven't copied the first word since there's
     * no space before it */

    // Catch that last word.
    jj += copy_word(&(temp[jj]), text);

    // Put in a terminating null in temp.
    temp[jj] = '\0';

    // Copy the reversed buffer back over the input.
    for (ii = 0; temp[ii] != '\0'; ii++) {
        text[ii] = temp[ii];
    }
   
    // Make sure we've got a null in text.
    text[ii] = '\0';
}

int
main(int _ac, char* _av[])
{
    char text[80];

    while (1) {
        get_line(text, 80);
        if (text[0] == 0) {
            break;
        }

        printf("line: %s\n", text);
        reverse_words(text);
        printf("rwds: %s\n", text);
    }
    return 0;
}

