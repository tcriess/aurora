#!/usr/bin/env python3

# create some of the movement patterns

# coordinates of the sprites are given by offsets to the screen base address + a shift of the data (0-15)

# visible screen coordinates are about 410 x 260, the leftmost visible pixel has coordinate x=5 (0-based)

# sprites are 16x16 pixels (all 4 planes!), the cursor sprites are centered, i.e. the center 8x8 pixels are set

from math import sin, pi, ceil

def convert_coord(x, y):
    # y coord is simple
    offset = y * 230  # one line has 230 bytes
    slice = x // 16  # which 16-pixel slice are we in
    offset = offset + slice*8  # 16 pixels take 8 bytes (4 planes * 2 bytes)
    shift = x % 16
    return offset, shift

def lissajous(t, delta=pi/2, a=1.0, b=2.0, A=1.0, B=1.0):
    x, y = A*sin(a*float(t) + delta), B*sin(b*t)
    return x, y

print("; GENERATED CODE")

DIV = 8

steps = ceil(2*pi*DIV)

for t in range(steps):
    x, y = lissajous(float(t)/DIV)
    x = x*190 + 200
    y = y*70 + 70
    x = int(x)
    y = int(y)
    offset, shift = convert_coord(x, y)
    print(f"    ; {x},{y}")
    print(f"    dc.w 2 ; delay")
    if t == 0:
        print(f"    dc.l ani_spr_em ; sprite")
    else:
        print(f"    dc.l 0 ; sprite")
    print(f"    dc.w {offset} ; offset")
    print(f"    dc.w {shift}*sprite_size_per_shift ; shift")
    if t == steps-1:
        print(f"    dc.w -12*{steps-1} ; next entry, jump to start")
    else:
        print(f"    dc.w 12 ; next entry")
