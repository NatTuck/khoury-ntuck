
# This is a GNU Makefile

EXEC := parse
SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)
HDRS := $(wildcard *.h)

$(EXEC): $(OBJS)
	gcc -g -o $(EXEC) $(OBJS)

%.o: %.c $(HDRS)
	gcc -c -g -o $@ $<

clean:
	rm -rf *.o $(EXEC) *.plist valgrind.out

.PHONY: clean

