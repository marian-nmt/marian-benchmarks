#!/bin/bash -v

test -d venv || python3 -m venv venv
source ./venv/bin/activate
pip3 install --upgrade pip setuptools
pip3 install sacrebleu

# fairseq doesn't seem to support CUDA 10.1 yet
CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.0 pip3 install fairseq
