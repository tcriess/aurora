#!/usr/bin/env python3

# create text data for the scroller.
def mapper(c):
    r = "0"
    c = c.upper()
    if 'A' <= c <= 'Z':
        r = str(ord(c) - ord('A') + 1)
    elif c == '.':
        r = "27"
    elif c == '-':
        r = "28"
    elif c == '!':
        r = "29"
    elif c == '$':  # left part atari logo
        r = "30"
    elif c == '%':  # right part atari logo
        r = "31"
    return r

text = " ".join(["" for _ in range(100)])
text += "$% $% $% hello sillyventure...  $% $% $% "
text += " ... more color!  $% $% $%  music by zoltarx - new generation  $% $% $%  code and gfx by tecer - hacknology $% $% $%   cheers to leonard!  $% $% $%  and greetz to abbuc!  $% $% $%  thanks to the sv team!  $% $% $%"

a = map(mapper, text)
print('; GENERATED CODE, DO NOT EDIT')
print("    dc.b " + ",".join(list(a)))
