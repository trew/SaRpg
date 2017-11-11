DEFINT A-Z      'Speed up program

'*** Change these constants when you make new labyrinth files. ***
CONST MAXROW = 24
CONST MAXCOL = 80
CONST Wallsfile$ = "MAZE.APG"

'Labyrinth file symbols (do not change).
CONST WAY = 0, PLAYER = 1, WALL = 2, DOOR = 3, LOCKED.PASS = 4, PASSED = 0
'Subprograms

DECLARE SUB SInput (Row%, Col%, Length%)
DECLARE SUB Help ()
DECLARE SUB Center (Row%, Text$)
DECLARE SUB Menu ()
DECLARE SUB PassDoor ()                 'Player escaped the labyrinth
DECLARE SUB Walls ()                    'Read labyrinth file into array
DECLARE SUB MovePlayer ()               'Get direction and draw player
DECLARE SUB DrawArea ()                 'Draw the screen from the "area" array
DECLARE SUB Meeting ()
DECLARE SUB PutKeys ()

'Arrays and variables
OPTION BASE 1
DIM SHARED area(MAXROW, MAXCOL)         'The labyrinth array
DIM SHARED SOutput$
COMMON SHARED pRow, pCol                'Player row and column
COMMON SHARED key1Row, key1Col, key2Row, key2Col, key1, key2

ON ERROR GOTO ErrorHandler
OPEN Wallsfile$ FOR INPUT AS #1
CLOSE #1

'*** Setup labyrinth ***
SCREEN 0: COLOR 7, 0: WIDTH 80: KEY OFF: VIEW PRINT: CLS

LOCATE 11, 25: PRINT "Vad heter du? "
SInput 11, 39, 18
'*** Menu ***
Menu
'*** Main loop ***

Walls
DrawArea
PutKeys
DO
        Meeting
        MovePlayer
LOOP

ErrorHandler:
SELECT CASE ERR
CASE 53
        CLS
        LOCATE 1, 1: PRINT "[ Filen "; Wallsfile$; " saknas. ] K”r setup eller ”ppna programmet i r„tt katalog."
        END
        RESUME
CASE ELSE
        CLS
        LOCATE 1, 1: PRINT "[ Ett fel intr„ffade { "; ERR; " } ]"
        END
        RESUME
END SELECT

SUB Center (Row%, Text$)

Col = 40 - INT(LEN(Text$) / 2)
LOCATE Row, Col
PRINT Text$;
END SUB

SUB DrawArea
key1Row = 6
key1Col = 75
key2Row = 11
key2Col = 13
FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
                LOCATE r, c
                IF area(r, c) = WALL THEN
                        PRINT "Û";
                ELSEIF area(r, c) = PLAYER THEN
                        lct = (r - 1) * 160 + (2 * (c - 1))
                        DEF SEG = &HB800
                        POKE lct + 1, 14
                        POKE lct, 2
                        DEF SEG
                ELSEIF area(r, c) = DOOR THEN
                        PRINT "ž";
                ELSEIF area(r, c) = LOCKED.PASS THEN
                        PRINT "±";
                ELSE
                        PRINT " ";
                END IF
        NEXT
NEXT

END SUB

SUB Help
u$ = CHR$(0) + "H"
d$ = CHR$(0) + "P"
esc$ = CHR$(27)
page1:
CLS
FOR X = 1 TO 79
    LOCATE 1, X: PRINT "ß"
    LOCATE 24, X: PRINT "Ü"
NEXT X
FOR Y = 1 TO 24
    LOCATE Y, 1: PRINT "Û"
    LOCATE Y, 79: PRINT "Û"
NEXT Y

Center 2, "SaRPG Version 1.0"
Center 4, "SaRPG is a beginner game from mr Samuel Andersson. The game includes"
Center 5, "Some files you must have to run the game. This files is:"
Center 6, "  File          Size   "
Center 7, "MAZE.APG     1970 bytes"
Center 8, "Symbols in SaRPG"
Center 9, "² = UNLOCKED DOOR"
Center 10, "± = LOCKED DORR "
COLOR 14, 0
Center 11, CHR$(2) + "               "
COLOR 7, 0
LOCATE 11, 33: PRINT "= PLAYER"
Center 12, "x = EXIT DOOR   "
Center 13, "Û = WALL        "
Center 14, "¨ = KEY         "

