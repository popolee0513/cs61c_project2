.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

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
    mv s1, a1     # int_ptr
    mv s2, a2     # number of rows
    mv s3, a3     # number of columns
    
    # fopen
    mv a1, s0      # filename
    li a2, 1       # write mode
    call fopen
    mv s4, a0      # file descriptor
    li t0, -1
    beq a0, t0, fopen_error

    li a0, 8
    call malloc
    beq a0, x0, malloc_error
    mv s5, a0

    sw s2, 0(s5) 
    sw s3, 4(s5)
     

    # fwrite
    mv a1, s4
    mv a2, s5
    li a3, 2
    li a4, 4
    call fwrite
    li t0 2
    blt a0, t0, fwrite_error

    # fwrite
    mv a1, s4
    mv a2, s1
    mul t0,s2,s3
    mv a3, t0
    li a4, 4
    call fwrite
    blt a0, t0, fwrite_error


    # fclose
    mv a1, s4
    call fclose
    li t0, -1
    beq a0, t0, fclose_error

    # free memory 
    mv a0 s5
    call free
    mv a0 s1
    call free

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

fopen_error:
    li a1, 93
    call exit2
malloc_error:
    li a1, 92
    call exit2
fclose_error:
    li a1, 95
    call exit2    
fwrite_error:
    li a1, 94
    call exit2    