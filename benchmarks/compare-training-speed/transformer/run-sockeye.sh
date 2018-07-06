#!/bin/bash

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS=$( realpath $ROOT/../tools )
DATA=$( realpath $ROOT/../data )

GPUS="-4"
MODEL=model.sockeye


mkdir -p $MODEL/train-data

test -f $MODEL/train-data/data.info || python3 -m sockeye.prepare_data \
    --source $DATA/corpus.bpe.en --target $DATA/corpus.bpe.de \
    --output $MODEL/train-data \
    > sockeye.data.log 2>&1


python3 -m sockeye.train \
    --prepared-data $MODEL/train-data \
    --output $MODEL \
    --encoder transformer --decoder transformer\
    --num-embed 512 --rnn-num-hidden 1024 --transformer-attention-heads 6:6
    --validation-source $DATA/valid.bpe.en --validation-target $DATA/valid.bpe.de \
    --max-seq-len 50 \
    --batch-size 256 \
    --max-updates 1100 --seed 1111 \
    --device-ids $GPUS \
    > sockeye.log 2>&1

bash $TOOLS/extract-wps-sockeye.sh < sockeye.log > sockeye.wps
