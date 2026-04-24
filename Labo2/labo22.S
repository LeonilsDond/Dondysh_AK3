.global labo22
.syntax unified
.cpu cortex-m4
.thumb

#define A #12
#define B #7
#define C #1

.type labo22, %function
.type factorial, %function

labo22:
    push {lr}              // зберегти адресу повернення

    mov r0, A              // r0 = a
    mov r1, B              // r1 = b
    mov r2, C              // r2 = c

    and r3, r0, r1         // r3 = a & b
    lsrs r3, r3, #2        // r3 = (a & b) >> 2

    mov r0, r2             // передати c у factorial
    bl factorial           // r0 = c!

    add r0, r3, r0         // r0 = ((a & b) >> 2) + c!

    pop {pc}               // завершити функцію

factorial:
    push {r1, lr}          // зберегти r1 і адресу повернення

    cmp r0, #0             // перевірка: c == 0 ?
    beq fact_zero          // якщо так, то 0! = 1

    mov r1, r0             // r1 = лічильник
    mov r0, #1             // r0 = початковий результат factorial

fact_loop:
    mul r0, r0, r1         // r0 = r0 * r1
    subs r1, r1, #1        // r1 = r1 - 1
    bne fact_loop          // повторювати, поки r1 != 0
    b fact_done            // завершити factorial

fact_zero:
    mov r0, #1             // factorial(0) = 1

fact_done:
    pop {r1, pc}           // повернення з factorial
