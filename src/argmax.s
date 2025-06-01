.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================

argmax:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0           # array 起始指標
    mv s1, a1           # array 長度
    li t0, 0            # i = 0
    li t6, 1
    li t3, 0 
    blt s1, t6, is_less
    lw  t4, 0(s0)

loop_continue:
    beq t0, s1, loop_end
    slli t1, t0, 2          # offset = i*4
    add t2, s0, t1          # t2 = &array[i]
    lw t5, 0(t2)            # 讀 array[i]
    blt t4, t5, change_value
    addi t0, t0, 1
    j loop_continue

change_value:
    mv t3, t0
    mv t4, t5
    addi t0, t0, 1
    j loop_continue

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    mv a0, t3
    ret

is_less:
    li a0, 77 # 設定錯誤碼 77
    li a7, 93 # ecall 93 = exit with code (Linux syscall convention)
    ecall     # 終止程式並回傳錯誤碼
