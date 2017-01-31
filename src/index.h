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

struct seqName{
	uint8_t * seq;
	uint32_t  len;
};

struct off_info{
	uint64_t min   ;
	uint32_t offset;
	uint32_t count ;
};

/*
	length is the length of the minizer array
	namelen is the length for the sequence names
	ulength is the lenght for unique minizers
 */
struct ns{
  struct seqName   * names;
  struct mr         * data;
	struct off_info   * offs;
	uint32_t         ulength;
	uint32_t         namelen;
  uint32_t          length;
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

KSEQ_INIT(gzFile, gzread)

static void rad_sort_u(struct mr ** data,
		uint32_t from,
		uint32_t to,
		uint64_t bit){

	if (!bit || to < from + 1) return;

	uint32_t ll = from,  rr = to -1;
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
	rad_sort_u(data, 0, len , bit);
}

struct ns *  db_init(){

	struct ns * db;

	db = malloc(sizeof(struct ns));
	db->length   = 0;
	db->ulength  = 0;
	db->namelen  = 0;
	db->data     = malloc(sizeof(struct mr));
	db->names    = malloc(sizeof(struct seqName)*100);

	return db;

}

void db_destroy(struct ns * db){

	free(db->data);
	free(db->offs);

	uint32_t i = 0;

	for(; i < db->namelen; i++){
		free(db->names[i].seq);
	}
	free(db->names);


}


/**
 * Dump the mr struct
 */
static inline void print_mr(struct mr * m){
	printf("minimizer:\n");
	printf(" min:    %" PRIu64  "\n",  m->min);
	printf(" load:   %" PRIu64  "\n",  m->load );
	printf(" strand: %" PRIu64  "\n",  m->load & 1);
	printf(" rid:    %" PRIu64  "\n",  m->load>>32 );
	printf(" pos:   %i"         "\n",  (uint32_t)m->load>>1 );
	printf("\n");
}

/**
 * Function insures that "A" homopolymers aren't zero
 */
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
 * adds sequence names to the ns object
 * @param db database object
 * @param k  kseq_t
 */
void loadSeq(struct ns * db, kseq_t * k, uint32_t count)
{

	if((count % 100) == 0 ){
		db->names = realloc(db->names, (count+100) * sizeof(struct seqName) );
	}

	db->names[count].len = k->name.l;
	db->names[count].seq = malloc(sizeof(uint8_t)* k->name.l);

	uint32_t i = 0;

	for(; i < k->name.l; i++){
		db->names[count].seq[i] = (uint8_t)k->name.s[i];
	}
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

	uint64_t wa = 0, cr = 0;
	uint8_t strand = 0;

  assert(len > 0 && w > 0 && k > 0 && len > k && len > w && k <= 32);

	int s = ((int)len/(float)w) + 2;

  int i = 0, l = 0, n = 0;

	struct mr * buffer = malloc( sizeof(struct mr) * s);

	for(i = 0; i < s; i++){
		buffer[i].min     = UINT64_MAX;
		buffer[i].load    = 0         ;
	}

	uint32_t nth = 0;

	for(i = 0; i < len; i++){
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
		if(nth >= w){
			nth = 0;
			n++;
		}
 		if(l >= k){
			nth++;
 			wa = hash64(kmers.km[0], mask);
 			cr = hash64(kmers.km[1], mask);
  			strand = wa > cr ? 0 : 1;
  			if(buffer[n].min   > kmers.km[strand]){
  				buffer[n].min    = kmers.km[strand];
 					buffer[n].load   = (uint64_t)rid<<32 | (uint32_t)i<<1 | strand;
  			}
			}
		}

		assert(n < s);

	fprintf(stderr, "INFO: Seq %s has %i minimizers\n", name, n );

	*data = realloc(*data, (n + (*datumSize)) * sizeof(struct mr));

	for(i = 0; i < n; i++){
		assert(buffer[i].load != 0);
		(*data)[i + (*datumSize)].load = buffer[i].load;
		(*data)[i + (*datumSize)].min  = buffer[i].min;
	}

	*datumSize += n;
	free(buffer);

}

/**
 * [buildOffsets description]
 *    This finds the offsets of each unique minizer then puts it in the offsets
 *    array. This speeds up the lookup for each kmer.
 * @param contain the main db structure
 */
void buildOffsets(struct ns * contain){

	fprintf(stderr, "INFO: Building minimier offsets.\n");


	uint64_t last = contain->data[0].min;
	uint32_t i    = 0;

	contain->ulength = 1;

	for(; i < contain->length; i++){
			if(contain->data[i].min != last){

		assert(last <= contain->data[i].min );
				last = contain->data[i].min;
				contain->ulength += 1;
		}
	}

	contain->offs =  malloc(sizeof(struct off_info)*contain->ulength);

	uint32_t end  = 0;
	uint32_t uniq = 0;

	for(i = 0 ;i < contain->length; i++){
			end = i;

			while(contain->data[i].min == contain->data[end].min){
				 	end+=1;
			 }

			contain->offs[uniq].min    = contain->data[i].min;
			contain->offs[uniq].offset = i ;
			contain->offs[uniq].count  = end - i;
			i = end -1;
			uniq +=  1;

	}

	for(i = 0; i < contain->ulength; i++){
		assert(contain->offs[i].min == contain->data[contain->offs[i].offset].min);
	}


	for(i = 1; i < contain->ulength; i++){
		assert(contain->offs[i-1].min < contain->offs[i].min);
	}
}


/**
 * [fileSketch description]
 * @param  argv [description]
 * @return      pointer to the minimizers, and the number of minimizers
 */

int fileSketch(struct ns * contain, char * filename, int ksize, int wsize)
	{
    fprintf(stderr, "INFO: Sketching minimizers from file: %s\n", filename);

	  gzFile fp;
	  kseq_t *seq;
	  int l;

	  fp = gzopen(filename, "r"); // STEP 2: open the file handler
	  seq = kseq_init(fp); // STEP 3: initialize seq
		uint32_t rid = 0;

	  while ((l = kseq_read(seq)) >= 0) { // STEP 4: read sequence
			if(seq->seq.l <= wsize){
				fprintf(stderr, "WARNING: Skipping %s : too small.\n", seq->seq.s);
				continue;
			}
			loadSeq(contain, seq, rid);

			sketch(seq->name.s, seq->seq.s,
        seq->seq.l, ksize, wsize, rid,
        &contain->data, &contain->length);

			rid++;
		}
		contain->namelen = rid;

		fprintf(stderr, "INFO: Sketched %i sequence\n", rid);
		fprintf(stderr, "INFO: Sorting minimizers\n");
		radix_sort_mr(&contain->data, contain->length);

		buildOffsets(contain);

	  kseq_destroy(seq); // STEP 5: destroy seq
	  gzclose(fp); // STEP 6: close the file handler


    fprintf(stderr, "INFO: Done sketching minimizers from file: %s\n", filename);
	  return 0;
}

int writeDB(struct ns * contain, char * filename)
{
		fprintf(stderr, "INFO: Writing minimizers to index\n");
		char db[strlen(filename)+5];
		strcpy(db, filename);
		strcat(db, ".midx");

		FILE * fn;
		fn = fopen(db, "wb");

		uint64_t magicFront = 1984;
		uint64_t magicTail  = 931 ;

		fwrite(&magicFront, sizeof(uint64_t), 1, fn);

		/* writing the names to DB */
		fwrite(&contain->namelen, sizeof(uint32_t), 1, fn);

		uint32_t i = 0;
		for(; i < contain->namelen; i++){
			fwrite(&contain->names[i].len, sizeof(uint32_t), 1, fn);
			fwrite(contain->names[i].seq, sizeof(uint8_t), contain->names[i].len, fn);
		}

		/* writing the unique offsets */
		fwrite(&contain->ulength, sizeof(uint32_t), 1, fn);
		fwrite(contain->offs,    sizeof(struct off_info), contain->ulength, fn );

		/* writing the data to the DB */
		fwrite(&contain->length, sizeof(uint64_t), 1, fn);
		fwrite(contain->data, sizeof(struct mr), contain->length, fn);
		fwrite(&magicTail, sizeof(uint64_t), 1, fn);
		fclose(fn);

    fprintf(stderr, "INFO: Wrote %i minimizers\n",  contain->length);

		return 0;
}

int readDB(struct ns * contains, char * filename){

	char db[strlen(filename)+5];
	strcpy(db, filename);
	strcat(db, ".midx");

	fprintf(stderr, "INFO: Reading minimizers index: %s\n", db);

	FILE * fn;
	fn = fopen(db, "rb");
	uint64_t magicFront;
	uint64_t magicTail;

	fread(&magicFront, sizeof(uint64_t), 1, fn);

	if(magicFront != MAGIC_HEAD){
		fprintf(stderr, "FATAL: Index is corrupt\n");
		return 1;
	}

	fread(&contains->namelen, sizeof(uint32_t), 1, fn);
	contains->names = malloc(sizeof(struct seqName)*contains->namelen);

	uint32_t i = 0;
	for(; i < contains->namelen; i++){
		fread(&contains->names[i].len, sizeof(uint32_t), 1, fn);
		contains->names[i].seq = malloc(sizeof(uint8_t)*contains->names[i].len);
		fread(contains->names[i].seq, sizeof(uint8_t), contains->names[i].len, fn);
	}


	/* reading the unique offsets */
	fread(&contains->ulength, sizeof(uint32_t), 1, fn);
	contains->offs = malloc(sizeof(struct off_info)*contains->ulength);
	fread(contains->offs, sizeof(struct off_info), contains->ulength, fn);


	fread(&contains->length, sizeof(uint64_t), 1, fn);

	contains->data = malloc(sizeof(struct mr)*contains->length);

	fread(contains->data, sizeof(struct mr), contains->length, fn);
	fread(&magicTail, sizeof(uint64_t), 1, fn);

	if(magicTail != MAGIC_TAIL){
		fprintf(stderr, "\nFATAL: Index is truncated\n");
		return 1;
	}

  fprintf(stderr, "INFO: Read %i minimizers: %s \n",  contains->length, db);

	fclose(fn);

	return 0;

}

#endif
