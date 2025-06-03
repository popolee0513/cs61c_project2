.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
     li t0, 1
     blt a1, t0, exit_a
     blt a2, t0, exit_a
     blt a4, t0, exit_b
     blt a5, t0, exit_b
     bne a2, a4, exit_c

    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    mv s0, a0           
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    
    # Error checks
     
    # Prologue
    li t1, 0 # start row
    li t2, 0 # start column
    li t0, 0 # start for d
    
outer_loop_start:
    beq t1, s1, outer_loop_end
    mul  t3, t1, s2
    slli t3, t3, 2
    add t5, s0, t3          # get the vector start address
inner_loop_start:
     beq t2, s5, inner_loop_end
     slli t4, t2, 2
     add t6, s3, t4          # get the vector start address
     addi sp, sp, -32
     sw t0, 0(sp)
     sw t1, 4(sp)
     sw t2, 8(sp)
     sw t3, 12(sp)
     sw t4, 16(sp)
     sw t5, 20(sp)
     sw t6, 24(sp)
     sw ra, 28(sp) 
     
     mv a0, t5
     mv a1, t6
     mv a2, s2
     li a3, 1 
     mv a4, s5 
     
     call dot 
     
     lw t0, 0(sp)
     lw t1, 4(sp)
     lw t2, 8(sp)
     lw t3, 12(sp)
     lw t4, 16(sp)
     lw t5, 20(sp)
     lw t6, 24(sp)
     lw ra, 28(sp)  
     addi sp, sp, 32

     slli t4, t0, 2 # reuse t4
     add t4, s6, t4 # address to write value
     sw  a0, 0(t4)
     addi t0, t0,  1
     addi t2, t2, 1
     j inner_loop_start
inner_loop_end:
     addi t1, t1, 1
     li t2, 0
     j outer_loop_start
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    addi sp, sp, 28
    ret
    
exit_a:
    li a1, 72 
    call exit2
exit_b:
    li a1, 73
    call exit2
exit_c:
    li a1, 74
    call exit2
    

