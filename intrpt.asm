.model small
.data
.code

mov ax, @data
mov ds, ax

mov al, 05h
mov bl, 00h
div bl

mov ah, 4Ch
INT 21h
end
