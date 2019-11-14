#!/bin/bash -v

# https://fairseq.readthedocs.io/en/latest/models.html#module-fairseq.models.transformer

mkdir -p checkpoints

CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.0 CUDA_VISIBLE_DEVICES=0,1 \
    fairseq-train data-bin \
        --save-dir checkpoints --num-workers 4 --save-interval-updates 5000 \
        --arch transformer_wmt_en_de \
        --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
        --lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 --warmup-updates 8000 --lr 0.0003 --min-lr 1e-09 \
        --max-tokens 8192 \
        --encoder-layers 6 --encoder-embed-dim 256 --encoder-ffn-embed-dim 1536 --encoder-attention-heads 8 --activation-fn relu \
        --decoder-layers 1 --decoder-embed-dim 256 --decoder-ffn-embed-dim 1536 --decoder-attention-heads 8 \
        --share-all-embeddings \
        --criterion label_smoothed_cross_entropy