LOCATE 15, 3: PRINT "Story:"
Center 16, "Mr." + SOutput$ + " has been used to fight for the land in the distance."
Center 17, "Because that land is threatened by some aliens from the outer space."
Center 18, "They... „h, just play the game and have some fun because I won't write"
Center 19, "any more!!!"

DO
    a$ = INKEY$
    IF a$ = esc$ OR a$ = d$ THEN EXIT DO
LOOP

SELECT CASE a$
CASE esc$
    EXIT SUB
CASE d$
GOTO page2
END SELECT

page2:
CLS
FOR X = 1 TO 79
    LOCATE 1, X: PRINT "ß"
    LOCATE 24, X: PRINT "Ü"
NEXT X
FOR Y = 1 TO 24
    LOCATE Y, 1: PRINT "Û"
    LOCATE Y, 79: PRINT "Û"
NEXT Y

Center 2, "SaRPG Version 1.0"

DO
    a$ = INKEY$
    IF a$ = esc$ OR a$ = u$ THEN EXIT DO
LOOP

SELECT CASE a$
CASE esc$
    EXIT SUB
CASE u$
    GOTO page1
END SELECT
END SUB

SUB Meeting

IF pRow = key1Row AND pCol = key1Col THEN area(12, 31) = 0
IF pRow = key2Row AND pCol = key2Col THEN area(22, 16) = 0

IF key1 <> PASSED THEN
    IF area(6, 75) = 0 THEN LOCATE 12, 31: PRINT "²": key1 = PASSED
ELSEIF area(6, 75) <> 0 THEN key1 = NOT PASSED
END IF

IF key2 <> PASSED THEN
    IF area(11, 13) = 0 THEN LOCATE 22, 16: PRINT "²": key2 = PASSED
ELSEIF area(11, 13) <> 0 THEN key2 = NOT PASSED
END IF
END SUB

SUB Menu
StartMenu:
u$ = CHR$(0) + "H"
d$ = CHR$(0) + "P"
F1$ = CHR$(0) + CHR$(&H3B)
enter$ = CHR$(13)

CLS
Center 1, "SaRPG"
Center 2, "îîîîî"
Center 24, "Version 1.0"
FOR X = 20 TO 60
    LOCATE 4, X: PRINT "ß"
    LOCATE 12, X: PRINT "Ü"
NEXT X
FOR Y = 4 TO 12
    LOCATE Y, 20: PRINT "Û"
    LOCATE Y, 60: PRINT "Û"
NEXT Y
FOR X = 20 TO 60
    LOCATE 14, X: PRINT "ß"
    LOCATE 20, X: PRINT "Ü"
NEXT X
FOR Y = 14 TO 20
    LOCATE Y, 20: PRINT "Û"
    LOCATE Y, 60: PRINT "Û"
NEXT Y
'COLOR 7, 0

cursor = 1

