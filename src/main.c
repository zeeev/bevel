#include <stdio.h>
#include "index.h"


int main(int argc, char *argv[])
{
	if (argc == 1) {
		fprintf(stderr, "Usage: %s <in.seq>\n", argv[0]);
	 	return 1;
 	}
	int nMinimizers = 0;
	struct mr * mins;
	struct mr * mins2;
	fileSketch(&mins, argv[1], &nMinimizers);
	writeDB(mins, argv[1], nMinimizers);
	readDB(mins2, argv[1], &nMinimizers);

  return 0;
}
