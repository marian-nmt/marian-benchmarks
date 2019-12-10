#!/bin/bash -v

set -e
source ./venv/bin/activate

DATA=../data
GPUS="0"


# https://github.com/pytorch/fairseq/tree/master/examples/translation
prefix=newstest2014

CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.0 CUDA_VISIBLE_DEVICES=$GPUS \
    fairseq-interactive data-bin --path checkpoints/checkpoint_best.pt \
        --buffer-size 2000 --batch-size 32 --beam 1 \
        --input $DATA/$prefix.spm.en --remove-bpe sentencepiece \
        > $prefix.out.sys

cat $prefix.out.sys | grep ^H | cut -f3 > $prefix.out
sacrebleu --force $DATA/$prefix.de < $prefix.out | tee $prefix.out.bleu
