%macro display 2

mov rax, 01
mov rdx, %1
mov rsi, %2
mov rdi, 01
syscall

%endmacro

%macro read 2

mov rax, 00
mov rdx, %1
mov rsi, %2
mov rdi, 01
syscall

%endmacro

section .data

msg0 dq 10,'Select an option ',10,'1. Calculate Factorial ',10,'2. Exit ',10
len0 equ $ -msg0

msg1 dq 10,'Enter a number ',10
len1 equ $ -msg1

msg2 dq '! = '
len2 equ $ -msg2

msg3 dq 10
len3 equ $ -msg3

section .bss

opt resb 2
num resb 2
fact resb 4

section .text

global _start

_start:
	;display len0, msg0
	;read 02, opt

	;sub byte[opt], 30h
	;mov dl, [opt]
	;cmp dl, 02h
	;je exit		

	;display len1, msg1
	;read 01, num

	pop rbx
	pop rbx
	pop rbx
	mov al, [rbx] 
	mov [num], al

	mov ax, 00
	mov bx, 00

	sub byte[num], 30h
	mov al, [num]
	mov r8, [num]
	add byte[num], 30h

	call facto

convert:
	mov rsi, fact
	mov r8, 04
again:	rol ax, 04
	mov bl, al
	and bl, 0Fh
	cmp bl, 09h
	jbe skip
	add bl, 07h
skip:	add bl, 30h
	mov [rsi], bl
	add rsi, 01
	dec r8
	jnz again

disp:	display 01, num
	display len2, msg2
	display 04, fact
	display len3, msg3 

	;jmp _start

exit:
	mov rax, 60
	syscall
	
facto:
	push ax
	dec ax
	jnz facto

	mov al, 01h
res:	pop bx
	mul bx
	dec r8
	jnz res

out:	ret

