.data
   
    msg_escolha:   .asciiz "\n--- MENU DE CRIPTOGRAFIA ---\n1. Cifra de Cesar\n2. Cifra XOR\nEscolha: "
    msg_operacao:  .asciiz "1. Criptografar\n2. Descriptografar\nEscolha: "
    msg_texto:     .asciiz "Digite o texto: "
    msg_resultado: .asciiz "\nO resultado e: "
    error_msg:     .asciiz "Opcao invalida. Tente novamente.\n"
    
   
    msg_chave_cesar: .asciiz "Digite a chave (DESLOCAMENTO inteiro ex: 3): "
    msg_chave_xor:   .asciiz "Digite a chave (CARACTERE unico ex: 'K'): "

   
    buffer_texto: .space 101
    buffer_chave_xor: .space 5   

.text
.globl main

main:
    # ---------------------------------------------------------
    # 1. ESCOLHER O ALGORITMO
    # ---------------------------------------------------------
    li $v0, 4
    la $a0, msg_escolha
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0        

    
    blt $s0, 1, opcao_invalida
    bgt $s0, 2, opcao_invalida

    # ---------------------------------------------------------
    # 2. ESCOLHER A OPERAÇÃO
    # ---------------------------------------------------------
    li $v0, 4
    la $a0, msg_operacao
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0        

    # ---------------------------------------------------------
    # 3. LER O TEXTO
    # ---------------------------------------------------------
    li $v0, 4
    la $a0, msg_texto
    syscall

    li $v0, 8            
    la $a0, buffer_texto
    li $a1, 101
    syscall

    # ---------------------------------------------------------
    # 4. DESVIO PARA LEITURA DA CHAVE CORRETA
    # ---------------------------------------------------------
    
    beq $s0, 1, prepare_cesar_key
    beq $s0, 2, prepare_xor_key

# ---------------------------------------------------------
# BLOCO: PREPARAÇÃO CÉSAR
# ---------------------------------------------------------
prepare_cesar_key:
    li $v0, 4
    la $a0, msg_chave_cesar
    syscall

    li $v0, 5            
    syscall
    move $s2, $v0        

    
    rem $s2, $s2, 26     
    beq $s1, 1, cesar_loop_start 
    sub $s2, $zero, $s2         

    j cesar_loop_start

# ---------------------------------------------------------
# BLOCO: PREPARAÇÃO XOR
# ---------------------------------------------------------
prepare_xor_key:
    li $v0, 4
    la $a0, msg_chave_xor
    syscall

    li $v0, 8            
    la $a0, buffer_chave_xor
    li $a1, 4
    syscall
    
    
    lb $s2, buffer_chave_xor($zero)  
    
    j xor_loop_start

# ---------------------------------------------------------
# LÓGICA DA CIFRA DE CÉSAR
# ---------------------------------------------------------
cesar_loop_start:
    la $t0, buffer_texto
    move $t1, $zero      

cesar_iteracao:
    add $t2, $t0, $t1    
    lb $t3, 0($t2)       

   
    beqz $t3, print_result
    beq $t3, 10, print_result 

    
    li $t4, 65
    li $t5, 90
    blt $t3, $t4, check_lower
    bgt $t3, $t5, check_lower
    
    
    sub $t3, $t3, 65
    add $t3, $t3, $s2
    rem $t3, $t3, 26
    bltz $t3, fix_neg_upper
    j store_upper
    
fix_neg_upper:
    addi $t3, $t3, 26
store_upper:
    addi $t3, $t3, 65
    sb $t3, 0($t2)
    j next_char_cesar

check_lower:
   
    li $t4, 97
    li $t5, 122
    blt $t3, $t4, next_char_cesar
    bgt $t3, $t5, next_char_cesar

    
    sub $t3, $t3, 97
    add $t3, $t3, $s2
    rem $t3, $t3, 26
    bltz $t3, fix_neg_lower
    j store_lower

fix_neg_lower:
    addi $t3, $t3, 26
store_lower:
    addi $t3, $t3, 97
    sb $t3, 0($t2)

next_char_cesar:
    addi $t1, $t1, 1
    j cesar_iteracao

# ---------------------------------------------------------
# LÓGICA DA CIFRA XOR
# ---------------------------------------------------------
xor_loop_start:
    la $t0, buffer_texto
    move $t1, $zero      

xor_iteracao:
    add $t2, $t0, $t1    
    lb $t3, 0($t2)       

   a
    beqz $t3, print_result
    beq $t3, 10, print_result 

    # --- Operação XOR ---
    
    xor $t3, $t3, $s2
    sb $t3, 0($t2)      

    addi $t1, $t1, 1     
    j xor_iteracao


# ---------------------------------------------------------
# SAÍDA E FIM
# ---------------------------------------------------------
print_result:
    li $v0, 4
    la $a0, msg_resultado
    syscall
    
    li $v0, 4
    la $a0, buffer_texto
    syscall
    
    j main_exit

opcao_invalida:
    li $v0, 4
    la $a0, error_msg
    syscall
    j main_exit

main_exit:
    li $v0, 10
    syscall