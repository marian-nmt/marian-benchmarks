#!/bin/bash

mkdir -p benchmark_fbgemm16_cpu
rm -rf benchmark_fbgemm16_cpu/res

test -e model/model.fbgemm16.bin || $MARIAN/marian-conv -f model/model.npz -t model/model.fbgemm16.bin --gemm-type packed16

$MARIAN/marian-decoder $@ \
    --relative-paths -m model/model.fbgemm16.bin -v model/vocab.deen.spm model/vocab.deen.spm \
    -i data/sources.shuf -o benchmark_fbgemm16_cpu/sources.shuf.out \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 512 \
    --skip-cost --shortlist model/lex.s2t.gz 50 50 --cpu-threads 32 \
    --quiet --quiet-translation --log benchmark_fbgemm16_cpu/speed.log

./scripts/get_bleu_score.sh benchmark_fbgemm16_cpu    

tail -n1 benchmark_fbgemm16_cpu/speed.log
