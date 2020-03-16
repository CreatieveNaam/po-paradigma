section .data
	digit db 0,10

section .text
	global _start

_start:
	call _addDigits
;	call _pushDigitToStack
	call _displayDigit
	
	mov rax, 60
	mov rdi, 0
	syscall

_addDigits:
	mov rax, 49 	; 1
	add rax, 2 	; 3
	ret

_displayDigit:
	mov [digit], rax
	mov rax, 1
	mov rdi, 1
	mov rsi, digit
	mov rdx, 1
	syscall
	ret	
