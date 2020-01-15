#include <stdio.h>
#include <string.h>

// for open(2)
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// for read(2) and close(2)
#include <unistd.h>

int
main(int _ac, char* _av[])
{
    char read_buf[192];
    char print_buf[64];

    char* intro = "Lines in msg.txt:\n";
    write(1, intro, strlen(intro));

    int fd = open("msg.txt", O_RDONLY);
    long size = read(fd, read_buf, 192);
    long lines = 0;
    for (int ii = 0; ii < size; ++ii) {
        if (read_buf[ii] == '\n') {
            lines += 1;
        }
    }
    close(fd);

    sprintf(print_buf, "lines = %ld\n", lines);
    write(1, print_buf, strlen(print_buf));

    return 0;
}
