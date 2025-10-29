.MODEL SMALL

JUMPS ; Nilagay ko toh para sa mga putanginang JMPs na nag-oout of range error. Atleast nan kahit yung mga JMPs na pupuntahan nya ay malayo, di na mag-eerror
      ; Para magets nyo, try mo remove yang JUMPS, tas run mo

.STACK 64
.DATA

; Strings for menu/display
STRING1 DB 0C9H, 48 DUP(0CDh), 0BBh, '$'
STRING2 DB 0BAH, '             STUDENT RECORD SYSTEM              ', 0BAH, '$'
STRING2_2 DB 0BAH, '                 MANAGE ACCESS                  ', 0BAH, '$'
STRING3 DB 0C8H, 48 DUP(0CDh), 0BCh, '$'
STRING4 DB 'View Student Record$'
STRING5 DB 'Add Student Record$'
STRING6 DB 'Update Student Record$'
STRING7 DB 'Delete Student Record$'
STRING8 DB 'Exit Program$'
STRING9 DB 'Manage Access$'
STRING10 DB 'YOU DO NOT HAVE ACCESS$'

; Manage Access variables
MA1 DB 'Set Access level to Guest'
MA2 DB 'Set Access level to Admin'
MA3 DB 'Username: $'
MA4 DB 'Password: $'
USERNAME DB 'admin$'
PASSWORD DB '1234567890$'
MA_USERNAME_BUFFER DB 21, ?, 21 DUP(?)
MA_PASSWORD_BUFFER DB 21, ?, 21 DUP(?)
ACCESS_LEVEL DB 0 ; 0 for Guest and 1 for Admin

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    CALL DISPLAY_MENU
    XOR CX, CX
    MOV CH, 5 ; VERY IMPORTANT TOH. MAPAPANSIN MO MAY MGA POP AND PUSH COMMANDS KASE ITONG CH ANG MAG_DEDETERMINE KUNG SAANG ROW/POSITION YUNG '>'

    INPUT:
        MOV AH, 10H
        INT 16H

        CMP AH, 48H ; Up Arrow
        JE UP_ARROW
        CMP AH, 50H ; Up Arrow
        JE DOWN_ARROW
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

    DOWN_ARROW:
        CMP CH, 10
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

        CMP CH, 10
        JE FINISH

        CMP CH, 9
        JE MANAGE_ACCESS_PAGE
        JMP INPUT

        VIEW_STUDENT_PAGE:
            ; Tinatanggal nya lang yung 'Do NOT HAVE ACCESS MESSAGE' whether meron or wala
            MOV AH, 13H
            MOV AL, 1
            MOV BH, 0
            MOV BL, 0
            MOV CX, 22
            MOV DH, 20
            MOV DL, 28
            LEA BP, STRING10
            INT 10H

            MOV BL, 07H ; Niligay ko ito baka kase magtaka kayo kapag nag-print kayo ng string ay blanko. Basically sinet ko lang sa default yung color attribute

            ; Set cursor position (Para lang itago yung cursor after printing)
            MOV AH, 02H
            MOV BH, 0
            MOV DL, 24
            MOV DH, 79
            INT 10H

            CALL VIEW_STUDENT
            JMP INPUT
        ADD_STUDENT_PAGE:
            CMP ACCESS_LEVEL, 1 ; Checks kung Admin yung access level nya
            JNE DO_NOT_HAVE_ACCESS

            ; Tinatanggal nya lang yung 'Do NOT HAVE ACCESS MESSAGE' whether meron or wala
            MOV AH, 13H
            MOV AL, 1
            MOV BH, 0
            MOV BL, 0
            MOV CX, 22
            MOV DH, 20
            MOV DL, 28
            LEA BP, STRING10
            INT 10H

            MOV BL, 07H ; Niligay ko ito baka kase magtaka kayo kapag nag-print kayo ng string ay blanko. Basically sinet ko lang sa default yung color attribute

            ; Set cursor position (Para lang itago yung cursor after printing)
            MOV AH, 02H
            MOV BH, 0
            MOV DL, 24
            MOV DH, 79
            INT 10H

            CALL ADD_STUDENT
            JMP INPUT
        UPDATE_STUDENT_PAGE:
            CMP ACCESS_LEVEL, 1 ; Checks kung Admin yung access level nya
            JNE DO_NOT_HAVE_ACCESS

            ; Tinatanggal nya lang yung 'Do NOT HAVE ACCESS MESSAGE' whether meron or wala
            MOV AH, 13H
            MOV AL, 1
            MOV BH, 0
            MOV BL, 0
            MOV CX, 22
            MOV DH, 20
            MOV DL, 28
            LEA BP, STRING10
            INT 10H

            MOV BL, 07H ; Niligay ko ito baka kase magtaka kayo kapag nag-print kayo ng string ay blanko. Basically sinet ko lang sa default yung color attribute

            ; Set cursor position (Para lang itago yung cursor after printing)
            MOV AH, 02H
            MOV BH, 0
            MOV DL, 24
            MOV DH, 79
            INT 10H

            CALL UPDATE_STUDENT
            JMP INPUT
        DELETE_STUDENT_PAGE:
            CMP ACCESS_LEVEL, 1 ; Checks kung Admin yung access level nya
            JNE DO_NOT_HAVE_ACCESS

            ; Tinatanggal nya lang yung 'Do NOT HAVE ACCESS MESSAGE' whether meron or wala
            MOV AH, 13H
            MOV AL, 1
            MOV BH, 0
            MOV BL, 0
            MOV CX, 22
            MOV DH, 20
            MOV DL, 28
            LEA BP, STRING10
            INT 10H

            MOV BL, 07H ; Niligay ko ito baka kase magtaka kayo kapag nag-print kayo ng string ay blanko. Basically sinet ko lang sa default yung color attribute

            ; Set cursor position (Para lang itago yung cursor after printing)
            MOV AH, 02H
            MOV BH, 0
            MOV DL, 24
            MOV DH, 79
            INT 10H

            CALL DELETE_STUDENT
            JMP INPUT
        MANAGE_ACCESS_PAGE:
            ; Tinatanggal nya lang yung 'Do NOT HAVE ACCESS MESSAGE' whether meron or wala
            MOV AH, 13H
            MOV AL, 1
            MOV BH, 0
            MOV BL, 0H
            MOV CX, 22
            MOV DH, 20
            MOV DL, 28
            LEA BP, STRING10
            INT 10H

            MOV BL, 07H ; Niligay ko ito baka kase magtaka kayo kapag nag-print kayo ng string ay blanko. Basically sinet ko lang sa default yung color attribute

            ; Set cursor position (Para lang itago yung cursor after printing)
            MOV AH, 02H
            MOV BH, 0
            MOV DL, 24
            MOV DH, 79
            INT 10H

            CALL MANAGE_ACCESS
            JMP INPUT
        FINISH:
            ; Tinatanggal nya lang yung 'Do NOT HAVE ACCESS MESSAGE' whether meron or wala
            MOV AH, 13H
            MOV AL, 1
            MOV BH, 0
            MOV BL, 0
            MOV CX, 22
            MOV DH, 20
            MOV DL, 28
            LEA BP, STRING10
            INT 10H

            MOV BL, 07H ; Niligay ko ito baka kase magtaka kayo kapag nag-print kayo ng string ay blanko. Basically sinet ko lang sa default yung color attribute
            
            ; Set cursor position (Para lang itago yung cursor after printing)
            MOV AH, 02H
            MOV BH, 0
            MOV DL, 24
            MOV DH, 79
            INT 10H
            MOV AH, 02H
            MOV BH, 0
            MOV DX, 184FH
            INT 10H

            MOV AH, 4CH
            INT 21H
        DO_NOT_HAVE_ACCESS:
            PUSH CX ; Need i-temporary store si CX since gagamitin yung CX register nung AH = 13H function

            ; Prints the do not have access message
            MOV AH, 13H
            MOV AL, 1
            MOV BH, 0
            MOV BL, 04H
            MOV CX, 22
            MOV DH, 20
            MOV DL, 28
            LEA BP, STRING10
            INT 10H

            MOV BL, 07H ; Niligay ko ito baka kase magtaka kayo kapag nag-print kayo ng string ay blanko. Basically sinet ko lang sa default yung color attribute

            ; Set cursor position (Para lang itago yung cursor after printing)
            MOV AH, 02H
            MOV BH, 0
            MOV DL, 24
            MOV DH, 79
            INT 10H

            POP CX ; Ibalik yung original CX value

        JMP INPUT
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
    MOV DX, OFFSET STRING9
    INT 21H

    MOV AH, 02H
    MOV BH, 0
    MOV DL, 29
    MOV DH, 10
    INT 10H

    MOV AH, 09H
    MOV DX, OFFSET STRING8
    INT 21H


    ; Set cursor > position
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

