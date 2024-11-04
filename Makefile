VASM := vasmm68k_mot
VASMFLAGS_DEBUG := -Ftos -nowarn=62 -m68000 -no-fpu -no-opt -DDEBUG=1
VASMFLAGS := -Ftos -nowarn=62 -m68000 -no-fpu -no-opt -nosym -DDEBUG=0
STRINKLER := STrinkler
MAIN := aurora.s
TARGET_DEBUG := aurorad.tos
TARGET := aurora.tos
TARGET_COMPRESSED := aurorac.tos

.PHONY: all clean debug
all: $(TARGET)
debug: $(TARGET_DEBUG)

$(TARGET): $(wildcard *.s)
		$(VASM) $(VASMFLAGS) $(MAIN) -o $@

$(TARGET_COMPRESSED): $(TARGET)
		$(STRINKLER) -9 -v $(TARGET) $(TARGET_COMPRESSED)

$(TARGET_DEBUG): $(wildcard *.s)
		$(VASM) $(VASMFLAGS_DEBUG) $(MAIN) -o $@

all: $(TARGET) $(TARGET_DEBUG) $(TARGET_COMPRESSED)

clean:
		rm -f $(TARGET) $(TARGET_DEBUG) $(TARGET_COMPRESSED)