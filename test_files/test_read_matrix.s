.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_files/test_input.bin"

.text
main:
    # Read matrix into memory
    addi a0, x0, 4 
    call malloc
    mv s1, a0 #pointer to allocated memory

    addi a0, x0, 4
    call malloc
    mv s2, a0  #pointer to allocated memory

    la a0, file_path
    addi a1, s1, 0
    addi a2, s2, 0 
    
    call read_matrix

    lw a1, 0(s1)
    lw a2, 0(s2)

    # Print out elements of matrix

    call print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall