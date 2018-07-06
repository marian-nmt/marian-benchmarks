#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS=$( realpath $ROOT/../tools )
DATA=$( realpath $ROOT/../data )

GPUS="0 1 2 3"
MODEL=model.marian

mkdir -p $MODEL


$TOOLS/marian/build/marian \
    --train-sets $DATA/corpus.bpe.{en,de} --vocabs $MODEL/vocab.en.yml $MODEL/vocab.de.yml \
    --model $MODEL/model.npz \
    --type transformer \
    --tied-embeddings-all --enc-depth 6 --dec-depth 6 ----label-smoothing 0.1 \
    --learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --mini-batch-fit -w 8000 --mini-batch 1000 --maxi-batch 1000 --sync-sgd \
    --disp-freq 100 --after-batches 1100 --seed 1111 \
    --devices $GPUS \
    > marian.log 2>&1

bash $TOOLS/extract-wps-marian.sh < marian.log > marian.wps
