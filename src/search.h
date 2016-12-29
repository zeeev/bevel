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

  fprintf(stderr, "INFO: searching %i by %i kmers\n", target->length, query->length);

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

    for(j = start; j <= end; j++){
      printf("%i\t%i\t%i\n",   (uint32_t)query->data[i].load>>1,
      (uint32_t)target->data[j].load>>1, end - start +1);
    }
  }

  return 0;
}


#endif /* SEARCH_H */
