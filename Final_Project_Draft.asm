.MODEL SMALL
.STACK 64
.DATA

STRING1 DB 0C9H, 48 DUP(0CDh), 0BBh, '$'
STRING2 DB 0BAH, '             STUDENT RECORD SYSTEM              ', 0BAH, '$'
STRING3 DB 0C8H, 48 DUP(0CDh), 0BCh, '$'
STRING4 DB 'View Student Record$'
STRING5 DB 'Add Student Record$'
STRING6 DB 'Update Student Record$'
STRING7 DB 'Delete Student Record$'
STRING8 DB 'Exit Program$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL DISPLAY_MENU
    XOR CX, CX
    MOV CH, 5

    INPUT:
        MOV AH, 10H
        INT 16H

        CMP AH, 48H ; Up Arrow
        JE UP_ARROW
        CMP AH, 50H ; Up Arrow
        JE DONW_ARROW
        CMP AX, 1C0DH ; Enter Key
        JE ENTER_KEY
    JNE INPUT

    UP_ARROW:
        CMP CH, 5
        JE INPUT

        MOV AH, 02H
        MOV BH, 0
        MOV DL, 27
        MOV DH, CH
        INT 10H
        PUSH CX

        MOV AH, 09H
        MOV AL, ' '
        MOV BH, 0
        MOV BL, 07H
        MOV CX, 1
        INT 10H
        POP CX

        DEC CH
        MOV AH, 02H
        MOV BH, 0
        MOV DL, 27
        MOV DH, CH
        INT 10H
        PUSH CX
        
        MOV AH, 09H
        MOV AL, '>'
        MOV BH, 0
        MOV BL, 07H
        MOV CX, 1
        INT 10H
        POP CX
    JMP INPUT

    DONW_ARROW:
        CMP CH, 9
        JE INPUT

        MOV AH, 02H
        MOV BH, 0
        MOV DL, 27
        MOV DH, CH
        INT 10H
        PUSH CX

        MOV AH, 09H
        MOV AL, ' '
        MOV BH, 0
        MOV BL, 07H
        MOV CX, 1
        INT 10H
        POP CX

        INC CH
        MOV AH, 02H
        MOV BH, 0
        MOV DL, 27
        MOV DH, CH
        INT 10H
        PUSH CX
        
        MOV AH, 09H
        MOV AL, '>'
        MOV BH, 0
        MOV BL, 07H
        MOV CX, 1
        INT 10H
        POP CX
    JMP INPUT

    ENTER_KEY:
        CMP CH, 5
        JE VIEW_STUDENT_PAGE

        CMP CH, 6
        JE ADD_STUDENT_PAGE

        CMP CH, 7
        JE UPDATE_STUDENT_PAGE

        CMP CH, 8
        JE DELETE_STUDENT_PAGE

        CMP CH, 9
        JE FINISH
        JMP INPUT

        VIEW_STUDENT_PAGE:
            CALL VIEW_STUDENT
            JMP INPUT
        ADD_STUDENT_PAGE:
            CALL ADD_STUDENT
            JMP INPUT
        UPDATE_STUDENT_PAGE:
            CALL UPDATE_STUDENT
            JMP INPUT
        DELETE_STUDENT_PAGE:
            CALL DELETE_STUDENT
            JMP INPUT
        FINISH:
            MOV AH, 02H
            MOV BH, 0
            MOV DX, 184FH
            INT 10H

            MOV AH, 4CH
            INT 21H
MAIN ENDP

DISPLAY_MENU PROC

; Clear the screen
    MOV AH, 06H
    MOV AL, 0
    XOR CX, CX
    MOV DX, 184FH
    MOV BH, 07H
    INT 10H

    ; Set cusror position
    MOV AH, 02H
    MOV BH, 0
    MOV DL, 14
    MOV DH, 1
    INT 10H

    ; Display the first string
    MOV AH, 09H
    MOV DX, OFFSET STRING1
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 14
    MOV DH, 2
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING2
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 14
    MOV DH, 3
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING3
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 29
    MOV DH, 5
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING4
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 29
    MOV DH, 6
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING5
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 29
    MOV DH, 7
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING6
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 29
    MOV DH, 8
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING7
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 29
    MOV DH, 9
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING8
    INT 21H

    ; Set cursor position
    MOV AH, 02H
    MOV BH, 0
    MOV DL, 27
    MOV DH, 5
    INT 10H

    MOV AH, 09H
    MOV AL, '>'
    MOV BH, 0
    MOV BL, 07H
    MOV CX, 1
    INT 10H

    MOV AH, 02H
    MOV BH, 0
    MOV DX, 184FH
    INT 10H

    RET
DISPLAY_MENU ENDP

VIEW_STUDENT PROC
    MOV AH, 05H
    MOV AL, 1
    INT 10H
    
    ;--------------------- YOUR PART/PAGE/CODE GOES HERE -------------------------

    RET
VIEW_STUDENT ENDP

ADD_STUDENT PROC
    MOV AH, 05H
    MOV AL, 2
    INT 10H

    ;--------------------- YOUR PART/PAGE/CODE GOES HERE -------------------------

    RET
ADD_STUDENT ENDP

UPDATE_STUDENT PROC
    MOV AH, 05H
    MOV AL, 3
    INT 10H

    ;--------------------- YOUR PART/PAGE/CODE GOES HERE -------------------------

    RET
UPDATE_STUDENT ENDP

DELETE_STUDENT PROC
    MOV AH, 05H
    MOV AL, 4
    INT 10H

    ;--------------------- YOUR PART/PAGE/CODE GOES HERE -------------------------

    RET
DELETE_STUDENT ENDP

END MAIN

