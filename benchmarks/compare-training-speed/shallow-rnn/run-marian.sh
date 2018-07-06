#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS=$( realpath $ROOT/../tools )
DATA=$( realpath $ROOT/../data )

GPUS="0"
MODEL=model.marian

mkdir -p $MODEL


$TOOLS/marian/build/marian \
    --devices $GPUS \
    --model $MODEL/model.npz \
    --type s2s \
    --dim-emb 512 --dim-rnn 1024 \
    --train-sets $DATA/corpus.bpe.{en,de} --vocabs $MODEL/vocab.en.yml $MODEL/vocab.de.yml \
    --max-length 50 \
    --batch-size 256 -w 8000 \
    --disp-freq 100 --after-batches 1100 --seed 1111 \
    --log $MODEL/train.log \
    > marian.log 2>&1

