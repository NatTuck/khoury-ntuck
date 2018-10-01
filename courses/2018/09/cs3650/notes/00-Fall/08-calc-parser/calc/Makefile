
EXEC := calc
SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)
HDRS := $(wildcard *.h)

$(EXEC): $(OBJS)
	gcc -g -o $(EXEC) $(OBJS)

%.o: %.c $(HDRS)
	gcc -c -g -o $@ $<

clean:
	rm -rf *.o $(EXEC) tmp *.plist valgrind.out

