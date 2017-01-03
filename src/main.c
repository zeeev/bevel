#include <stdio.h>
#include <unistd.h>
#include "index.h"
#include "search.h"

struct opts{
	int dump;
	int window;
	int ksize;
}globalOpts;


int loadOrBuild(struct ns * mins, char * filename){
	char db[strlen(filename)+5];
	strcpy(db, filename);
	strcat(db, ".midx");

	if(access (db, F_OK) != -1 ){
				readDB(mins, filename);
	}
	else{
		fileSketch(mins, filename, globalOpts.ksize, globalOpts.window);
		if(globalOpts.dump){
			writeDB(mins, filename);
		}
	}
	return 0;
}

int main(int argc, char *argv[])
{

	globalOpts.dump   =  0 ;
	globalOpts.window = 100;
	globalOpts.ksize  = 17 ;

 int c;

	static char usage[] = "usage: bevel [options] <target.fa> <query.fa> <query.fa ... \n\n options:\n    -d <FLAG> Write databases to files\n    -w <INT>  Save every Nth minimizer [100]\n    -k <INT>  Minimizer size (up to 32) [17] \n";

	while ((c = getopt(argc, argv, "dhw:k:")) != -1){
				switch (c) {
					case 'k':
					{
						globalOpts.ksize =  atoi(optarg);
						if(globalOpts.ksize > 32){
							printf("\nFATAL: bevel only supports kmers up to 32 bases\n");
							return 1;
						}
						break;
					}
					case 'w':
					{
						globalOpts.window = atoi(optarg);
						break;
					}
					case 'd':
					{
						globalOpts.dump = 1;
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

	struct ns * tDB = db_init();
	struct ns * qDB = db_init();

	loadOrBuild(tDB, argv[optind]);
	optind++;

	for (; optind < argc; optind++){
		loadOrBuild(qDB, argv[optind]);
	}

	search(tDB, qDB);

	db_destroy(tDB);
	db_destroy(qDB);

  return 0;
}
