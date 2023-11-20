CROSS_COMPILE  := 
CC             := $(CROSS_COMPILE)gcc
OBJCPY         := $(CROSS_COMPILE)objcopy
CFLAGS         := -Wall -Wextra -m16 -std=c99 -MMD -O1 -g -ffreestanding -nostdlib -nostartfiles -fno-pie
LDFLAGS        := -T x86_firmware.ld -static -no-pie
OUT            := image.elf
FILES          := 

FILES   := $(FILES) entry.o
FILES   := $(FILES) main.o

.PHONY: all rebuild clean linkerdeps

all: $(OUT) $(OUT).bin $(OUT).bin.img

rebuild: clean
	$(MAKE) all

clean:
	rm -f $(FILES) $(OUT) $(OUT).bin $(OUT).bin.img *.d

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
