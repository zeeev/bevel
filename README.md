# bevel
Working toward a probabilistic MSA tool 

## install 
cd bevel && make

## running dotplot

To produce all minimizer matches across two sequences:

```
bin/bevel target.fa query.fa
```

Building a database (decreases runtime)

```
bin/bevel -d target.fa
```

## output

The output is a five column TSV that is written to STDOUT:



|  query Seqid | target Seqid  | query Start | targetStart | number of minimizers found in target  |
| ------------ | ------------- | ----------- | ----------- | --------------------------------------|