DO
    Center 6, "Play"
    Center 8, "Help"
    Center 10, "Exit"
    IF cursor = 1 THEN
        COLOR 1, 2
        Center 6, "Play"
        COLOR 7, 0
        FOR X = 21 TO 59
            FOR Y = 15 TO 19
                LOCATE Y, X: PRINT " "
            NEXT Y
        NEXT X
        LOCATE 15, 22: PRINT "Play the game"
    ELSEIF cursor = 2 THEN
        COLOR 1, 2
        Center 8, "Help"
        COLOR 7, 0
        FOR X = 21 TO 59
            FOR Y = 15 TO 19
                LOCATE Y, X: PRINT " "
            NEXT Y
        NEXT X
        LOCATE 15, 22: PRINT "Help about the game, special commands"
        LOCATE 16, 22: PRINT "and how to cheat."
        LOCATE
    ELSEIF cursor = 3 THEN
        COLOR 1, 2
        Center 10, "Exit"
        COLOR 7, 0
        FOR X = 21 TO 59
            FOR Y = 15 TO 19
                LOCATE Y, X: PRINT " "
            NEXT Y
        NEXT X
        LOCATE 15, 22: PRINT "Exit the game"
    END IF
    IF cursor <> 1 THEN
        COLOR 7, 0
        Center 6, "Play"
    END IF
    IF cursor <> 2 THEN
        COLOR 7, 0
        Center 8, "Help"
    END IF
    IF cursor <> 3 THEN
        COLOR 7, 0
        Center 10, "Exit"
    END IF

    DO
        a$ = INKEY$
        IF a$ = enter$ OR a$ = u$ OR a$ = d$ OR a$ = F1$ THEN EXIT DO
    LOOP
    SELECT CASE a$
    CASE enter$
        IF cursor = 1 THEN EXIT DO
        IF cursor = 2 THEN Help: GOTO StartMenu
        IF cursor = 3 THEN CLS : END
    CASE u$
        cursor = cursor - 1
        IF cursor < 1 THEN cursor = 3
    CASE d$
        cursor = cursor + 1
        IF cursor > 3 THEN cursor = 1
    CASE F1$
    END SELECT
LOOP
END SUB

SUB MovePlayer

LARROW$ = CHR$(0) + "K"
RARROW$ = CHR$(0) + "M"
UARROW$ = CHR$(0) + "H"
DARROW$ = CHR$(0) + "P"
esc$ = CHR$(27)

DO
direction$ = INKEY$
LOOP WHILE direction$ = ""

SELECT CASE direction$
        CASE LARROW$
                IF pCol - 1 < LBOUND(area, 2) THEN EXIT SUB
                IF area(pRow, pCol - 1) = DOOR THEN PassDoor: EXIT SUB
                IF area(pRow, pCol - 1) = 0 THEN
                        area(pRow, pCol) = 0
                        LOCATE pRow, pCol: PRINT " "
                        pCol = pCol - 1
                        area(pRow, pCol) = 1
                END IF
        CASE RARROW$
                IF pCol + 1 > UBOUND(area, 2) THEN EXIT SUB
                IF area(pRow, pCol + 1) = DOOR THEN PassDoor: EXIT SUB
                IF area(pRow, pCol + 1) = 0 THEN
                        area(pRow, pCol) = 0
                        LOCATE pRow, pCol: PRINT " "
                        pCol = pCol + 1
                        area(pRow, pCol) = 1
                END IF
        CASE UARROW$
                IF pRow - 1 < LBOUND(area, 1) THEN EXIT SUB
                IF area(pRow - 1, pCol) = DOOR THEN PassDoor: EXIT SUB
                IF area(pRow - 1, pCol) = 0 THEN
                        area(pRow, pCol) = 0
                        LOCATE pRow, pCol: PRINT " "
                        pRow = pRow - 1
                        area(pRow, pCol) = 1
                END IF
        CASE DARROW$
                IF pRow + 1 > UBOUND(area, 1) THEN EXIT SUB
                IF area(pRow + 1, pCol) = DOOR THEN PassDoor: EXIT SUB
                IF area(pRow + 1, pCol) = 0 THEN
                        area(pRow, pCol) = 0
                        LOCATE pRow, pCol: PRINT " "
                        pRow = pRow + 1
                        area(pRow, pCol) = 1
                END IF
        CASE esc$
                CLS
                END
END SELECT

'Draw player
lct = (pRow - 1) * 160 + (2 * (pCol - 1))
DEF SEG = &HB800
POKE lct + 1, 14
POKE lct, 2
DEF SEG

END SUB

SUB PassDoor

CLS
PRINT "The door is passed...": PRINT
PRINT "Press enter to end."
DO: a$ = INKEY$
LOOP UNTIL a$ = CHR$(13)
END

END SUB

SUB PutKeys

LOCATE 6, 75
PRINT "¨";
LOCATE 11, 13
PRINT "¨";

END SUB

