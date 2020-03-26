section .data
    arr dq 50, 53, 52, 51, 55, 52, 49, 54
    temp dq 0
    temp2 dq 0
    partionIndex dq 0
    
section .text
    global main
    
main:
    mov rbp, rsp; for correct debugging
    mov rsi, arr    ; rsi is the array
    mov r10, 0      ; r10 will be the low index
    mov r11, 56     ; r11 ill be the higher index
    
    call _beginQuicksort
    
    mov rax, 60
    mov rdi, 0
    syscall
    
    _beginQuicksort:
        ; if (low < high) 
        cmp r10, r11
        jge _endQuicksort
                        
        ; --- PARTITION START ---  
              
                
        ; int pivot = arr[high]
        mov rdi, [rsi + r11] ; rdi will be our pivot
        
        ; int i = (low - 1)
        mov rax, r10
        sub rax, 8
        mov r15, rax ; r15 will be our 'i'
        
        ; int j = low
        mov rcx, r10   ; rcx will be the 'j' in the loop
                
        _beginForLoop:
            ; j <= high - 1
            mov rdx, r11
            sub rdx, 8
            cmp rcx, rdx
            jg _endForLoop
            
            _beginSwap:
                ; if (arr[j] <= pivot)
                mov rax, [rsi + rcx]
                cmp rax, rdi
                jg _endSwap
                
                ; i++
                add r15, 8
                
                ; int temp = arr[i]
                mov rax, [rsi + r15]
                mov [temp], rax
                
                ; arr[i] = arr[j]
                mov rax, [rsi + rcx] 
                mov [rsi + r15], rax
                
                ; arr[j] = temp
                mov rdx, [temp]
                mov [rsi + rcx], rdx 
            _endSwap:
            
                
            ; j++    
            add rcx, 8
            jmp _beginForLoop        
        _endForLoop:  
        
        ; int temp2 = arr[i + 1]
        mov rax, [rsi + r15 + 8]
        mov [temp2], rax
            
        ; arr[i + 1] = arr[high]
        mov rax, [rsi + r11]
        mov [rsi + r15 + 8], rax
            
        ; arr[high] = temp 2
        mov rdx, [temp2]
        mov [rsi + r11], rdx
            
        ; partionIndex = i + 1  
        mov rax, r15
        add rax, 8
        mov [partionIndex], rax
        
        ; --- PARTITION END ---    
        
        push r10
        push r11
        
        ;quicksort(arr, low, pi-1)
        mov rax, [partionIndex]
        sub rax, 8
        mov r11, rax
        call _beginQuicksort
        
        pop r11
        pop r10
        
        ;quicksort(arr, pi+1, high)
        mov rax, [partionIndex]
        add rax, 8
        mov r10, rax
        call _beginQuicksort
        
    _endQuicksort:
    ret