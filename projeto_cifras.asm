.data

    msg_escolha: .asciiz "Digite 1 para Cifra de César e 2 para Cifra XOR: "
    msg_operacao: .asciiz "Digite 1 para criptografar e 2 para descriptografar: "
    msg_texto: .asciiz "Digite o texto: "
    msg_chave: .asciiz "Digite a chave: "
    msg_resultado: .asciiz "O resultado é: "
    pula_linha: .asciiz "\n"

    erro_chave_cesar: .asciiz "Digite um valor do tipo inteiro"
    erro_chave_xor: .asciiz "Digite um valor do tipo String"

    tam_maximo: .word 100
    buffer_texto: .space 101
    buffer_chave: .space 101
    chave_cesar: .word 0
    error_msg: .asciiz "Opção inválida. Tente novamente.\n"

.text
.globl main

main:

    # 1. Perguntar qual Cifra (Cesar ou XOR)
    li $v0, 4
    la $a0, msg_escolha
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0

    # 2. Perguntar o Modo (Criptografar ou Descriptografar)
    li $v0, 4
    la $a0, msg_operacao
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0

    # 3. Ler o Texto
    li $v0, 4
    la $a0, msg_texto
    syscall

    li $v0, 8
    la $a0, buffer_texto
    li $a1, 101
    syscall

    # 4. Ler a Chave
    li $v0, 4
    la $a0, msg_chave
    syscall

    li $v0, 5
    syscall
    move $s2, $v0

# --- DESVIO LÓGICO ---
    beq $s0, 1, setup_cesar
#   beq $s0, 2, setup_xor
    
    # Se opção inválida
    li $v0, 4
    la $a0, error_msg
    syscall
    j main_exit

# ---------------------------------------------------------
#             LÓGICA DA CIFRA DE CÉSAR
# ---------------------------------------------------------

setup_cesar:

    # Preparar a chave para César
    rem $s2, $s2, 26
    
    beq $s1, 1, cesar_loop
    
    # Se for Descriptografar, invertemos a rotação
    sub $s2, $zero, $s2
    
cesar_loop:

    la $t0, buffer_texto
    move $t1, $zero

cesar_interacao:

    add $t2, $t0, $t1
    lb $t3, 0($t2)
    
    beqz $t3, print_result
    beq $t3, 10, print_result

    # Verifica se é letra Maiúscula (A-Z -> 65-90)
    li $t4, 65
    li $t5, 90
    blt $t3, $t4, check_lower
    bgt $t3, $t5, check_lower
    
    # É Maiúscula
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
    j next_char

check_lower:

    # Verifica se é letra Minúscula (a-z -> 97-122)
    li $t4, 97
    li $t5, 122
    blt $t3, $t4, next_char
    bgt $t3, $t5, next_char

    # É Minúscula
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
    
next_char:

    addi $t1, $t1, 1
    j cesar_interacao


# ---------------------------------------------------------
#                      SAÍDA E FIM
# ---------------------------------------------------------

print_result:

    li $v0, 4
    la $a0, msg_resultado
    syscall
    
    li $v0, 4
    la $a0, buffer_texto
    syscall
    
main_exit:

    li $v0, 10
    syscall