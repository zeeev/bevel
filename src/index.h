#include <stdio.h>
#include <zlib.h>
#include "kseq.h"
#include <assert.h>
#include <inttypes.h>
#include <string.h>

#ifndef INDEX_H
#define INDEX_H


#ifndef MAGIC_HEAD
#define  MAGIC_HEAD 1984
#endif

#ifndef MAGIC_TAIL
#define MAGIC_TAIL 931
#endif

struct kp{
	uint64_t km[2];
};

struct mr{
	uint64_t min, load;
};

struct ns{
  char ** names;
  struct mr * data;
  uint32_t length;
};


struct offsetInfo{
	uint32_t arrayOffset;
	uint32_t count;
};

unsigned char seq_nt4_table[256] = {
	0, 1, 2, 3,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 0, 4, 1,  4, 4, 4, 2,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  3, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 0, 4, 1,  4, 4, 4, 2,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  3, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,
	4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4,  4, 4, 4, 4
};

#define swap(t, a, b) {t tmp = a; a = b; b = tmp; }

static void rad_sort_u(struct mr ** data,
		uint32_t from,
		uint32_t to,
		uint64_t bit){

	if (!bit || to < from + 1) return;

	uint32_t ll = from,  rr = to ;
	while(1){
		while(ll < rr && !((*data)[ll].min & bit)) ll++;
		while(ll < rr && ((*data)[rr].min & bit )) rr--;
		if(ll >= rr) break;
		swap(struct mr, (*data)[ll], (*data)[rr]);
	}
	if (!(bit & (*data)[ll].min) && ll < to) ll++;
	bit >>= 1;

	rad_sort_u(data, from, ll, bit);
	rad_sort_u(data, ll, to, bit);
}

void radix_sort_mr(struct mr ** data, uint64_t len){
	uint64_t bit = 1;
	bit <<= 63;
	rad_sort_u(data, 0, len - 1, bit);
}


static inline void print_mr(struct mr * m){
	printf("minimizer:\n");
	printf(" min:    %" PRIu64  "\n",  m->min);
	printf(" load:   %" PRIu64  "\n",  m->load );
	printf(" strand: %" PRIu64  "\n",  m->load & 1);
	printf(" rid:    %" PRIu64  "\n",  m->load>>32 );
	printf(" pos:   %i"         "\n",  (uint32_t)m->load>>1 );
	printf("\n");
}

static inline uint64_t hash64(uint64_t key, uint64_t mask)
{
	key = (~key + (key << 21)) & mask; // key = (key << 21) - key - 1;
	key = key ^ key >> 24;
	key = ((key + (key << 3)) + (key << 8)) & mask; // key * 265
	key = key ^ key >> 14;
	key = ((key + (key << 2)) + (key << 4)) & mask; // key * 21
	key = key ^ key >> 28;
	key = (key + (key << 31)) & mask;
	return key;
}

/**
 * Takes a char pointer and creates a list of minimizers
 *
 * @param seq    the sequences
 * @param len    the length of the sequence
 * @param k      kmer size
 * @param w      window size
 * @param rid    seq index
 */
void sketch(const char * name, const char * seq,
									int len, int k, int w,
									uint32_t rid,
									struct mr ** data,
									uint32_t  * datumSize ){

  uint64_t shift1 = 2 * (k - 1), mask = (1ULL << 2*k)-1;

	struct kp kmers;
	kmers.km[0] = 0; kmers.km[1] = 0;

	uint64_t wa = 0, cr = 0, min = 0;
	uint8_t strand = 0;

  assert(len > 0 && w > 0 && k > 0 && len > k && len > w && k < 64/2);

	int s = ((int)len/(float)w) +1 ;

	// $i is the base index
	// $j is the count of acceptable bases
	// $l last kmer window
	// $n buffer index
  int i = 0, j = 0, l = 0, n = 0;

	l = k;

	struct mr * buffer = (struct mr *) malloc( sizeof(struct mr) * s);

	for(i = 0;i < s; i++){
		buffer[i].min     = UINT64_MAX;
		buffer[i].load    = 0         ;
	}

	i = 0;

   for(; i < len; i++){
 		int c = seq_nt4_table[(uint8_t)seq[i]];
 		if(c < 4){
 			kmers.km[0] = (kmers.km[0] << 2  | c ) & mask        ;
 			kmers.km[1] = (kmers.km[1] >> 2) | (3ULL^c) << shift1;
 			if(kmers.km[0] == kmers.km[1]) continue;
 			l++;
 		}
 		else{
 			l = 0;
 		}
 		if((l % w) == 0 && l > k){
 			n++;
 		}
 		if(l >= k){
 			assert(n < s);
 			wa = hash64(kmers.km[0], mask);
 			cr = hash64(kmers.km[1], mask);
  			strand = wa > cr ? 0 : 1;
  			if(buffer[n].min > kmers.km[strand]){
  				buffer[n].min    = kmers.km[strand];
 					buffer[n].load = (uint64_t)rid<<32 | (uint32_t)i<<1 | strand;
  			}
  		}
  	}

	printf("INFO: Seq %s has %i minimizers\n", name, n );

	*data = (struct mr *) realloc(*data, (n + (*datumSize)) * sizeof(struct mr));

	for(i = 0; i < n; i++){
		(*data)[i + (*datumSize)].load = buffer[i].load;
		(*data)[i + (*datumSize)].min  = buffer[i].min;
	}

	*datumSize += n;

	free(buffer);
}