SUB SInput (Row, Col, Length)

'Reset output variable
SOutput$ = ""

'ICol = Current column
'ECol = Last allowed column
Ecol = (Col + Length - 1)

FOR i = Ecol TO Col STEP -1
        IF CHR$(SCREEN(Row, i)) <> " " THEN EXIT FOR
        Icol = i
NEXT i
IF Icol < 1 OR Icol > Ecol THEN Icol = Ecol

StartInput:
        LOCATE Row, Icol, 1
        DO: Inp$ = INKEY$: LOOP WHILE Inp$ = ""
        'If the input is valid, then print the character
        FOR Ch = 32 TO 254
                IF Ch = ASC(Inp$) THEN GOTO PrintCh
        NEXT Ch

        IF Inp$ = CHR$(13) GOTO InputFinished           'Enter ends input.
                                                        'Modify if needed.
        IF Inp$ = CHR$(0) + CHR$(75) THEN Icol = Icol - 1       'Left arrow
        IF Inp$ = CHR$(0) + CHR$(77) THEN Icol = Icol + 1       'Right arrow
        IF Inp$ = CHR$(8) THEN                                  'Backstep
                IF Icol = Ecol AND CHR$(SCREEN(Row, Ecol)) <> " " THEN
                        LOCATE Row, Ecol
                        PRINT " "
                        LOCATE Row, Ecol
                ELSE
                        IF Icol = Col THEN Icol = Col + 1
                        LOCATE Row, Icol - 1
                        PRINT " "
                        Icol = Icol - 1
                END IF
        END IF
        IF Inp$ = CHR$(0) + CHR$(83) THEN                       'Del
                FOR Del = Icol TO Ecol
                        LOCATE Row, Del
                        IF Del = Ecol THEN
                                PRINT " ";
                        ELSE
                                PRINT CHR$(SCREEN(Row, (Del + 1)));
                        END IF
                NEXT Del
        END IF
        IF Inp$ = CHR$(0) + CHR$(71) THEN                       'Home
                FOR FirstCh = Col TO Ecol
                        IF FirstCh = Col THEN Icol = Col
                        IF CHR$(SCREEN(Row, FirstCh)) <> " " THEN EXIT FOR
                        Icol = FirstCh + 1
                        IF FirstCh = Ecol THEN Icol = Col
                NEXT FirstCh
        END IF
        IF Inp$ = CHR$(0) + CHR$(79) THEN                       'End
                FOR LastCh = Ecol TO Col STEP -1
                        IF LastCh = Ecol THEN Icol = Ecol
                        IF CHR$(SCREEN(Row, LastCh)) <> " " THEN EXIT FOR
                        Icol = LastCh
                NEXT LastCh
        END IF

        IF Icol < Col THEN Icol = Col
        IF Icol > Ecol THEN Icol = Ecol
       
GOTO StartInput

'Type character
PrintCh:
        IF Icol < Col THEN Icol = Col
        IF Icol > Ecol THEN Icol = Ecol
        LOCATE Row, Icol
        PRINT Inp$;
        IF Icol < Ecol THEN Icol = Icol + 1
GOTO StartInput

InputFinished:
LOCATE , , 0            'Turn off cursor
FOR Ch = Col TO Ecol                            'Write screen output to
        SOutput$ = SOutput$ + CHR$(SCREEN(Row, Ch))   'variable 'SOutput$'
NEXT Ch
'Remove spaces before and after input
SOutput$ = LTRIM$(RTRIM$(SOutput$))

END SUB

SUB Walls

'Read formatstring from labyrinth file
OPEN Wallsfile$ FOR INPUT AS #1
FOR a = 1 TO MAXROW
        INPUT #1, partOfFormat$
        formatstring$ = formatstring$ + partOfFormat$
NEXT a
CLOSE #1

'Write formatstring into area array
FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
                i = i + 1
                area(r, c) = VAL(MID$(formatstring$, i, 1))
                IF area(r, c) = 1 THEN pRow = r: pCol = c
        NEXT c
NEXT r

END SUB

