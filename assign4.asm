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

msg1 dq 10,'Which method of multiplication should be used ? ',10,'1. Successive Addition ',10,'2. Shift and Add ',10,'3. Exit ',10
len1 equ $ -msg1

msg2 dq 10,'Enter a valid option ',10
len2 equ $ -msg2

msg3 dq 10,'Enter two Numbers ',10
len3 equ $ -msg3

section .bss

choice resb 2
num1 resb 3
num2 resb 3
result resb 4

section .text

global _start

_start:	
	display len1, msg1
	read 2, choice

opt:
	mov al, [choice]
	sub al, 30h
	
	sub al, 01
	jz one
	sub al, 01
	jz two
	sub al, 01
	jz three
	display len2, msg2

one:
	display len3, msg3
	read 03, num1
	read 03, num2

	call get_num
	
repeat:
	add ax, bx
	dec dl
	jnz repeat
	
	call fin_res
	
	display 04, result

	jmp _start
two:	
	display len3, msg3
	read 03, num1
	read 03, num2

	call get_num

	mov ax, 00h
	mov r8, 08

again2:	shl bl, 01
	jnc skip
	add al, dl
skip:	shl ax, 01
	dec r8
	jnz again2
	
	shr al ,01
	
	call fin_res

	display 04, result

	jmp _start

three:
	jmp exit


exit:
	mov rax, 60
	syscall
	

get_num:
	mov ax, 00
	mov bx, [num1]
	sub bx, 3030h
	cmp bl, 09h
	jbe c1
	sub bl, 07h
c1:	cmp bh, 09h
	jbe c2
	sub bh, 07h
c2:	shl bl, 04
	add bl, bh
	and bx, 00FFh	
	mov dx, [num2]
	sub dx, 3030h
	cmp dl, 09h
	jbe c3
	sub dl, 07h
c3:	cmp dh, 09h
	jbe c4
	sub dh, 07h
c4:	shl dl, 04
	add dl, dh
	and dl, 00FFh
	ret

fin_res:
	mov r8, 04
	mov esi, result
str:	rol ax, 04	
	mov bl, al
	and bl, 0Fh
	cmp bl, 09h
	jbe n_corr
	add bl, 07h
n_corr:	add bl, 30h
	mov [esi], bl
	inc esi
	dec r8	
	jnz str
	ret
