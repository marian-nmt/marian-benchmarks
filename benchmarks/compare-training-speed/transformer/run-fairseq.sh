#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS=$( realpath $ROOT/../tools )
DATA=$( realpath $ROOT/../data )

GPUS="0 1 2 3"
MODEL=model.fairseq


mkdir -p $MODEL

test -f $MODEL/train-data/train.en-de.de.bin || python3.6 $TOOLS/fairseq/preprocess.py \
    --source-lang en --target-lang de \
    --trainpref $DATA/corpus.bpe --validpref $DATA/valid.bpe \
    --destdir $MODEL/train-data
    > fairseq.data.log 2>&1


CUDA_VISIBLE_DEVICES=0,1,2,3 python3.6 $TOOLS/fairseq/train.py \
    $MODEL/train-data \
    --save-dir $MODEL \
    --arch transformer_wmt_en_de \
    \
    \
    \
    --batch-size 256 --optimizer adam \
    --log-interval 100 --max-update 1100 --seed 1111 \
    --device-id $GPUS \
    > fairseq.log 2>&1

bash $TOOLS/extract-wps-fairseq.sh < fairseq.log > fairseq.wps
