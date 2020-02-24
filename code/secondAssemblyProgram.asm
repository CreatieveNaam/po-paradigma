section .data
	first db "My first assembly program",10
	second db "My second assembly program!",10
	print db "This should definitly be printed!",10
	
section .text
	global _start

_start:
	mov rbx, 25 ; Move 25 into rbx register
	mov rax, rbx ; Move the value in rbx (25) into rax
	cmp rax, rbx ; Compare rax (25) to rbx (25)
	je _printSecond ; This should be executed since the value in rax (25) equals 25
	jmp _printFirst ; This should not be executed since we jumped to the _printSecond lable.

_printSecond:
	mov rax, 1
	mov rdi, 1
	mov rsi, second
	mov rdx, 28
	syscall

	call _printPrint
	
	; I think the next memory address the rip register will point to is the beginning 
	; of the _endProgram lable. Since i'm not explicitly ending the program, but the
	; program does end.

_endProgram:
	mov rax, 60
	mov rdi, 0
	syscall	

_printPrint:
	mov rax, 1
	mov rdi, 1
	mov rsi, print
	mov rdx, 35
	syscall
	ret ; Return to original position where we called from	

_printFirst:
	mov rax, 1
	mov rdi, 1
	mov rsi, first
	mov rdx, 277
	syscall
