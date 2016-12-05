#include <stdio.h>
#include <zlib.h>
#include "kseq.h"
#include <assert.h>
#include <inttypes.h>

struct kp{
	uint64_t km[2];
};

struct mr{
	uint64_t min, load;
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


static inline print_mr(struct mr * m){
	printf("minimizer:\n");
	printf(" min: %" PRIu64    "\n",  m->min);
	printf(" load: %" PRIu64   "\n",  m->load );
	printf(" strand: %" PRIu64 "\n",  m->load & 1);
	printf(" rid: %" PRIu64    "\n",  m->load>>32 );
	printf(" pos: %i"     "\n",  (uint32_t)m->load>>1 );


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
									int  * datumSize ){

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

  for(i = 0; i < len; i++){
		int c = seq_nt4_table[(uint8_t)seq[i]];
		if(c < 4){
			kmers.km[0] = (kmers.km[0] << 2  | c ) & mask        ;
			kmers.km[1] = (kmers.km[1] >> 2) | (3ULL^c) << shift1;
			j++;
		}
		if(j >= k && i >= l){
			if(kmers.km[0] == kmers.km[1]) continue;
			wa = hash64(kmers.km[0], mask);
			cr = hash64(kmers.km[1], mask);
			strand = wa > cr ? 0 : 1;
			if(buffer[n].min > kmers.km[strand]){
				buffer[n].min  = kmers.km[strand];
				buffer[n].load = (uint64_t)rid<<32 | (uint32_t)i<<1 | strand;
			}
			j = 0;
			l = i + w;
			n += 1;
		}
	}
	printf("seq: %s has %i minimizers\n", name, n );

	*data = (struct mr *) realloc(*data, (n + (*datumSize)) * sizeof(struct mr));

	for(i = 0; i < n; i++){
		(*data)[i + (*datumSize)].load = buffer[i].load;
		(*data)[i + (*datumSize)].min  = buffer[i].min;
	}
	*datumSize += n;
	free(buffer);
}

KSEQ_INIT(gzFile, gzread)

int main(int argc, char *argv[])
{
	int nMinimizers = 0;
	struct mr * kmers_and_positions = 0;
	kmers_and_positions = (struct mr*)malloc(sizeof(struct mr));

  gzFile fp;
  kseq_t *seq;
  int l;
  if (argc == 1) {
    fprintf(stderr, "Usage: %s <in.seq>\n", argv[0]);
   return 1;
 }
  fp = gzopen(argv[1], "r"); // STEP 2: open the file handler
  seq = kseq_init(fp); // STEP 3: initialize seq
	uint32_t rid = 0;

  while ((l = kseq_read(seq)) >= 0) { // STEP 4: read sequence
		sketch(seq->name.s, seq->seq.s, seq->seq.l, 17, 50, rid, &kmers_and_positions, &nMinimizers);
		rid++;
	}
  kseq_destroy(seq); // STEP 5: destroy seq
  gzclose(fp); // STEP 6: close the file handler
  return 0;
}
