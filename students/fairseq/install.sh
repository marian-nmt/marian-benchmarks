#!/bin/bash

test -d venv || python3 -m venv venv
source ./venv/bin/activate

pip3 install --upgrade pip setuptools
pip3 install sacrebleu

# fairseq 0.8.0 doesn't seem to support CUDA 10.1 yet
# fairseq 0.9.0 returns a 'invalid syntax' error
CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.0 pip3 install fairseq==0.8.0
