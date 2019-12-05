#!/usr/bin/env python3

import sys
import argparse
import numpy as np
import yaml


DESC = "Prints total number of parameters in model.npz"
S2S_SPECIAL_NODE = "special:model.yml"


def main():
    args = parse_args()

    print("Loading {}".format(args.model))
    model = np.load(args.model)

    count = 0
    for key in model:
        if key == S2S_SPECIAL_NODE:
            continue
        #print("{} : {}".format(key, model[key].size))
        count += model[key].size

    print("Total number of parameters: {}".format(count))


def parse_args():
    parser = argparse.ArgumentParser(description=DESC)
    parser.add_argument("-m", "--model", help="model file", default="model.npz")
    return parser.parse_args()


if __name__ == "__main__":
    main()
