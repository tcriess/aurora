#!/usr/bin/env python3

import imageio.v3 as iio
import numpy as np
from bitstring import BitArray
from itertools import groupby

import sys

bg = (255, 255, 255)
use_color_numbers = [8, 9, 10, 11]  # 4 color numbers that will be assigned

bits = {
    8: [1, 0, 0, 0],
    9: [1, 0, 0, 1],
    10: [1, 0, 1, 0],
    11: [1, 0, 1, 1],
}

colors = {}

k = 0
for i in range(11):
    if i%6 == 0:
        print(f"raw_spr_butterfly_{k}:")
        k += 1
    im = iio.imread(f"butterfly-{i}.png")  # 16x16 image
    #print(f"{im.shape}")
    no_lines = im.shape[0]
    for lno in range(no_lines):
        line = im[lno, :]
        #print(line)
        maskbits = []
        linebits0 = []
        linebits1 = []
        linebits2 = []
        linebits3 = []
        for el in line:
            elt = tuple(el)
            #print(elt)
            if elt not in colors:
                if elt == bg:
                    # print(f"{elt} is bg")
                    color = bg
                    maskbits.append(1)
                    linebits0.append(0)
                    linebits1.append(0)
                    linebits2.append(0)
                    linebits3.append(0)
                    continue
                else:
                    maskbits.append(0)
                    colors[elt] = use_color_numbers[len(colors)]
                    color = colors[elt]
            else:
                maskbits.append(0)
                color = colors[elt]
            if bits[color][0] > 0:
                linebits3.append(1)
            else:
                linebits3.append(0)
            if bits[color][1] > 0:
                linebits2.append(1)
            else:
                linebits2.append(0)
            if bits[color][2] > 0:
                linebits1.append(1)
            else:
                linebits1.append(0)
            if bits[color][3] > 0:
                linebits0.append(1)
            else:
                linebits0.append(0)
            
            # print(color)
        mask = BitArray(maskbits).uint
        b1 = BitArray(linebits0).uint
        b2 = BitArray(linebits1).uint
        b3 = BitArray(linebits2).uint
        b4 = BitArray(linebits3).uint
        if i%6 == 0:
            print(f"    dc.w ${mask:0{4}x},${b1:0{4}x},${b2:0{4}x},${b3:0{4}x},${b4:0{4}x}")