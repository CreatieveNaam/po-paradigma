; Basic program to show "My first assembly program" to the screen

section .data
	message db "My first assembly program",10

section .text
	global _start

_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, message
	mov rdx, 27
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
