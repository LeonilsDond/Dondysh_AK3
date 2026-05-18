.RECIPEPREFIX := >

SDK_PREFIX?=arm-none-eabi-
CC = $(SDK_PREFIX)gcc
LD = $(SDK_PREFIX)ld
SIZE = $(SDK_PREFIX)size
OBJCOPY = $(SDK_PREFIX)objcopy
QEMU = qemu-system-gnuarmeclipse
BOARD ?= STM32F4-Discovery
MCU=STM32F407VG
TARGET=firmware
CPU_CC=cortex-m4
TCP_ADDR=1234

CFLAGS = -O0 -g3 -Wall -mthumb
LDFLAGS = -Wall --specs=nosys.specs -nostdlib -lgcc -mthumb

APP_PATH=$(abspath ./)

GASSRC += start.S
GASSRC += print.S
GASSRC += bootloader.S

SOBJS = $(GASSRC:.S=.o)

.PHONY: all clean qemu qemu_run flash

vpath % $(APP_PATH)

all: kernel.bin $(TARGET).elf $(TARGET).bin

%.o: %.S
>$(CC) -x assembler-with-cpp $(CFLAGS) -mcpu=$(CPU_CC) -c -o $@ $<

bootloader.o: kernel.bin

$(TARGET).elf: $(SOBJS)
>$(CC) -mcpu=$(CPU_CC) $(LDFLAGS) -T./lscript.ld -o $@ $^

$(TARGET).bin: $(TARGET).elf
>$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

kernel.bin:
>$(CC) -x assembler-with-cpp $(CFLAGS) -mcpu=$(CPU_CC) -c kernel.S -o kernel.o
>$(CC) -x assembler-with-cpp $(CFLAGS) -mcpu=$(CPU_CC) -c print.S -o print_kernel.o
>$(CC) -mcpu=$(CPU_CC) $(LDFLAGS) -T./lscript_kernel.ld -o kernel.elf kernel.o print_kernel.o
>$(OBJCOPY) -O binary kernel.elf kernel.bin

qemu:
>$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).elf --semihosting-config enable=on,target=native -gdb tcp::$(TCP_ADDR) -S

qemu_run:
>$(QEMU) --verbose --verbose --board $(BOARD) --mcu $(MCU) -d unimp,guest_errors --image $(TARGET).elf --semihosting-config enable=on,target=native

clean:
>-rm -f *.o
>-rm -f *.elf
>-rm -f *.bin

flash:
>st-flash write $(TARGET).bin 0x08000000
