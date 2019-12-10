#!/bin/bash

set -e
source ./venv/bin/activate

DATA=../data
MARIAN=../marian/marian-dev/build

# https://github.com/OpenNMT/OpenNMT-tf/tree/v2.0.0/scripts/wmt

# Extract textual vocabulary from SentencePiece
$MARIAN/spm_export_vocab --model $DATA/vocab.ende.spm > vocab.ende.txt

# Generate vocab for OpenNMT
onmt-build-vocab --from_format sentencepiece --from_vocab vocab.ende.txt --save_vocab vocab.ende.onmt

