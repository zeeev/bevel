INCLUDE=-I ./src
LINKERS=-lz
FLAGS=-Wall -g

.PHONY: all clean

all: bin/bevel

bin/bevel: bin/ src/main.c src/index.h src/search.h
	gcc $(FLAGS) $(INCLUDE) src/main.c -o bin/bevel  $(LINKERS)

bin/:
	mkdir -p bin

clean:
	rm -rf bin
