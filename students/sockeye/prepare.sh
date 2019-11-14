#!/bin/bash -v

DATA=../data

sockeye-prepare-data --source-lang en --target-lang de \
    --trainpref $DATA/train.4.spm --validpref $DATA/valid.spm --testpref $DATA/newstest2014.spm \
    --destdir data-bin \
    --joined-dictionary \
    --workers 16
