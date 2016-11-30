#include <stdio.h>
#include <zlib.h>
#include "kseq.h"
#include <assert.h>
#include <inttypes.h>

struct kp{
	uint64_t km[2];
};

struct mr{
	uint64_t   min;
	uint32_t  load;
	uint8_t strand;
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
	printf(" min: %" PRId64 "\n", m->min);
	printf(" load: %i\n", m->load);
	printf(" strand: %i\n", m->strand);
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
	int len, int k, int w, uint32_t rid){
  uint64_t shift1 = 2 * (k - 1), mask = (1ULL << 2*k);

	struct kp kmers;

	uint64_t wa = 0, cr = 0, min = 0;
	uint8_t strand = 0;

	kmers.km[0] = 0; kmers.km[1] = 0;

  assert(len > 0 && w > 0 && k > 0 && len > k && len > w && k < 64/2);

  int i = 0, l = 0, n = 0;
	int s = (int)len/(float)w ;

	struct mr * buffer = (struct mr *) malloc( sizeof(struct mr) * s);

	for(;i < s; i++){
		buffer[i].min     = UINT64_MAX;
		buffer[i].strand  = 0         ;
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
				buffer[n].strand = strand;
			}
		}
	}
	printf("seq: %s min: %i\n", name, n);
	for(i = 0; i < 10; i++){
		print_mr(&buffer[i]);
	}
}

KSEQ_INIT(gzFile, gzread)

int main(int argc, char *argv[])
{
  gzFile fp;
  kseq_t *seq;
  int l;
  if (argc == 1) {
    fprintf(stderr, "Usage: %s <in.seq>\n", argv[0]);
   return 1;
 }
  fp = gzopen(argv[1], "r"); // STEP 2: open the file handler
  seq = kseq_init(fp); // STEP 3: initialize seq
  while ((l = kseq_read(seq)) >= 0) { // STEP 4: read sequence
		sketch(seq->name.s, seq->seq.s, seq->seq.l, 10, 5, 8);
	}
  kseq_destroy(seq); // STEP 5: destroy seq
  gzclose(fp); // STEP 6: close the file handler
  return 0;
}
