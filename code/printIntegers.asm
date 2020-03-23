; Explaining printing Integers.

section .bss
	; Reserve the space for our String to print out.
	digitSpace resb 100

	; Reserve 8 bytes. Why 8? Well 8 bytes can hold the value
	; of a single register.
	digitSpacePos resb 8

section .text:
	global _start:

_start:
	mov rax, 1337
	call _printRAX

	mov rax, 60
	mov rdi, 0
	syscall

_printRAX: 
	mov rcx, digitSpace
	mov rbx, 10
	; Where rcx points to, store rbx in that memory location
	mov [rcx], rbx

	; Where digitSpacePosition points to, store rcx in that
	; memory location. What we say here is point to the next
	; writeable area of the digit space.
	inc rcx 
	mov [digitSpacePos], rcx
	
_printRAXLoop:
	; We need to mov 0 into rdx. If rdx is not zero it will mess
	; up the division. If the rdx is not 0 the rdx register will
	; be concatted into the rax register and make the rdx and rax
	; register act like a 128-bit register.	
	mov rdx, 0
	mov rbx, 10

	; Divide rax by value in rbx (10). We divide by 10? So we can
	; see the last number of the integer we are dividing. 
	div rbx

	; Store the value in rax for later use.
	push rax

	; So the remainder of our division is located in the rdx
	; register. We need to add 48 to to make it a character.
	add rdx, 48

	; Dereference the content of digitSpacePos and store
	; the pointed-to value in rcx
	mov rcx, [digitSpacePos]

	; Where rcx points to, store dl (the lower 8 bit part of
	; the rdx register)
	mov [rcx], dl

	; Move to the next position of digitSpace
	inc rcx

	; Move value of rcx into digitSpacePos
	mov [digitSpacePos], rcx

	; Now we want to rax value back
	pop rax;

	; We divided rax by 10, if it's not equal to 0 that means
	; there is still a number left.
	cmp rax, 0
	jne _printRAXLoop

_printRAXLoop2:
	mov rcx, [digitSpacePos]
	
	; Print digit
	mov rax, 1
	mov rdi, 1
	mov rsi, rcx
	mov rdx, 1
	syscall
	
	mov rcx, [digitSpacePos]
	dec rcx
	mov [digitSpacePos], rcx

	; If this is true, we reached the beginning of the digitSpace
	; This means we are done priting character.
	cmp rcx, digitSpace
	jge _printRAXLoop2

	ret
