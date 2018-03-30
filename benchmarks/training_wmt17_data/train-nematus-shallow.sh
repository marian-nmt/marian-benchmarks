#!/bin/bash -v

export LC_ALL=C.UTF-8


MARIAN=../../tools/marian
NEMATUS=../../tools/nematus
DATA=$(realpath ../../models/wmt17_data)
MODEL=$(realpath nematus.shallow)

LOGFILE=$1
shift
GPUS=$@

test -e $MODEL/model.npz && exit

mkdir -p $MODEL
test -e vocab.ende.yml || cat $DATA/all.bpe.{en,de} | $MARIAN/build/marian-vocab --max-size 36000 > vocab.ende.yml
test -e vocab.ende.json || python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' < vocab.ende.yml > vocab.ende.json

CUDA_VISIBLE_DEVICES=$GPUS THEANO_FLAGS=mode=FAST_RUN,floatX=float16,device=cuda0=0.8 python $NEMATUS/nematus/nmt.py \
    --model $MODEL/model.npz \
    --datasets $DATA/all.bpe.{de,en} \
    --dictionaries vocab.ende.json vocab.ende.json \
    --reload \
    --dim_word 512 \
    --dim 1024 \
    --lrate 0.0001 \
    --optimizer adam \
    --maxlen 100 \
    --batch_size 155 \
    --dispFreq 100 \
    --tie_decoder_embeddings \
    --layer_normalisation \
    --max_epochs 1

