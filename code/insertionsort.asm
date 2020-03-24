section .data
    arr dq 59, 56, 54, 52, 53, 52, 52, 0

section .text
    global main
    
main:
    mov rbp, rsp; for correct debugging

    mov rcx, 8      ; rcx will be used as 'i' since the convention is to use *CX in loops.
    mov rbx, 0      ; rbx will be used as the key. The convetion is to use *BX to point to data.
    mov rsi, arr    ; rsi will be used as the source of the stream operation. 
    
    _beginForLoop:
        ; i == 0x0
        mov rax, [rsi + rcx]    ; rax = arr[pointer to element i of array]
        cmp rax, 0              ; Null byte marks end of the array
        je _endForLoop
        
        ; key = arr[i]
        mov rbx, [rsi + rcx] 
        
        ; j = i - 1
        push rcx ; From now on we are going to use rcx for the 'j' in the loop
        sub rcx, 8
                          
        _BeginWhileLoop:
            ; While loop condition (j >= 0)
            cmp rcx, -8
            je _endWhileLoop
            
            ; While loop condition (arr[j] > key)
            cmp [rsi + rcx], rbx
            jle _endWhileLoop
            
            ; arr[j + 1] = arr[j]
            mov rax, [rsi + rcx]
            mov [rsi + rcx + 8], rax ; Value of rax rememberd in the while loop conidition
      
            ; j = j - 1
            sub rcx, 8
            
            ; Go back to while loop begin
            jmp _BeginWhileLoop
        
        _endWhileLoop:
        
        ; arr[j + 1] = key
        mov [rsi + rcx + 8], rbx     
        
        ; Loop has finished
        pop rcx ; We need to get the 'i' back
        add rcx, 8
        jmp _beginForLoop ; Lets go the the beginning
    
    _endForLoop:     
       
    mov rax, 60
    mov rdi, 0
    syscall
    