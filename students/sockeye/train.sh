#!/bin/bash

set -e
source ./venv/bin/activate

DATA=../data
GPUS="4 5 6 7"

mkdir -p model 

# https://github.com/awslabs/sockeye/blob/7fd7f152a2480ecf10683f71a89f7519fe7fbc06/sockeye_contrib/autopilot/models.py#L28 

sockeye-train --device-ids $GPUS \
    --source $DATA/train.spm.en --target $DATA/train.spm.de --max-seq-len 200:200 \
    --shared-vocab --num-words 32000:32000 \
    --validation-source $DATA/valid.spm.en --validation-target $DATA/valid.spm.de \
    --output model \
    --encoder transformer --decoder transformer --num-layers 6:6 --num-embed 512:512 \
    --transformer-model-size 512 --transformer-attention-heads 8 --transformer-feed-forward-num-hidden 2048 \
    --transformer-preprocess "" --transformer-postprocess drn \
    --transformer-dropout-attention 0 --transformer-dropout-act 0 --transformer-dropout-prepost 0.1 --label-smoothing 0.1 \
    --weight-tying --weight-tying-type src_trg_softmax \
    --weight-init xavier --weight-init-scale 3.0 --weight-init-xavier-factor-type avg \
    --gradient-clipping-threshold -1 \
    --initial-learning-rate 0.0003 --batch-type word --batch-size 8192 \
    --learning-rate-scheduler-type fixed-rate-inv-sqrt-t --learning-rate-warmup 8000 \
    --optimizer adam --optimized-metric bleu \
    --checkpoint-interval 5000 --max-num-checkpoint-not-improved 20 --checkpoint-frequency 5000 --decode-and-evaluate 500 --keep-last-params 60 \
    2>&1 | tee train.log

# @TODO: figure out learning rate schedule