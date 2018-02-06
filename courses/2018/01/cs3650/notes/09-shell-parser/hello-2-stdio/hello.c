#include <stdio.h>
#include <string.h>

void
print_string(const char* ss)
{
    int length = strlen(ss);
    fwrite(ss, 1, length, stdout);
}

void
read_line(char* buf, int nn)
{
    for (int ii = 0; ii < (nn - 1); ++ii) {
        fread(buf + ii, 1, 1, stdin);
        if (buf[ii] == '\n') {
            buf[ii + 1] = '\0';
            break;
        }
    }
}

int
main(int _ac, char* _av[])
{
    char name[80];

    print_string("Name?\n");

    read_line(name, 80);

    print_string("Hello, ");
    print_string(name);
    print_string("\n");
    return 0;
}

// next: replace fread, fwrite with read, write
