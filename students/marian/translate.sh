#!/bin/bash -v

DATA=../data
MARIAN=./marian-dev/build
GPUS="0"

prefix=newstest2014

$MARIAN/marian-decoder -c model/model.npz.best-bleu-detok.npz.decoder.yml \
    -i $DATA/$prefix.en -o $prefix.out \
    -b 1 \
    -d $GPUS -w 500 \
   
sacrebleu --force $DATA/$prefix.de < $prefix.out | tee $prefix.out.bleu
