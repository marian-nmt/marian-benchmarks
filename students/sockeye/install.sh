#!/bin/bash

test -d venv || python3 -m venv venv
source ./venv/bin/activate

pip3 install --upgrade pip setuptools
pip3 install numpy==1.14
pip3 install sacrebleu
pip3 install mxnet-cu101
pip3 install sockeye --no-deps
