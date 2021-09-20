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

extern file

msg2 dq 10,'No. of Lines is '
len2 equ $-msg2

msg1 dq 10,'No. of spaces is '
len1 equ $-msg1

msg3 dq 10,'No. of occorance is '
len3 equ $-msg3

msg31 dq 10,'Character to be searched ',10
len31 equ $-msg31

space dq 10
space_len equ $-space

section .bss

extern fp, buffer, siz
n1 resb 1
n2 resb 1
n3 resb 1

inp resb 2

section .text

_start:	
	global no_space, no_lines, no_char

exit:
	mov rax, 60
	syscall

no_space:
	
	mov r8, [siz]
	mov r9, 00
	mov rsi, buffer
up1:	mov al, [rsi]
	cmp al, 20h
	jne skip1
	inc r9
skip1:	inc rsi
	dec r8
	jnz up1
	
	cmp r9, 09
	jbe no_corr1
	add r9, 07h
no_corr1:add r9, 30h

	mov [n1], r9
	display len1, msg1
	display 01, n1 
	display space_len, space

exit1:	ret
	

no_lines:

	mov r8, [siz]
	mov r9, 00
	mov rsi, buffer
up2:	mov al, [rsi]
	cmp al, 0Ah
	jne skip2
	inc r9
skip2:	inc rsi
	dec r8
	jnz up2
	
	inc r9 
	cmp r9, 09
	jbe no_corr2
	add r9, 07h
no_corr2:add r9, 30h

	mov [n2], r9
	display len2, msg2
	display 01, n2 
	display space_len, space

exit2:	ret


no_char:

	;;display len31, msg31
	;;input 02, inp
	
	;;mov dl, [inp]	
	;;display 01, inp
	mov r8, [siz]
	display 01, siz
	mov r9, 00
	mov rsi, buffer
up3:	mov al, [rsi]
	cmp al, 97
	jne skip3
	inc r9
skip3:	inc rsi
	dec r8
	jnz up3
	display len31, msg31
	
	cmp r9, 09
	jbe no_corr3
	add r9, 07h
no_corr3:add r9, 30h
	
	mov [n3], r9
	display	len3, msg3
	display 01, n3
	display space_len, space

exit3:	ret


 
