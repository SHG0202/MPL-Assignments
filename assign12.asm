.MODEL TINY

.286
ORG 100H


CODE SEGMENT
     ASSUME CS:CODE,DS:CODE,ES:CODE
        OLD_IP DW 00
        OLD_CS DW 00
JMP INIT

MY_TSR:
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
        PUSH ES
	
	;;INITIALISE VIDEO RAM
        MOV AX, 0B800H			;;Screen start position
        MOV ES, AX
        MOV DI, 100			;;Clock position

        MOV AH, 02H			;;To Get System Clock
        INT 1AH               		;;CH=Hrs, CL=Mins,DH=Sec
        MOV BX, CX

	;;PRINTING HOURS
        MOV CL, 2			;;Count
LOOP1:  ROL BH, 4
        MOV AL, BH
        AND AL, 0FH
        ADD AL, 30H
        MOV AH, 191			;;Formatting ;;MSB = 0 (NO blink)
        MOV ES:[DI],AX			;; Base + Offset
        INC DI
        INC DI				;; For ASCII value Formatting
        DEC CL
        JNZ LOOP1

        MOV AL,':'
        MOV AH,64H
        MOV ES:[DI],AX
        INC DI
        INC DI

        MOV CL,2
LOOP2:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI
        INC DI
        DEC CL
        JNZ LOOP2

        MOV AL,':'
        MOV AH,97H
        MOV ES:[DI],AX
        INC DI
        INC DI

        MOV CL,2
        MOV BL,DH
LOOP3:  ROL BL,4
        MOV AL,BL
        AND AL,0FH
        ADD AL,30H
        MOV AH,17H
        MOV ES:[DI],AX
        INC DI
        INC DI
        DEC CL
        JNZ LOOP3
	
	;;UPDATING VALUES
        POP ES
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX

       jmp MY_TSR

INIT:
        MOV AX,CS
        MOV DS,AX

        CLI

	;;GET IV
        MOV AH,35H
        MOV AL,08H
        INT 21H

        MOV OLD_IP,BX
        MOV OLD_CS,ES
	
	;;SET NEW IV
        MOV AH,25H
        MOV AL,08H				;Timer interrupt	
        LEA DX,MY_TSR
        INT 21H
	
	;;TRANSIANT PROG
        MOV AH,31H
        MOV DX,OFFSET INIT
        STI
        INT 21H
        
        CODE ENDS

END
