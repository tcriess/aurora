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
text += "$% $% $% hello sillyventure...  poor little cursor ... wants to break the border ...  $% $% $% "
text += " and now... more color!  $% $% $% code by tecer - hacknology $% $% $%   thanks to leonard for the strinkler port and a lot of inspiration!  $% $% $%  thanks to james ingram for the coding tutorials! $% $% $%  greetz to the abbuc community  $% $% $%  thanks to grey and the sv team for sillyventure!  $% $% $%"

a = map(mapper, text)
print("    dc.b " + ",".join(list(a)))
