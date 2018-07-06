#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS=$( realpath $ROOT/../tools )
DATA=$( realpath $ROOT/../data )

GPUS="-1"
MODEL=model.sockeye


mkdir -p $MODEL/train-data

test -f $MODEL/train-data/data.info || python3 -m sockeye.prepare_data \
    --source $DATA/corpus.bpe.en --target $DATA/corpus.bpe.de \
    --output $MODEL/train-data \
    > sockeye.data.log 2>&1


python3 -m sockeye.train \
    --device-ids $GPUS \
    --output $MODEL \
    --encoder rnn --decoder rnn \
    --num-embed 512 --rnn-num-hidden 1024 --rnn-attention-type dot \
    --prepared-data $MODEL/train-data \
    --validation-source $DATA/valid.bpe.en --validation-target $DATA/valid.bpe.de \
    --max-seq-len 50 \
    --batch-size 256 \
    --max-updates 1100 --seed 1111 \
    > sockeye.log 2>&1
