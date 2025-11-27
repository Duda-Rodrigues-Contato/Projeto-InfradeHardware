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
.include "cesar.asm"
.include "xor.asm"

main:
    li $v0, 4
    la $a0, msg_escolha
    syscall
    
    li $v0, 5
    syscall
    move $s0, $v0       

    blt $s0, 1, erro_input
    bgt $s0, 2, erro_input

    li $v0, 4
    la $a0, msg_operacao
    syscall
    
    li $v0, 5
    syscall
    move $s1, $v0        

    blt $s1, 1, erro_input
    bgt $s1, 2, erro_input

    li $v0, 4
    la $a0, msg_texto
    syscall

    li $v0, 8
    la $a0, buffer_texto
    li $a1, 101
    syscall

    beq $s0, 1, setup_cesar
    beq $s0, 2, setup_xor

setup_cesar:
    li $v0, 4
    la $a0, msg_chave_cesar
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0    
    
    rem $t0, $t0, 26
    beq $s1, 1, call_cesar
    sub $t0, $zero, $t0  

call_cesar:
    la $a0, buffer_texto
    move $a1, $t0
    jal cifra_cesar      
    j show_result

setup_xor:
    li $v0, 4
    la $a0, msg_chave_xor
    syscall
    
    li $v0, 8
    la $a0, buffer_chave_xor
    li $a1, 4
    syscall
    
    lb $t0, buffer_chave_xor($zero) 

    la $a0, buffer_texto
    move $a1, $t0
    jal cifra_xor        
    j show_result
    
show_result:
    li $v0, 4
    la $a0, msg_resultado
    syscall
    
    li $v0, 4
    la $a0, buffer_texto
    syscall
    
    j fim_programa

erro_input:
    li $v0, 4
    la $a0, error_msg
    syscall
    j main 

fim_programa:
    li $v0, 10
    syscall