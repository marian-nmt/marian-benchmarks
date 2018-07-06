#!/bin/bash
grep 'Ep. ' | tail -n +2 | sed -r 's/.* ([0-9.]+) words.*/\1/'  | awk '{ total += $1; count++ } END { print total/count }'
