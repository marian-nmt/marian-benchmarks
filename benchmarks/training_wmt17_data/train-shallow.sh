#!/bin/bash -v

export LC_ALL=C.UTF-8

MARIAN=../../tools/marian
DATA=../../models/wmt17_data
MODEL=model.shallow

WORKSPACE=6000

LOGFILE=$1
shift
GPUS=$@


test -e $MODEL/model.npz && exit

mkdir -p $MODEL
test -e vocab.ende.yml || cat $DATA/all.bpe.{en,de} | $MARIAN/build/marian-vocab --max-size 36000 > vocab.ende.yml

$MARIAN/build/marian \
    --devices $GPUS \
    --model $MODEL/model.npz --type s2s \
    --train-sets $DATA/all.bpe.{de,en} \
    --vocabs vocab.ende.yml vocab.ende.yml \
    --max-length 100 \
    --mini-batch-fit -w $WORKSPACE --mini-batch 1000 --maxi-batch 1000 \
    --disp-freq 500 --after-batches 3000 \
    --cost-type=ce-mean-words \
    --log $MODEL/train.log --valid-log $MODEL/valid.log \
    --tied-embeddings-all --layer-normalization \
    --exponential-smoothing \
    --seed 1111
