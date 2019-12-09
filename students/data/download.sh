#!/bin/bash -v

wget -nc http://data.statmt.org/romang/wngt/data/wngt19.train.tgz
tar zxvf wngt19.train.tgz
mv noisybt.merge.train.4.filtered.en train.en
mv noisybt.merge.train.4.filtered.de train.de

wget -nc http://data.statmt.org/romang/wngt/data/wngt19.train.spm.tgz
tar zxvf wngt19.train.spm.tgz
mv noisybt.merge.train.4.filtered.spm.en train.spm.en
mv noisybt.merge.train.4.filtered.spm.de train.spm.de
