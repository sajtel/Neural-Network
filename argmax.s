.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -8 #allocate space on the stack
    addi t0, x0, 0  #set t0 to 0 -> index values
    addi t1, x0, 0  #t1 keeps track of the largest index
    sw s0, 0(sp)    #storing s0 so i can use it in the function
    sw s1, 4(sp)    #storing s1 to use in function


loop_start:
    beq t0, a1, loop_end  #jump to the end of the loop if t0=a1
    addi t2, x0, 4  #t2 contains offset for int array
    mul t2, t2, t0  #sizeof(int)*index
    add t3, t2,a0   #calculates address of value and stores in t3, sizeof(int)*index + address
    lw t4,0(t3)     #load the value at the index into t4
    addi t5, x0 ,4   #t5 contains offset for int val
    mul t6, t5, t1   #t6 = sizeof(int)*largestindex
    add s0, t6, a0   #s0 = sizeof(int)*largestindex + address
    lw s1, 0(s0)     #load current largest value 


    ble t4, s1, loop_continue # if t4 <= t1 loop_continue
    
    addi t1, t0, 0  #if value at index is greater, store index in t1
    addi t0,t0, 1   #index++
    j loop_start


loop_continue:
    addi t0, t0, 1  #index++
    j loop_start


loop_end:
    mv a0, t1 #copy largest index value into a0
    

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8 

    ret
