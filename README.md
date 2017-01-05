
# ![alt tag](https://github.com/zeeev/bevel/blob/master/images/logo.png =250x)

Bevel is a sequence similarity search tool that uses a minimizer database.  Minimizers are representative kmers across a window of kmers.  Two databases can be queried against each other, resulting in a list of positions where two or more sequences match. 

The  code headers ```index.h``` and ```search.h``` have minimal dependences and can easily be incorporated into other software.  The snippet below shows how to use the database.

```
struct ns * tDB = db_init();
struct ns * qDB = db_init();

loadOrBuild(tDB, “fasta.fa|fq”);
loadOrBuild(qDB, “fasta.fa|fq”);

search(tDB, qDB);
```

The inspiration and much of the code comes from minimap.  If you find this code useful please cite:
```
Li, Heng. "Minimap and miniasm: fast mapping and de novo assembly for noisy long sequences." 
    Bioinformatics (2016): btw152.
```

## install 
cd bevel && make

## running

To produce all minimizer matches across two sequences:

```
bin/bevel target.fa query.fa
```

## options 

```
    -d <FLAG> Write databases to files
    -w <INT>  Save every Nth minimizer [100]
    -k <INT>  Minimizer size (up to 32) [17]
```

1. -d - Write the database to a file decreasing subsequent queries.
2. -w - Save a minimizer every [w] kmers.
3. -k - Minimizer size.  

## output

The output is a five column TSV that is written to STDOUT:




|  query Seqid | target Seqid  | query Start | target Start | number of minimizers found in target  | query strand (+ = 0) | target strand (+ = 0)| 
| ------------ | ------------- | ----------- | ------------ | --------------------------------------| -------------------- | -------------------- | 


 
