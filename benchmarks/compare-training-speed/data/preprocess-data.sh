#!/bin/bash -v

SRC=en
TRG=de

BPE=32000

MOSESDECODER=../../../tools/moses-scripts
SUBWORDNMT=../../../tools/subword-nmt/subword_nmt

# tokenize
for prefix in corpus valid test2014 test2015 test2016 test2017
do
    cat $prefix.$SRC \
        | $MOSESDECODER/scripts/tokenizer/normalize-punctuation.perl -l $SRC \
        | $MOSESDECODER/scripts/tokenizer/tokenizer.perl -a -l $SRC > $prefix.tok.$SRC
    test -f $prefix.$TRG || continue
    cat $prefix.$TRG \
        | $MOSESDECODER/scripts/tokenizer/normalize-punctuation.perl -l $TRG \
        | $MOSESDECODER/scripts/tokenizer/tokenizer.perl -a -l $TRG > $prefix.tok.$TRG
done

# clean empty and long sentences, and sentences with high source-target ratio (training corpus only)
mv corpus.tok.$SRC corpus.tok.uncleaned.$SRC
mv corpus.tok.$TRG corpus.tok.uncleaned.$TRG
$MOSESDECODER/scripts/training/clean-corpus-n.perl corpus.tok.uncleaned $SRC $TRG corpus.tok 1 100

# train truecaser
$MOSESDECODER/scripts/recaser/train-truecaser.perl -corpus corpus.tok.$SRC -model tc.$SRC
$MOSESDECODER/scripts/recaser/train-truecaser.perl -corpus corpus.tok.$TRG -model tc.$TRG

# apply truecaser (cleaned training corpus)
for prefix in corpus valid test2014 test2015 test2016 test2017
do
    $MOSESDECODER/scripts/recaser/truecase.perl -model tc.$SRC < $prefix.tok.$SRC > $prefix.tc.$SRC
    test -f $prefix.tok.$TRG || continue
    $MOSESDECODER/scripts/recaser/truecase.perl -model tc.$TRG < $prefix.tok.$TRG > $prefix.tc.$TRG
done

# train BPE
cat corpus.tc.$SRC corpus.tc.$TRG | $SUBWORDNMT/learn_bpe.py -s $BPE > bpe.$SRC$TRG

# apply BPE
for prefix in corpus valid test2014 test2015 test2016 test2017
do
    $SUBWORDNMT/apply_bpe.py -c bpe.$SRC$TRG < $prefix.tc.$SRC > $prefix.bpe.$SRC
    test -f $prefix.tc.$TRG || continue
    $SUBWORDNMT/apply_bpe.py -c bpe.$SRC$TRG < $prefix.tc.$TRG > $prefix.bpe.$TRG
done

rm -rf *.tok.* *.tc.*
