#!/bin/bash -v

export LC_ALL=C.UTF-8

MARIAN=../../tools/marian
EXAMPLES=../../marian-examples

MODEL=$1
GPUS=$(seq 0 $2)
ARGS=$3

echo "Using GPUs $GPUS"

test -e $MODEL/model.npz && exit

mkdir -p $MODEL
test -e vocab.ro.yml || $MARIAN/build/marian-vocab < $EXAMPLES/training-basics/data/corpus.bpe.ro > vocab.ro.yml
test -e vocab.en.yml || $MARIAN/build/marian-vocab < $EXAMPLES/training-basics/data/corpus.bpe.en > vocab.en.yml


$MARIAN/build/marian --devices $GPUS \
    --model $MODEL/model.npz --type s2s \
    --train-sets $EXAMPLES/training-basics/data/corpus.bpe.{ro,en} \
    --vocabs vocab.{ro,en}.yml \
    --dim-vocabs 66000 50000 \
    --disp-freq 500 --after-batches 3000 \
    --log $MODEL/train.log \
    $ARGS \
    --mini-batch-fit -w 8000 \
    --layer-normalization --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1
