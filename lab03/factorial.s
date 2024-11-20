.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0 
    addi a0, x0, 1
    ecall # Print Result
    
    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit
#a0作为返回值同时作为调用参数
factorial:
    addi sp,sp,-8
    sw a0,0(sp)  
    sw ra,4(sp)

    beq a0,x0,base_case
    addi a0,a0,-1 #n=n-1
    #recurse
    jal factorial

    lw,a1,0(sp)  #n
    lw ra,4(sp)
    mul a0,a1,a0 #a0 = n*f(n-1)
    addi sp,sp,8
    jr ra

base_case:
    addi a0,x0,1
    lw ra,4(sp)
    addi sp,sp,8
    jr ra
