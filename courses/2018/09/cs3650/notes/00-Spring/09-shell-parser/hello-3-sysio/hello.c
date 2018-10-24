#include <unistd.h>
#include <string.h>

void
print_string(const char* ss)
{
    int length = strlen(ss);
    write(1, ss, length);
}

void
read_line(char* buf, int nn)
{
    for (int ii = 0; ii < (nn - 1); ++ii) {
        read(0, buf + ii, 1);
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
