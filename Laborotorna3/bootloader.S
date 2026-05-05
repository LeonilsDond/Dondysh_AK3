.syntax unified
.cpu cortex-m4
.thumb

.global bootload

.section .rodata
image:              .incbin "kernel.bin"
end_of_image:
str_boot_start:     .asciz "bootloader started\n"
str_boot_end:       .asciz "bootloader end\n"

.section .text
bootload:
    ldr r0, =str_boot_start
    bl dbgput_line

    ldr r0, =end_of_image      // r0 is the end_of_image
    ldr r1, =image             // r1 is an image start
    ldr r2, =_ram_start        // r2 is a RAM start

    sub r5, r0, r1             // r5 is an image size in bytes
    add r2, r2, r5             // r2 is a RAM start and image size

    mov r4, #2                 // register offset 2 bytes for my variant

    sub r0, r0, #4             // base so [r0, r4] is the last halfword of image
    sub r2, r2, #4             // base so [r2, r4] is the last halfword in RAM

    sub r6, r1, #2             // lower bound for decrement loop

copy_loop:
    ldrh r3, [r0, r4]          // load halfword from source using register offset
    strh r3, [r2, r4]          // store halfword to RAM using register offset

    sub r0, r0, #2             // decrement source base
    sub r2, r2, #2             // decrement destination base

    cmp r0, r6
    bhs copy_loop

    ldr r0, =str_boot_end
    bl dbgput_line

    ldr lr, =bootload_end
    add lr, lr, #1

    ldr r2, =_ram_start
    add r2, r2, #4             // second word of vector table is the reset handler
    ldr r0, [r2]
    bx r0

bootload_end:
    b bootload_end
