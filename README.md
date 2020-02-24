# Introduction

This repository contains code and process details for my school assignment 'PO-paradigma'. My assignment is to learn a new programming language that interests me and differs from the programming language we are used to at school: Java.

This assignments purpose is to learn a new programming language by myself and to spread the knowledge I got from this assignment to fellow students. 

The new programming language I want to learn is assembly for the x86-64 instruction set. I chose assembly because I think it's important that software developers know how software works near the hardware level. Also, I have an interest in reverse-engineering but I never found an opportunity to learn assembly, so this is the ideal time to learn assembly.

The bulk of my information will come from [this](https://www.youtube.com/watch?v=VQAKkuLL31g&list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn) Youtube guide. My plan is to watch every video so I can provide a summary of the video and to implement my own version of code that was treated during the video.

For this assignment to be a success I will do a challenge: implement the quicksort algorithm in assembly.

During this assignment I will use the following tools:
- Debian 10.3 as operation system.
- NASM as assembler
- ld from the binutils package as linker
- Currently nano as 'IDE' but I will probably change this..

# Compiling and executing
Source video: https://youtu.be/VQAKkuLL31g

Code I made for this chapter: https://github.com/CreatieveNaam/po-paradigma/blob/master/util/auto-link

To be able to execute assembly code we need a few things. First we need an x64 linux distribution. I use Debian since the guide also uses Debian. We also need an assembler. An assembler is basically a compiler for assembly code. I use NASM as assembler since the guide also uses NASM. To make a file and edit it we need an editor. For now I am using nano as editor.

Now we are ready to write assembly code. The first thing we need to do is make a file with an .asm extension. To make a file with the name 'hello' and an .asm extension we can use the following command: `nano hello.asm`. In this file we can write the assembly code. 

Once we are done writing code we need to compile the code. This can be done using the following command: `nasm -f elf64 -o hello.o hello.asm`. Elf64 is the assembly program format, hello.o is the output file and hello.asm is the input file. This command will produce an non executable object file called 'hello.o'. 

To make the file an excutable we need to link it using an linker. The linker I use is ld. The command for linking is: `ld hello.o -o hello`. This will produce an excutable file called 'hello'.

To execute the file, we can use the following command: `./hello`.

# Hello, World
Source video: https://youtu.be/BWRR3Hecjao

Code I made for this chapter: https://github.com/CreatieveNaam/po-paradigma/blob/master/code/basicASM.asm

Now that we are able to compile and execute code we can start with the actual fun stuff: writing code. The code below is prints out "Hello, World".

```
section .data
	text db "Hello, World!",10

section .text
	global _start

_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, text
	mov rdx, 14
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
 ```
 Let's take a look what the code means.
 
 ## Defining Bytes 
 So what does `text db "Hello, World!",10` mean?
 
`db` stands for "define bytes". This means that we are going to define bytes of data. 
 
`"Hello, World!",10` is the bytes of data we are defining. The "10" is a newline character. 
 
`text` is the name assigned to the address in memory that this data is located in. When we use "text" in the code, when the code is compiled, the compiler will determine the actual location in memory of this data and replace all instances of "text" with that memory address.

## Sections
So what do the code `section .data` and `section .text` mean?

Well, there are three types of sections in assembly files. There is a .data section where all data is defined before compilation. We basically define memory for future use. 

There is a .text where all the code goes.

Lastly there is a .bss section where data is allocated for future use. We do not use it in the Hello World code but the .bss section often gets used for reservering bytes of memory for user input.

## Lables
So what does the code `_start:` mean?

Well, `_start:` is called a lable. A lable is used to lable a part of code. Upon compilation the compiler will calculate the location in which the lable will sit in memory. Any time the lable is used afterwards, that name is replaced by the location in memory of the compiler. 

The `_start:` lable is essential for all programs. When the program is compiled and executed, it is first executed at the location of `_start:`.

## Global
So what does the code `global _start` mean?

The word `global` is used when we want the linker to be able to know the address of some label. The object file generated will containt a link to every label declared `global`. In this case, we have to declare `_start` as global since it is required for the code to be propery linked.
 
 ## Registers
To understand the rest of the code, we first need to understand registers. Registers are a part of the processor that temporarily holds memory. In the x86_64 architecture, registers hold 64 bits. Below is a list of registers in the x86_64 architecture. 

8-bit | 16-bit | 32-bit | 64-bit
--- | --- | --- | ---
al | ax | eax | rax 
bl | bx | ebx | rbx
cl | cx | exc | rcx
dl | dx | edx | rdx
sil | si | esi | rsi
dil | di | edi | rdi
bpl | bp | ebp | rbp
spl | sp | esp | rsp
r8b | r8w | r8d | r8
r9b | r9w | r9d | r9
r10b | r10w | r10d | r10
r11b | r11w | r11d | r11
r12b | r12w | r12d | r12
r13b | r13w | r13d | r13
r14b | r14w | r14d | r14
r15b | r15w | r15d | r15

Notice the eax register. It's part of the rax register and half it's size. The 16-bit ax register is part of the eax register and half it's size and the 8-bit register al is part of the ax register and half it's size. So if we use the al register we are modifying the lower 8 bits of the rax register. The diagram below visualises the rax register.

![64-bit register](https://github.com/CreatieveNaam/po-paradigma/blob/master/img/64-bit%20register.png "rax register")

## Syscall
A syscall is when a program requests a service from the kernel. Every syscall has an ID associated with it. A syscall takes arguments. So when we use a syscall it has a number of inputs. Inputs are based on the value stored in the register.

argument | register 
--- | ---
ID | rax
1 | rdi
2 | rsi
3 | rdx
4 | r10
5 | r8
6 | r9

What we see in the table is that the ID of the syscall is stored in the rax register. The first argument in the rdi register and so on. So when you want to use a syscall you first need to store the ID value of the syscall in the rax register, the value of the first argument in the rdi register and so on. [This](http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/) table shows all syscall for the x64 instruction set and which value should be stored in which register.

Let's use sys_write as example. We want to write "Hello, World!\n" to the screen. If we look at the syscall table we see that the ID associated with sys_write is 1. So we want to store 1 in the rax register. We do this using the follow command: `mov rax, 1` (mov stand for move). We need to store the file descriptor in the rdi register. There are three file descriptors:

description | number 
--- | ---
stdin | 0
stdout | 1
stderr | 2

We want to write to the screen so as file descriptor we choose 1 (what the other ones mean will come later). We do this using the following command: `mov rdi, 1`. In the rsi register we want to store the pointer to memory address that holds the text "Hello, World!\n". If we take a look at the code of the "Hello World!" program we see the following line of code: `text db "Hello, World!",10`. We know that when we use 'text' in the code, the compiler will determine the actual location in memory of this data. So if we want to store the pointer to the memory address that holds the text "Hello, World!\n" in the rsi register we can use the following command: `mov rsi, text`. The last argument is the length of the string we want to print. In this case the length of our string is 14, so we want to store the value 14 in the rdx register. We do this using the following command `mov rdx, 14`. The last thing we need to do is make the syscall. We do this using the following command: `syscall`. 

# Jumps, Calls, Comparisons
Source video: https://youtu.be/busHtSyx2-w

Code I made for this chapter: https://github.com/CreatieveNaam/po-paradigma/blob/master/code/controlFlow.asm

In this chapter we get to know what flags, pointers, control flow, jumps, conditional jumps and calls are. We will also learn  how to do comparisions.

## Flags
Flags, like registers, hold data. This data is either a one (true) or a zero (false). Flags are part of a larger register called the flags register. 

## Pointers
Pointers are also registers that hold data. Pointer points to data. That means they hold the memory address of the data (not the value of the data). There are a bunch of different pointers but for know it's important to know what the rip pointer is. The rip pointer, or index pointer, points to the next address to be executed in the control flow.

## Control flow
By default all code runs from top to bottom. The direction a program flows is called the control flow. The rip register holds the address of the next instruction to be executed. After each instruction the rip register is incremented so that it holds the address of the next instruction to be executed, making the control flow, flow from top to bottom.

## Jumps
Jumps van be used to jump to different parts of code based on lables. They are used to divert program flow. The format of the jump is `jmp label`

## Comparisons
Comparisons allow programs to be able to take different paths based on certain conditions. The format of a comparison is `jmp register, register` or `jmp register, value`. After a comparision, flags are set.

## Conditional Jumps
After a comparison is made, a conditional jump can be made. Conditional jumps are based on the status of the flags. In code, conditional jumps are written just like 'normal' jumps, however `jmp` is replaced by the symbol for the conditional jump. The table below shows all jump symbols. 

Jump symbol (signed) | Jump symbol (unsigned) | Results of cmp a,b
--- | --- | ---
je | - | a = b
jne | - | a != b
jg | ja | a > b
jge | jae | a >= b
jl | jb | a < b
jle | jbe | a <= b
jz | - | a = 0
jnz | - | a != 0
jo | - | Overflow occurred
jno | - | Overflow did not occur
js | - | Jump if signed
jns | - | Jump if not signed

The following code will jump to the address of label \_doX if and only if the value in the rax register equals 25:
```
cmp rax, 25
je _doX
```

The following code will jump to the address of label \_doY if and only if the value in the rax register is greater than the value in the rbx register:
```
cmp rax, rbx
jg _doY
```

## Registers as pointers
The default registers can be treated as pointers. To treat a register as pointer, surround the register name with square brackets, such as \[rax]. The following code loads the value in the rbx register into the rax register:
```
mov rax, rbx
```

The following code loads the value the rbx is pointing to into the rax register:
```
mov rax, [rbx]
```

## Calls
A call is essentially the same as a jump. However when a call is used, the original position the call was made can be returned to using `ret`. 
