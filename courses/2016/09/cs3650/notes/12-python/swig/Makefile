
_cfib.so: cfib.c cfib_wrap.c
	gcc -shared -fPIC -o _cfib.so cfib.c cfib_wrap.c -I /usr/include/python2.7

cfib_wrap.c: cfib.i
	swig -python cfib.i

clean:
	rm -f cfib_wrap.c _cfib.so
