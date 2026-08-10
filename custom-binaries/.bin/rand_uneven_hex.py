#!/bin/python3
import random
import sys
import os

def hex_fixed(n: int, bits: int) -> str:
    digits = bits // 4
    return f"0x{n & ((1 << bits) - 1):0{digits}x}"

if not len(sys.argv) == 3:
    print(f"Usage: {sys.argv[0]} <quantity> <size_bits>")
    exit(1)

if int(sys.argv[2]) not in [8, 16, 32, 64]:
    print("<size_bits> must be power of two, from 8 to 64\nAllowed <size_bits>: [8, 16, 32, 64]")
    exit(1)

for a in range(int(sys.argv[1])):
    num_impar = random.getrandbits(int(sys.argv[2])) | 1
    print(hex_fixed(num_impar, int(sys.argv[2])))

