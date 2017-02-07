#include <stdio.h>
#include <unistd.h>
#include "index.h"
#include "search.h"

struct opts{
	int dump;
	int missing;
	int window;
	int ksize;
	int max;
}globalOpts;


int loadOrBuild(struct ns * mins, char * filename){
	char db[strlen(filename)+5];
	strcpy(db, filename);
	strcat(db, ".midx");

	if(access (filename, F_OK) == -1){
			fprintf(stderr, "\nFATAL: One fasta file does not exist.\n       -d does not take an argument\n");
			exit(1);
		}

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

	globalOpts.missing = 0   ;
	globalOpts.dump   = 0   ;
	globalOpts.window = 100 ;
	globalOpts.ksize  = 17  ;
	globalOpts.max    = 500 ;

 int c;

	static char usage[] = "usage: bevel [options] <target.fa> <query.fa> <query.fa ... \n\n options:\n    -d <FLAG> Write databases to files\n    -w <INT>  Save every Nth minimizer [100]\n    -k <INT>  Minimizer size (up to 32) [17] \n    -n <INT>  Filter high frequeny minimizers [500]\n";

	while ((c = getopt(argc, argv, "dhw:k:n:m")) != -1){
				switch (c) {
					case 'm':
					{
							globalOpts.missing = 1;
							break;
					}
					case 'n':
					{
						globalOpts.max = atoi(optarg);
						break;
					}
					case 'k':
					{
						globalOpts.ksize =  atoi(optarg);
						if(globalOpts.ksize > 32){
							fprintf(stderr, "\nFATAL: bevel only supports minimizers up to 32 bases\n");
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
		fprintf(stderr, "\nFATAL: No target or query provided.\n\n" );
		exit(1);
	}

	struct ns * tDB = db_init();

	loadOrBuild(tDB, argv[optind]);
	optind++;

	for (; optind < argc; optind++){
		struct ns * qDB = db_init();
		loadOrBuild(qDB, argv[optind]);
		if(globalOpts.missing == 1){
			searchMissing(tDB, qDB, globalOpts.max);
		}
		else{
			search(tDB, qDB, globalOpts.max);
		}
		db_destroy(qDB);
	}

	db_destroy(tDB);

  return 0;
}
