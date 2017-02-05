#ifndef SEARCH_H
#define SEARCH_H
#include "index.h"

/**
 * A binary search with struct offset_info vector
 * @param  a struct mr pointer
 * @param  n length of struct mr
 * @param  x midpoint
 * @return   [description]
 */
int custom_bsearch (struct off_info *a, uint32_t n, uint64_t x) {
    int i = 0, j = n - 1;
    while (i <= j) {
        int k = (i + j) / 2;
        if (a[k].min == x) {
            return k;
        }
        else if (a[k].min < x) {
            i = k + 1;
        }
        else {
            j = k - 1;
        }
    }
    return -1;
}

/**
 * Prints the seqID by converting uint8_t to char
 * @param  sInfo a pointer to a seqName struct
 * @return      NA
 */
void printSeqNames(struct seqName * sInfo){

  uint32_t i = 0;

  for(; i < sInfo->len; i++){
    printf("%c", (char)sInfo->seq[i]);
  }

}

/**
 * Loops over the query database structure and binary searches
 * the target structure for the matching minimizer.  It prints
 * the matches in the order: qSeqid tSeqid qStart tStart minimizer count.
 * @param  target [description]
 * @param  query  [description]
 * @return        1 if something is wrong, zero on success
 */
int search(struct ns * target, struct ns * query, int max)
{

  fprintf(stderr, "INFO: Searching %i by %i minimizers\n", target->length, query->length);

  uint32_t i = 0;
  uint32_t tstart = 0; uint32_t tend = 0;
  uint32_t qstart = 0; uint32_t qend = 0;

  uint32_t j = 0; uint32_t k = 0;

for(i = 1; i < query->ulength; i++){
  assert(  query->offs[i-1].min < query->offs[i].min);
}
for(i = 1; i < target->ulength; i++){
  assert(  target->offs[i-1].min < target->offs[i].min);
}

  for( i = 0; i < query->ulength; i++){

    if(query->offs[i].count > max) continue;


    int tp = custom_bsearch(target->offs, target->ulength, query->offs[i].min);

    if(tp == -1) continue;

    if(target->offs[tp].count > max) continue;

    tstart = target->offs[tp].offset;
    tend   = tstart + target->offs[tp].count - 1;

    qstart = query->offs[i].offset;
    qend   = qstart + query->offs[i].count -1;

    uint32_t t, q;

    assert(query->offs[i].min == target->offs[tp].min);

    for(j = qstart; j < qend; j++){
      q = (query->data[j].load>>32);
      for(k = tstart; k < tend; k++){

        assert(query->data[j].min == target->data[k].min);
  //      printf("%i %i\n", q, query->namelen);
        assert(q < query->namelen);


        t = (target->data[k].load>>32);
        assert(t < target->namelen);
        printSeqNames(&query->names[q]);
        printf("\t");
        printSeqNames(&target->names[t]);
        printf("\t");
        printf("%i\t%i\t%i\t%i\n", (uint32_t)query->data[j].load>>1,
        (uint32_t)target->data[k].load>>1, target->offs[tp].count, query->offs[i].count);

      }
    }
  }
  fprintf(stderr, "INFO: finished searching.\n");
  return 0;
}


#endif /* SEARCH_H */
