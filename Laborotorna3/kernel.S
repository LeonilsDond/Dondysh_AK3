.syntax unified
.cpu cortex-m4
.thumb

#define A #12
#define B #7
#define C #1

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function
.type factorial, %function

.section .interrupt_vector
vtable_kernel:
.word __stack_start
.word __kernel_reset__+1
.size vtable_kernel, .-vtable_kernel

.section .rodata
data:  .asciz "kernel started!\n"
final: .asciz "Value in register r3: "

.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line

    // ((a & b) >> 2) + c!
    mov r0, A
    mov r1, B
    and r3, r0, r1
    lsrs r3, r3, #2

    mov r0, C
    bl factorial

    add r3, r3, r0

    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num
    bl newline

end:
    b end

factorial:
    push {r1, lr}

    cmp r0, #0
    beq fact_zero

    mov r1, r0
    mov r0, #1

fact_loop:
    mul r0, r0, r1
    subs r1, r1, #1
    bne fact_loop
    b fact_done

fact_zero:
    mov r0, #1

fact_done:
    pop {r1, pc}
