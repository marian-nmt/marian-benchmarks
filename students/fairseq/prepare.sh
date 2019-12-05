#!/bin/bash -v

DATA=../data

fairseq-preprocess --source-lang en --target-lang de \
    --trainpref $DATA/train.spm --validpref $DATA/valid.spm \
    --testpref $DATA/newstest2014.spm --destdir data-bin \
    --nwordssrc 32000 --nwordstgt 32000 \
    --joined-dictionary \
    --workers 16
