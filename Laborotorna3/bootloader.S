.syntax unified
.cpu cortex-m4
.thumb

.global bootload

.section .rodata
image: .incbin "kernel.bin"
end_of_image:

str_boot_start: .asciz "bootloader started\n"
str_boot_end:   .asciz "bootloader end\n"

.section .text
bootload:
    ldr r0, =str_boot_start
    bl dbgput_line

    ldr r0, =end_of_image      // r0 = кінець kernel.bin
    ldr r1, =image             // r1 = початок kernel.bin
    subs r3, r0, r1            // r3 = розмір kernel.bin у байтах

    ldr r2, =_ram_start        // r2 = початок RAM
    adds r2, r2, r3            // r2 = адреса одразу після образу в RAM

    movs r4, #2                // r4 = крок 2 байти

    subs r0, r0, #4            // база для читання з кінця
    subs r2, r2, #4            // база для запису в кінець RAM

copy_loop:
    ldrh r5, [r0, r4]          // читаємо півслово з kernel.bin
    strh r5, [r2, r4]          // пишемо півслово в RAM

    subs r3, r3, r4            // зменшуємо лічильник байтів
    beq copy_done              // якщо все скопійовано — вихід

    subs r0, r0, r4            // декремент адреси джерела
    subs r2, r2, r4            // декремент адреси призначення
    b copy_loop

copy_done:
    ldr r0, =str_boot_end
    bl dbgput_line

    ldr r2, =_ram_start        // початок завантаженого kernel у RAM

    ldr r0, [r2]               // перше слово векторної таблиці = початковий SP
    mov sp, r0

    ldr r0, [r2, #4]           // друге слово = адреса __kernel_reset__ + 1
    bx r0

bootload_end:
    b bootload_end
