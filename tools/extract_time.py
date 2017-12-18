#!/usr/bin/env python

from __future__ import print_function, unicode_literals, division

import os
import sys
import argparse


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--type", help="marian/amun/nematus", required=True)
    parser.add_argument("-i", "--input", help="path to the log file", required=True)
    parser.add_argument("--wps", help="path to the source file")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()

    if args.type.startswith("marian") or args.type.startswith("amun"):
        cmd = "cat {} | tail -n2 | head -n1 | sed -r 's/.* ([0-9.]*)s wall.*/\\1/'".format(args.input)
        seconds = float(os.popen(cmd).read().strip())
    elif args.type.startswith("nematus"):
        cmd = "cat {} | grep -Po 'Time start.*: [0-9.]+' | grep -o '[0-9.]*$'".format(args.input)
        seconds_start = float(os.popen(cmd).read().strip())
        cmd = "cat {} | grep -Po 'Time end.*: [0-9.]+' | grep -o '[0-9.]*$'".format(args.input)
        seconds_end = float(os.popen(cmd).read().strip())
        seconds = seconds_end - seconds_start
    else:
        print("unknown type: {}".format(args.type))
        exit()

    if args.wps:
        cmd = "cat {} | wc -c".format(args.wps)
        words = int(os.popen(cmd).read().strip())
        print(words / seconds)
    else:
        print(seconds)
