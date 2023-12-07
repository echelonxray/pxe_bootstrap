CROSS_COMPILE  := 
CC             := $(CROSS_COMPILE)gcc
OBJCPY         := $(CROSS_COMPILE)objcopy
CFLAGS         := -Wall -Wextra -m16 -std=c99 -MMD -O2 -g -ffreestanding -nostdlib -nostdinc -nostartfiles -fno-pie -I./src
LDFLAGS        := -T x86_firmware.ld -static -no-pie
OUT            := image.elf
FILES          := 

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
	$(CC) $(CFLAGS) $< -c -o $@

%.o: %.S
	$(CC) $(CFLAGS) $< -c -o $@

$(OUT): $(FILES) x86_firmware.ld
	$(CC) $(CFLAGS) $(FILES) $(LDFLAGS) -o $@

$(OUT).bin: $(OUT)
	$(OBJCPY) -O binary $< $@

$(OUT).bin.img: $(OUT).bin
	./pad_to_length.sh $(OUT).bin $@

copy: $(OUT).bin
	sudo cp $< /var/tftproot/pxe_bootfile.bin

-include *.d
