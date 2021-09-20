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

arr1 dq 11,22,33,44,55,0Ah

msg1 dq 10,'Select a method for block transfer ',10,'1. overlapping using string (forward)',10,'2. overlapping using string (backward)',10,'3. overlapping without using string (forward)',10,'4. overlapping without using string (forward)',10,'5. non - overlapping using string ',10,'6. non - overlapping without using string ',10
len1 equ $ -msg1

msg2 dq 10,'WRONG OPTION ',10
len2 equ $ -msg2

space dq '     '
len6 equ $ -space

nextline dq 10,''
len7 equ $ -nextline

BA dq 10,'        BEFORE               AFTER    ',10
len8 equ $ -BA

AV1 dq 10,'ADDRESS      VALUE    ADDRESS     VALUE',10
len9 equ $ -AV1

AV2 dq 10,'ADDRESS      VALUE ',10
len10 equ $ -AV2

section .bss

arr resb 64
arr2 resq 5
choice resb 1
temp resq 1
byte1 resb 1

section .text

global _start

_start:
	display len1, msg1
	read 01, choice
	display 01, choice

cho:	
	mov rax, [choice]
	sub rax, 30h
	sub rax, 01
	jz over_s_a
	sub rax, 01
	jz over_s_b
	sub rax, 01
	jz over_ns_a
	sub rax, 01
	jz over_ns_b
	sub rax, 01
	jz n_over_s
	sub rax, 01
	jz n_over_ns
	display len2, msg2
	jmp exit
	

over_s_a:
	mov esi, arr1
	add esi, 32
	mov edi, arr1
	add edi, 56
	mov rcx, 05	
	std
	rep movsq

	jmp print_o_a

over_s_b:
	mov esi, arr1
	mov edi, arr1
	sub edi, 24
	mov rcx, 05	
	cld
	rep movsq

	jmp print_o_b

over_ns_a:
	mov rsi, arr1
	add rsi, 32
	mov rdi, arr1
	add rdi, 56
	mov cx, 05

move1:	mov ax, [rsi]
	mov [rdi], ax
	sub rsi, 08
	sub rdi, 08
	dec cx
	jnz move1
	
	jmp print_o_a

over_ns_b:
	mov rsi, arr1
	mov rdi, arr1
	sub rdi, 24
	mov cx, 05

move2:	mov ax, [rsi]
	mov [rdi], ax
	add rsi, 08
	add rdi, 08
	dec cx
	jnz move2
	
	jmp print_o_b

n_over_s:
	mov rsi, arr1
	mov rdi, arr2
	mov rcx, 05
	cld
	rep movsq

	jmp print_tf

n_over_ns:
	mov rsi, arr1
	mov rdi, arr2
	mov cx, 05

move3:	mov ax, [rsi]
	mov [rdi], ax
	add rsi, 08
	add rdi, 08
	dec cx
	jnz move3
	
	jmp print_tf

print_o_a:

	display len10, AV2

	mov r10, 08

	mov r8, arr1
	mov r9, arr1
	add r9, 24
	
after1: 
	mov [temp], r8
	mov byte[byte1], 08
	call print
	
	display len6, space	
	
	mov rax, [r8]
	mov [temp], rax
	mov byte[byte1], 04
	call print

	display len7, nextline

	add r8, 08
	add r9, 08
	sub r10, 01
	jnz after1
	 
	jmp exit

print_o_b:
	display len10, AV2

	mov r10, 08

	mov r8, arr1
	sub r8, 24
	mov r9, arr1
	sub r9, 24
	
after2: 
	mov [temp], r8
	mov byte[byte1], 08
	call print
	
	display len6, space	
	
	mov rax, [r8]
	mov [temp], rax
	mov byte[byte1], 04
	call print

	display len7, nextline

	add r8, 08
	sub r10, 01
	jnz after2
	 
	jmp exit

print_tf:
	display len8, BA 
	display len9, AV1

	mov r10, 05
 
	mov r8, arr1
	mov r9, arr2
before3: 
	mov [temp], r8
	mov byte[byte1], 08
	call print
	
	display len6, space	
	
	mov rax, [r8]
	mov [temp], rax
	mov byte[byte1], 04
	call print

	display len6, space

after3:
	mov [temp], r9
	mov byte[byte1], 08
	call print
	
	display len6, space	
	
	mov rax, [r9]
	mov [temp], rax
	mov byte[byte1], 04
	call print

	display len7, nextline

	add r8, 08
	add r9, 08
	sub r10, 01
	jnz before3
	

exit:	mov rax, 60
	syscall

print:
	mov esi, arr
	mov cx, [byte1]
	
	mov ax, [temp]
again:	rol ax, 04
	mov dx, ax
	AND dx, 0Fh
	cmp dx, 09h
	jbe l	
	add dx, 07h
l:	add dx, 30h
	mov [esi], dx
	inc esi
	dec cx
	jnz again

	display [byte1], arr
	ret
