%macro open 1

mov rax, 02
mov rdx, 0777
mov rdi, %1
mov rsi, 02
syscall

%endmacro

%macro read 3

mov rax, 00
mov rdx, %1
mov rdi, %2
mov rsi, %3
syscall

%endmacro

%macro write 3

mov rax, 01
mov rdx, %1
mov rdi, %2
mov rsi, %3
syscall

%endmacro

%macro close 1

mov rax, 03
mov rdi, %1
syscall

%endmacro

%macro display 02

mov rax, 01
mov rdx, %1
mov rsi, %2
mov rdi, 01
syscall

%endmacro

%macro input 2

mov rax, 00
mov rdx, %1
mov rsi, %2
mov rdi, 01
syscall

%endmacro

section .data

global file
file db './FILE.txt',0

msg1 dq 10,'What to count ? ',10,'1. No. of Blank Spaces ',10,'2. No. of lines ',10,'3. Occerance of a character ',10,'4. Exit ',10
len1 equ $-msg1

section .bss

global fp, buffer, siz 

buffer resb 200

fp resb 8

opt resb 2

siz resb 1

section .text

global _start

_start:
	extern no_space, no_lines, no_char
	
	open file
	mov [fp], rax

	read 100, [fp], buffer

	dec rax
	mov [siz], rax
temp:	
	display len1, msg1
	input 02, opt	
	
	cmp byte[opt], 31h
	je one
	cmp byte[opt], 32h
	je two
	cmp byte[opt], 33h
	je three
	cmp byte[opt], 34h
	je exit
	
one:	call no_space
	jmp _start 
two:	call no_lines
	jmp _start
three:	call no_char
	jmp _start
	
exit:
	mov rax, 60
	syscall
