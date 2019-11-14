#!/bin/bash -v

DATA=../data
MARIAN=./marian-dev/build
GPUS="0"

prefix=newstest2014

$MARIAN/marian-decoder -c model/model.npz.best-bleu-detok.npz.decoder.yml \
    -i $DATA/$prefix.en -o $DATA/$prefix.de \
    -b 1 \
    -d $GPUS -w 5000 \
   
cat $prefix.out.spm | $MARIAN/spm_decode --model $DATA/vocab.ende.spm > $prefix.out
sacrebleu $DATA/$prefix.de < $prefix.out | tee $prefix.out.bleu
