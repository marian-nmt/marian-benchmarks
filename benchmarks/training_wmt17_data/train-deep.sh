#!/bin/bash -v

export LC_ALL=C.UTF-8

MARIAN=../../tools/marian
DATA=../../models/wmt17_data
MODEL=model.deep

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
    --cost-type ce-mean-words \
    --log $LOGFILE --valid-log $MODEL/valid.log \
    --tied-embeddings-all --layer-normalization \
    --dropout-rnn 0.1 --label-smoothing 0.1 \
    --exponential-smoothing \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --enc-type bidirectional --enc-depth 1 --enc-cell-depth 4 \
    --dec-depth 1 --dec-cell-base-depth 8 --dec-cell-high-depth 1 \
    --learn-rate 0.0003 --lr-report \
    --seed 1111
