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

section .data

file db './abc.txt',0

msg1 dq 'Sorted array is '
len1 equ $ -msg1


 
section .bss

fd resb 08 
num resb 10

section .text
global _start

_start:
	open file
	mov [fd], rax 
	read 10, [fd], num
	;;close [fd]

	call sorting
	
	;;open file
	;;mov [fd], rax 
	write len1, [fd], msg1
	write 09, [fd], num
	close [fd]

exit:
	mov rax, 60
	syscall

sorting:
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

	mov r8, 01
loop1:	mov r9, 09
	sub r9, r8

	mov rsi, num
	inc rsi
	mov rdi, num

loop2:	mov bl, [rdi]
	mov cl, [rsi]
	
	cmp bl, cl
	jb conti	 
swap:	mov [rsi], bl
	mov [rdi], cl			
conti:	inc rsi
	inc rdi	
	dec r9
	jnz loop2

	inc r8
	cmp r8, 08
	jne loop1

out:	ret
