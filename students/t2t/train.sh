#!/bin/bash -v

set -e
source ./venv/bin/activate

# the problem is defined in t2t_usr/wngt19.py
# the hparams_set is defined in https://github.com/tensorflow/tensor2tensor/blob/master/tensor2tensor/models/transformer.py#L1930

CUDA_VISIBLE_DEVICES=0,1,2,3 t2t-trainer --data_dir data --output_dir train \
    --t2t_usr_dir t2t_usr --problem translate_wngt19_en_de32k_spm --model transformer --hparams_set transformer_base \
    --worker-gpu 4 --worker_gpu_memory_fraction 0.8 \
    2>&1 | tee train.log
