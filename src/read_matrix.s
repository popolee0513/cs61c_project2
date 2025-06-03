.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================

read_matrix:
    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)    
    
    mv s0, a0     # filename
    mv s1, a1     # row_ptr
    mv s2, a2     # col_ptr

    # fopen
    mv a1, s0      # filename
    li a2, 0       # read mode
    call fopen
    mv s3, a0      # file descriptor
    li t0, -1
    beq a0, t0, fopen_error

    # malloc 8 bytes for header
    li a0, 8
    call malloc
    beq a0, x0, malloc_error
    mv s4, a0

    # fread 8 bytes
    mv a1, s3
    mv a2, s4
    li a3, 8
    call fread
    li t1, 8
    blt a0, t1, fread_error
    lw t0, 0(s4)        
    sw t0, 0(s1)          
    lw t2, 4(s4)          
    sw t2, 0(s2)    

    # malloc matrix
    mul t3, t0, t2        # total elements
    li t4, 4
    mul t6, t3, t4        # total bytes
    mv a0, t6
    call malloc
    beq a0, x0, malloc_error
    mv s5, a0             # matrix_ptr

    # fread matrix data
    mv a1, s3
    mv a2, s5
    mv a3, t6
    call fread
    blt a0, t6, fread_error

    # fclose
    mv a1, s3
    call fclose
    li t0, -1
    beq a0, t0, fclose_error

    # Epilogue
end:
    mv a0, s5          # return matrix_ptr
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    ret


# ==== Error handlers ====
fopen_error:
    li a1, 90
    call exit2

fread_error:
    li a1, 91
    call exit2

malloc_error:
    li a1, 88
    call exit2

fclose_error:
    li a1, 92
    call exit2

