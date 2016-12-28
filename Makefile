INCLUDE=./src
LINKERS=-lz
FLAGS=-Wall -03

.PHONY: all clean

all: bin/bevel

bin/bevel: bin/ src/main.c src/index.h src/search.h
	gcc -I $(FLAG) $(INCLUDE) $(LINKERS) src/main.c -o bin/bevel

bin/:
	mkdir -p bin

clean:
	rm -rf bin
