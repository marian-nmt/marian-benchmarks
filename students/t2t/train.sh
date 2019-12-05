#!/bin/bash -v

set -e
source ./venv/bin/activate

CUDA_VISIBLE_DEVICES=0,1 t2t-trainer --data_dir data --output_dir train \
    --t2t_usr_dir t2t_usr --problem translate_wngt19_en_de32k_spm --model transformer --hparams_set transformer_wngt19_tiny1 \
    --worker-gpu 2 --worker_gpu_memory_fraction 0.8 \
    --eval_early_stopping_metric loss --eval_early_stopping_metric_delta 0.00001 --eval_early_stopping_steps 20 \
    --local_eval_frequency 2000 \
    2>&1 | tee train.log
