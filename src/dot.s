.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================

dot:
    # Prologue
    li t0, 1
    blt a2, t0, exit_a
    blt a3, t0, exit_b
    blt a4, t0, exit_b

    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    mv s0, a0           
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    li t1, 0 # start index
    li t2, 0 # start index
    li t3, 0
    
    
    li t0, 0
    li  t6, 0
    li s5, 0 
        
    
loop_start:
    bge s5, s2, loop_end
    slli t3, t1, 2          # offset = i*4
    slli t6, t2, 2          
    
    
    add t4, s0, t3          # t2 = &array[i]
    add t5, s1, t6
    
    lw t3, 0(t4)            # 讀 array[i]
    lw t6, 0(t5)            # 讀 array[j]
    
    mul t3, t3, t6
    add t0, t0, t3
    
    
    add t1, t1, s3
    add t2, t2, s4
    addi s5, s5, 1
    
    j loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24
    mv a0, t0
    ret

exit_a:
    li a1 75
    call exit2
    
exit_b:
    li a1, 76
    call exit2

