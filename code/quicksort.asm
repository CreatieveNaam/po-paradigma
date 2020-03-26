; Quicksort in assembler x64 using the median of three pivot.

section .data
    arr dq 50, 51, 49, 47, 51, 52, 58, 59, 4
    
section .text
    global main
    
main:
    
    mov rbp, rsp; for correct debugging
    mov rsi, arr    ; rsi is the array
    mov r10, 0      ; r10 will be the low index
    mov r11, 64      ; r11 will be the higher index
    
    call _beginQuicksort
     
    mov rax, 60
    mov rdi, 0
    syscall
    
    _beginQuicksort:
    ; if (low < high) 
        cmp r10, r11
        jge _endQuicksort
        
        ; Determine the pivot
        
        mov rax, r10
        mov rdx, r11
        add rax, rdx    ; low + high
        shr rax, 4      ; Shift right 4 times, we get the 'index' of the middle of the array
        shl rax, 3      ; Multiply that number by 8 (to get the real index) by shifting left 3 times.
        mov rdi, rax    ; rdi = mid (for now)
        
        _beginFirstPivotIf:
            ; if (arr[mid] < array[low])
            mov rdx, [rsi + rdi]    ; rdx = arr[mid]
            mov rax, [rsi + r10]    ; rax = arr[low]
            cmp rdx, rax
            jge _endFirstPivotIf
            
            ; Swap arr[low] with arr[mid]
            mov [rsi + rdi], rax    ; arr[mid] = rax
            mov [rsi + r10], rdx    ; arr[low] = rdx
        _endFirstPivotIf:
        _beginSecondPivotIf:
            ; if (arr[high] < arr[low])
            mov rdx, [rsi + r11]    ; rdx = arr[high]      
            mov rax, [rsi + r10]    ; rax = arr[low]
            cmp rdx, rax
            jge _endSecondPivotIf
            
            ; Swap arr[low] with arr[high]
            mov [rsi + r11], rax    ; arr[high] = rax
            mov [rsi + r10], rdx    ; arr[low] = rdx
        _endSecondPivotIf:
        _beginThirdPivotIf:
            ; if (arr[mid] < arr[high])
            mov rdx, [rsi + rdi]    ; rdx = arr[mid]
            mov rax, [rsi + r11]    ; rax = arr[high]
            cmp rdx, rax
            jge _endThirdPivotIf
            
            ; Swap arr[mid] with arr[high]
            mov [rsi + r11], rax    ; arr[high] = rdx
            mov [rsi + rdi], rdx    ; arr[mid] = rax
        _endThirdPivotIf:
        
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
                cmp [rsi + rcx], rdi    ; Compare arr[j] to pivot
                jg _endSwap
                
                ; i++
                add r15, 8
                
                ; Swap
                mov rdx, [rsi + r15]    ; rdx = arr[i]               
                mov rax, [rsi + rcx]    ; rax = arr[j]
                mov [rsi + r15], rax    ; arr[i] = rax
                mov [rsi + rcx], rdx    ; arr[j] = rdx
            _endSwap:
            
            ; j++    
            add rcx, 8                      
            jmp _beginForLoop        
        _endForLoop:  
        
        
        ; Swap arr[i + i] and arr[high]
        mov rdx, [rsi + r15 + 8]    ; rdx = arr[i + i]
        mov rax, [rsi + r11]        ; rax = arr[high]
        mov [rsi + r15 + 8], rax    ; arr[i + 1] = rax
        mov [rsi + r11], rdx        ; arr[high] = rdx

        ; pi = i + 1
        mov rax, r15
        add rax, 8
        mov r14, rax    ; r14 wil be our partion index
        
        push r10
        push r11
        
        ;quicksort(arr, low, pi-1)
        mov rax, r14
        sub rax, 8
        mov r11, rax
        call _beginQuicksort
        
        pop r11
        pop r10
        
        ;quicksort(arr, pi+1, high)
        mov rax, r14
        add rax, 8
        mov r10, rax
        call _beginQuicksort
        
    _endQuicksort:
    ret   
   
