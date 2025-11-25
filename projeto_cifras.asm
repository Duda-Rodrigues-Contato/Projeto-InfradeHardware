.data

	msg_escolha: .asciiz "Digite 1 para Cifra de César e 2 para Cifra XOR: "
	msg_operacao: .asciiz "Digite 1 para criptografar e 2 para descriptografar: "
	msg_texto: .asciiz "Digite o texto: "
	msg_chave: .asciiz "Digite a chave: "
	msg_resultado: .asciiz "O resultado é: "
	pula_linha: "\n"
	
	erro_chave_ cesar: .asciiz "Digite um valor do tipo inteiro"
	erro_chave_vigenere: .asciiz "Digite um valor do tipo String"
	
	tam_maximo: .word 100
	buffer_texto: .space 101
	buffer_chave: .space 101
	chave_cesar: .word 0
	
.text
.globl main

main:
# 1. Perguntar qual Cifra (Cesar ou XOR)
    li $v0, 4
    la $a0, menu_cipher
    syscall
    
    li $v0, 5           # Ler inteiro
    syscall
    move $s0, $v0       # $s0 guarda a escolha da Cifra (1=Cesar, 2=XOR)

    # 2. Perguntar o Modo (Criptografar ou Descriptografar)
    li $v0, 4
    la $a0, menu_mode
    syscall
    
    li $v0, 5           # Ler inteiro
    syscall
    move $s1, $v0       # $s1 guarda o modo (1=Encriptar, 2=Decriptar)

    # 3. Ler o Texto
    li $v0, 4
    la $a0, prompt_text
    syscall

    li $v0, 8           # Ler string
    la $a0, input_text  # Buffer
    li $a1, 100         # Tamanho maximo
    syscall

    # 4. Ler a Chave
    li $v0, 4
    la $a0, prompt_key
    syscall

    li $v0, 5           # Ler inteiro
    syscall
    move $s2, $v0       # $s2 guarda a chave

    # --- DESVIO LÓGICO ---
    beq $s0, 1, setup_cesar
    beq $s0, 2, setup_xor
    
    # Se opção inválida
    li $v0, 4
    la $a0, error_msg
    syscall
    j main_exit

# ---------------------------------------------------------
# LÓGICA DA CIFRA DE CÉSAR
# ---------------------------------------------------------
setup_cesar:
