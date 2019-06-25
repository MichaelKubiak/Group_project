#! /usr/bin/env python3
import argparse
from data_combination import add_to_lines

parser = argparse.ArgumentParser()

parser.add_argument("input", type = str, nargs=2)
args = parser.parse_args()
lines = []

with open(args.input[0]) as file:
    lines = file.readlines()

with open(args.input[1]) as file:
    add_to_lines(lines, file.readlines())

with open("pair_output", "w") as output:
    output.writelines(lines)
