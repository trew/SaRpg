'Files:
'   README.TXT          README-file
'   MAZE.APG            The labyrinth Page 1
'   MAZE2.APG           The labyrinth Page 2
'   SAVGAME.DAT         Saved games
'   *.GAM               The files you save

DEFINT A-Z
DECLARE SUB DoEnemies ()
DECLARE SUB SaveBG (Restr, row1, col1, row2, col2, BG())
DECLARE SUB FigthEnemy ()
DECLARE SUB TunnelMovie (wey)
DECLARE SUB DestroyLock ()
DECLARE SUB LoadGame ()
DECLARE SUB SaveGame ()
DECLARE SUB Delay (T#)
DECLARE SUB PauseMenu ()
DECLARE SUB Setup ()
DECLARE SUB SInput (row, col, Length)
DECLARE SUB DoBox (x1, y1, x2, y2, colour)
DECLARE SUB Center (row, Text$)
DECLARE SUB Menu ()
DECLARE SUB Help ()
DECLARE SUB PlayGame ()
DECLARE SUB Meeting (S)
DECLARE SUB PassDoor ()
DECLARE SUB Walls (Ban)
DECLARE SUB MovePlayer ()
DECLARE SUB DrawArea ()

'Constants
CONST MAXROW = 24
CONST MAXCOL = 80

CONST WAY = 0
CONST PLAYER = 1
CONST WALL = 2
CONST DOOR = 3
CONST LOCKED.PASS = 4
CONST ENEMY = 5

CONST FALSE = 0
CONST TRUE = 1

CONST PASSED = 1
CONST MEN = 1

CONST Key11Row = 6
CONST Key11Col = 75
CONST Key12Row = 11
CONST Key12Col = 13

CONST Key21Row = 13
CONST Key21Col = 78
CONST Key22Row = 3
CONST Key22Col = 56

CONST Door11Row = 12
CONST Door11Col = 31
CONST Door12Row = 22
CONST Door12Col = 16

CONST Door21Row = 2
CONST Door21Col = 79
CONST Door22Row = 18
CONST Door22Col = 3

CONST ExitDoor1Row = 23
CONST ExitDoor1Col = 1

CONST ExitDoor2Row = 2
CONST ExitDoor2Col = 80

CONST BackDoor2Row = 23
CONST BackDoor2Col = 80

'Arrays and variables
OPTION BASE 1

DIM SHARED area(MAXROW, MAXCOL)
DIM SHARED EnemyData$(5)
DIM SHARED EnemyAttack(5)
DIM SHARED EnemyDefence(5)
DIM SHARED EnemyMagic(5, 3)
DIM SHARED EnemyHitPoints(5)

COMMON SHARED pRow
COMMON SHARED pCol

COMMON SHARED Key11
COMMON SHARED Key12
COMMON SHARED Key21
COMMON SHARED Key22

COMMON SHARED Bana

COMMON SHARED Load
COMMON SHARED SOutput$
COMMON SHARED cheate
COMMON SHARED areas
COMMON SHARED areas2
COMMON SHARED inputs
COMMON SHARED a

COMMON SHARED u$
COMMON SHARED d$
COMMON SHARED enter$
COMMON SHARED esc$

COMMON SHARED enemes AS STRING

ON ERROR GOTO ErrorHandler

KEY 15, CHR$(&H0) + CHR$(&H1)
ON KEY(15) GOSUB Pause

Setup
Menu

Pause:
    PauseMenu
RETURN

ErrorHandler:
SELECT CASE ERR
CASE 53
    CLS
    LOCATE 1, 1: PRINT "En Fil saknas. Installera om programmet eller "
    LOCATE 2, 1: PRINT "starta om programmet i rätt katalog."
    END
    RESUME
CASE ELSE
    CLS
    LOCATE 1, 1: PRINT "Ett fel har inträffat { "; ERR; " }"
    LOCATE 2, 1: PRINT LTRIM$(RTRIM$(STR$(ERL)))
    END
    RESUME
END SELECT

savgame.daterror:
SELECT CASE ERR
CASE 53
OPEN "saved/SAVGAME.DAT" FOR OUTPUT AS #1
    WRITE #1, 0
CLOSE #1
RESUME
END SELECT

SUB Center (row, Text$)

col = 40 - INT(LEN(Text$) / 2)
LOCATE row, col
PRINT Text$;
END SUB

SUB Delay (T#)

time! = TIMER + T#
DO
a$ = INKEY$
IF a$ = CHR$(27) THEN EXIT DO
LOOP WHILE time! > TIMER
END SUB

SUB DestroyLock
        DEF SEG = &H40
            POKE &H17, PEEK(&H17) AND (NOT 240)
        DEF SEG
END SUB

SUB DoBox (row1, col1, row2, col2, colour)
COLOR colour, 0

FOR col = col1 TO col2
    LOCATE row1, col: PRINT "▀"
    LOCATE row2, col: PRINT "▄"
NEXT col

FOR row = row1 TO row2
    LOCATE row, col1: PRINT "█"
    LOCATE row, col2: PRINT "█"
NEXT row
FOR row = row1 + 1 TO row2 - 1
FOR col = col1 + 1 TO col2 - 1
    LOCATE row, col: PRINT " "
NEXT col
NEXT row
COLOR 7, 0
END SUB

SUB DoEnemies
FOR r = 1 TO 6
    FOR c = 1 TO MAXCOL
        IF area(r, c) = WAY THEN
            rn = INT(RND(1) * 1000 + 1)
            IF rn >= 2 AND rn < 50 THEN
                area(r, c) = ENEMY
            ELSE
                area(r, c) = WAY
            END IF
        END IF
    NEXT c
NEXT r
FOR r = 6 TO 12
    FOR c = 1 TO MAXCOL
        IF area(r, c) = WAY THEN
            rn = INT(RND(1) * 1000 + 1)
            IF rn >= 2 AND rn < 50 THEN
                area(r, c) = ENEMY
            ELSE
                area(r, c) = WAY
            END IF
        END IF
    NEXT c
NEXT r
FOR r = 12 TO 18
    FOR c = 1 TO MAXCOL
        IF area(r, c) = WAY THEN
            rn = INT(RND(1) * 1000 + 1)
            IF rn >= 2 AND rn < 50 THEN
                area(r, c) = ENEMY
            ELSE
                area(r, c) = WAY
            END IF
        END IF
    NEXT c
NEXT r
FOR r = 18 TO 24
    FOR c = 1 TO MAXCOL
        IF area(r, c) = WAY THEN
            rn = INT(RND(1) * 1000 + 1)
            IF rn >= 2 AND rn <= 50 THEN
                area(r, c) = ENEMY
            ELSE
                area(r, c) = WAY
            END IF
        END IF
    NEXT c
NEXT r
END SUB

SUB DrawArea

CLS
FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
                LOCATE r, c
                IF area(r, c) = WALL THEN
                        PRINT "█"
                ELSEIF area(r, c) = PLAYER THEN
                        IF Load = FALSE THEN
                            lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
                            DEF SEG = &HB800
                                POKE lct + 1, 15
                                POKE lct, 2
                            DEF SEG
                        ELSE
                        END IF
                ELSEIF area(r, c) = DOOR THEN
                        PRINT "░"
                ELSEIF area(r, c) = LOCKED.PASS THEN
                        PRINT "▒"
                ELSEIF area(r, c) = ENEMY THEN
                        PRINT CHR$(1)
                ELSE
                        PRINT " "
                END IF
        NEXT
NEXT
END SUB

SUB FigthEnemy

DIM BG(24, 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
DoBox 5, 5, 12, 30, 7
DoBox 5, 35, 11, 70, 7
DoBox 14, 5, 19, 30, 7
DoBox 14, 35, 19, 70, 7

enemis = INT(RND(1) * 20 + 1)
IF enemis >= 0 AND enemis < 7 THEN
    enemes = "Oldman"
ELSEIF enemis >= 7 AND enemis <= 10 AND enemies <> 8 THEN
    enemes = "Monster"
ELSEIF enemis = 8 THEN
    enemes = "MagicMan"
ELSEIF enemis >= 11 AND enemis < 13 THEN
    enemes = "Evilman"
ELSEIF enemis >= 13 THEN
    enemes = "Soldier"
ELSE
    enemes = "Soldier"
END IF
SELECT CASE enemes
CASE "Oldman"

LOCATE 6, 7: PRINT "NE: "; EnemyData$(1)
LOCATE 7, 7: PRINT "HP: "; LTRIM$(RTRIM$(STR$(EnemyHitPoints(1))))
LOCATE 8, 7: PRINT "AT: "; LTRIM$(RTRIM$(STR$(EnemyAttack(1))))
LOCATE 9, 7: PRINT "DF: "; LTRIM$(RTRIM$(STR$(EnemyDefence(1))))

CASE "Monster"
LOCATE 6, 7: PRINT "NE: "; EnemyData$(2)
LOCATE 7, 7: PRINT "HP: "; LTRIM$(RTRIM$(STR$(EnemyHitPoints(2))))
LOCATE 8, 7: PRINT "AT: "; LTRIM$(RTRIM$(STR$(EnemyAttack(2))))
LOCATE 9, 7: PRINT "DF: "; LTRIM$(RTRIM$(STR$(EnemyDefence(2))))

CASE "MagicMan"
LOCATE 6, 7: PRINT "NE: "; EnemyData$(3)
LOCATE 7, 7: PRINT "HP: "; LTRIM$(RTRIM$(STR$(EnemyHitPoints(3))))
LOCATE 8, 7: PRINT "AT: "; LTRIM$(RTRIM$(STR$(EnemyAttack(3))))
LOCATE 9, 7: PRINT "DF: "; LTRIM$(RTRIM$(STR$(EnemyDefence(3))))
LOCATE 10, 7: PRINT "MG1: "; LTRIM$(RTRIM$(STR$(EnemyMagic(3, 1))))
LOCATE 11, 7: PRINT "MG2: "; LTRIM$(RTRIM$(STR$(EnemyMagic(3, 2))))

CASE "Evilman"
LOCATE 6, 7: PRINT "NE: "; EnemyData$(4)
LOCATE 7, 7: PRINT "HP: "; LTRIM$(RTRIM$(STR$(EnemyHitPoints(4))))
LOCATE 8, 7: PRINT "AT: "; LTRIM$(RTRIM$(STR$(EnemyAttack(4))))
LOCATE 9, 7: PRINT "DF: "; LTRIM$(RTRIM$(STR$(EnemyDefence(4))))
                                                                  
CASE "Soldier"
LOCATE 6, 7: PRINT "NE: "; EnemyData$(5)
LOCATE 7, 7: PRINT "HP: "; LTRIM$(RTRIM$(STR$(EnemyHitPoints(5))))
LOCATE 8, 7: PRINT "AT: "; LTRIM$(RTRIM$(STR$(EnemyAttack(5))))
LOCATE 9, 7: PRINT "DF: "; LTRIM$(RTRIM$(STR$(EnemyDefence(5))))
END SELECT
g$ = INPUT$(1)
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

SUB Help
StartHelp:
esc$ = CHR$(27)
Page1:
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
CLS
DoBox 1, 1, 24, 80, 7
Center 2, "Symbols in SaRpg3:"
Center 3, "╛ = Player       "
Center 4, "¿ = Key          "
Center 5, "█ = Wall         "
Center 6, "░ = Locked door  "
Center 7, "▒ = Locked door  "
Center 8, "▓ = Unlocked door"
Center 10, "Shorts: "
Center 11, "AT = Attack"
Center 12, "DF = Defence"
Center 13, "HP = Hit Points"
Center 14, "MGn = Magic n"
Center 15, "TY = Type"
DO
    a$ = INKEY$
    IF a$ = esc$ THEN
        SaveBG 1, 1, 1, 24, 80, BG()
        EXIT SUB
    ELSEIF a$ = PgDn$ THEN
        GOTO Page2
    END IF
LOOP

Page2:
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
CLS
DoBox 1, 1, 24, 80, 7
Center 2, "InGame Commands:"
Center 3, "Left Arrow = Move Player Left"
Center 4, "Right Arrow = Move Player Right"
Center 5, "Up Arrow = Move Player Up"
Center 6, "Down Arrow = Move Player Down"
Center 7, "Esc = Pause Menu"
g$ = INPUT$(1)
SaveBG 1, 1, 1, 24, 80, BG()
GOTO Page1
END SUB

SUB LoadGame
DIM fil(1 TO 30)
DIM file$
DIM name$(1 TO 30)
DIM nummer(1 TO 30)
FOR n = 1 TO 30
        fil(n) = n
        nummer(n) = n
NEXT n
CLS
DoBox 1, 1, 80, 24, 7
DoBox 1, 1, 80, 6, 7

ON ERROR GOTO savgame.daterror
OPEN "saved/SAVGAME.DAT" FOR INPUT AS #1
        ON ERROR GOTO ErrorHandler
        INPUT #1, antalfiler
CLOSE #1

FOR filer = 1 TO antalfiler
        file$ = "saved/SAVED"
        file$ = file$ + LTRIM$(RTRIM$(STR$(filer))) + ".GAM"
        OPEN file$ FOR INPUT AS #1
                INPUT #1, name$(filer)
        CLOSE #1
       
        IF filer >= 1 AND filer < 5 THEN
                LOCATE filer + 1, 3: PRINT filer; name$(filer)
        END IF
  
        IF filer > 4 AND filer < 9 THEN
                LOCATE filer - 3, 15: PRINT filer; name$(filer)
        END IF
  
        IF filer > 9 AND filer < 14 THEN
                LOCATE filer - 8, 28: PRINT filer; name$(filer)
        END IF
  
        IF filer > 14 AND filer < 19 THEN
                LOCATE filer - 13, 41: PRINT filer; name$(filer)
        END IF
  
        IF filer > 18 AND filer < 23 THEN
                LOCATE filer - 17, 54: PRINT filer; name$(filer)
        END IF
  
        IF filer > 22 AND filer < 27 THEN
                LOCATE filer - 21, 67: PRINT filer; name$(filer)
        END IF
NEXT filer
loopen:
DO
        a$ = INKEY$
        IF a$ <> "" OR a$ = CHR$(27) THEN EXIT DO
LOOP
FOR fi = 1 TO antalfiler
IF VAL(a$) = fil(fi) THEN
    OPEN "saved/SAVED" + (LTRIM$(RTRIM$(STR$(fi)))) + ".GAM" FOR INPUT AS #1
        INPUT #1, filename$
        INPUT #1, pRow, pCol
        INPUT #1, Bana
        INPUT #1, Key11, Key12, Key21
        FOR r = 1 TO MAXROW
            FOR c = 1 TO MAXCOL
                INPUT #1, area(r, c)
            NEXT c
        NEXT r
        Load = TRUE
        PlayGame
    CLOSE #1
END IF
NEXT fi
END SUB

SUB Meeting (S)

'Type in 6 PgDn to go to CASE 2

SELECT CASE S
CASE 1
IF pRow = Key11Row AND pCol = Key11Col THEN area(12, 31) = 0: Key11 = PASSED
IF pRow = Key12Row AND pCol = Key12Col THEN area(22, 16) = 0: Key12 = PASSED

IF Key11 = NOT PASSED THEN
        lct = (Key11Row - 1) * 160 + ((Key11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 125
        DEF SEG
        lct = (Door11Row - 1) * 160 + ((Door11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Key11Row AND pCol = Key11Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 15
            POKE lct, 2
        DEF SEG
        lct = (Door11Row - 1) * 160 + ((Door11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 178
        DEF SEG
ELSEIF pRow = Door11Row AND pCol = Door11Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, 15
                POKE lct, 2
        DEF SEG
ELSEIF Key11 = PASSED THEN
        lct = (Key11Row - 1) * 160 + ((Key11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 123
        DEF SEG
        lct = (Door11Row - 1) * 160 + ((Door11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 178
        DEF SEG
END IF

IF Key12 = NOT PASSED THEN
        lct = (Key12Row - 1) * 160 + ((Key12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 125
        DEF SEG
        lct = (Door12Row - 1) * 160 + ((Door12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Key12Row AND pCol = Key12Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 15
            POKE lct, 2
        DEF SEG
        lct = (Door12Row - 1) * 160 + ((Door12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 178
        DEF SEG
ELSEIF pRow = Door12Row AND pCol = Door12Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, 15
                POKE lct, 2
        DEF SEG
ELSEIF Key12 = PASSED THEN
        lct = (Key12Row - 1) * 160 + ((Key12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 123
        DEF SEG
        lct = (Door12Row - 1) * 160 + ((Door12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 178
        DEF SEG
END IF

IF Key11 = NOT PASSED THEN
        lct = (ExitDoor1Row - 1) * 160 + ((ExitDoor1Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 176
        DEF SEG
ELSEIF Key11 = PASSED AND Key12 = NOT PASSED THEN
        lct = (ExitDoor1Row - 1) * 160 + ((ExitDoor1Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 177
        DEF SEG
ELSEIF Key12 = PASSED THEN
        lct = (ExitDoor1Row - 1) * 160 + ((ExitDoor1Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 178
        DEF SEG
END IF


CASE 2


IF pRow = Key21Row AND pCol = Key21Col THEN area(Door21Row, Door21Col) = 0: Key21 = PASSED
IF pRow = Key22Row AND pCol = Key22Col THEN area(Door22Row, Door22Col) = 0: Key22 = PASSED

IF Key11 = PASSED AND Key12 = PASSED THEN
    lct = (BackDoor2Row - 1) * 160 + ((BackDoor2Col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 1, 7
        POKE lct, 178
    DEF SEG
ELSEIF Key11 = PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, 7
        POKE lct, 177
    DEF SEG
ELSE
    DEF SEG = &HB800
        POKE lct + 1, 7
        POKE lct, 176
    DEF SEG
END IF

IF Key21 = NOT PASSED THEN
        lct = (Key21Row - 1) * 160 + ((Key21Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 125
        DEF SEG
        lct = (Door21Row - 1) * 160 + ((Door21Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Door21Row AND pCol = Door21Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, 15
                POKE lct, 2
        DEF SEG
ELSEIF Key21 = PASSED THEN
        IF pRow = Key21Row AND pCol = Key21Col THEN
            lct = (Door21Row - 1) * 160 + ((Door21Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, 7
                POKE lct, 178
            DEF SEG
        ELSE
            lct = (Key21Row - 1) * 160 + ((Key21Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, 7
                POKE lct, 123
            DEF SEG
            lct = (Door21Row - 1) * 160 + ((Door21Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, 7
                POKE lct, 178
            DEF SEG
        END IF
END IF


IF Key22 = NOT PASSED THEN
        lct = (Key22Row - 1) * 160 + ((Key22Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 125
        DEF SEG
        lct = (Door22Row - 1) * 160 + ((Door22Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, 7
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Door22Row AND pCol = Door22Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, 15
                POKE lct, 2
        DEF SEG
ELSEIF Key22 = PASSED THEN
        IF pRow = Key22Row AND pCol = Key22Col THEN
            lct = (Door22Row - 1) * 160 + ((Door22Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, 7
                POKE lct, 178
            DEF SEG
        ELSE
            lct = (Key22Row - 1) * 160 + ((Key22Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, 7
                POKE lct, 123
            DEF SEG
            lct = (Door22Row - 1) * 160 + ((Door22Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, 7
                POKE lct, 178
            DEF SEG
        END IF
END IF

lct = (ExitDoor2Row - 1) * 160 + ((ExitDoor2Col - 1) * 2)
IF Key21 = NOT PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, 7
        POKE lct, 176
    DEF SEG
ELSEIF Key21 = PASSED AND Key22 = NOT PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, 7
        POKE lct, 177
    DEF SEG
ELSEIF Key21 = PASSED AND Key22 = PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, 7
        POKE lct, 178
    DEF SEG
END IF
    
END SELECT
END SUB

SUB Menu
u$ = CHR$(0) + CHR$(72)
d$ = CHR$(0) + CHR$(80)
enter$ = CHR$(13)

KEY(15) OFF

MenuStart:
CLS
DoBox 6, 25, 12, 55, 7
cursor = 1
Center 2, "SaRpg"
Center 3, "εεεεε"
Center 24, "Version 1.0"
DO
        IF cursor = 1 THEN
                COLOR 3, 4
                LOCATE 7, 37: PRINT "Play"
        ELSEIF cursor = 2 THEN
                COLOR 1, 3
                LOCATE 9, 37: PRINT "Help"
        ELSEIF cursor = 3 THEN
                COLOR 0, 6
                LOCATE 11, 37: PRINT "Exit"
        END IF
        IF cursor > 1 THEN
                COLOR 7, 0
                LOCATE 7, 37: PRINT "Play"
        END IF
        IF cursor <> 2 THEN
                COLOR 7, 0
                LOCATE 9, 37: PRINT "Help"
        END IF
        IF cursor <> 3 THEN
                COLOR 7, 0
                LOCATE 11, 37: PRINT "Exit"
        END IF
        DO
                a$ = INKEY$
                IF a$ = u$ OR a$ = d$ OR a$ = enter$ THEN EXIT DO
        LOOP
        SELECT CASE a$
        CASE u$
                cursor = cursor - 1
                IF cursor < 1 THEN cursor = 3
        CASE d$
                cursor = cursor + 1
                IF cursor > 3 THEN cursor = 1
        CASE enter$
                IF cursor = 1 THEN PlayGame: GOTO MenuStart
                IF cursor = 2 THEN Help: GOTO MenuStart
                IF cursor = 3 THEN CLS : END
        END SELECT
LOOP
END SUB

SUB MovePlayer

Load = TRUE
LARROW$ = CHR$(0) + "K"
RARROW$ = CHR$(0) + "M"
UARROW$ = CHR$(0) + "H"
DARROW$ = CHR$(0) + "P"

direction$ = INKEY$

LOCATE pRow, pCol
SELECT CASE direction$
        CASE LARROW$
                IF pCol - 1 < LBOUND(area, 2) THEN EXIT SUB
                IF area(pRow, pCol - 1) = ENEMY THEN
                    FigthEnemy
                    area(pRow, pCol - 1) = 0
                    LOCATE pRow, pCol - 1: PRINT " "
                    LOCATE pRow, pCol
                    area(pRow, pCol) = 0
                    PRINT " "
                    pCol = pCol - 1
                ELSEIF area(pRow, pCol - 1) = DOOR THEN
                    IF Bana = 2 THEN
                        TunnelMovie 1
                        PassDoor
                    ELSE
                        Bana = Bana + 1
                        Walls Bana
                        DoEnemies
                        DrawArea
                        pRow = 23
                        pCol = 79
                        EXIT SUB
                    END IF
                ELSEIF area(pRow, pCol - 1) = 0 THEN
                        area(pRow, pCol) = 0
                        PRINT " "
                        pCol = pCol - 1
                        area(pRow, pCol) = 1
                END IF
        CASE RARROW$
                IF pCol + 1 > UBOUND(area, 2) THEN EXIT SUB
                IF area(pRow, pCol + 1) = ENEMY THEN
                    FigthEnemy
                    area(pRow, pCol + 1) = 0
                    LOCATE pRow, pCol + 1: PRINT " "
                    LOCATE pRow, pCol
                    area(pRow, pCol) = 0
                    PRINT " "
                    pCol = pCol + 1
                ELSEIF area(pRow, pCol + 1) = DOOR THEN
                    IF Bana = 2 THEN
                        IF pRow = BackDoor2Row AND pCol + 1 = BackDoor2Col THEN
                            Bana = 1
                            Walls Bana
                            DrawArea
                            pRow = 23
                            pCol = 2
                            EXIT SUB
                        ELSE
                            TunnelMovie 1
                            PassDoor
                        END IF
                    ELSE
                        Bana = Bana + 1
                        Walls Bana
                        DrawArea
                    END IF
                ELSEIF area(pRow, pCol + 1) = 0 THEN
                        area(pRow, pCol) = 0
                        PRINT " "
                        pCol = pCol + 1
                        area(pRow, pCol) = 1
                END IF
        CASE UARROW$
                IF pRow - 1 < LBOUND(area, 1) THEN EXIT SUB
                IF area(pRow - 1, pCol) = ENEMY THEN
                    FigthEnemy
                    area(pRow - 1, pCol) = 0
                    LOCATE pRow - 1, pCol: PRINT " "
                    LOCATE pRow, pCol
                    area(pRow, pCol) = 0
                    PRINT " "
                    pRow = pRow - 1
                ELSEIF area(pRow - 1, pCol) = DOOR THEN
                    IF Bana = 2 THEN
                        TunnelMovie 1
                        PassDoor
                    ELSE
                        Bana = Bana + 1
                        Walls Bana
                        DrawArea
                    END IF
                ELSEIF area(pRow - 1, pCol) = 0 THEN
                        area(pRow, pCol) = 0
                        PRINT " "
                        pRow = pRow - 1
                        area(pRow, pCol) = 1
                END IF
        CASE DARROW$
                IF pRow + 1 > UBOUND(area, 1) THEN EXIT SUB
                IF area(pRow + 1, pCol) = ENEMY THEN
                    FigthEnemy
                    area(pRow + 1, pCol) = 0
                    LOCATE pRow + 1, pCol: PRINT " "
                    LOCATE pRow, pCol
                    area(pRow, pCol) = 0
                    PRINT " "
                    pRow = pRow + 1
                ELSEIF area(pRow + 1, pCol) = DOOR THEN
                    IF Bana = 2 THEN
                        TunnelMovie 1
                        PassDoor
                    ELSE
                        Bana = 2
                        Walls Bana
                        DrawArea
                    END IF
                ELSEIF area(pRow + 1, pCol) = 0 THEN
                        area(pRow, pCol) = 0
                        PRINT " "
                        pRow = pRow + 1
                        area(pRow, pCol) = 1
                END IF
END SELECT

lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
DEF SEG = &HB800
    POKE lct + 1, 15
    POKE lct, 2
DEF SEG

END SUB

SUB PassDoor

KEY(15) OFF
CLS
PRINT "The door is passed...": PRINT
PRINT "Press enter to end."
DO: a$ = INKEY$
LOOP UNTIL a$ = CHR$(13)
END

END SUB

SUB PauseMenu
DIM b(MAXROW, MAXCOL)
KEY(15) OFF
DIM BG(24, 80, 0 TO 1)

SaveBG 0, 1, 1, 24, 80, BG()

PauseMenuStart:
FOR r = 7 TO 17
    FOR c = 17 TO 60
        LOCATE r, c: PRINT " "
    NEXT c
NEXT r
FOR c = 17 TO 60
    LOCATE 7, c: PRINT "▀"
    LOCATE 17, c: PRINT "▄"
NEXT c
FOR r = 7 TO 17
    LOCATE r, 17: PRINT "█"
    LOCATE r, 60: PRINT "█"
NEXT r

mark = 1
DO
    fg1 = 1: fg2 = 1: fg3 = 1: fg4 = 1: fg5 = 1: fg6 = 1
    IF mark = 1 THEN
        bg1 = 2: bg2 = 0: bg3 = 0: bg4 = 0: bg5 = 0: bg6 = 0
    ELSEIF mark = 2 THEN
        bg2 = 2: fg2 = 1: bg1 = 0: bg3 = 0: bg4 = 0: bg5 = 0: bg6 = 0
    ELSEIF mark = 3 THEN
        bg3 = 2: fg3 = 1: bg1 = 0: bg2 = 0: bg4 = 0: bg5 = 0: bg6 = 0
    ELSEIF mark = 4 THEN
        bg4 = 2: fg4 = 1: bg1 = 0: bg2 = 0: bg3 = 0: bg5 = 0: bg6 = 0
    ELSEIF mark = 5 THEN
        bg5 = 2: fg5 = 1: bg1 = 0: bg2 = 0: bg3 = 0: bg4 = 0: bg6 = 0
    ELSEIF mark = 6 THEN
        bg6 = 2: fg6 = 1: bg1 = 0: bg2 = 0: bg3 = 0: bg4 = 0: bg5 = 0
    END IF
    COLOR fg1, bg1
    Center 9, "Continue"
    COLOR fg2, bg2
    Center 10, "Help"
    COLOR fg3, bg3
    Center 11, "Save Game"
    COLOR fg4, bg4
    Center 12, "Load Game"
    COLOR fg5, bg5
    Center 13, "Exit to Menu"
    COLOR fg6, bg6
    Center 14, "Exit to your OS"
    COLOR 7, 0
    DO
        a$ = INKEY$
        IF a$ = u$ OR a$ = d$ OR a$ = enter$ THEN EXIT DO
    LOOP
    SELECT CASE a$
    CASE u$
        mark = mark - 1
        IF mark < 1 THEN mark = 6
    CASE d$
        mark = mark + 1
        IF mark > 6 THEN mark = 1
    CASE enter$
        IF mark = 1 THEN EXIT DO
        IF mark = 2 THEN Help: GOTO PauseMenuStart
        IF mark = 3 THEN SaveGame: GOTO PauseMenuStart
        IF mark = 4 THEN LoadGame: GOTO PauseMenuStart
        IF mark = 5 THEN Menu
        IF mark = 6 THEN CLS : END
    END SELECT
LOOP

KEY(15) ON


SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG

END SUB

SUB PlayGame

CLS
LOCATE 1, 1: PRINT "Please Wait..."
KEY(15) ON
'*** Setup Labyrint ***
Walls Bana
DoEnemies
DrawArea

'*** Main loop ***
DO
        DestroyLock
        Meeting Bana
        MovePlayer
LOOP
END SUB

SUB SaveBG (Restr, row1, col1, row2, col2, BG())

DEF SEG = &HB800
IF Restr THEN
    FOR row = row1 TO row2
        FOR col = col1 TO col2
            offset = (row - 1) * 160 + (2 * (col - 1))
            POKE offset, BG(row, col, 0)          'Poke char
            POKE offset + 1, BG(row, col, 1)      'Poke color
        NEXT col
    NEXT row
EXIT SUB
END IF
DEF SEG

DEF SEG = &HB800
FOR row = row1 TO row2
    FOR col = col1 TO col2
        'Peek char
        BG(row, col, 0) = PEEK((row - 1) * 160 + (2 * (col - 1)))
        'Peek color
        BG(row, col, 1) = PEEK(((row - 1) * 160 + (2 * (col - 1))) + 1)
    NEXT col
NEXT row
DEF SEG

END SUB

SUB SaveGame

DIM file$
DIM name$(1 TO 30)
CLS
DoBox 1, 1, 80, 24, 7
DoBox 1, 1, 80, 6, 7

ON ERROR GOTO savgame.daterror
OPEN "saved/SAVGAME.DAT" FOR INPUT AS #1
    ON ERROR GOTO ErrorHandler
    INPUT #1, antalfiler%
CLOSE #1

file$ = "SAVED"
FOR filer = 1 TO antalfiler%
        file$ = "saved/SAVED"
        file$ = file$ + LTRIM$(RTRIM$(STR$(filer))) + ".GAM"
        OPEN file$ FOR INPUT AS #1
                INPUT #1, name$(filer)
        CLOSE #1
   
        IF filer >= 1 AND filer < 5 THEN
                LOCATE filer + 1, 3: PRINT name$(filer)
        END IF
   
        IF filer > 4 AND filer < 9 THEN
                LOCATE filer - 3, 15: PRINT name$(filer)
        END IF
   
        IF filer > 9 AND filer < 14 THEN
                LOCATE filer - 8, 28: PRINT name$(filer)
        END IF
   
        IF filer > 14 AND filer < 19 THEN
                LOCATE filer - 13, 41: PRINT name$(filer)
        END IF
   
        IF filer > 18 AND filer < 23 THEN
                LOCATE filer - 17, 54: PRINT name$(filer)
        END IF
   
        IF filer > 22 AND filer < 27 THEN
                LOCATE filer - 21, 67: PRINT name$(filer)
        END IF

NEXT filer

LOCATE 8, 3: PRINT "Filename: "
SInput 8, 13, 15
filename$ = SOutput$

IF filename$ = "" THEN
        EXIT SUB
ELSE
antalfiler3% = antalfiler% + 1
Filenamn$ = "saved/SAVED" + LTRIM$(RTRIM$(STR$(antalfiler3%))) + ".GAM"
OPEN Filenamn$ FOR OUTPUT AS #1
    LOCATE 9, 3: PRINT "Saving..."
   
    WRITE #1, filename$
    WRITE #1, pRow, pCol
    WRITE #1, Bana
    WRITE #1, Key11, Key12, Key21
    FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
            WRITE #1, area(r, c)
        NEXT c
    NEXT r
   
    OPEN "saved/SAVGAME.DAT" FOR OUTPUT AS #2
        antalfiler2% = antalfiler% + 1
        WRITE #2, antalfiler2%
    CLOSE #2
CLOSE #1
LOCATE 9, 3: PRINT "Done.    "
END IF
g$ = INPUT$(1)
file$ = ""
END SUB

SUB Setup

SCREEN 0
WIDTH 80
COLOR 7, 0
KEY OFF
VIEW PRINT
CLS

FOR r = 1 TO MAXROW
    FOR c = 1 TO MAXCOL
        area(r, c) = WAY
    NEXT c
NEXT r

OPEN "OLDMAN.DAT" FOR INPUT AS #1
    INPUT #1, EnemyData$(1), EnemyHitPoints(1), EnemyAttack(1), EnemyDefence(1)
CLOSE #1
OPEN "MONSTER.DAT" FOR INPUT AS #1
    INPUT #1, EnemyData$(2), EnemyHitPoints(2), EnemyAttack(2), EnemyDefence(2)
CLOSE #1
OPEN "MAGIC.DAT" FOR INPUT AS #1
    INPUT #1, EnemyData$(3), EnemyHitPoints(3), EnemyAttack(3), EnemyDefence(3), EnemyMagic(3, 1), EnemyMagic(3, 2)
CLOSE #1
OPEN "EVIL.DAT" FOR INPUT AS #1
    INPUT #1, EnemyData$(4), EnemyHitPoints(4), EnemyAttack(4), EnemyDefence(4)
CLOSE #1
OPEN "SOLDIER.DAT" FOR INPUT AS #1
    INPUT #1, EnemyData$(5), EnemyHitPoints(5), EnemyAttack(5), EnemyDefence(5)
CLOSE #1

u$ = CHR$(0) + CHR$(72)
d$ = CHR$(0) + CHR$(80)
enter$ = CHR$(13)
esc$ = CHR$(27)

Load = FALSE
Key11 = NOT PASSED
Key12 = NOT PASSED
Key21 = NOT PASSED
Key22 = NOT PASSED
Bana = 1
END SUB

SUB SInput (row, col, Length)
'Reset output variable
SOutput$ = ""

'ICol = Current column
'ECol = Last allowed column
Ecol = (col + Length - 1)

FOR I = Ecol TO col STEP -1
        IF CHR$(SCREEN(row, I)) <> " " THEN EXIT FOR
        Icol = I
NEXT I
IF Icol < 1 OR Icol > Ecol THEN Icol = Ecol

StartInput:
        LOCATE row, Icol, 1
        DO
            Inp$ = INKEY$
            IF Inp$ = CHR$(27) THEN
                LOCATE , , 0
                inputs = TRUE
                EXIT SUB
            END IF
        LOOP WHILE Inp$ = ""
        'If the input is valid, then print the character
        FOR Ch = 32 TO 254
                IF Ch = ASC(Inp$) THEN GOTO PrintCh
        NEXT Ch

        IF Inp$ = CHR$(13) GOTO InputFinished           'Enter ends input.
                                                        'Modify if needed.
        IF Inp$ = CHR$(0) + CHR$(75) THEN Icol = Icol - 1       'Left arrow
        IF Inp$ = CHR$(0) + CHR$(77) THEN Icol = Icol + 1       'Right arrow
        IF Inp$ = CHR$(8) THEN                                  'Backstep
                IF Icol = Ecol AND CHR$(SCREEN(row, Ecol)) <> " " THEN
                        LOCATE row, Ecol
                        PRINT " "
                        LOCATE row, Ecol
                ELSE
                        IF Icol = col THEN Icol = col + 1
                        LOCATE row, Icol - 1
                        PRINT " "
                        Icol = Icol - 1
                END IF
        END IF
        IF Inp$ = CHR$(0) + CHR$(83) THEN                       'Del
                FOR Del = Icol TO Ecol
                        LOCATE row, Del
                        IF Del = Ecol THEN
                                PRINT " ";
                        ELSE
                                PRINT CHR$(SCREEN(row, (Del + 1)));
                        END IF
                NEXT Del
        END IF
        IF Inp$ = CHR$(0) + CHR$(71) THEN                       'Home
                FOR FirstCh = col TO Ecol
                        IF FirstCh = col THEN Icol = col
                        IF CHR$(SCREEN(row, FirstCh)) <> " " THEN EXIT FOR
                        Icol = FirstCh + 1
                        IF FirstCh = Ecol THEN Icol = col
                NEXT FirstCh
        END IF
        IF Inp$ = CHR$(0) + CHR$(79) THEN                       'End
                FOR LastCh = Ecol TO col STEP -1
                        IF LastCh = Ecol THEN Icol = Ecol
                        IF CHR$(SCREEN(row, LastCh)) <> " " THEN EXIT FOR
                        Icol = LastCh
                NEXT LastCh
        END IF

        IF Icol < col THEN Icol = col
        IF Icol > Ecol THEN Icol = Ecol
      
GOTO StartInput

'Type character
PrintCh:
        IF Icol < col THEN Icol = col
        IF Icol > Ecol THEN Icol = Ecol
        LOCATE row, Icol
        PRINT Inp$;
        IF Icol < Ecol THEN Icol = Icol + 1
GOTO StartInput

InputFinished:
LOCATE , , 0            'Turn off cursorr
FOR Ch = col TO Ecol                            'Write screen output to
        SOutput$ = SOutput$ + CHR$(SCREEN(row, Ch))   'variable 'SOutput$'
NEXT Ch
'Remove spaces before and after input
SOutput$ = LTRIM$(RTRIM$(SOutput$))

END SUB

SUB TunnelMovie (WAY)
SELECT CASE WAY
CASE 1
CLS
FOR col = 10 TO 70
    Delay .01
    lct = (12 - 1) * 160 + ((col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 3, 15
        POKE lct + 2, 2
        POKE lct + 1, 0
        POKE lct, 32
    DEF SEG
    LOCATE 12, col
    IF col = 20 THEN PRINT "Y"
    IF col = 22 THEN PRINT "o"
    IF col = 24 THEN PRINT "u"
    IF col = 28 THEN PRINT "a"
    IF col = 30 THEN PRINT "r"
    IF col = 32 THEN PRINT "e"
    IF col = 36 THEN PRINT "i"
    IF col = 38 THEN PRINT "n"
    IF col = 42 THEN PRINT "t"
    IF col = 44 THEN PRINT "h"
    IF col = 46 THEN PRINT "e"
    IF col = 50 THEN PRINT "t"
    IF col = 52 THEN PRINT "u"
    IF col = 54 THEN PRINT "n"
    IF col = 56 THEN PRINT "n"
    IF col = 58 THEN PRINT "e"
    IF col = 60 THEN PRINT "l"
NEXT col
CASE 0
CLS
FOR col = 70 TO 10 STEP -1
    Delay .01
    lct = 11 * 160 + ((col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 1, 15
        POKE lct, 2
        POKE lct + 3, 0
        POKE lct + 2, 32
    DEF SEG
    LOCATE 12, col + 1
    IF col = 20 THEN PRINT "Y"
    IF col = 22 THEN PRINT "o"
    IF col = 24 THEN PRINT "u"
    IF col = 28 THEN PRINT "a"
    IF col = 30 THEN PRINT "r"
    IF col = 32 THEN PRINT "e"
    IF col = 36 THEN PRINT "i"
    IF col = 38 THEN PRINT "n"
    IF col = 42 THEN PRINT "t"
    IF col = 44 THEN PRINT "h"
    IF col = 46 THEN PRINT "e"
    IF col = 50 THEN PRINT "t"
    IF col = 52 THEN PRINT "u"
    IF col = 54 THEN PRINT "n"
    IF col = 56 THEN PRINT "n"
    IF col = 58 THEN PRINT "e"
    IF col = 60 THEN PRINT "l"
NEXT col
Delay 1
END SELECT
END SUB

SUB Walls (Ban)

IF Ban = 1 THEN WALLSFILE$ = "MAZE.APG"
IF Ban = 2 THEN WALLSFILE$ = "MAZE2.APG"

OPEN WALLSFILE$ FOR INPUT AS #1
FOR format = 1 TO MAXROW
        INPUT #1, partOfFormat$
        formatstring$ = formatstring$ + partOfFormat$
NEXT format
CLOSE #1

FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
                I = I + 1
                area(r, c) = VAL(MID$(formatstring$, I, 1))
                IF Load = TRUE THEN
                ELSE
                    IF area(r, c) = PLAYER THEN pRow = r: pCol = c
                END IF
        NEXT c
NEXT r

END SUB

