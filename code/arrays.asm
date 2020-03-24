section .data
	numbers db 52, 53, 50, 52, 50, 0
	digit db 0,10

section .bss
        numbersPos resb 8

section .text
	global main

main:
    mov rbp, rsp; for correct debugging
    mov rcx, numbers ; move numbers into rcx
    
    mov rax, [rcx]
    call _printDigitLoop
    
    mov rax, 60
    mov rdi, 1
    syscall
    

_printDigitLoop:
    inc rcx ; Increment rcx so we point to the next value in the array
    mov [numbersPos], rcx ; remember the address pointed to because a syscall updates the rcx register
    call _printRAXDigit ; print the digit in the rax register    
        
    mov rcx, [numbersPos] ; move rcx back to the original pointed number
    mov rax, [rcx] ; load that value to the rax register
    cmp al, 0 ; check if the end of the array is raeched
    jne _printDigitLoop ; if not, enter the loop again
        
    ret
            
_printRAXDigit:
    mov [digit], al            
      
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 2
    syscall
    
    ret


