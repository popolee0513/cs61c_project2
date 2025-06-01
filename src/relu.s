.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0           # array 起始指標
    mv s1, a1           # array 長度
    li t0, 0            # i = 0
    li t1, 1
    blt s1, t1, is_less

loop_continue:
    beq t0, s1, loop_end
    slli t1, t0, 2          # offset = i*4
    add t2, s0, t1          # t2 = &array[i]
    lw t3, 0(t2)            # 讀 array[i]
    blt t3, x0, change_value
    addi t0, t0, 1
    j loop_continue

change_value:
    sw x0, 0(t2)            # 寫 0 到 array[i]
    addi t0, t0, 1
    j loop_continue

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

is_less:
    li a0, 78 # 設定錯誤碼 78
    li a7, 93 # ecall 93 = exit with code (Linux syscall convention)
    ecall     # 終止程式並回傳錯誤碼

