#!/bin/bash

set -e
source ./venv/bin/activate

DATA=../data
GPUS="0 1"

mkdir -p model 

# https://github.com/awslabs/sockeye/blob/7fd7f152a2480ecf10683f71a89f7519fe7fbc06/sockeye_contrib/autopilot/models.py#L28 

sockeye-train --device-ids $GPUS \
    --source $DATA/train.spm.en --target $DATA/train.spm.de --max-seq-len 150:150 \
    --shared-vocab --num-words 32000:32000 \
    --validation-source $DATA/valid.spm.en --validation-target $DATA/valid.spm.de \
    --output model \
    --encoder transformer --decoder transformer --num-layers 6:1 --num-embed 256:256 \
    --transformer-model-size 256 --transformer-attention-heads 8 --transformer-feed-forward-num-hidden 1536 \
    --transformer-preprocess "" --transformer-postprocess drn \
    --transformer-dropout-attention 0 --transformer-dropout-act 0 --transformer-dropout-prepost 0 --label-smoothing 0 \
    --weight-tying --weight-tying-type src_trg_softmax \
    --weight-init xavier --weight-init-scale 3.0 --weight-init-xavier-factor-type avg \
    --gradient-clipping-threshold -1 \
    --initial-learning-rate 0.0003 --batch-type word --batch-size 8192 \
    --learning-rate-reduce-num-not-improved 8 --learning-rate-reduce-factor 0.9 --learning-rate-scheduler-type plateau-reduce --learning-rate-decay-optimizer-states-reset best --learning-rate-decay-param-reset \
    --optimizer adam --optimized-metric bleu \
    --checkpoint-interval 5000 --max-num-checkpoint-not-improved 20 --checkpoint-frequency 5000 --decode-and-evaluate 500 --keep-last-params 60 \
    2>&1 | tee train.log
