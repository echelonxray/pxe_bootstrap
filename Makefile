# SPDX-License-Identifier: 0BSD
#
# Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
#

CROSS_COMPILE  := 
CC             := $(CROSS_COMPILE)gcc
OBJCPY         := $(CROSS_COMPILE)objcopy
OBJDMP         := $(CROSS_COMPILE)objdump
CFLAGS         := -Wall -Wextra -m16 -std=c99 -MMD -g -ffreestanding -nostdlib -nostdinc -nostartfiles -fno-pie -I./src
LDFLAGS        := -T x86_firmware.ld -static -no-pie
OUT            := image.elf
FILES          := 
OPTIMIZE       := 

# O1
OPTIMIZE += -fauto-inc-dec
OPTIMIZE += -fbranch-count-reg
OPTIMIZE += -fcombine-stack-adjustments
OPTIMIZE += -fcompare-elim
OPTIMIZE += -fcprop-registers
OPTIMIZE += -fdce
OPTIMIZE += -fdefer-pop
# OPTIMIZE += -fdelayed-branch -- Not supported for target
OPTIMIZE += -fdse
OPTIMIZE += -fforward-propagate
OPTIMIZE += -fguess-branch-probability
OPTIMIZE += -fif-conversion
OPTIMIZE += -fif-conversion2
OPTIMIZE += -finline-functions-called-once
OPTIMIZE += -fipa-modref
OPTIMIZE += -fipa-profile
OPTIMIZE += -fipa-pure-const
OPTIMIZE += -fipa-reference
OPTIMIZE += -fipa-reference-addressable
OPTIMIZE += -fmerge-constants
OPTIMIZE += -fmove-loop-invariants
OPTIMIZE += -fmove-loop-stores
OPTIMIZE += -fomit-frame-pointer
OPTIMIZE += -freorder-blocks
OPTIMIZE += -fshrink-wrap
OPTIMIZE += -fshrink-wrap-separate
OPTIMIZE += -fsplit-wide-types
OPTIMIZE += -fssa-backprop
OPTIMIZE += -fssa-phiopt
OPTIMIZE += -ftree-bit-ccp
OPTIMIZE += -ftree-ccp
OPTIMIZE += -ftree-ch
OPTIMIZE += -ftree-coalesce-vars
OPTIMIZE += -ftree-copy-prop
OPTIMIZE += -ftree-dce
OPTIMIZE += -ftree-dominator-opts
OPTIMIZE += -ftree-dse
OPTIMIZE += -ftree-forwprop
OPTIMIZE += -ftree-fre
OPTIMIZE += -ftree-phiprop
OPTIMIZE += -ftree-pta
OPTIMIZE += -ftree-scev-cprop
OPTIMIZE += -ftree-sink
OPTIMIZE += -ftree-slsr
OPTIMIZE += -ftree-sra
OPTIMIZE += -ftree-ter
OPTIMIZE += -funit-at-a-time

# O2
OPTIMIZE += -falign-functions  -falign-jumps
OPTIMIZE += -falign-labels  -falign-loops
OPTIMIZE += -fcaller-saves
OPTIMIZE += -fcode-hoisting
OPTIMIZE += -fcrossjumping
OPTIMIZE += -fcse-follow-jumps  -fcse-skip-blocks
OPTIMIZE += -fdelete-null-pointer-checks
OPTIMIZE += -fdevirtualize  -fdevirtualize-speculatively
OPTIMIZE += -fexpensive-optimizations
OPTIMIZE += -ffinite-loops
OPTIMIZE += -fgcse  -fgcse-lm
OPTIMIZE += -fhoist-adjacent-loads
OPTIMIZE += -finline-functions
OPTIMIZE += -finline-small-functions
OPTIMIZE += -findirect-inlining
OPTIMIZE += -fipa-bit-cp  -fipa-cp  -fipa-icf
OPTIMIZE += -fipa-ra  -fipa-sra  -fipa-vrp
OPTIMIZE += -fisolate-erroneous-paths-dereference
OPTIMIZE += -flra-remat
OPTIMIZE += -foptimize-sibling-calls
OPTIMIZE += -foptimize-strlen
OPTIMIZE += -fpartial-inlining
OPTIMIZE += -fpeephole2
OPTIMIZE += -freorder-blocks-algorithm=stc
OPTIMIZE += -freorder-blocks-and-partition  -freorder-functions
OPTIMIZE += -frerun-cse-after-loop
OPTIMIZE += -fschedule-insns  -fschedule-insns2
OPTIMIZE += -fsched-interblock  -fsched-spec
OPTIMIZE += -fstore-merging
OPTIMIZE += -fstrict-aliasing
OPTIMIZE += -fthread-jumps
OPTIMIZE += -ftree-builtin-call-dce
OPTIMIZE += -ftree-loop-vectorize
OPTIMIZE += -ftree-pre
OPTIMIZE += -ftree-slp-vectorize
OPTIMIZE += -ftree-switch-conversion  -ftree-tail-merge
OPTIMIZE += -ftree-vrp
OPTIMIZE += -fvect-cost-model=very-cheap

# O3
OPTIMIZE += -fgcse-after-reload
OPTIMIZE += -fipa-cp-clone
OPTIMIZE += -floop-interchange
OPTIMIZE += -floop-unroll-and-jam
OPTIMIZE += -fpeel-loops
OPTIMIZE += -fpredictive-commoning
OPTIMIZE += -fsplit-loops
OPTIMIZE += -fsplit-paths
OPTIMIZE += -ftree-loop-distribution
OPTIMIZE += -ftree-partial-pre
OPTIMIZE += -funswitch-loops
OPTIMIZE += -fvect-cost-model=dynamic
OPTIMIZE += -fversion-loops-for-strides

FILES   := $(FILES) src/entry.o
FILES   := $(FILES) src/main.o
FILES   := $(FILES) src/printm.o
FILES   := $(FILES) src/string.o
FILES   := $(FILES) src/math.o

FILES_BASE := $(basename $(FILES))

.PHONY: all rebuild clean linkerdeps

all: $(OUT) $(OUT).bin $(OUT).bin.img

rebuild: clean
	$(MAKE) all

clean:
	rm -f $(OUT) $(OUT).bin $(OUT).bin.img
	rm -f $(FILES)
	rm -f $(addsuffix .d,$(FILES_BASE))

%.o: %.c
	$(CC) $(CFLAGS) $(OPTIMIZE) $< -c -o $@

%.o: %.S
	$(CC) $(CFLAGS) $(OPTIMIZE) $< -c -o $@

$(OUT): $(FILES) x86_firmware.ld
	$(CC) $(CFLAGS) $(OPTIMIZE) $(FILES) $(LDFLAGS) -o $@

$(OUT).bin: $(OUT)
	$(OBJCPY) -O binary $< $@

$(OUT).bin.img: $(OUT).bin
	./pad_to_length.sh $(OUT).bin $@

copy: $(OUT).bin
	sudo cp $< /var/tftproot/pxe_bootfile.bin

-include *.d

objdump: image.elf
	$(OBJDMP) -M no-aliases -m i8086 -D image.elf | less
