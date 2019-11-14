#!/bin/bash -v

pip3 install sacrebleu --user

test -d marian-dev && exit

git clone https://github.com/marian-nmt/marian-dev
mkdir -p marian-dev/build
cd marian-dev/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_SENTENCEPIECE=ON
make -j
cd -
