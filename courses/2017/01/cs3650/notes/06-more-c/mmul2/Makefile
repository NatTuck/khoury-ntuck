
mmul: mmul.o matrix.o
	gcc -g -o mmul mmul.o matrix.o

mmul.o: mmul.c matrix.h
	gcc -g -c -o mmul.o mmul.c

matrix.o: matrix.c matrix.h
	gcc -g -c -o matrix.o matrix.c

clean:
	rm -rf *.o mmul

.PHONY: clean

