.import ../read_matrix.s
.import ../write_matrix.s
.import ../matmul.s
.import ../dot.s
.import ../relu.s
.import ../argmax.s
.import ../utils.s

.data
output_step1: .asciiz "\n**Step 1: hidden_layer = matmul(m0, input)**\n"
output_step2: .asciiz "\n**Step 2: NONLINEAR LAYER: ReLU(hidden_layer)** \n"
output_step3: .asciiz "\n**Step 3: Linear layer = matmul(m1, relu)** \n"
output_step4: .asciiz "\n**Step 4: Argmax ** \n"
.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <INPUT_PATH> <M0_PATH> <M1_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    addi t0, x0, 4      
    bne a0, t0, error  #check if number of arguments is != 3

    mv s0, a1   #s0 contains **argv


    

	# =====================================
    # LOAD MATRICES
    # =====================================


    # Load pretrained m0

    addi a0,x0,4  #sizeof int
    call malloc
    mv s2, a0  #contains pointer to no of rows->m0

    addi a0, x0, 4  #sizeof int
    call malloc
    mv s3, a0  #contains pointer to number of columns->m0

    lw a0, 8(s0)  #pointer to m0 file 
    mv a1, s2  #pointer to number of rows
    mv a2, s3  #pointer to number of columns

    jal read_matrix

    mv s1, a0  #s1 contains pointer to matrix m0


    # Load pretrained m1

    addi a0, x0, 4
    call malloc
    mv s4, a0   #contains pointer to number of rows -> m1

    addi a0, x0, 4
    call malloc
    mv s5,a0    #contains pointer to number of columns -> m1

    lw a0, 12(s0)  #contains pointer to m1_filepath
    mv a1, s4
    mv a2, s5   

    jal read_matrix

    mv s6, a0  #contains matrix m1


    # Load input matrix

    addi a0, x0, 4  
    call malloc
    mv s7, a0 #contains pointer to number of rows for input

    addi a0, x0, 4
    call malloc
    mv s8, a0  #contains pointer to number of columns for input

    lw a0,4(s0)   #contains pointer to input_filepath
    mv a1, s7
    mv a2, s8 

    jal read_matrix

    mv s9, a0  #contains pointer to input matrix


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input

    addi a0, x0, 4 #sizeof int
    lw t0, 0(s2) #contains value in row pointer of M0
    mul a0, a0, t0 #sizeof(int)*rows of M0
    lw t1, 0(s8) #contains value in columns pointer of input
    mul a0, a0, t2 #sizeof(int)*columns of input
    call malloc

    mv s10, a0  #contains pointer to result of matmul

    mv a0, s1  
    lw t0, 0(s2)
    mv a1, t0
    lw t1, 0(s3)
    mv a2, t1 
    mv a3, s9
    lw t2, 0(s7)
    mv a4, t2 
    lw t3, 0(s8)
    mv a5, t3
    mv a6, s10 

    jal matmul

    # Output of stage 1
    la a1, output_step1
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 

    mv a0, s10 
    lw t3, 0(s2)
    mv a1, t3
    lw t4, 0(s8)  
    mv a2, t4

    call print_int_array

    # 2. NONLINEAR LAYER: ReLU(m0 * input)

    mv a0, s10
    lw t0, 0(s2) #rows of M0
    lw t1, 0(s8) #columns of input
    mul a1, t0, t1 

    jal relu


    # Output of stage 2
    la a1, output_step2
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 

    mv a0, s10 
    lw t0, 0(s2)
    mv a1, t0 
    lw t1, 0(s8)
    mv a2, t1 

    call print_int_array


    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    addi a0, x0, 4  #a0 = sizeof(int)
    lw t4, 0(s4)  #t4 = rows of m1
    mul a0, a0, t4 #a0 = rows of m1 *size of int
    lw t5, 0(s8)  #t5 = columns of input
    mul a0, a0, t5  #a0 = rows of m1*columns of input*sizeof(int)

    call malloc

    mv s11, a0  #contains pointer to result of matmul
    

    mv a0, s6 
    lw t0, 0(s4)
    mv a1, t0
    lw t1, 0(s5)
    mv a2, t1 
    mv a3, s10 
    lw t2, 0(s2)
    mv a4, t2
    lw t3, 0(s8)
    mv a5, t3
    mv a6, s11

    jal matmul



    # Output of stage 3
    la a1, output_step3
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 

    mv a0, s11
    lw t0, 0(s4)
    mv a1, t0
    lw t1, 0(s8)
    mv a2, t1 

    call print_int_array


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s11
    lw t0, 0(s4) 
    lw t1, 0(s8)
    mul a1, t0, t1 

    jal argmax

    mv t0, a0 

    addi sp, sp, -4
    sw t0, 0(sp)


    # Print classification

        # Output of stage 3
    la a1, output_step4
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 

    lw t0, 0(sp)
    addi sp, sp, 4


    mv a1, t0 
    call print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit


error:
    li a1, 3
    jal exit2