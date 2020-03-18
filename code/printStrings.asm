; Program to show a subroutine to print Strings.

section .data
	; Here we define bytes for the text "Hello World!" \n. Nothing to special.
	; Notice the 3 at the end though. This 3 is used to mark it as the end of
	; the String. In the ASCII table the 3 means end of text (ETX). So if there
	; is a 3, this means it's the end of text
	text db "Hello World!",10,3
	
	; Define another String for demonstration.
	text2 db "Hello World 2!",10,3

section .text
	global _start

_start:
	mov rax, text

	; Read print & printLoop first, after that come back here. How can we call
	; print when print isn't even a subroutine? Well, since assembler executes 
	; code line by line, at the end of print it will simply go to printLoop until
	; it finds a ret, after that it goes back to the callers position.
	call _print 

	mov rax, text2
	call _print

	; Exit the program
	mov rax, 60
	mov rdi, 0
	syscall
_print:
	; Push the value of rax into the stack. We save the value of rax for later.
	; In this case the value of rax is the pointer text
	push rax
	
	; We are going to use the rbx register to count the length of the String.
	mov rbx, 0 
_printLoop:
	
	; Here we increment rax. Why incremnt? So rax contains a pointer to the
	; String. Since rax is a pointer it moves the pointer by one byte.  	
	inc rax

	; Here we increment rbx. Why increment rbx? Well we use rbx to keep track
	; of the length of the String. 
	inc rbx

	; This is where the cool shit happens. Remember we incremented rax? Well
	; cl (the lower 8-bit section of rcx) get the value rax point to. Let's say
	; rax is the pointer to text (text has the value "Hello World",10). So in
	; the first iteration of the loop we are going to load 'H' into cl. The
	; second iteration of the loop we are going to load 'e' into cl.
	mov cl, [rax]
	
	; So here we compare cl to 3. If the value in cl is 3 it means we reached the end of the String. 
	cmp cl, 3

	; But if it's not 3 we need to continue the loop since the end of the String is not reached.
	jne _printLoop

	; Code for sysout. Nothing to special
	mov rax, 1
	mov rdi, 1

	; Remember we pushed the value of rax onto the stack? Now we want to use
	; that value. So we pop the value of the stack into the rsi register.
	; Why the rsi register? Well the rsi register needs the pointer to
	; the String we want to print.
	pop rsi

	; We also kept track of the length of the String. This value is found
	; in the rbx register. To output a String we need to keep track of
	; its length. Register rbx did this for us in the loop. 
	mov rdx, rbx
	
	; Do it
	syscall

	; It's a subroutine
	ret
