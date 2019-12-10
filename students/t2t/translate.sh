#!/bin/bash -x

set -e
source ./venv/bin/activate

DATA=../data
MARIAN=../marian/marian-dev/build
GPUS="0"


prefix=newstest2014

CUDA_VISIBLE_DEVICES=$GPUS \
    t2t-decoder --data_dir data --output_dir train \
    --t2t_usr_dir t2t_usr --problem translate_wngt19_en_de32k_spm --model transformer --hparams_set transformer_base \
    --decode_hparams "beam_size=4,alpha=0.6" --decode_from_file $DATA/$prefix.en --decode_to_file $prefix.out.spm \
    --worker_gpu_memory_fraction 0.8

cat $prefix.out.spm | $MARIAN/spm_decode --model $DATA/vocab.ende.spm > $prefix.out
sacrebleu --force $DATA/$prefix.de < $prefix.out | tee $prefix.out.bleu
