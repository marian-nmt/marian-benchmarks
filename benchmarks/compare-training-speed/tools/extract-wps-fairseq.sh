#!/bin/bash
grep 'epoch 001:' | tail -n +2 | sed -r 's/.*wps=([0-9.]+),.*/\1/' | awk '{ total += $1; count++ } END { print total/count }'