MANAGE_ACCESS PROC
    ; Set page to 5
    MOV AH, 05H
    MOV AL, 5
    INT 10H

    ; Clear screen
    MOV AH, 06H
    MOV AL, 0
    XOR CX, CX
    MOV DX, 184FH
    MOV BH, 07H
    INT 10H

    ;-----------------Sets the display/menu for Manage Access page--------------
    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 50
    MOV DH, 1
    MOV DL, 14
    LEA BP, STRING1
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 50
    MOV DH, 2
    MOV DL, 14
    LEA BP, STRING2_2
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 50
    MOV DH, 3
    MOV DL, 14
    LEA BP, STRING3
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 10
    MOV DH, 8
    MOV DL, 22
    LEA BP, MA3
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 10
    MOV DH, 9
    MOV DL, 22
    LEA BP, MA4
    INT 10H

    ; ------------------LOGIC--------------
    MOV AH, 02H ; set cursor position
    MOV BH, 5
    MOV DH, 8
    MOV DL, 32
    INT 10H

    MOV AH, 0AH
    MOV DX, OFFSET MA_USERNAME_BUFFER
    INT 21H

    MOV AH, 02H
    MOv BH, 5
    MOV DH, 9
    MOV DL, 32
    INT 10H

    MOV AH, 0AH
    MOV DX, OFFSET MA_PASSWORD_BUFFER
    INT 21H

    ; Compare legth of the string of the username and password
    CMP BYTE PTR [MA_USERNAME_BUFFER+1], 5
    JNE NOT_MATCH

    CMP BYTE PTR [MA_PASSWORD_BUFFER+1], 10
    JNE NOT_MATCH

    ; Compare the user's typed username to the target username
    MOV SI, OFFSET MA_USERNAME_BUFFER+2
    MOV DI, OFFSET USERNAME
    XOR CX, CX
    MOV CL, [MA_USERNAME_BUFFER+1]
    COMPARE_USERNAME:
        MOV AL, [SI]
        CMP AL, [DI]
        JNE NOT_MATCH

        INC SI
        INC DI
        LOOP COMPARE_USERNAME

    ; Compare the user's typed password to the target password
    MOV SI, OFFSET MA_PASSWORD_BUFFER+2
    MOV DI, OFFSET PASSWORD
    XOR CX, CX
    MOV CL, [MA_PASSWORD_BUFFER+1]
    COMPARE_PASSWORD:
        MOV AL, [SI]
        CMP AL, [DI]
        JNE NOT_MATCH

        INC SI
        INC DI
        LOOP COMPARE_PASSWORD

    ; ------- Mag-rurun toh kapag correct yung username and password --------

    ; Clear the screen
    MOV AH, 06H
    MOV AL, 0
    XOR CX, CX
    MOV DX, 184FH
    MOV BH, 07H
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 50
    MOV DH, 1
    MOV DL, 14
    LEA BP, STRING1
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 50
    MOV DH, 2
    MOV DL, 14
    LEA BP, STRING2_2
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV CX, 50
    MOV DH, 3
    MOV DL, 14
    LEA BP, STRING3
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV BL, 1FH
    MOV CX, 25
    MOV DH, 6
    MOV DL, 26
    LEA BP, MA1
    INT 10H

    MOV AH, 13H
    MOV AL, 1
    MOV BH, 5
    MOV BL, 07H
    MOV CX, 25
    MOV DH, 7
    MOV DL, 26
    LEA BP, MA2
    INT 10H

    XOR CX, CX
    MOV CH, 6 ; Position ng highlighter (6 for the first row/position and 7 for the second row/position)
    ; ------ LOGIC para sa up and down arrow keys function ------
    MA_INPUT:
        MOV AH, 10H
        INT 16H

        CMP AH, 48H ; Up Arrow
        JE MA_UP_ARROW
        CMP AH, 50H ; Up Arrow
        JE MA_DOWN_ARROW
        CMP AX, 1C0DH ; Enter Key
        JE MA_ENTER_KEY
    JNE MA_INPUT

    MA_UP_ARROW:
        CMP CH, 6
        JE MA_INPUT
        
        PUSH CX ; Need i-temporary store yung CX since need ng CX yung function na AH = 13H

        MOV AH, 13H
        MOV AL, 1
        MOV BH, 5
        MOV BL, 07H
        MOV CX, 25
        MOV DH, 7
        MOV DL, 26
        LEA BP, MA2
        INT 10H

        MOV AH, 13H
        MOV AL, 1
        MOV BH, 5
        MOV BL, 1FH
        MOV CX, 25
        MOV DH, 6
        MOV DL, 26
        LEA BP, MA1
        INT 10H

        POP CX
        DEC CH ; Update the position/row
    JMP MA_INPUT

    MA_DOWN_ARROW:
        CMP CH, 7
        JE MA_INPUT
        
        PUSH CX ; Need i-temporary store yung CX since need ng CX yung function na AH = 13H

        MOV AH, 13H
        MOV AL, 1
        MOV BH, 5
        MOV BL, 07H
        MOV CX, 25
        MOV DH, 6
        MOV DL, 26
        LEA BP, MA1
        INT 10H

        MOV AH, 13H
        MOV AL, 1
        MOV BH, 5
        MOV BL, 1FH
        MOV CX, 25
        MOV DH, 7
        MOV DL, 26
        LEA BP, MA2
        INT 10H

        POP CX
        INC CH ; Update the position/row
    JMP MA_INPUT

    MA_ENTER_KEY:
        CMP CH, 6 ; The position is at 'Set Access level to Guest'
        JE SET_ACCESS_TO_GUEST

        CMP CH, 7 ; The position is at 'Set Access level to Admin'
        JE SET_ACCESS_TO_ADMIN

        SET_ACCESS_TO_GUEST:
        MOV ACCESS_LEVEL, 0
        JMP NOT_MATCH

        SET_ACCESS_TO_ADMIN:
        MOV ACCESS_LEVEL, 1
        JMP NOT_MATCH

    NOT_MATCH:
    ; Clear the whole username buffer
    MOV SI, OFFSET MA_USERNAME_BUFFER+2
    XOR CX, CX
    MOV CL, [MA_USERNAME_BUFFER+1]

    CLEAR_USERNAME_BUFFER:
    MOV [SI], 0
    INC SI
    LOOP CLEAR_USERNAME_BUFFER

    MOV BYTE PTR [MA_USERNAME_BUFFER+1], 0 ; Clears the amount typed value in the buffer

    ; CLears the whole password buffer
    MOV SI, OFFSET MA_PASSWORD_BUFFER+2
    XOR CX, CX
    MOV CL, [MA_PASSWORD_BUFFER+1]
    

    CLEAR_PASSWORD_BUFFER:
    MOV [SI], 0
    INC SI
    LOOP CLEAR_PASSWORD_BUFFER

    MOV BYTE PTR [MA_PASSWORD_BUFFER+1], 0 ; Clears the amount typed value in the buffer

    MOV AH, 05H
    MOV AL, 0
    INT 10H

    XOR CX, CX
    MOV CH, 9

    RET
MANAGE_ACCESS ENDP

END MAIN