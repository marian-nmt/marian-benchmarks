#!/bin/sh

mkdir -p data
cd data
wget -c -N http://data.statmt.org/heafield/wngt20/test/keys.xz
wget -c -N http://data.statmt.org/heafield/wngt20/test/ref-emea.xz
wget -c -N http://data.statmt.org/heafield/wngt20/test/ref-federal.xz
wget -c -N http://data.statmt.org/heafield/wngt20/test/ref-tatoeba.xz
wget -c -N http://data.statmt.org/heafield/wngt20/test/restore.py
wget -c -N http://data.statmt.org/heafield/wngt20/test/sources.shuf.xz

unxz *.xz

cd ..
mkdir -p model
cd model
wget -c -N http://data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11/model.npz
wget -c -N http://data.statmt.org/romang/bergamot/models/deen/ende.student.tiny11/lex.s2t.gz
wget -c -N http://data.statmt.org/romang/bergamot/models/deen/vocab.deen.spm

