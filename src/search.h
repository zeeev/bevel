#ifndef SEARCH_H
#define SEARCH_H
#include "index.h"

/**
 * A binary search with struct mr vector
 * @param  a struct mr pointer
 * @param  n length of struct mr
 * @param  x midpoint
 * @return   [description]
 */
int custom_bsearch (struct mr *a, uint32_t n, uint64_t x) {
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
int search(struct ns * target, struct ns * query)
{

  fprintf(stderr, "INFO: Searching %i by %i minimizers\n", target->length, query->length);

  uint32_t i = 0;
  uint32_t j = 0;

  uint64_t currentMin = 0;

  for(; i < query->length; i++){
    if(query->data[i].min == currentMin) continue;
    currentMin = query->data[i].min;
    int p = custom_bsearch(target->data, target->length, query->data[i].min);

    if(p == -1) continue;

    uint32_t start = p, end = p;

    while(start > 1){
      if(target->data[start - 1].min != currentMin) break;
      start--;
    }
    while(end < target->length - 1){
      if(target->data[end + 1].min != currentMin) break;
      end++;
    }


    uint64_t t, q;

    for(j = start; j <= end; j++){

      q = query->data[i].load>>32;
      t = target->data[i].load>>32;

      printSeqNames(&query->names[q]);
      printf("\t");
      printSeqNames(&target->names[t]);
      printf("\t");
      printf("%i\t%i\t%i\t%i\t%i\n",   (uint32_t)query->data[i].load>>1,
      (uint32_t)target->data[j].load>>1, end - start +1,
      (uint32_t)query->data[i].load & 1, (uint32_t)target->data[i].load & 1);
    }
  }

  return 0;
}


#endif /* SEARCH_H */
