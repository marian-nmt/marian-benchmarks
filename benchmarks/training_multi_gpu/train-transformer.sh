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

test -e vocab.ende.yml || cat $EXAMPLES/transformer/data/corpus.bpe.{en,de} \
    | $MARIAN/build/marian-vocab --max-size 36000 > vocab.ende.yml

$MARIAN/build/marian --devices $GPUS \
    --model $MODEL/model.npz --type transformer \
    --train-sets $EXAMPLES/transformer/data/corpus.bpe.{en,de} \
    --vocabs vocab.ende.yml vocab.ende.yml \
    --disp-freq 500 --after-batches 3000 \
    --log $MODEL/train.log \
    $ARGS \
    --max-length 100 \
    --mini-batch-fit -w 8000 --maxi-batch 1000 \
    --cost-type=ce-mean-words \
    --enc-depth 6 --dec-depth 6 \
    --transformer-heads 8 \
    --transformer-postprocess-emb d \
    --transformer-postprocess dan \
    --transformer-dropout 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all \
    --exponential-smoothing
