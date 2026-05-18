.syntax unified
.cpu cortex-m4
.thumb

.global vtable
.global __hard_reset__

.type vtable, %object
.type __hard_reset__, %function

.section .interrupt_vector
vtable:
    .word __stack_start
    .word __hard_reset__+1
.size vtable, .-vtable

.section .rodata
d: .asciz "starting\n"

.section .text
__hard_reset__:
    ldr r0, =__stack_start
    mov sp, r0

    ldr r0, =d
    bl dbgput_line

    bl bootload

_loop:
    b _loop

.size __hard_reset__, .-__hard_reset__
