#!/bin/bash -v

test -d venv || python3 -m venv venv
source ./venv/bin/activate
pip3 install --upgrade pip setuptools
pip3 install sacrebleu
# TensorFlow 1.15 includes both tensorflow and tensorflow-gpu in a single package
pip3 install tensorflow==1.15
pip3 install tensor2tensor
