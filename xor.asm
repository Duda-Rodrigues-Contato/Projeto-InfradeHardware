.text
cifra_xor:
    addi $sp, $sp, -8
    sw $s0, 4($sp)
    sw $s1, 0($sp)

    move $s0, $a0    
    move $s1, $a1    

xor_loop:
    lb $t0, 0($s0)
    
    beq $t0, $zero, xor_end
    beq $t0, 10, xor_end   

    xor $t0, $t0, $s1      
    sb $t0, 0($s0)         

    addi $s0, $s0, 1
    j xor_loop

xor_end:
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
