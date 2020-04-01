# Introduction
This repository contains code and process details for my school assignment 'PO-paradigma'. My assignment is to learn a new programming language that interests me and differs from the programming language we are used to at school: Java.

The purpose of this assignment is to learn a new programming language by myself and spread the knowledge I got from this assignment to fellow students. 

The new programming language I want to learn is assembly for the x86-64 instruction set. I chose assembly because I think it's important for software developers to know how software works near the hardware level. Also, I have an interest in reverse-engineering but I never found an opportunity to learn assembly, so this is the ideal time to learn assembly.

The bulk of my information will come from [this](https://www.youtube.com/watch?v=VQAKkuLL31g&list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn) Youtube guide. 

For this assignment to be a success, I will do a challenge: implement the insertion sort algorithm in assembly x64. My assignment will be a success when the assembly code can sort an array from low to high using the insertion sort algorithm. I think this challenge is perfect to implement in assembly since assembly code can produce much faster code (and fast sorting is what we want) than high(er) level languages (Kent State University, z.d).


During this assignment I will use the following tools:
- Debian 10.3 as operating system.
- NASM as assembler
- [SASM](https://dman95.github.io/SASM/english.html) as IDE

# Hello, World
Source video: https://youtu.be/BWRR3Hecjao

Code I made for this chapter: https://github.com/CreatieveNaam/po-paradigma/blob/master/code/basicASM.asm

The code below prints out “Hello, World”.

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
What does `text db "Hello, World!",10` mean?
 
`db` stands for "define bytes". This means that we are going to define bytes of data. 
 
`"Hello, World!",10` is the bytes of data we are defining. The  “10” is a newline character. 
 
 `text` is the name assigned to the address in memory that this data is located in. When the code is compiled the compiler will determine the actual location in memory of this data and replace all instances of "text" with that memory address.

## Sections
So what does the code `section .data` and `section .text` mean?

Well, there are three types of sections in assembly files. There is a .data section where all data is defined before compilation. We define memory for future use. 

There is a .text where all the code goes.

And there is a .bss section where data is allocated for future use. We do not use it in the Hello World code but the .bss section often gets used to reserve bytes of memory for user input.

## Labels
So what does the code `_start:` mean?

Well, `_start:` is called a label. A label is used to label a part of code. Upon compilation the compiler will calculate the location in which the label will sit in memory. Any time the label is used afterwards, that name is replaced by the location in memory of the compiler. 

The `_start:` label is essential for all programs. When the program is compiled and executed, it is first executed at the location of `_start:`. The start label can be compared with `public static void main(String args[]`.

## Global
So what does the code `global _start` mean?

The word `global` is used when we want the linker to be able to know the address of some label. The object file generated during compilation will contain a link to every label declared `global`. In this case, we have to declare `_start` as global since it is required for the code to be properly linked.
 
 ## Registers
To be able to understand the rest of the code we first need to be able to understand registers. Registers are a part of the processor part that temporarily holds memory. In the x86_64 architecture, registers hold 64 bits. Below is a list of registers in the x86_64 architecture. 

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

Notice the eax register. It's part of the rax register and half its size. The 16-bit ax register is part of the eax register and half its size and the 8-bit register al is part of the ax register and half its size. This means that when we use the al register we are modifying the lower 8 bits of the rax register. The diagram below visualizes the rax register.

![64-bit register](https://github.com/CreatieveNaam/po-paradigma/blob/master/img/64-bit%20register.png "rax register")

## Syscall
A syscall is when a program requests a service from the kernel. Every syscall has an ID associated with it. A syscall takes arguments. The value of those arguments is based on the value stored in the register.

argument | register 
--- | ---
ID | rax
1 | rdi
2 | rsi
3 | rdx
4 | r10
5 | r8
6 | r9

What we see in the table is that the ID of the syscall is stored in the rax register. So when we want to use a syscall, we have to store the ID value of the syscall in the rax register, the value of the first argument in the rdi register and so on. [This](http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/) table shows all syscalls for the x64 instruction set and which value should be stored in which register.

Let's use sys_write as an example. We want to write "Hello, World!\n" to the screen. When we look at the syscall table we see that the ID associated with sys_write is 1. So we want to store 1 in the rax register. We do this using the following command: `mov rax, 1`. We need to store the file descriptor in the rdi register. There are three file descriptors:

description | number 
--- | ---
stdin | 0
stdout | 1
stderr | 2

We want to write to the screen, so as file descriptor we choose 1. We do this using the following command: `mov rdi, 1`. In the rsi register we want to store the pointer to a memory address that holds the text "Hello, World!\n". If we take a look at the code of the "Hello World!" program we see the following line of code: `text db "Hello, World!",10`. We know that when we use 'text' in the code, the compiler will determine the actual location in memory of this data. So if we want to store the pointer to the memory address that holds the text "Hello, World!\n" in the rsi register we can use the following command: `mov rsi, text`. The last argument is the length of the string we want to print. In this case the length of our string is 14, so we want to store the value 14 in the rdx register. We do this using the following command `mov rdx, 14`. The last thing we need to do is make the syscall. We do this using the following command: `syscall`. 

# Jumps, Calls, Comparisons
Source video: https://youtu.be/busHtSyx2-w

Code I made for this chapter: https://github.com/CreatieveNaam/po-paradigma/blob/master/code/controlFlow.asm

In this chapter we get to know what pointers, control flow, jumps, conditional jumps and calls are. We will also learn how to do comparisons.

## Pointers
Pointers are also registers that hold data. Pointer points to data. That means they hold the memory address of the data (not the value of the data). There are a bunch of different pointers but for now it's important to know what the rip pointer is. The rip pointer, also known as the index pointer, points to the next address to be executed in the control flow.

## Control flow
By default all code runs from top to bottom. The direction a program flows is called the control flow. The rip register holds the address of the next instruction to be executed. After each instruction the rip register is incremented so that it holds the address of the next instruction to be executed, making the control flow, flow from top to bottom.

## Jumps
Jumps can be used to jump to different parts of code based on labels. They are used for diverting program flow. The format of the jump is 'jmp label'

## Comparisons
Comparisons allow programs to be able to take different paths based on certain conditions. The format of a comparison is `cmp register, register` or `cmp register, value`.

## Conditional Jumps
After a comparison is made, a conditional jump can be made. In code, conditional jumps are written just like 'normal' jumps, however `jmp` is replaced by the symbol for the conditional jump. The table below shows all jump symbols. 

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
The default registers can be treated as pointers. To treat a register as a pointer, surround the register name with square brackets, such as \[rax]. The following code loads the value in the rbx register into the rax register:
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
Math operations are used to mathematically manipulate register. The syntax of a math operation is typically `operation register, value/register`. The first register is the subject of the operation. The table below shows every math operation.

Operation | Operation Name | Operation Name (signed) | Description
--- | --- | --- | --- 
add | add a, b | - | a = a + b
subtract  | sub a, b | - | a = a - b
multiply | mul reg | imul reg | rax = rax * reg
divide | div reg | idiv reg | rax = rax / reg
negate | neg reg | - | reg = -reg
increment | inc reg | - | reg = reg + 1
decrement | dec reg | - | reg = reg - 1
add carry | adc a, b| - | a = a+b+CF
subtract  carry | sbb a, b | - | a = a-b-CF

When using 'adc' or 'sbb' we add or subtract, but we also add the [carry flag](http://teaching.idallen.com/dat2343/10f/notes/040_overflow.txt)

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
The code `add rax, 48` adds 48 to the rax register. If we look at the ASCII table, we see that 48 is the value of the "0" character.

The code `mov [digit], al` moves the lower byte of the rax register into the memory address 'digit'. 'Digit' is defined with two bytes (0 and 10). Since we are only loading the lower byte of the rax register into 'digit', it only overwrites the first byte and does not affect the newline character.

The code after `mov [digit], al` prints the two bytes to the screen and returns to the position the subroutine was called from. 

This subroutine can be used to display a digit between 0-9 by loading that digit into the rax register and calling the subroutine, like so:
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

The video tutorial doesn't teach the use of arrays but I think it's crucial to use arrays for implementing insertion sort. Defining an array is almost the same as defining one 'variable'. Instead of `num db 52` for defining one 'variable' we use `num db 52, 53` for defining an array. See my implementation of printing an array in this [this](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/arrays.asm) file.

I noticed it became very difficult to debug my code, so I changed my IDE from nano to SASM. Instead of `global _start` SASM needs a `global _main`. So from now on, I will use main instead of start.

# Change of challenge
While I was writing code for arrays I noticed I struggled a lot with basic assembly like printing all elements of an array. I decided to change my challenge from quicksort to insertion sort. The way I see it is that insertion sort is easier to implement since insertion sort doesn't use recursion. This would give me more time to focus on the basics of assembly before moving on to the harder parts (like recursion). 

# Insertion sort
My challenge was to implement insertion sort in assembly. Well, I did it. Insertion sort in assembly can be found [here](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/insertionsort.asm). The code should be readable with the explanation I previously gave and the comments.

The way I programmed insertion sort was to use a correct insertion sort in Java as an example and program each line of code in assembly. This made it easier for me to write assembly code since it made me clear what I needed to do. I used [this](https://www.geeksforgeeks.org/insertion-sort/) implementation of insertion sort as an example. 

# Quicksort
While quicksort was a bit harder than insertion sort, I managed to implement quicksort in assembly. The code can be found [here](https://github.com/CreatieveNaam/po-paradigma/blob/master/code/quicksort.asm). I used the same plan as the plan I had for insertion sort.

# Differences Java and Assembly
During the process of learning assembly I noticed a fair number of differences between Java and assembly x64. In this chapter I will list these differences and give my opinion on them. I will also list differences I didn't notice but are present.

Type. Assembly is an untyped language (University of Debrecen, z.d.). In the case of assembly, this means that all values are represented as word-sized integers (Morrisett, G., Walker, D, Crary, K., Glew, N, 1999). Java is a static, manifestly typed language (University of Debrecen, z.d.). This means I have to explicitly declare a variable type during development time. I have to say I liked the untyped system of assembly. I could put any value I wanted in every register. This makes it easier to write code faster. However, since assembly is untyped, I can also multiply a string by 2 which shouldn't be possible in my opinion. So I like the untyped property of assembly, but I think it will lead to a lot of unexpected behavior.

Paradigm. Java is Object-Oriented; assembly is imperative. The main difference between the  Object-Oriented paradigm and the imperative paradigm is that in the Object Orient paradigm classes (which in most cases represent real-life objects) talk to each other. In the imperative paradigm statements change the state of the program. For very small programs (say less than 20 lines of code.) I generally prefer the imperative paradigm since I'm able to quickly write some code and execute it. Of course it depends on what kind of code I'll be writing but generally speaking I prefer the imperative paradigm. However, the larger the codebase the more I prefer the Object-Oriented paradigm since the Object-Oriented paradigm allows me to structure my code better than the imperative paradigm.

Since assembly isn't object-oriented, objects do not exist in assembly. This means that a string doesn't exist in assembly either. In assembly, I had to make an array of word-sized integers and loop over that array to print a string. In my opinion this is too much work to print a string. I prefer Java to assembly in this case.

(Un)strucutered. Assembly is unstructured, Java is structured. Unstructured means that the code cannot be separated into different modules (C. A. Hofeditz, 1985). I prefer Java in this case because it makes me able to structure my code better thus making it more readable and maintainable. 

Portability. Assembler is platform-specific (Agner, F. 2020). The insertion sort code doesn't work on a Raspberry Pi because the Raspberry Pi instruction set is different compared to the x64 instruction set. This is a downside in my opinion. If I write code I want to run it everywhere and not rewrite code for different hardware. I prefer Java to assembly in this case.

Error protection. High-level languages like Java protect the programmer against errors. While I was writing the code for quicksort, I tried to pop an empty stack. Java would've thrown a runtime exception. Assembly didn't throw anything; it put a seemingly random number in the register I popped into. In this case, I prefer Java because it protects me more from errors than assembly.

Development time. Writing code in assembly takes much longer than in a high-level language (Fog, A. 2020). It took me a few hours to implement insertion sort in assembly. In Java, I did it in less than an hour. In this case I prefer Java because Java allows me to write more code (that functions) in less time.

Syntax. Not a lot of explanation needed. I prefer assembly syntax. It's simpler and cleaner looking than Java.

Program Flow. Assembly code gets executed from top to bottom. If the bottom is reached, it will stop executing the program. The control flow in assembly can be changed using jumps and subroutine calls. In Java the code will also execute from top to bottom automatically. Also, when I call a method Java will only execute that method and return to what code called that method, it doesn't execute the next method when I don't explicitly state that the method should return. I prefer Java, I have to think less about the program flow and this makes me able to focus more on the code its functionality.

The stack. In assembly, I have direct access to the stack. I liked this a lot about assembly. In Java, I have to manually make a temporary variable (or import the stack library or something) but in assembly the stack was already there, so I didn't have to manually make a structure to save values. In my opinion Java should also implement a structure where I can use the stack directly without importing and declaring the stack.

Scoping. Assembly doesn't support scoping; there is only one scope and that is the global scope. I prefer Java. I can reuse commonly used variables (like *i* in for loops) and having a local scope reduces bugs (P.W. Homer, 2005).

Generation. Assembly is typed as a second type generation programming language. Java is typed as a third type generation programming language. Second-generation languages are abstracted machine code, such as assembly language, that are tied to a specific system architecture but are human-readable and need to be compiled. Third-generation programming languages decouple code from the processor, allowing for the development of code that used more readable statements (Eugene, P., Angela B, 2020). Like I said before, I want my code to run everywhere without rewriting it for different hardware. I prefer a third-generation language over a second-generation language.

Fun. During the time I was writing assembly code I had a lot of fun. I tried certain optimizations like shifting instead of dividing. Java is also fun but in a different way. In Java, I optimize my code by making it as maintainable and readable as possible. In assembly, I tried to make my code as fast as possible. An example of this is using bit shifts instead of multiplying or dividing (Agner, F. 2020). 
 

# Sources
References to sources is in the Dutch way. 

Kent State University. (z.d). *The Assembly Language Level*. Geraadpleegd op 27 maart 2020, van http://www.personal.kent.edu/~aguercio/CS35101Slides/Tanenbaum/CA_Ch07.pdf

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
