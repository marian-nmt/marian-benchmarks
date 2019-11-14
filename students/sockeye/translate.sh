#!/bin/bash -v

set -e
source ./venv/bin/activate

DATA=../data
MARIAN=../marian/marian-dev/build
GPUS="0"


prefix=newstest2014

cat $DATA/$prefix.spm.en | sockeye-translate --device-ids $GPUS --models model --beam-size 1 > $prefix.out.spm
# --use-cpu

cat $prefix.out.spm | $MARIAN/spm_decode --model $DATA/vocab.ende.spm > $prefix.out
sacrebleu $DATA/$prefix.de < $prefix.out | tee $prefix.out.bleu
