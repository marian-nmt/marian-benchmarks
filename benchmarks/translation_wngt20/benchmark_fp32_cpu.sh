#!/bin/bash

mkdir -p benchmark_fp32_cpu
rm -rf benchmark_fp32_cpu/res

$MARIAN/marian-decoder $@ \
    --relative-paths -m model/model.npz -v model/vocab.deen.spm model/vocab.deen.spm \
    -i data/sources.shuf -o benchmark_fp32_cpu/sources.shuf.out \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 512 \
    --skip-cost --shortlist model/lex.s2t.gz 50 50 --cpu-threads 32 \
    --quiet --quiet-translation --log benchmark_fp32_cpu/speed.log

./scripts/get_bleu_score.sh benchmark_fp32_cpu
    
tail -n1 benchmark_fp32_cpu/speed.log
