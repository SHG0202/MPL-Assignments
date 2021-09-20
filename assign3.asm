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

msg1 dq 10,10,'Select an option ',10,'1. Hex to BCD ',10,'2. BCD to Hex ',10,'3. EXIT ',10
len1 equ $ -msg1

msg2 dq 10,'INVALID OPTION ',10
len2 equ $ -msg2

msg3 dq 10,'Enter a Hex Number : '
len3 equ $ -msg3

msg4 dq 10,'Enter a BCD Number : '
len4 equ $ -msg4

msg5 dq 10,'Equivalent BCD is : '
len5 equ $ -msg5

msg6 dq 10,'Equivalent HEX is : '
len6 equ $ -msg6

pow dq '10000, 1000, 100, 10, 1'


section .bss

choice resb 02
H_in resb 05
B_in resb 06
T resb 01
result resb 04
count resb 01

section .text

global _start

_start:
	display len1, msg1
	read 02, choice

option:	mov al, [choice]
	sub al, 30h
	dec al
	jz H_to_B
	dec ax
	jz B_to_H
	dec ax
	jz exit
	display len2, msg2	
	jmp _start	

H_to_B:
	display len3, msg3
	read 05, H_in
	call convert_AtoH	

	mov rax, 00h
temp:	mov ax, bx
	mov rdx, 00h
	mov bx, 0Ah
again2:	div bx
	push dx
	mov dx, 00h
	inc r9
	cmp ax, 00h
	jne again2
	
	display len5, msg5

up:	pop ax
	cmp ax, 09
	jbe down
	add ax, 07h
down:	add ax, 30h
	mov [T], ax
	display 01, T	
	dec r9
	jnz up

	jmp _start

B_to_H:
	display len4, msg4
	read 06, B_in
	call convert_AtoB

	display len6, msg6
temp2:	display 04, result
		
	jmp _start

exit:
	mov rax, 60
	syscall	

convert_AtoH:
	mov rsi, H_in
	mov cx, 04
	mov bx, 00
again:	mov al, [rsi]
	sub al, 30h
	cmp al, 09h
	jbe skip
	sub al, 07h
skip:	add bl, al
	cmp cx, 01
	je out
	rol bx, 04
	add rsi, 01
	dec cx
	jnz again
out:	ret


convert_AtoB:
	mov rsi, B_in
	mov r8,05
	mov bx,10
	mov dx,0
	mov ax,0

loop1:	mul bx
	sub byte[rsi], 30h
	movsx cx, byte[rsi]
	add ax, cx
	inc rsi
	dec r8
	jnz loop1

check:	mov rsi, result
	mov r8, 04

again3:	rol ax, 04
	mov bl, al
	and bl, 0Fh
	cmp bl, 09
	jbe no_corr
	add bl, 07
no_corr:add bl, 30h
	mov byte[rsi], bl
	inc rsi
	dec r8
	jnz again3

out2:	ret
 
