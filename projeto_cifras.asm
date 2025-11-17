.data

	msg_escolha: .asciiz "Digite 1 para Cifra de César e 2 para Cifra de Vigenère: "
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
