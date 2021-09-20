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

msg1 dq 10,'File Read successfully ',10
len1 equ $ -msg1

msg2 dq 10,'File Copied successfully ',10
len2 equ $ -msg2

msg3 dq 10,'File Deleted successfully ',10
len3 equ $ -msg3

file1 db './FIL1.txt',0
file2 db './FIL2.txt',0

section .bss

buf1 resb 100
buf2 resb 100

fp1 resb 8
fp2 resb 8

siz1 resb 1 

temp resb 1

fname resq 1

section .text

global _start

_start:
	pop rdx
	pop rsi 
	add rsi, 02
	xor dx, dx
	mov dx, [rsi]
	mov [temp], dx
	cmp byte[temp], 084
	je RD
	cmp byte[temp], 067
	je CPY
	cmp byte[temp], 068
	je DEL
	
	jmp exit

RD:	
	pop rsi
	add rsi, 03
	mov dx, [rsi]
	mov [temp], dx
	cmp byte[temp], 31h
	je one
	jmp two
one:	open file1
	mov [fp1], rax
	jmp over
two:	open file2
	mov [fp1], rax
		
over:	read 100, [fp1], buf1	
	
	dec rax
	mov [siz1], rax
	
	call Type
	
	display len1, msg1
	
	jmp exit
	
CPY:	
	open file1	
	mov [fp1], rax
	open file2
	mov [fp2], rax
	
	read 100, [fp1], buf1	
	
	dec rax
	mov [siz1], rax
	
	call Copy
	
	display len2, msg2
	
	jmp exit	
		
DEL:	open file1	
	mov [fp1], rax

	read 100, [fp1], buf1	
	
	dec rax
	mov [siz1], rax
	
	call Delete
	
	display len3, msg3
	
	jmp exit


exit:	close [fp1]
	close [fp2]
	mov ax, 60
	syscall
	
Type:
	;;mov r8, [siz1]
	;;mov r9, buf1
up1:	;;mov al, [r9]
	;;mov [temp], al
	;;display 01, temp
	;;inc r9
	;;dec r8
	;;jnz up1
	display siz1, buf1
	
out1:	ret

Copy:
	open file2	
	mov [fp2], rax

	write [siz1], [fp2], buf1	
out2:	ret

Delete:
	open file2
	mov [fp2], rax
	
	read 100, [fp2], buf2
	
	mov rax, 87
	mov rdi, file2
	syscall
	
out3:	ret 
