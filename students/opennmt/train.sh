#!/bin/bash

set -e
source ./venv/bin/activate

# https://github.com/OpenNMT/OpenNMT-tf/tree/v2.0.0/scripts/wmt

CUDA_VISIBLE_DEVICES=0,1,2,3 \
    onmt-main --model_type Transformer --config wngt-ende.yml --auto_config train --with_eval --num_gpus 4 \
        2>&1 | tee train.log

