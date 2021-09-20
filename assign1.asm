%macro display 2

mov rax, 01
mov rdx, %1
mov rsi, %2
mov rdi, 01
syscall

%endmacro


section .data

array dq -1,-2,-3,-4,5,6,-7,8,-9,0Ah
msg1 dq 10,'no. of positive elements = '
len1 equ $ -msg1
msg2 dq 10,'no. of negative elements = '
len2 equ $ -msg2

section .bss

posi resq 01 
negi resq 01

section .text
global _start
_start: mov rax, 00
	mov rsi, array
	mov ch, 09
	mov dh, 00
	mov dl, 00

up:	mov rax, [rsi]
	add rax, 00
	js neg

pos:	add dh, 01
	jmp down
	

neg: 	add dl, 01
down:	add rsi, 08
	sub ch, 01
	jnz up

P1:	add dh, 30h	
	mov [posi], dh

	add dl, 30h
	mov [negi], dl 	

P2:	display len1, msg1
	display 01, posi

P3:	display len2, msg2
	display 01, negi    

	jmp exit
	
exit:	mov rax, 60	
	syscall

	
