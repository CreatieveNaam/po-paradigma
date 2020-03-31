# Introduction

This repository contains code and process details for my school assignment 'PO-paradigma'. My assignment is to learn a new programming language that interests me and differs from the programming language we are used to at school: Java.

This assignments purpose is to learn a new programming language by myself and to spread the knowledge I got from this assignment to fellow students. 

The new programming language I want to learn is assembly for the x86-64 instruction set. I chose assembly because I think it's important that software developers know how software works near the hardware level. Also, I have an interest in reverse-engineering but I never found an opportunity to learn assembly, so this is the ideal time to learn assembly.

The bulk of my information will come from [this](https://www.youtube.com/watch?v=VQAKkuLL31g&list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn) Youtube guide. 

For this assignment to be a success, I will do a challenge: implement the insertion sort algorithm in assembler x64. My assignment will be a success when the assembler code is able to sort an array from low to high using the insertion sort algorithm. I think this challenge is perfect to implement in assembler since assembler code can produce much faster code (and fast sorting is what we want) then high(er) level languagues (Kent State University, z.d).

During this assignment I will use the following tools:
- Debian 10.3 as operation system.
- NASM as assembler
- [SASM](https://dman95.github.io/SASM/english.html) as IDE

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
So what does the code `section .data` and `section .text` mean?

Well, there are three types of sections in assembly files. There is a .data section where all data is defined before compilation. We basically define memory for future use. 

There is a .text where all the code goes.

Lastly, there is a .bss section where data is allocated for future use. We do not use it in the Hello World code but the .bss section often gets used for reservering bytes of memory for user input.

## Labels
So what does the code `_start:` mean?

Well, `_start:` is called a label. A label is used to label a part of code. Upon compilation the compiler will calculate the location in which the label will sit in memory. Any time the label is used afterwards, that name is replaced by the location in memory of the compiler. 

The `_start:` label is essential for all programs. When the program is compiled and executed, it is first executed at the location of `_start:`.

## Global
So what does the code `global _start` mean?

The word `global` is used when we want the linker to be able to know the address of some label. The object file generated will contain a link to every label declared `global`. In this case, we have to declare `_start` as global since it is required for the code to be properly  linked.
 
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

Let's use sys_write as example. We want to write "Hello, World!\n" to the screen. If we look at the syscall table we see that the ID associated with sys_write is 1. So we want to store 1 in the rax register. We do this using the following command: `mov rax, 1` (mov stand for move). We need to store the file descriptor in the rdi register. There are three file descriptors:

description | number 
--- | ---
stdin | 0
stdout | 1
stderr | 2

We want to write to the screen so as file descriptor we choose 1 (what the other ones mean will come later.). We do this using the following command: `mov rdi, 1`. In the rsi register we want to store the pointer to memory address that holds the text "Hello, World!\n". If we take a look at the code of the "Hello World!" program we see the following line of code: `text db "Hello, World!",10`. We know that when we use 'text' in the code, the compiler will determine the actual location in memory of this data. So if we want to store the pointer to the memory address that holds the text "Hello, World!\n" in the rsi register we can use the following command: `mov rsi, text`. The last argument is the length of the string we want to print. In this case the length of our string is 14, so we want to store the value 14 in the rdx register. We do this using the following command `mov rdx, 14`. The last thing we need to do is make the syscall. We do this using the following command: `syscall`. 

# Jumps, Calls, Comparisons
Source video: https://youtu.be/busHtSyx2-w

Code I made for this chapter: https://github.com/CreatieveNaam/po-paradigma/blob/master/code/controlFlow.asm

In this chapter we get to know what pointers, control flow, jumps, conditional jumps and calls are. We will also learn  how to do comparisons.

## Pointers
Pointers are also registers that hold data. Pointer points to data. That means they hold the memory address of the data (not the value of the data). There are a bunch of different pointers but for know it's important to know what the rip pointer is. The rip pointer, also known as the index pointer, points to the next address to be executed in the control flow.

## Control flow
By default all code runs from top to bottom. The direction a program flows is called the control flow. The rip register holds the address of the next instruction to be executed. After each instruction the rip register is incremented so that it holds the address of the next instruction to be executed, making the control flow, flow from top to bottom.

## Jumps
Jumps van be used to jump to different parts of code based on labels. They are used to divert program flow. The format of the jump is `jmp label`

## Comparisons
Comparisons allow programs to be able to take different paths based on certain conditions. The format of a comparison is `jmp register, register` or `jmp register, value`.

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
A call is essentially the same as a jump. However, when a call is used, the original position the call was made can be returned to using `ret`. 

# Math operations, displaying a digit and the Stack
Source video: https://www.youtube.com/watch?v=NFv7l3wQsZ4

In this chapter we get to know how to do math operations, display a digit and use the Stack. You should know what the [Stack](https://www.cs.cmu.edu/~adamchik/15-121/lectures/Stacks%20and%20Queues/Stacks%20and%20Queues.html) is before you read this chapter. You should also be familiar with the ASCII [table](https://i.stack.imgur.com/iCOov.gif).

## Math operations
Math operations are used to mathematically manipulate register. The syntax of a math operation is typically `operation register, value/register`. The first register is the subject op the operation. The table below shows every math operation.

Operation | Operation Name | Operation Name (signed) | Description
--- | --- | --- | --- 
add | add a, b | - | a = a + b
substract | sub a, b | - | a = a - b
multiply | mul reg | imul reg | rax = rax * reg
divide | div reg | idiv reg | rax = rax / reg
negate | neg reg | - | reg = -reg
increment | inc reg | - | reg = reg + 1
decrement | dec reg | - | reg = reg - 1
add carry | adc a, b| - | a = a+b+CF
substract carry | sbb a, b | - | a = a-b-CF

When using `adc` or `sbb` we add or substract but we also add the [carry flag](http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt)

## Displaying a digit
The following code can be used to display a digit between 0 and 9. What does each line of code mean?
```
section .data
	digit db 0,10
	
... 

_printRAXDigit:
	add rax, 48
	mov [digit], al
	mov rax, 1
	mov rdi, 1
	mov rsi, digit
	mov rdx, 2
	syscall
	ret
```
The code `add rax, 48` adds 48 to the rax register. So if the value in rax was 0, it is now 48. If we look at the ASCII table we, can see that 48 is the value of the "0" character.

The code `mov [digit], al` moves the lower byte of the rax register into the memory address 'digit'. 'Digit' is actually defined with two bytes (0 and 10). Since we are only loading the lower byte of the rax register into 'digit', it only overwrites the first byte and does not affect the newline character.

The code after `mov [digit], al` prints the two bytes to the screen and returns to the position the subroutine was called from. 

This subroutine can be used to display a digit between 0-9 by 7 loading that digit into the rax register then calling the subroutine, like so:
```
mov rax, 7
call _printRAXDigit
```

## The Stack
To push a value onto the stack use `push reg/value`

To pop a value of the stack use `pop reg`

To peek on the stack use `mov reg, [rsp]`

Usually in places where you can use registers, you can also use pointers. Such as, instead of `pop reg` we can use `pop [label]` to pop a value off the stack directly into a position in memory.

# Subroutine to print Strings.
Source video: https://www.youtube.com/watch?v=Fz7Ts9RN0o4.

This time I am going to do it differently. I got annoyed with typing so much in the readme.md and I wanted to code. So I just explained the code using comments. Code of this video with explanation can be found [here](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/printStrings.asm)

# Subroutine to print Integers.
Source video: https://www.youtube.com/watch?v=Fz7Ts9RN0o4

Just as last time, I explain the code in the file. See explanation [here](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/printIntegers.asm)


# Arrays
Sources: [This](https://www.tutorialspoint.com/assembly_programming/assembly_arrays.htm) tutorial, [this](https://www.youtube.com/watch?v=bM0_HRkM_CE) video.

The video tutorial doesn't teach the use of arrays, but I think it's crucial to use arrays for implementing insertion sort. Defining an array is almost the same as defining one 'variable'. Instead of `num db 52` for defining one 'variable' we use `num db 52, 53` for defining an array. To see how I printed the array see [this](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/arrays.asm) file.

I noticed it became very difficult to debug my code so I changed my IDE from nano to SASM. Instead of `global _start` SASM needs a `global _main`. So from now on I will use main instead of start.


# Insertion sort
My challenge was to implement insertion sort in assembly. Well, I did it. Insertion sort in assembly can be found [here](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/insertionsort.asm). 

# Quicksort
I also implemented quicksort in assembly, see the code [here](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/quicksort.asm)

# Differences Java and Assembler x64
During the process of learning assembler I noticed a fair number of differences between Java and Assembler x64. In this chapter I will list these differences and give my opinion on them. I will also list differences I didn't notice but are present.

Portability. Assembler is platform specific (Agner, F. 2020). The insertion sort code doesn't work on raspberry pi for example because the raspberry pi instruction set is different. In my opinion this is a downside of assembly x64. If I write code I want to run it everywhere and not rewrite it for different hardware. I prefer Java over assembly x64 in this case.

Debugging. Assembly code is more difficult to debug (Fog, A. 2020). High-level languages like Java protects the programmer against errors. When I was writing the code for quicksort, I tried to pop an empty stack. Java would've thrown a runtime exception. Assembly didn't throw anything; it put a random(?) number in the register I popped it into. In this case i prefer Java because it protects me more from errors then assembly.

Development time. Writing code in assembly takes much longer then in a high level lanague (Fog, A. 2020). It took me a few hours to implement insertion sort in assembly. In Java I did it in less then an hour. In this case I prefer Java because Java allows me to write more code (that functions) in less time.

Paradigm. Java is Object Oriented; assembly is imperative. The main difference between the Object Oriented paradigm and the imperative paradigm is that in the Object Orient paradigm classes talk to each other. In the imperative paradigm statements change the state of the program. For very small programs (say less than 20 lines of code.) I generally prefer the imperative paradigm since i'm able to quickly write some code and execute it. Of course it depends on what kind of code I'll be writing but generally speaking I prefer the imperative paradigm. However, the larger the codebase the more I prefer the Object Oriented paradigm since the Object Oriented paradigm allows me to structure my code better then the imperative paradigm.

Syntax. Not alot of explanation needed. I prefer the assembly syntax. It's simpler and cleaner looking then Java.

Program Flow. Assembly code gets executed from top to bottom. If the bottom is reached, it will stop executing the programming. The control flow in assembly can be changed using jumps and subroutine calls. In Java the code will also execute from top to bottom but this gets done automatically. Also, when I call a method Java will only execute that method and return to what code called that method, it doesn't execute the next method when I don't explicitly state that the method should return. I prefer Java, I have to think less about the program flow and this makes me able to focus more on the codes functionality.

Type. Assembly is an untyped language (University of Debrecen, z.d.). In the case of assembly, this means that all values are represented as word-sized integers (Morrisett, G., Walker, D, Crary, K., Glew, N, 1999). Java is a static, manifestly typed language (University of Debrecen, z.d.). This means I have to explicitly declarate a variable it's type during compile time. I have to say I liked the untyped system of assembly.I could put any value I wanted in every register. This make it easier to write code faster. However, since assembly is untyped, I can also multiply a string by 2 which shouldn't be possible in my opinion. So I like the untyped property of assembly, but I think it wil lead to a lot of unexpected behaviour.

The stack. In assembly I have direct access to the stack. I actually liked this alot about assembly. In Java I have to manually make a temporary variable (or import the stack library or something) but in assembly the stack was already there so I didn't have to manually make a structure to save values. In my opinion Java should also implement a structure where I can use the stack directly without importing and declaring the stack.

(Un)strucutered. Assembly is unstructured, Java is structured. Unstructured means that the code cannot be clearly separated in different modules (C. A. Hofeditz, 1985). I prefer Java in this case because it makes me able to structure my code better and thus make it more readable.

Scoping. Assembly doesn't support scoping; there is only one scope and that is the global scope. I prefer Java. I can reuse commenly used variables (like *i* in for loops) and having a local scope reduces bugs (P.W. Homer, 2005).

Generation. Assembly is a typed as a second type generation programming language. Java is a typed as a third type generation programming language. Second-generation languages are abstracted machine code, such as assembly language, that are tied to a specific system architecture but are human readable and need to be compiled. Third-generation programming languages decouple code from the processor, allowing for the development of code that used more readable statements (Eugene, P., Angela B, 2020). Like I said before, I want my code to run everywhere without rewriting it for different hardware. I prefer third generation languages over second-generation languages.


- TODO
- What vind ik belangrijk bij talen 
- Of assembler zijn doel bereikt

# Sources
References to sources is in the Dutch way. 

Kent State University. (z.d). *The Assembly Language Level*. Geraadpleeg op 27 maart 2020, van http://www.personal.kent.edu/~aguercio/CS35101Slides/Tanenbaum/CA_Ch07.pdf

Landmark Universty. (z.d). *Programming Paradigms*. Geraadpleegd op 30 maart 2020, van https://cs.lmu.edu/~ray/notes/paradigms/

Fog, A. (2020, 4 maart). *Optimizing subroutines in assembly language*. Geraadpleegd op 30 maart 2020, van
https://www.agner.org/optimize/optimizing_assembly.pdf

University of Maryland. (z.d). *Incremental Java*. Geraadpleegd op 30 maart 2020, van https://www.cs.umd.edu/~clin/MoreJava/Intro/what-prog.html

University of Debrecen. (z.d.). *New Programming Paradigms*. Geraadpleegd op 31 maart 2020, van https://arato.inf.unideb.hu/panovics.janos/npp-intro.pdf

Morrisett, G., Walker, D, Crary, K., Glew, N. (Maart 1999). *From System F to Typed Assembly Language*. Geraadpleegd op 31 maart 2020, van https://www.cs.princeton.edu/~dpw/papers/tal-toplas.pdf

C. A. Hofeditz. (1985). *Computer programming languagues in practice*. Geraadpleegd op 31 maart 2020, van
https://books.google.nl/books?id=EGWeBQAAQBAJ&pg=PA43&lpg=PA43&dq=unstructured+programming+language&source=bl&ots=q_C4SyagTu&sig=ACfU3U2VMsc9triTNcTSjne5PDc4fX389w&hl=nl&sa=X&ved=2ahUKEwiToPzX1sToAhVM2qQKHX3HACI4FBDoATAEegQIChAB#v=onepage&q=unstructured%20programming%20language&f=false

P.W. Homer. (2005, 3 november). *The Programmers Paradox*. Geraadpleegd op 31 maart 2020, van  
https://books.google.nl/books?id=rxpLCAAAQBAJ&pg=PT302&lpg=PT302&dq=global+scope+and+bugs&source=bl&ots=W1--tnxVS2&sig=ACfU3U0PQcqJAjiKFt-sFxj3uqThV88i0g&hl=nl&sa=X&ved=2ahUKEwjzhseV2cToAhXP-qQKHf8tArg4ChDoATABegQICRAB#v=onepage&q=global%20scope%20and%20bugs&f=false

Eugene, P., Angela B. (2020, 31 maart). *What Are Programming Language Generations?*. Geraadpleegd op 31 maart 2020, van 
https://www.wisegeek.com/what-are-programming-language-generations.htm
