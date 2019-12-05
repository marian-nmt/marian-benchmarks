#!/bin/bash -v

DATA=../data
MARIAN=./marian-dev/build
GPUS="0 1"

mkdir -p model tmp

$MARIAN/marian \
    --model model/model.npz \
    --type transformer --enc-depth 6 --dec-depth 1 --enc-cell gru --dec-cell gru --dim-emb 256 \
    --transformer-dim-ffn 1536 --transformer-ffn-activation relu --transformer-ffn-depth 2 --transformer-heads 8 \
    --transformer-preprocess --transformer-postprocess dan \
    --train-sets $DATA/train.4.{en,de}.gz -T tmp --shuffle-in-ram \
    --vocabs $DATA/vocab.{ende,ende}.spm --tied-embeddings-all \
    --max-length 200 \
    --mini-batch-fit -w 9000 --mini-batch 1000 --maxi-batch 1000 --devices $GPUS --sync-sgd \
    --cost-type ce-mean-words \
    --learn-rate 0.0003 --lr-report --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --optimizer-params 0.9 0.98 1e-09 --clip-norm 0 \
    --valid-metrics bleu-detok ce-mean-words perplexity \
    --valid-sets $DATA/valid.{en,de} --valid-translation-output model/valid.out --quiet-translation \
    --valid-mini-batch 16 --beam-size 1 --normalize 0.6 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 1000 --disp-first 10 \
    --early-stopping 20 \
    --overwrite --keep-best \
    --exponential-smoothing \
    --log train.log --valid-log valid.log
