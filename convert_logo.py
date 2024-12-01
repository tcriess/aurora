#!/usr/bin/env python3

import imageio.v3 as iio
import numpy as np
from bitstring import BitArray
from itertools import groupby

import sys

# the visisble area is about 410 x 260

im = iio.imread('logo_105x50.png') # 410x101 with the same logo 4 times


# in order to create screen data, we need to set 230 bytes per line (4 words=8 bytes per 16 pixels)
# visible screen starts at pixel 6, that is in the midde of the first word

# first step:
# extend the image matrix to fit in the word-based size (i.e. extend the first 5 pixels to the left and one pixel to the right)
im = np.insert(im, 0, [[255], [255], [255], [255], [255], [255]], axis=1)
im = np.roll(im, -1, axis=1)
# print(im.shape)

no_lines = im.shape[0]

slices = np.split(im, 26, axis=1)
#slices = np.split(im, 13, axis=1)

# 26 slices of 16x202
#
# test: only store one quarter
slices = slices[:13]
#no_lines = no_lines // 2

print('; GENERATED CODE, DO NOT EDIT')

for lno in range(no_lines):
    # the image is now 416x202, so we split it in 26 slices of 16 pixels width each
    bfrom = 1
    bto = 4
    pfrom = 1
    pto = 16
    print(f"; line {lno+1}")
    #rleline = np.array([])
    for sl in slices:
        line = sl[lno, :]
        #print('')
        #for line in sl[:]:
        #print(line.shape)
        l = np.ones(16)
        l[line > 128] = 0
        #rleline = np.append(rleline, l)

        #for x,y in groupby(l):
        #    print(f"    dc.b {int(x)},{int(sum(1 for _ in y))}")
        
        #l[0:4] = 0 if np.sum(l[0:4]) < 2 else 1
        #l[4:8] = 0 if np.sum(l[4:8]) < 2 else 1
        #l[8:12] = 0 if np.sum(l[8:12]) < 2 else 1
        #l[12:16] = 0 if np.sum(l[12:16]) < 2 else 1

        #if lno < 168:
        #    l[0:8] = 0 if np.sum(l[0:8]) < 2 else 1
        #    l[8:16] = 0 if np.sum(l[8:16]) < 2 else 1
        #else:  # lower part = text
        #    l[0:4] = 0 if np.sum(l[0:4]) < 1 else 1
        #    l[4:8] = 0 if np.sum(l[4:8]) < 1 else 1
        #    l[8:12] = 0 if np.sum(l[8:12]) < 1 else 1
        #    l[12:16] = 0 if np.sum(l[12:16]) < 1 else 1

        # print(l)
        b = BitArray(l).uint
        #print(f"    move.l #${b:0{4}x}{b:0{4}x},(a6)+ ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
        print(f"    dc.l ${b:0{4}x}0000 ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
        ##print(f"    move.l #${b:0{4}x}0000,(a6)+ ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
        bfrom += 4
        bto += 4
        #print(f"    move.l #$00000000,(a6)+ ; pixels {pfrom}-{pto}, planes 3+4, bytes {bfrom}-{bto}")
        #print(f"    dc.l $00000000 ; pixels {pfrom}-{pto}, planes 3+4, bytes {bfrom}-{bto}")
        bfrom += 4
        bto += 4
        pfrom += 16
        pto += 16

    # print(rleline)
    #currpos = 0
    #for x,y in groupby(rleline):
    #    s = int(sum(1 for _ in y))
    #    if int(x) > 0:
    #        print(f"    dc.b {lno}")
    #        print(f"    dc.w {currpos}")
    #        print(f"    dc.b {s}")
    #    currpos += s

    #print(f"    move.l #$00000000,(a6)+ ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
    #print(f"    dc.l $00000000 ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
    bfrom += 4
    bto += 4
    #print(f"    move.l #$00000000,(a6)+ ; pixels {pfrom}-{pto}, planes 3+4, bytes {bfrom}-{bto}")
    #print(f"    dc.l $00000000 ; pixels {pfrom}-{pto}, planes 3+4, bytes {bfrom}-{bto}")
    bfrom += 4
    bto += 4
    pfrom += 16
    pto += 16
    #print(f"    move.l #$00000000,(a6)+ ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
    #print(f"    dc.l $00000000 ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
    bfrom += 4
    bto += 4
    #print(f"    move.l #$00000000,(a6)+ ; pixels {pfrom}-{pto}, planes 3+4, bytes {bfrom}-{bto}")
    #print(f"    dc.l $00000000 ; pixels {pfrom}-{pto}, planes 3+4, bytes {bfrom}-{bto}")
    bfrom += 4
    bto += 4
    pfrom += 16
    pto += 16
    #print(f"    move.l #$00000000,(a6)+ ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
    #print(f"    dc.l $00000000 ; pixels {pfrom}-{pto}, planes 1+2, bytes {bfrom}-{bto}")
    bfrom += 4
    bto += 2
    # print(f"    move.w #$0000,(a6)+ ; pixels {pfrom}-{pto}, planes 3+4 (not really, cut-off), bytes {bfrom}-{bto}")
    #print(f"    dc.w $0000 ; pixels {pfrom}-{pto}, planes 3+4 (not really, cut-off), bytes {bfrom}-{bto}")
