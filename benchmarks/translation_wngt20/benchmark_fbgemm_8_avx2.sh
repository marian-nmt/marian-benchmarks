#!/bin/bash

mkdir -p benchmark_fbgemm8avx2_cpu
rm -rf benchmark_fbgemm8avx2_cpu/res

test -e model/model.fbgemm8_avx2.bin || $MARIAN/marian-conv -f model/model.npz -t model/model.fbgemm8_avx2.bin --gemm-type packed8avx2

$MARIAN/marian-decoder $@ \
    --relative-paths -m model/model.fbgemm8_avx2.bin -v model/vocab.deen.spm model/vocab.deen.spm \
    -i data/sources.shuf -o benchmark_fbgemm8avx2_cpu/sources.shuf.out \
    --beam-size 1 --mini-batch 32 --maxi-batch 100 --maxi-batch-sort src -w 512 \
    --skip-cost --shortlist model/lex.s2t.gz 50 50 --cpu-threads 32 \
    --quiet --quiet-translation --log benchmark_fbgemm8avx2_cpu/speed.log

./scripts/get_bleu_score.sh benchmark_fbgemm8avx2_cpu
    
tail -n1 benchmark_fbgemm8avx2_cpu/speed.log
