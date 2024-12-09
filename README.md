# Aurora Atari ST/E 4kb intro

Meet Aurora, the poor little cursor. She's trying to get to her friend who is outside the screen border...

The code is a fully synchronized, all-border-busting screen which only uses the vertical blank interrupt routine, and it also features a dosound-compatible sound replay.
It consists of 2 16x16 animated sprites and a 64-lines scroller (8-pixel-steps) with the possibility of a different color palette in every line (of the scroller).

The font is extracted from the TOS in order to save some bytes, some of the included data is generated using some simple python scripts (also included here).
