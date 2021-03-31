#!/bin/bash

data/restore.py data/keys $1/res < $1/sources.shuf.out

cd $1/res

i=$((0))
for c in federal emea tatoeba; do
    sacrebleu --score-only --force ../../data/ref-$c < $c > $c.sacre &
    pids[${i}]=$!
    i=$(($i+1))
done

for t in wmt10 wmt11 wmt13 wmt14 wmt15 wmt16 wmt17 wmt18 wmt19; do
    sacrebleu -t $t -l en-de --score-only < $t > $t.sacre &
    pids[${i}]=$!
    i=$(($i+1))
done

for pid in ${pids[*]}; do
    wait $pid
done

cat *.sacre > bleu.all
echo "Average BLEU score is:" `awk '{ total += $1; count++ } END { print total/count }' bleu.all`
