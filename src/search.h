#ifndef SEARCH_H
#define SEARCH_H
#include "index.h"

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

int search(struct ns * target, struct ns * query)
{

  printf("INFO: searching %i by %i kmers\n", target->length, query->length);

  uint32_t i = 0;

  for(; i < query->length; i++){
    int p = custom_bsearch(target->data, target->length, query->data[i].min);
    printf("index: %i\n", p);
  }


  return 0;
}


#endif /* SEARCH_H */
