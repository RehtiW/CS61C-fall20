.globl simple_fn naive_pow inc_arr

.data
failure_message: .asciiz "Test failed for some reason.\n"
success_message: .asciiz "Sanity checks passed! Make sure there are no CC violations.\n"
array:
    .word 1 2 3 4 5
exp_inc_array_result:
    .word 2 3 4 5 6

.text
main:
    # We test our program by loading a bunch of random values
    # into a few saved registers - if any of these are modified
    # after these functions return, then we know calling
    # convention was broken by one of these functions
    li s0, 2623
    li s1, 2910
    # ... skipping middle registers so the file isn't too long
    # If we wanted to be rigorous, we would add checks for
    # s2-s20 as well
    li s11, 134
    # Now, we call some functions
    # simple_fn: should return 1
    jal simple_fn # Shorthand for "jal ra, simple_fn"
    li t0, 1
    bne a0, t0, failure
    # naive_pow: should return 2 ** 7 = 128
    li a0, 2
    li a1, 7
    jal naive_pow
    li t0, 128
    bne a0, t0, failure
    # inc_arr: increments "array" in place
    la a0, array
    li a1, 5
    jal inc_arr
    jal check_arr # Verifies inc_arr and jumps to "failure" on failure
    # Check the values in the saved registers for sanity
    li t0, 2623
    li t1, 2910
    li t2, 134
    bne s0, t0, failure
    bne s1, t1, failure
    bne s11, t2, failure
    # If none of those branches were hit, print a message and exit normally
    li a0, 4
    la a1, success_message
    ecall
    li a0, 10
    ecall

# Just a simple function. Returns 1.
simple_fn:
    li a0, 1
    ret

# Computes a0 to the power of a1.
# This is analogous to the following C pseudocode:
#
# uint32_t naive_pow(uint32_t a0, uint32_t a1) {
#     uint32_t s0 = 1;
#     while (a1 != 0) {
#         s0 *= a0;
#         a1 -= 1;
#     }
#     return s0;
# }
#
naive_pow:
    addi sp,sp,-4
    sw s0,0(sp)
    li s0, 1
naive_pow_loop:
    beq a1, zero, naive_pow_end
    mul s0, s0, a0
    addi a1, a1, -1
    j naive_pow_loop
naive_pow_end:
    mv a0, s0
    lw,s0,0(sp)
    addi sp,sp,4
    ret

# Increments the elements of an array in-place.
# a0 holds the address of the start of the array, and a1 holds
# the number of elements it contains.
#
# This function calls the "helper_fn" function, which takes in an
# address as argument and increments the 32-bit value stored there.
inc_arr:
    addi sp, sp, -12      # 给栈分配16字节空间
    sw ra, 0(sp)          # 保存返回地址
    sw s0, 4(sp)          # 保存s0
    sw s1, 8(sp)          # 保存s1
    # END PROLOGUE
    mv s0, a0             # 将数组起始地址保存到s0
    mv s1, a1             # 将数组长度保存到s1
    li t0, 0              # 初始化计数器 t0 为 0
inc_arr_loop:
    beq t0, s1, inc_arr_end 
    slli t1, t0, 2        
    add a0, s0, t1
    
    addi sp,sp,-4
    sw t0,0(sp)
 
    jal helper_fn        #
    
    lw t0,0(sp)
    addi t0, t0, 1
    addi sp,sp,4
    j inc_arr_loop       

inc_arr_end:
    # BEGIN EPILOGUE
    lw ra, 0(sp)          # 恢复返回地址
    lw s0, 4(sp)          # 恢复s0
    lw s1, 8(sp)          # 恢复s1
    addi sp, sp, 12       # 恢复栈指针
    # END EPILOGUE
    ret

helper_fn:
    # BEGIN PROLOGUE
    addi sp, sp, -8       # 给栈分配空间(8字节)
    sw t0, 0(sp)          # 保存 t0
    sw s0, 4(sp)          # 保存 s0
    # END PROLOGUE
    lw t0, 0(a0)          # 将数组当前值加载到 t1
    addi s0, t0, 1        # 将 t0 加 1 存入 s0
    sw s0, 0(a0)          # 将更新后的值存回数组

    # BEGIN EPILOGUE
    lw t0, 0(sp)          # 恢复 t1
    lw s0, 4(sp)          # 恢复 s0
    addi sp, sp, 8        # 恢复栈指针
    # END EPILOGUE
    ret


# YOU CAN IGNORE EVERYTHING BELOW THIS COMMENT

# Checks the result of inc_arr, which should contain 2 3 4 5 6 after
# one call.
# You can safely ignore this function; it has no errors.
check_arr:
    la t0, exp_inc_array_result
    la t1, array
    addi t2, t1, 20 # Last element is 5*4 bytes off
check_arr_loop:
    beq t1, t2, check_arr_end
    lw t3, 0(t0)
    lw t4, 0(t1)
    bne t3, t4, failure
    addi t0, t0, 4
    addi t1, t1, 4
    j check_arr_loop
check_arr_end:
    ret
    

# This isn't really a function - it just prints a message, then
# terminates the program on failure. Think of it like an exception.
failure:
    li a0, 4 # String print ecall
    la a1, failure_message
    ecall
    li a0, 10 # Exit ecall
    ecall
    
