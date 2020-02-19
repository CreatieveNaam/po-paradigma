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

To be able to execute assembly code we need a few things. First we need an x64 linux distribution. I use Debian since the guide also uses Debian. We also need an assembler. An assembler is basically a compiler for assembly code. I use NASM as assembler since the guide also uses NASM. To make a file and edit it we need an editor. For now I am using nano as editor.

Now we are ready to write assembly code. The first thing we need to do is make a file with an .asm extension. To make a file with the name 'hello' and an .asm extension we can use the following command: `nano hello.asm`. In this file we can write the assembly code. 

Once we are done writing code we need to compile the code. This can be done using the following command: `nasm -f elf64 -o hello.o hello.asm`. Elf64 is the assembly program format, hello.o is the output file and hello.asm is the input file. This command will produce an non executable object file called 'hello.o'. 

To make the file an excutable we need to link it using an linker. The linker I use is ld. The command for linking is: `ld hello.o -o hello`. This will produce an excutable file called 'hello'.

To execute the file, we can use the following command: `./hello`.

# Hello, World
Source video: https://youtu.be/BWRR3Hecjao

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
 
 So what does everything mean? We start with the `text db "Hello, World!",10`
 
 `db` stands for "define bytes". This means that we are going to define bytes of data. `"Hello, World!",10` is the bytes of data we are defining. The "10" is a newline character. `text` is the name assigned to the address in memory that this data is located in. When we use "text" in the code, when the code is compiled, the compiler will determine the actual location in memory of this data and replace all instances of "text" with that memory address. So the way i see it is that `text db "Hello, World!",10` is the equivalent of `String text = "Hello, World! \n"`.
 
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

![64-bit register](https://github.com/CreatieveNaam/po-paradigma/blob/master/64-bit%20register.png "rax register")

## Syscall
