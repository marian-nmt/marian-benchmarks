#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS=$( realpath $ROOT/../tools )
DATA=$( realpath $ROOT/../data )

GPUS="0"
MODEL=model-marian

mkdir -p $MODEL

$TOOLS/marian/build/marian \
    --devices $GPUS \
    --type s2s \
    --model $MODEL/model.npz --train-sets $DATA/corpus.bpe.{en,de} \
    --vocabs $DATA/vocab.{yml,yml} \
    --mini-batch-fit -w 8000 \
    --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
    --disp-freq 100 --after-batches 1100 \
    --log $MODEL/train.log \
    --seed 1111 \
    > marian.log 2>&1

