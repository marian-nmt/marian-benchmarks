#!/bin/bash

mkdir -p benchmark_intgemm8_cpu
rm -rf benchmark_intgemm8_cpu/res

test -e model/model.intgemm8.bin || $MARIAN/marian-conv -f model/model.npz -t model/model.intgemm8.bin --gemm-type intgemm8

$MARIAN/marian-decoder $@ \
    --relative-paths -m model/model.intgemm8.bin -v model/vocab.deen.spm model/vocab.deen.spm \
    -i data/sources.shuf -o benchmark_intgemm8_cpu/sources.shuf.out \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 512 \
    --skip-cost --shortlist model/lex.s2t.gz 50 50 --cpu-threads 32 \
    --quiet --quiet-translation --log benchmark_intgemm8_cpu/speed.log

./scripts/get_bleu_score.sh benchmark_intgemm8_cpu

tail -n1 benchmark_intgemm8_cpu/speed.log
