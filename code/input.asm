; Basic assembly program that will repeat what was inputted

section .data
	message db "Input something",10

section .bss
	input resb 16

section .text
	global _start

_start:
	call _printMessage
	call _recieveInput
	call _printInput
	
	mov rax, 60
	mov rdi, 0
	syscall

_printMessage:
	mov rax, 1
	mov rdi, 1
	mov rsi, message
	mov rdx, 17
	syscall
	ret

_recieveInput:
	mov rax, 0 ; sys_read
	mov rdi, 0 ; stdin
	mov rsi, input
	mov rdx, 16
	syscall
	ret

_printInput:
	mov rax, 1
	mov rdi, 1
	mov rsi, input
	mov rdx, 16
	syscall
	ret
