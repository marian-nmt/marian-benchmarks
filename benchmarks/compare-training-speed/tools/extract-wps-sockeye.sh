#!/bin/bash
grep 'Epoch\[0\]' | tail -n +2 | sed -r 's/.* ([0-9.]+) tokens.*/\1/' | awk '{ total += $1; count++ } END { print total/count }'