KSEQ_INIT(gzFile, gzread)
/**
 * [fileSketch description]
 * @param  argv [description]
 * @return      pointer to the minimizers, and the number of minimizers
 */

int fileSketch(struct ns * contain, char * filename, int ksize, int wsize)
	{
    printf("INFO: Sketching minimizers from file: %s\n", filename);

		contain->data  = (struct mr*)malloc(sizeof(struct mr));

	  gzFile fp;
	  kseq_t *seq;
	  int l;

	  fp = gzopen(filename, "r"); // STEP 2: open the file handler
	  seq = kseq_init(fp); // STEP 3: initialize seq
		uint32_t rid = 0;

	  while ((l = kseq_read(seq)) >= 0) { // STEP 4: read sequence
			sketch(seq->name.s, seq->seq.s,
        seq->seq.l, ksize, wsize, rid,
        &contain->data, &contain->length);
			rid++;
		}


		radix_sort_mr(&contain->data, contain->length);

	  kseq_destroy(seq); // STEP 5: destroy seq
	  gzclose(fp); // STEP 6: close the file handler


    printf("INFO: Done sketching minimizers from file: %s\n", filename);
	  return 0;
}

void findOffsets(struct mr * mins, int nmins){

	uint64_t last = mins[0].min;
	uint32_t lp   = 0;
	uint32_t c    = 0;
	uint32_t i    = 0;
	for(; i < nmins; i++){
			if(mins[i].min != last){
				printf("fp:  %i lp: %i lc: %i\n", lp, lp+c, c);
				lp = i + 1;
				c  = 0;
				last = mins[i].min;
		}
			c++;
	}
}

int writeDB(struct ns * contain, char * filename)
{
		printf("INFO: writing minimizers index\n");
		char db[strlen(filename)+5];
		strcpy(db, filename);
		strcat(db, ".midx");

		FILE * fn;
		fn = fopen(db, "wb");

		uint64_t magicFront = 1984;
		uint64_t magicTail  = 931 ;

		fwrite(&magicFront, sizeof(uint64_t), 1, fn);
		fwrite(&contain->length, sizeof(uint64_t), 1, fn);
		fwrite(contain->data, sizeof(struct mr), contain->length, fn);
		fwrite(&magicTail, sizeof(uint64_t), 1, fn);
		fclose(fn);

    printf("INFO wrote %i minimizers \n",  contain->length);

		return 0;
}

int readDB(struct ns * contains, char * filename){

	printf("INFO: reading minimizers index\n");

	char db[strlen(filename)+5];
	strcpy(db, filename);
	strcat(db, ".midx");

	FILE * fn;
	fn = fopen(db, "rb");
	uint64_t magicFront;
	uint64_t magicTail;

	fread(&magicFront, sizeof(uint64_t), 1, fn);
	fread(&contains->length, sizeof(uint64_t), 1, fn);


	if(magicFront != MAGIC_HEAD){
		printf("FATAL: Index is corrupt\n");
		return 1;
	}

	contains->data = (struct mr *) malloc(sizeof(struct mr)*contains->length);

	fread(contains->data, sizeof(struct mr), contains->length, fn);
	fread(&magicTail, sizeof(uint64_t), 1, fn);

	if(magicTail != MAGIC_TAIL){
		printf("FATAL: Index is truncated\n");
		return 1;
	}

  printf("INFO read %i minimizers \n",  contains->length);

	fclose(fn);

	return 0;

}

#endif
