#!/bin/bash

set -e
source ./venv/bin/activate

# https://github.com/pytorch/fairseq/issues/346
# https://fairseq.readthedocs.io/en/latest/models.html#module-fairseq.models.transformer

mkdir -p checkpoints

CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.0 CUDA_VISIBLE_DEVICES=0,1,2,3 \
    fairseq-train data-bin \
        --arch transformer_wmt_en_de \
        --encoder-layers 6 --encoder-embed-dim 512 --encoder-ffn-embed-dim 2048 --encoder-attention-heads 8 --activation-fn relu \
        --decoder-layers 6 --decoder-embed-dim 512 --decoder-ffn-embed-dim 2048 --decoder-attention-heads 8 \
        --share-all-embeddings \
        --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
        --lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 --warmup-updates 4000 --lr 0.0007 --min-lr 1e-09 \
        --dropout 0.1 \
        --criterion label_smoothed_cross_entropy --label-smoothing 0.1 --weight-decay 0.0 \
        --max-tokens 4096 \
        --save-dir checkpoints --save-interval-updates 1000 --keep-interval-updates 20 --no-progress-bar --log-interval 50
