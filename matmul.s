.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    #the column values to multiply are width-1 stride away
    #mo-left, m1-right
    #need to save ra because it will be modified when entering dot product


    # Prologue
    bne a2, a4, mismatched_dimensions  #if number of columns dont match exit code 2
    addi sp, sp, -36  #allocate space on stack for s register values to be saved
    sw ra, 0(sp)   #save ra to return back after dots call
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
           
    mv s0, a0  #moving pointer to m0 to use a0 for argument call
    mv s1, a3  #moving pointer to m1 to use a3 in argument call
    mv s2, a1  #setting s2 to n
    mv s3, a5  #setting s3 to k
    addi s5, x0, 0  #setting s5 to be index counter for outerloop (i)
    addi s4, x0, 0  #setting s4 to be index counter for innerloop (j)
    mv s7, a2  #s7 contains width of m0
    mv s8, a6  #move pointer to d into s8 


outer_loop_start:
    beq s5, s2 outer_loop_end


inner_loop_start:
    beq s4, s3 inner_loop_end

    mul t5, s5, s7  #t5 = i*m
    addi t3, x0 ,4   #t3 = sizeof(int)
    mul t5, t5, t3  #t5 = i*m*sizeof(int)
    add t5, s0, t5  #t5 = A+(i*m*sizeof(int)) -t5 contains row address
    mul s6, s4, t3  #s6 = j*sizeof(int)
    add s6, s6, s1  #s6 = B+(j*sizeof(int)) - s6 now contains col address

    #set up argument values into a registers before calling function
    mv a0, t5  #a0 contains row address
    mv a1, s6  #pointer to column address
    mv a2, s7  #size of vector
    addi a3, x0, 1   #stride of vector from m0
    mv a4, s3   #move stride of m1 to argument register

    jal ra, dot

    mv t6, a0  #move result of dot into t6
    addi t4, x0 4 #t4 = sizeof(int)
    mul t1, s5, t4  #t1 = i*sizeof(int)
    mul t1, t1, s3  #t1 = i*sizeof(int)*width 
    mul t2, s4, t4  #t2 = j*sizeof(int)
    add t1, t1, t2  # t1 = i*sizeof(int)*width + j*sizeof(int) -> t1 contains offset to store value in d 
    add t1, t1, s8  #t1 = offset + base address of d
    lw t3, 0(t1)  #load value at t1 into t3
    add t3, x0, t6 #add 0 + dots result
    sw t3, 0(t1) #store return value from dots to memory location
    addi s4, s4, 1 #j++
    j inner_loop_start


inner_loop_end:
    addi s5, s5, 1  #i++
    addi s4, x0, 0  #set j = 0
    j outer_loop_start



outer_loop_end:


    # Epilogue
    lw ra, 0(sp)  #load ra from stack
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    addi sp, sp, 36
    
    ret


mismatched_dimensions:
    li a1 2
    jal exit2
