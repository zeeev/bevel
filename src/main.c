#include <stdio.h>
#include <unistd.h>
#include "index.h"


int loadOrBuild(struct ns * mins, char * filename, int dump){
	char db[strlen(filename)+5];
	strcpy(db, filename);
	strcat(db, ".midx");

	if(access (db, F_OK) != -1 ){
				readDB(mins, filename);
	}
	else{
		fileSketch(mins, filename);
		if(dump){
			writeDB(mins, filename);
		}
	}
}

int main(int argc, char *argv[])
{

	int dump = 1; int c;

	static char usage[] = "usage: %s [options] <target.fa> <query.fa> <query.fa ... >\n";

	while ((c = getopt(argc, argv, "dh")) != -1){
				switch (c) {
					case 'd':
					{
						dump = 0;
						break;
					}
					case 'h':
					{
						printf("%s", usage);
						return 0;
					}
					case '?':
						{
							break;
						}
				}
	}
	if(optind >= argc){
		printf("\nFATAL: No target or query provided.\n\n" );
		exit(1);
	}

	for (; optind < argc; optind++){
		struct ns qDB;
		loadOrBuild(&qDB, argv[optind], dump);
	}

  return 0;
}
