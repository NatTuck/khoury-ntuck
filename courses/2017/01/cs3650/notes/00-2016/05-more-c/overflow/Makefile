
overflow: overflow.c
	gcc -g -o overflow overflow.c

unsafe: overflow.c
	gcc -g -o unsafe overflow.c -fno-stack-protector

clean:
	rm -f overflow unsafe
