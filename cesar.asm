.text
cifra_cesar:
    addi $sp, $sp, -12    
    sw $ra, 8($sp)        
    sw $s0, 4($sp)        
    sw $s1, 0($sp)        

    move $s0, $a0         
    move $s1, $a1         

cesar_loop:
    lb $t0, 0($s0)        
    
    beq $t0, $zero, cesar_end  
    beq $t0, 10, cesar_end     

    li $t1, 65
    li $t2, 90
    blt $t0, $t1, check_lower
    bgt $t0, $t2, check_lower
    
    sub $t0, $t0, 65      
    add $t0, $t0, $s1     
    rem $t0, $t0, 26      
    bltz $t0, fix_neg_upper
    j store_upper
fix_neg_upper:
    addi $t0, $t0, 26
store_upper:
    addi $t0, $t0, 65     
    sb $t0, 0($s0)        
    j cesar_next

check_lower:
    li $t1, 97
    li $t2, 122
    blt $t0, $t1, cesar_next
    bgt $t0, $t2, cesar_next

    sub $t0, $t0, 97
    add $t0, $t0, $s1
    rem $t0, $t0, 26
    bltz $t0, fix_neg_lower
    j store_lower
fix_neg_lower:
    addi $t0, $t0, 26
store_lower:
    addi $t0, $t0, 97
    sb $t0, 0($s0)

cesar_next:
    addi $s0, $s0, 1     
    j cesar_loop

cesar_end:
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra               