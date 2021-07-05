.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28  #allocate space on stack
    sw ra, 0(sp)   #save ra t0 to jumpt back to read_matrix
    sw s0, 4(sp)    
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)  #contains file descriptor returned by fopen
    sw s4, 20(sp)  #contains rows*columns for malloc size
    sw s5, 24(sp)  #contains pointer to malloc

    mv s0, a0  #pointer to string representing filename
    mv s1, a1 #pointer to number of rows
    mv s2, a2  #pointer to number of columns

    #body

    mv a1, s0  
    addi a2, x0, 0 #set up arguments to pass into fopen

    call fopen
    addi t0 ,x0, 0

    beq t0, a0, eof_or_error  #if fopen returns NULL, exit

    mv s3, a0  #move file descriptor into s3 to allow use of a0
    mv a1, s3  #move file descriptor into a1
    mv a2, s1  #pointer to rows in a2
    addi a3, x0, 4  #read 4 bytes 

    call fread

    bne a3, a0, eof_or_error #if number of bytes read are not equal, exit 

    lw t1, 0(s1)  #load the value in row into t1 

    blt t1, x0 , eof_or_error  #exit if integer in row is < 0

    mv a1, s3 #repeat intial fead setup for column pointer
    mv a2, s2 #move pointer to column into a2
    addi a3, x0, 4  #read 4 bytes 

    call fread

    bne a3, a0, eof_or_error  #if number of bytes read != 4, exit

    lw t2, 0(s2) #load the column integer into t2
    
    blt t2, x0, eof_or_error #exit if integer in column is < 0

    lw t0, 0(s1) #load number of rows into t0
    lw t1, 0(s2) #load number of columns in t1
    mul a0, t1, t0 #a0 contains rows*columns
    mv s4, a0  #save number of entries to use a0 for arugment call
    addi t3, x0, 4  #t3=sizeof(int)
    mul a0, a0, t3  #a0 = rows*columns*sizeof(int)

    call malloc  #pass a0 to allocate space on heap

    beq a0, x0, eof_or_error  #if NUll pointer returned, malloc failed and code exit

    mv s5, a0  #store pointer to malloc in s5

    mv a1, s3  #move file descriptor into a1 for fread
    mv a2, s5  #move malloc pointer into a2
    addi t4, x0, 4 #t4 = sizeof(int)
    mul a3, s4, t4  #a3 = sizeof(int)*cols*rows

    call fread

    bne a0, a3 , eof_or_error  #if returned number of bytes read != a3, exit 

    mv a1, s3  #move file descriptor into a1 to close file

    call fclose

    bne a0, x0, eof_or_error  #if return value = -1, exit code

    mv a0, s5   #move pointer by malloc into a0 for return value



    # Epilogue
                    #restore saved registers

    lw ra, 0(sp)  
    lw s0, 4(sp)    
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp) 
    lw s4, 20(sp)  
    lw s5, 24(sp)  
    addi sp, sp, 28 

    ret

eof_or_error:
    li a1 1
    jal exit2
    