.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    add t0, x0, x0 #index values

loop_start:
    beq t0, a1, loop_end  #run the loop from 0 to n-1
    addi t1, x0, 4 #t1 holds size of stride ( t1 = 4)
    mul t2, t1, t0 # calculates offset for each index (t2 = t1*index)
    add t1, t2, a0 #add offset to pointer to array (t1 = t2 + a0), t1 contains address
    lw t3, 0(t1)  #load the value at that index and store in t3 

    bge t3, x0, loop_continue # if t3 > 0 then continue loop

    add t3, x0, x0  #set t3 to 0 if value is negative
    sw t3, 0(t1)  #store the updated value back into the index
    addi t0, t0 ,1   #increment index by one
    j loop_start     #jump back into the loop


loop_continue:
    addi t0, t0, 1  #increment index by one
    j loop_start    #run loop again


loop_end:


    # Epilogue

    
	ret
