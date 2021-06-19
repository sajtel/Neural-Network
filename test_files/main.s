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






	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0






    # Load pretrained m1






    # Load input matrix






    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input


    # Output of stage 1
    la a1, output_step1
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 



    # 2. NONLINEAR LAYER: ReLU(m0 * input)



    # Output of stage 1
    la a1, output_step2
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 



    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)



    # Output of stage 3
    la a1, output_step3
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 












    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax




    # Print classification

        # Output of stage 3
    la a1, output_step4
    jal print_str

    ## FILL OUT
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 



    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit
