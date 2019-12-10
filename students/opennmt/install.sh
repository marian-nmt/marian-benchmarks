#!/bin/bash

test -d venv || python3 -m venv venv
source ./venv/bin/activate

pip3 install --upgrade pip setuptools
pip3 install OpenNMT-tf
