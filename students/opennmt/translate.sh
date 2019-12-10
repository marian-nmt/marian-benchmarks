#!/bin/bash -v

set -e
source ./venv/bin/activate

DATA=../data
MARIAN=../marian/marian-dev/build
GPUS="0"

# Run if the training was not left to run until completion
# onmt-main --config wngt_ende.yml --auto_config average-checkpoints --output_dir wngt_ende_transformer/avg --max_count 5

prefix=newstest2014

CUDA_VISIBLE_DEVICES=$GPUS onmt-main --config wmt_ende.yml --auto_config --checkpoint_path wngt_ende_transformer/avg \
    infer --features_file $DATA/$prefix.spm.en > $prefix.out.spm

cat $prefix.out.spm | $MARIAN/spm_decode --model $DATA/vocab.ende.spm > $prefix.out
sacrebleu --force $DATA/$prefix.de < $prefix.out | tee $prefix.out.bleu
