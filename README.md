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

# Writing, compiling and executing code using NASM
Source video: https://youtu.be/VQAKkuLL31g

To be able to execute assembly code we need a few things. First we need an x64 linux distribution. I use Debian since the guide also uses Debian. We also need an assembler. An assembler is basically a compiler for assembly code. I use NASM as assembler since the guide also uses NASM. To make a file and edit it we need an editor. For now I am using nano as editor.

Now we are ready to write assembly code. The first thing we need to do is make a file with an .asm extension. To make a file with the name 'hello' and an .asm extension we can use the following command: `nano hello.asm`. In this file we can write the assembly code. 

Once we are done writing code we need to compile the code. This can be done using the following command: `nasm -f elf64 -o hello.o hello.asm`. Elf64 is the assembly program format, hello.o is the output file and hello.asm is the input file. This command will produce an non executable object file called 'hello.o'. 

To make the file an excutable we need to link it using an linker. The linker I use is ld. The command for linking is: `ld hello.o -o hello`. This will produce an excutable file called 'hello'.

To execute the file, we can use the following command: `./hello`.
