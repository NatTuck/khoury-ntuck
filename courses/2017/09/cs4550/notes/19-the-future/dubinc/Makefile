

all: dubinc.js

dubinc.js: dubinc.c
	emcc -o dubinc.js dubinc.c -s WASM=1 -s EXPORTED_FUNCTIONS="['_dubinc']"

clean:
	rm -f dubinc.js dubinc.wasm

