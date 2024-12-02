VASM := vasmm68k_mot
VASMFLAGS_DEBUG := -Ftos -nowarn=62 -m68000 -no-fpu -no-opt -DDEBUG=1
VASMFLAGS := -Ftos -nowarn=62 -m68000 -no-fpu -no-opt -nosym -DDEBUG=0
STRINKLER := STrinkler
MAIN := aurora.s
TARGET_DEBUG := aurorad.tos
TARGET := aurora.tos
TARGET_COMPRESSED := aurorac.tos
CREATESCROLLTEXT := createtext.py
CONVERTLOGO := convert_logo.py
CREATECOORDS := create_coords.py

.PHONY: all clean debug
all: $(TARGET)
debug: $(TARGET_DEBUG)

$(TARGET): $(wildcard *.s) gen_scrolltext.s gen_logo.s gen_lissajous.s
		$(VASM) $(VASMFLAGS) $(MAIN) -o $@

$(TARGET_COMPRESSED): $(TARGET)
		$(STRINKLER) -9 -v $(TARGET) $(TARGET_COMPRESSED)

$(TARGET_DEBUG): $(wildcard *.s) gen_scrolltext.s gen_logo.s
		$(VASM) $(VASMFLAGS_DEBUG) $(MAIN) -o $@

gen_scrolltext.s: $(CREATESCROLLTEXT)
		python3 $(CREATESCROLLTEXT) > gen_scrolltext.s

gen_logo.s: $(CONVERTLOGO)
		python3 $(CONVERTLOGO) > gen_logo.s

gen_lissajous.s: $(CREATECOORDS)
		python3 $(CREATECOORDS) > gen_lissajous.s

all: $(TARGET) $(TARGET_DEBUG) $(TARGET_COMPRESSED)

clean:
		rm -f $(TARGET) $(TARGET_DEBUG) $(TARGET_COMPRESSED)