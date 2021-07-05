.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    # Prologue
    addi sp, sp, -16 #allocate space on stack
    addi t0, x0, 0 #set t0 to index counter
    add t1, x0, a3 #stride of v0
    add t2, x0, a4 #stride of v1
    addi t3, x0, 0 #dot product value stored in t3
    sw s0, 0(sp)  
    sw s1, 4(sp)
    sw s2, 8(sp)

loop_start:
    beq t0, a2, loop_end  #termination condition

    addi t4, x0, 4  #sizeof(int)
    mul t5, t0, t1  #stride*index for v0
    mul t6, t0, t2  #stride*index for v1
    mul t5, t5, t4  #multiply stride of v0 by sizeof(int)
    mul t6, t6, t4  #multiply stride of v1 by sizeof(int)
    add t5, t5, a0  #sizeof(int)*index*stride + address of v0
    add t6, t6, a1  #sizeof(int)*index*stride + address of v1
    lw s0, 0(t5)   #load the value of t5 into s0
    lw s1, 0(t6)   #load the value of t6 into s1
    mul s2, s0, s1 #store dot product of current index value in s2
    add t3, t3, s2 #add the values to t3
    addi t0, t0, 1  #increment index by one
    j loop_start


loop_end:
    mv a0, t3  #store final value in a0

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 16 

    ret
