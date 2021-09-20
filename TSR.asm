.model tiny
.code
org 100H
jmp INIT
save dd ?
msg db "divide by zero by  pict$",10

residential:
	push cs
	pop ds
	mov ah,09
	lea dx,msg
	INT 21H
	;jmp save
	
INIT:
	push cs
	pop ds
	;get IVT
	mov ah,35H
	mov al,00
	
	INT 21H
	mov word ptr[save],bx
	mov word ptr[save+2],es
	
	;set IVT
	mov ah,25H
	mov al,00

	lea dx,residential
	INT 21H
	
	mov ah,31H
	lea dx,INIT
	INT 21H

end INIT

