'Files:
'   MAP1.MAP            The labyrinth Page 1
'   MAP2.MAP            The labyrinth Page 2
'   MAP3.MAP            The labyrinth Page 3
'   MAP4.MAP            The labyrinth Page 4
'   TRAIN.MAP           The labyrinth Train Part
'   ENEMY.DAT           All Enemies Data
'   DATA.DAT            Game Data
'   BOSS.DAT            All Bosses Data
'   SAVED.GAM           Saved Game
'   MAGIC.CNT           Shows how much you have to use magic to level up
'   FIGHT.CNT           Shows how much you have to use fight and shielding
'                       to level up
'   LEVEL.LST           Level Highscores
'
'(Special Cheats)       See Bottom
'Begin code:

DEFINT A-Z
DECLARE FUNCTION SInput$ (Row, Col, Text$)
DECLARE FUNCTION TestForMapFour ()
DECLARE SUB Box (Row1, Col1, Row2, Col2, Connect, Style, Shadow, FG, BG)
DECLARE SUB Center (Row, Text$)
DECLARE SUB Change ()
DECLARE SUB ChangeName ()
DECLARE SUB ClearDialogBox (n)
DECLARE SUB Counting ()
DECLARE SUB Delay (T#, AbleToQuitSub)
DECLARE SUB DeleteGame ()
DECLARE SUB DestroyLock ()
DECLARE SUB DoBG ()
DECLARE SUB DoEnemies ()
DECLARE SUB DrawArea ()
DECLARE SUB Eat ()
DECLARE SUB FightBoss (Boss)
DECLARE SUB FightEnemy ()
DECLARE SUB GameWin ()
DECLARE SUB GiveAReward (Skill)
DECLARE SUB HandleHouse ()
DECLARE SUB HardMap ()
DECLARE SUB Help ()
DECLARE SUB Info (Track)
DECLARE SUB Introduction ()
DECLARE SUB LevelList ()
DECLARE SUB LevelUp ()
DECLARE SUB LoadGame ()
DECLARE SUB Loads ()
DECLARE SUB Market ()
DECLARE SUB Menu ()
DECLARE SUB Meeting (S)
DECLARE SUB MovePlayer ()
DECLARE SUB MoveToTrain ()
DECLARE SUB NewGame ()
DECLARE SUB OldMansHouse ()
DECLARE SUB Options ()
DECLARE SUB OutOfGame ()
DECLARE SUB PauseMenu ()
DECLARE SUB PickItem ()
DECLARE SUB PlayerDie ()
DECLARE SUB PlayGame (a)
DECLARE SUB Radar ()
DECLARE SUB RecieveItem (Thing)
DECLARE SUB ResetGame ()
DECLARE SUB SaveBG (Restr, Row1, Col1, Row2, Col2, BG())
DECLARE SUB SaveGame ()
DECLARE SUB SeePassword ()
DECLARE SUB SetOutfit ()
DECLARE SUB Setup ()
DECLARE SUB ShowHighDmg ()
DECLARE SUB ShowInfo ()
DECLARE SUB ShowItem ()
DECLARE SUB ShowLevelList ()
DECLARE SUB ShowOther ()
DECLARE SUB SkillsAdvance (Skill$)
DECLARE SUB TunnelMovie (wey)
DECLARE SUB Walls ()
DECLARE SUB WeaponChange ()

'Constants
CONST MAXROW = 24, MAXCOL = 80
CONST WAY = 0, PLAYER = 1, WALL = 2, DOOR = 3, LOCKED.PASS = 4, ENEMY = 5
CONST Item = 6, house = 7, MarketPlace = 8, OldHouse = 9
CONST FALSE = 0, TRUE = 1, PASSED = 1

CONST Item2Row = 2, Item2Col = 79
CONST Item3Row = 18, Item3Col = 31

CONST HouseRow = 3, HouseCol = 62
CONST MarketRow = 2, MarketCol = 69
CONST OldHouseRow = 5, OldHouseCol = 48

'For track 1
CONST CodeRow = 19, CodeCol = 79
CONST ExitDoor1Row = 23, ExitDoor1Col = 1
CONST Door11Row = 12, Door11Col = 31, Door12Row = 22, Door12Col = 16
CONST Key11Row = 6, Key11Col = 75, Key12Row = 11, Key12Col = 13
CONST Door13Row = 23, Door13Col = 78, Door14Row = 22, Door14Col = 79

'For track 2
CONST ExitDoor2Row = 2, ExitDoor2Col = 80
CONST Door21Row = 2, Door21Col = 79, Door22Row = 18, Door22Col = 3
CONST BackDoor2Row = 23, BackDoor2Col = 80
CONST Key21Row = 13, Key21Col = 78, Key22Row = 3, Key22Col = 56

'For track 3
CONST EndDoorRow = 8, EndDoorCol = 4
CONST Door31Row = 3, Door31Col = 2
CONST DoorRow = 4, Door1Col = 2, Door2Col = 3, Door3Col = 4
CONST BackDoor3Row = 2, BackDoor3Col = 1
CONST SecretRow = 23, SecretCol = 59
CONST Key31Row = 23, Key31Col = 79

OPTION BASE 1

'Arrays
DIM SHARED area(0 TO 25, 0 TO 81)
DIM SHARED EnemyData(15) AS STRING, EnemyAttack(15), EnemyDefence(15)
DIM SHARED EnemyMagic(15, 3), EnemyHitPoints(15), EnemyExperience(15)
DIM SHARED EnemyUsen(15, 2), EnemyLevel(15), EnemyMagicPoints(15)
DIM SHARED EnemyArmour(15), EnemyWeapon(15, 16), EnemyWeaponType(15) AS STRING
DIM SHARED EnemyMoney(15), EnemyLoot(15), EnemyLootThing(15) AS STRING
DIM SHARED EnemyLootChance(15)

DIM SHARED BossData(2) AS STRING, BossHitPoints(2) AS LONG, BossAttack(2), BossDefence(2)
DIM SHARED BossExperience(2), BossLevel(2), BossMagicPoints(2), BossArmour(2)
DIM SHARED BossWeapon(2, 3), BossWeaponType(2) AS STRING, BossMoney(2)
DIM SHARED BossMagic(2, 2), BossUsen(2, 2)

DIM SHARED Weapon(6, 7), WeaponType(6) AS STRING
DIM SHARED YouHitPoints(2), YouMagic(2), NeedMagic(2)
DIM SHARED Uses(3) AS STRING, Usen(3)
DIM SHARED PassWor$(15), LevelQual&(100)
DIM SHARED MagicCounter(999, 2), FightCounter(999), ShieldCounter(999)
DIM SHARED MagLevUp(2), MagicCount(2)

DIM SHARED nam$(10), scor(10)  AS LONG, levl(10)
DIM SHARED HighestDamage(5)
DIM SHARED Items(29) AS STRING, Itemn(29), ItemCost(5 TO 9)

DIM SHARED GiveReward(100, 5), RewardCount(5), GiveRewardCount(5)
DIM SHARED Reward(5), RewardName(5) AS STRING, RewardItemn(5), RewardSpecial(5)


'Variables
      
COMMON SHARED YouData$, YouHitPoints, YouDefence, YouAttack
COMMON SHARED YouArmour

COMMON SHARED pRow, pCol, Experience&
COMMON SHARED Key11, Key12, Key21, Key22, Key1, Key31
COMMON SHARED Bana, Load, StillEnemy, MaxUsen
COMMON SHARED u$, D$, r$, l$, enter$, esc$, Money, PassWord$
COMMON SHARED c$, User, HousePass, Code, CodeDropped
COMMON SHARED Mana AS LONG, InHouse, SavErr, DontBg, OnHardMap
COMMON SHARED FightCount, ShieldCount
COMMON SHARED DefLevUp, AtkLevUp, Level, ForNextLevelExp&
COMMON SHARED Increased, Attack, Defence, PlayMovie
COMMON SHARED PlayerColor, DoorColor, ForeGround, DrawAreas
COMMON SHARED PassedTest, AutoAttack, MaxMagic, MaxDefence, MaxAttack
COMMON SHARED Skill AS STRING, CriticalDouble, Critical
COMMON SHARED AmuletRow, AmuletCol, OldHousePass

ON ERROR GOTO ErrorHandler

KEY 15, CHR$(&H0) + CHR$(&H1)
ON KEY(15) GOSUB Pause


'Game
'****************************************************************************'
'           ********                                   ********
'                          **********************
                                    Loads
                                    Menu
'                          **********************
'           ********                                   ********
'****************************************************************************'


Pause:
    PauseMenu
RETURN



ErrorHandler:
SELECT CASE ERR
CASE 53
    CLS
    LOCATE 1, 1: PRINT "En Fil saknas. Installera om programmet eller "
    LOCATE 2, 1: PRINT "starta om programmet i r„tt katalog."
    END
    RESUME
CASE ELSE
    CLS
    LOCATE 1, 1: PRINT "Ett fel har intr„ffat { "; ERR; " }"
    END
    RESUME
END SELECT

SavGame.DatError:
SELECT CASE ERR
CASE 53
    DIM BG(9 TO 11, 25 TO 55, 0 TO 1)
    SaveBG 0, 9, 25, 11, 55, BG()
    Box 9, 25, 11, 55, 0, 1, 1, ForeGround, 0
    LOCATE 10, 29: PRINT "There is no game saved"
    g$ = INPUT$(1)
    SaveBG 1, 9, 25, 11, 55, BG()
    SavErr = TRUE
    OPEN "SAVED.GAM" FOR OUTPUT AS #1
    CLOSE #1
END SELECT
RESUME




'How to get "Magic Sword":
'
'1. Buy a shovel in the shop
'2. Go to row 22 and column 77 in map 3
'3. Now press a big 'D' and you will receive "Magic Sword" which is the most
'   powerful weapon in the game.
'
'How to get "Amulet of Life":
'
'1. Buy a shovel in the shop
'2. Go strange places in the training center. You need to have teleporter
'   first. Then go out side and start dig by pressing a big 'D' everywhere.
'3. Recieve "Amulet of Life".


SUB Box (Row1, Col1, Row2, Col2, Connect, Style, Shadow, FG, BG)

COLOR FG, BG
IF Style THEN
    ConnectLeft$ = "Ì"
    ConnectRight$ = "¹"
    ConnectDown$ = "Ê"
    ConnectUp$ = "Ë"

    UpDown$ = "Í"
    LDCorner$ = "È"
    RDCorner$ = "¼"
    RUCorner$ = "»"
    LUCorner$ = "É"
    LeftRight$ = "º"
ELSE
    ConnectLeft$ = "Ã"
    ConnectRight$ = "´"
    ConnectDown$ = "Á"
    ConnectUp$ = "Â"

    UpDown$ = "Ä"
    LDCorner$ = "À"
    RDCorner$ = "Ù"
    RUCorner$ = "¿"
    LUCorner$ = "Ú"
    LeftRight$ = "³"
END IF

FOR Row = Row1 + 1 TO Row2 - 1
    FOR Col = Col1 + 1 TO Col2 - 1
        LOCATE Row, Col, 0
        PRINT " "
    NEXT Col
NEXT Row

FOR Col = Col1 + 1 TO Col2 - 1
    LOCATE Row1, Col
    PRINT UpDown$
    LOCATE Row2, Col
    PRINT UpDown$
NEXT Col
FOR Row = Row1 + 1 TO Row2 - 1
    LOCATE Row, Col1
    PRINT LeftRight$
    LOCATE Row, Col2
    PRINT LeftRight$
NEXT Row
LOCATE Row1, Col1: PRINT LUCorner$
LOCATE Row1, Col2: PRINT RUCorner$
LOCATE Row2, Col1: PRINT LDCorner$
LOCATE Row2, Col2: PRINT RDCorner$

IF Connect = 2 THEN
    LOCATE Row1, Col1
    PRINT ConnectUp$
    LOCATE Row2, Col1
    PRINT ConnectDown$
ELSEIF Connect = 1 THEN
    LOCATE Row1, Col1
    PRINT ConnectLeft$
    LOCATE Row1, Col2
    PRINT ConnectRight$
END IF

IF Shadow THEN
    DEF SEG = &HB800
    COLOR 8, 0
    offset = Row1 * 160 + (2 * Col2)
    FOR right = (Row1 + 1) TO Row2
        LOCATE right, (Col2 + 1)
        PRINT CHR$(PEEK(offset));
        PRINT CHR$(PEEK(offset + 2))
        offset = offset + 160
    NEXT right
 
    offset = Row2 * 160 + ((Col1 + 1) * 2)
    FOR down = (Col1 + 2) TO (Col2 + 2)
        LOCATE (Row2 + 1), down
        PRINT CHR$(PEEK(offset))
        offset = offset + 2
    NEXT down
    DEF SEG
END IF

COLOR FG, BG
END SUB

SUB Center (Row, Text$)

Col = 40 - INT(LEN(Text$) / 2)
LOCATE Row, Col
PRINT Text$;
END SUB

SUB Change
KEY(15) OFF
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 6, 20, 15, 44, 0, 1, 1, ForeGround, 0

LOCATE 7, 22: PRINT "Oranges"
LOCATE 7, 32: PRINT Usen(1)

LOCATE 8, 22: PRINT "Bananas"
LOCATE 8, 32: PRINT Usen(2)
LOCATE 10, 22: PRINT "Change:"
LOCATE 11, 22: PRINT "(B)ananas to Oranges."
LOCATE 12, 22: PRINT "(O)ranges to Bananas."
DO
    q$ = INKEY$
    IF UCASE$(q$) = "B" THEN
        LOCATE 14, 22: PRINT "How many:"
        n = VAL(SInput$(14, 32, SPACE$(3)))
        IF n <= Usen(2) THEN
            IF Usen(2) > 0 THEN
                Usen(2) = Usen(2) - n
                Usen(1) = Usen(1) + (n * 2)
                IF Usen(1) > MaxUsen THEN
                    n = Usen(1) - MaxUsen
                    FOR e = 1 TO (MaxUsen - 1) STEP 2
                        IF e = n THEN
                            Usen(1) = Usen(1) + 1
                            EXIT FOR
                        END IF
                    NEXT e
                    Usen(1) = Usen(1) - n
                    Usen(2) = Usen(2) + (n \ 2)
                END IF
            END IF
            EXIT DO
        ELSE
            LOCATE 14, 22: PRINT "You can't change that."
        END IF
    ELSEIF UCASE$(q$) = "O" THEN
        LOCATE 14, 22: PRINT "How many:"
        n = VAL(SInput$(14, 32, SPACE$(3)))
        IF n <= Usen(1) THEN
            FOR e = 1 TO (MaxUsen - 1) STEP 2
                IF n = e THEN
                    Usen(1) = Usen(1) + 1
                    EXIT FOR
                END IF
            NEXT e
            IF Usen(1) > 1 THEN
                Usen(1) = Usen(1) - n
                Usen(2) = Usen(2) + (n \ 2)
                IF Usen(2) > MaxUsen THEN
                    n = Usen(2) - MaxUsen
                    Usen(2) = Usen(2) - n
                    Usen(1) = Usen(1) + (n * 2)
                END IF
            END IF
            EXIT DO
        ELSE
            LOCATE 14, 22: PRINT "You can't change that."
        END IF
    ELSEIF q$ = CHR$(32) THEN
        EXIT DO
    END IF
LOOP
SaveBG 1, 1, 1, 24, 80, BG()
LOCATE 8, 44: PRINT Usen(1)
LOCATE 9, 44: PRINT Usen(2)
KEY(15) ON
END SUB

SUB ChangeName

DIM BG(8 TO 12, 27 TO 68, 0 TO 1)
SaveBG 0, 8, 27, 12, 68, BG()

Box 8, 27, 11, 65, 0, 1, 1, ForeGround, BackGround
LOCATE 9, 29: PRINT "Name: " + YouData$
LOCATE 10, 29: PRINT "New Name:"
name$ = SInput$(10, 39, SPACE$(25))
IF LEN(name$) <= 0 THEN
    SaveBG 1, 8, 27, 11, 52, BG()
    EXIT SUB
END IF
YouData$ = name$
SaveBG 1, 8, 27, 12, 68, BG()
END SUB

SUB ClearDialogBox (n)

SELECT CASE n
CASE 1
LOCATE 12, 21: PRINT "             "


LOCATE 14, 21: PRINT "                   "
LOCATE 15, 21: PRINT "                   "
LOCATE 16, 21: PRINT "                   "
LOCATE 17, 21: PRINT "                   "
LOCATE 18, 21: PRINT "                   "
LOCATE 19, 21: PRINT "                   "
LOCATE 20, 21: PRINT "                   "
LOCATE 21, 21: PRINT "                   "

LOCATE 17, 47: PRINT "         "
LOCATE 18, 47: PRINT "             "
LOCATE 19, 47: PRINT "             "

CASE 2
LOCATE 15, 6: PRINT "                                  "
LOCATE 16, 6: PRINT "                                  "
LOCATE 17, 6: PRINT "                                  "
LOCATE 18, 6: PRINT "                                  "
LOCATE 19, 6: PRINT "                                  "
CASE 3

LOCATE 14, 17: PRINT "                            "
LOCATE 15, 17: PRINT "                            "
LOCATE 16, 17: PRINT "                            "
LOCATE 17, 17: PRINT "                            "
LOCATE 18, 17: PRINT "                            "
LOCATE 19, 17: PRINT "                            "

CASE 4      'Old Mans House
LOCATE 11, 7: PRINT "                                 "
LOCATE 12, 7: PRINT "                                 "
LOCATE 13, 7: PRINT "                                 "
LOCATE 14, 7: PRINT "                                 "
LOCATE 15, 7: PRINT "                                 "
LOCATE 16, 7: PRINT "                                 "
LOCATE 17, 7: PRINT "                                 "
LOCATE 18, 7: PRINT "                                 "
LOCATE 19, 7: PRINT "                                 "
END SELECT
END SUB

SUB Counting

'****************************LEVEL COUNTING***********************************

OPEN "LEVEL.PTS" FOR INPUT AS #1
    FOR i = 1 TO 35
        INPUT #1, LevelQual&(i)
    NEXT i
  
    PRINT "Û";

    FOR l = 36 TO 100
        LevelQual&(l) = LevelQual&(l - 1) + 300000
    NEXT l
    ForNextLevelExp& = LevelQual&(Level) - Experience&
  
    PRINT "Û";

CLOSE #1

'*****************************MAGIC COUNTING**********************************

OPEN "MAGIC.CNT" FOR INPUT AS #1
    FOR i = 1 TO 20
        INPUT #1, MagicCounter(i, 1)
        MagicCounter(i, 2) = MagicCounter(i, 1)
    NEXT i
  
    PRINT "Û";

    FOR i = 21 TO 40
        MagicCounter(i, 1) = (MagicCounter(20, 1) + 1)
        MagicCounter(i, 2) = (MagicCounter(20, 2) + 1)
    NEXT i
    FOR i = 41 TO 60
        MagicCounter(i, 1) = (MagicCounter(40, 1) + 1)
        MagicCounter(i, 2) = (MagicCounter(40, 2) + 1)
    NEXT i
    FOR i = 61 TO 999
        MagicCounter(i, 1) = (MagicCounter(60, 1) + 1)
        MagicCounter(i, 2) = (MagicCounter(60, 2) + 1)
    NEXT i
CLOSE #1

'****************************FIGHT COUNTING***********************************

OPEN "FIGHT.CNT" FOR INPUT AS #1
    FOR i = 1 TO 11
        INPUT #1, FightCounter(i)
        ShieldCounter(i) = FightCounter(i)
    NEXT i

    PRINT "Û";
   
    FOR i = 12 TO 999
        FightCounter(i) = (FightCounter(11) + (i - 10) * 3)
        ShieldCounter(i) = (FightCounter(11) + (i - 10) * 3)
    NEXT i
CLOSE #1
                                                       
'**************************REWARD COUNTING************************************


OPEN "REWARD.CNT" FOR INPUT AS #1
    FOR i = 1 TO 10
        INPUT #1, GiveReward(i, 1), GiveReward(i, 2), GiveReward(i, 3), GiveReward(i, 4), GiveReward(i, 5)
    NEXT i
    FOR i = 11 TO 100
        GiveReward(i, 1) = GiveReward(i - 1, 1) + 5
        GiveReward(i, 2) = GiveReward(i - 1, 2) + 100
        GiveReward(i, 3) = GiveReward(i - 1, 3) + 25
        GiveReward(i, 4) = GiveReward(i - 1, 4) + 100
        GiveReward(i, 5) = GiveReward(i - 1, 5) + 100
    NEXT i
    PRINT "Û";
CLOSE #1

OPEN "REWARD.DAT" FOR INPUT AS #1
    FOR i = 1 TO 5
        INPUT #1, Reward(i), RewardName(i), RewardItemn(i), RewardSpecial(i)
    NEXT i
CLOSE #1
END SUB

SUB Delay (T#, AbleToQuitSub)

time# = TIMER + T#
DO
IF AbleToQuitSub THEN
    c$ = INKEY$
    IF c$ <> "" THEN EXIT DO
END IF
LOOP WHILE time# > TIMER
END SUB

SUB DeleteGame

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
Box 9, 25, 11, 55, 0, 1, 1, ForeGround, BackGround

ON ERROR GOTO SavGame.DatError
OPEN "SAVED.GAM" FOR INPUT AS #1
ON ERROR GOTO ErrorHandler
IF SavErr THEN
    CLOSE #1
    SavErr = FALSE
    KILL "SAVED.GAM"
    SaveBG 1, 1, 1, 24, 80, BG()
    EXIT SUB
END IF
CLOSE #1
LOCATE 10, 30: PRINT "Are you sure? (Y/N)"
DO
    keys$ = UCASE$(INPUT$(1))
LOOP UNTIL INSTR("YN", keys$) <> 0
IF keys$ = "Y" THEN
    KILL "SAVED.GAM"
END IF
SaveBG 1, 1, 1, 24, 80, BG()

END SUB

SUB DestroyLock
        DEF SEG = &H40
            POKE &H17, PEEK(&H17) AND (NOT 240)
        DEF SEG
END SUB

SUB DoBG
RANDOMIZE TIMER
FOR Col = 1 TO 80 STEP 5
    FOR Row = 1 TO 24
        FG = INT(15 * RND + 1)
        BG = INT(6 * RND + 1)
        IF FG = BG THEN
            IF FG = 1 THEN FG = BG + 1 ELSE FG = BG - 1
        END IF
        Colour = BG * 16 + FG
        DEF SEG = &HB800
            lct = (Row - 1) * 160 + ((Col - 1) * 2) - 2
            FOR a = lct + 3 TO lct + 11 STEP 2
                POKE a, Colour
            NEXT a
            POKE lct + 2, ASC("S")
            POKE lct + 4, ASC("a")
            POKE lct + 6, ASC("R")
            POKE lct + 8, ASC("p")
            POKE lct + 10, ASC("g")
        DEF SEG
    NEXT Row
NEXT Col

END SUB

SUB DoEnemies
RANDOMIZE TIMER
FOR r = 1 TO 6
    FOR c = 1 TO MAXCOL
        IF area(r, c) = WAY THEN
            rn = INT(RND(1) * 1500 + 1)
            IF rn >= 2 AND rn < 100 THEN
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
            rn = INT(RND(1) * 1500 + 1)
            IF rn >= 2 AND rn < 100 THEN
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
            rn = INT(RND(1) * 1500 + 1)
            IF rn >= 2 AND rn < 100 THEN
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
            rn = INT(RND(1) * 1500 + 1)
            IF rn >= 2 AND rn <= 100 THEN
                area(r, c) = ENEMY
            ELSE
                area(r, c) = WAY
            END IF
        END IF
    NEXT c
NEXT r

IF Bana = 1 THEN
    IF Code = FALSE THEN
        area(CodeRow, CodeCol) = ENEMY
    ELSE
        area(CodeRow, CodeCol) = WAY
    END IF
END IF
IF Bana = 1 AND NOT Itemn(1) THEN area(23, 79) = Item
IF Bana = 2 AND NOT Itemn(4) THEN area(Item3Row, Item3Col) = Item
IF Bana = 3 AND NOT Itemn(2) THEN area(Item2Row, Item2Col) = Item
IF Bana = 4 AND NOT Itemn(10) THEN area(23, 79) = Item
END SUB

SUB DrawArea

CLS
FOR r = 1 TO MAXROW
    FOR c = 1 TO MAXCOL
        COLOR ForeGround, 0
        LOCATE r, c
        IF area(r, c) = WALL THEN
            PRINT "Û"
        ELSEIF area(r, c) = PLAYER THEN
            IF Load = FALSE THEN
                lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
                DEF SEG = &HB800
                    POKE lct + 1, PlayerColor
                    POKE lct, 2
                DEF SEG
            END IF
        ELSEIF area(r, c) = DOOR THEN
            COLOR DoorColor, 0
            PRINT "°"
        ELSEIF area(r, c) = LOCKED.PASS THEN
            COLOR DoorColor, 0
            PRINT "±"
        ELSEIF area(r, c) = house THEN
            PRINT CHR$(127)
        ELSEIF area(r, c) = MarketPlace THEN
            PRINT "º"
        ELSEIF area(r, c) = OldHouse THEN
            PRINT CHR$(127)
        ELSE
            PRINT " "
        END IF
    NEXT
NEXT

IF Bana = 1 THEN
    IF Itemn(1) < 1 THEN
        LOCATE 23, 79: PRINT "¨"
    ELSE
        area(23, 79) = 0
    END IF
ELSEIF Bana = 2 THEN
    IF Itemn(4) < 1 THEN
        LOCATE Item3Row, Item3Col: PRINT "I"
    ELSE
        area(Item3Row, Item3Col) = 0
    END IF
ELSEIF Bana = 3 THEN
    IF Itemn(2) < 1 THEN
        LOCATE Item2Row, Item2Col: PRINT CHR$(24)
    ELSE
        area(Item2Row, Item2Col) = WAY
    END IF
ELSEIF Bana = 4 THEN
    IF Itemn(10) < 1 THEN
        LOCATE 23, 79: PRINT CHR$(15)
    ELSE
        area(23, 79) = WAY
    END IF
END IF
END SUB

SUB Eat
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 6, 30, 14, 50, 0, 1, 1, ForeGround, BackGround
LOCATE 8, 32: PRINT Uses(1)
LOCATE 8, 44: PRINT Usen(1)
LOCATE 9, 32: PRINT Uses(2)
LOCATE 9, 44: PRINT Usen(2)
IF OldHousePass THEN
    LOCATE 10, 32: PRINT Uses(3)
    LOCATE 10, 44: PRINT Usen(3)
END IF
LOCATE 11, 32: PRINT "(C)hange"
DO
    a$ = INKEY$
    IF UCASE$(a$) = "O" THEN
        IF Usen(1) <= 0 THEN
            LOCATE 12, 32: PRINT "You don't have "
            LOCATE 13, 32: PRINT "any Oranges. "
        ELSE
            YouHitPoints(1) = YouHitPoints(1) + 5
            IF YouHitPoints(1) > YouHitPoints(2) THEN
                YouHitPoints(1) = YouHitPoints(2)
            END IF
            Usen(1) = Usen(1) - 1
            SaveBG 1, 1, 1, 24, 80, BG()
            ERASE BG
            LOCATE 8, 24: PRINT USING "#### / ####"; YouHitPoints(1); YouHitPoints(2)
            EXIT SUB
        END IF
    ELSEIF UCASE$(a$) = "B" THEN
        IF Usen(2) <= 0 THEN
            LOCATE 12, 32: PRINT "You don't have "
            LOCATE 13, 32: PRINT "any Bananas. "
        ELSE
            YouHitPoints(1) = YouHitPoints(1) + 10
            IF YouHitPoints(1) > YouHitPoints(2) THEN
                YouHitPoints(1) = YouHitPoints(2)
            END IF
            Usen(2) = Usen(2) - 1
            SaveBG 1, 1, 1, 24, 80, BG()
            ERASE BG
            LOCATE 8, 24: PRINT USING "#### / ####"; YouHitPoints(1); YouHitPoints(2)
            EXIT SUB
        END IF
    ELSEIF UCASE$(a$) = "L" THEN
        IF OldHousePass THEN
            IF Usen(3) <= 0 THEN
                LOCATE 12, 32: PRINT "You don't have "
                LOCATE 13, 32: PRINT "any Lifefluids. "
            ELSE
                YouHitPoints(1) = YouHitPoints(2)
                IF YouHitPoints(1) > YouHitPoints(2) THEN
                    YouHitPoints(1) = YouHitPoints(2)
                END IF
                Usen(3) = Usen(3) - 1
                SaveBG 1, 1, 1, 24, 80, BG()
                ERASE BG
                LOCATE 8, 24: PRINT USING "#### / ####"; YouHitPoints(1); YouHitPoints(2)
                EXIT SUB
            END IF
        END IF
    ELSEIF UCASE$(a$) = "C" THEN
        Change
    END IF
LOOP UNTIL a$ = CHR$(32)
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

SUB FightBoss (Boss)

KEY(15) OFF                         'Put off key 15
DIM BG(4 TO 22, 20 TO 65, 0 TO 1)    'Save Background
SaveBG 0, 4, 20, 22, 65, BG()

Box 4, 20, 11, 40, 0, 1, 1, ForeGround, 0      'V„nster Uppe   EnemyBox
Box 11, 20, 13, 40, 1, 1, 1, ForeGround, 0    'V„nster Mellan ExtraBox
Box 13, 20, 22, 40, 1, 1, 1, ForeGround, 0     'V„nster Nere   DialogBox
Box 4, 45, 20, 65, 0, 1, 1, ForeGround, 0      'H”ger          YouBox

RANDOMIZE TIMER

'Show player info at Bax right
LOCATE 5, 47: PRINT "TYP: " + YouData$
LOCATE 6, 47: PRINT "HP:"; YouHitPoints(1); "/"; YouHitPoints(2); " "
LOCATE 7, 47: PRINT "ATK:"; YouAttack
LOCATE 8, 47: PRINT "DEF:"; YouDefence
LOCATE 9, 47: PRINT "ARM:"; YouArmour
IF Itemn(2) = 1 THEN
    LOCATE 10, 47: PRINT "MG1:"; YouMagic(1)
    LOCATE 11, 47: PRINT "MG2:"; YouMagic(2)
    LOCATE 12, 47: PRINT "MAN:"; Mana
    LOCATE 13, 47: PRINT "EXP:"; Experience&
    LOCATE 14, 47: PRINT "FNL:"; ForNextLevelExp&
    LOCATE 15, 47: PRINT "LEV:"; Level
    LOCATE 16, 47: PRINT "MON:"; Money
ELSE
    LOCATE 10, 47: PRINT "EXP:"; Experience&
    LOCATE 11, 47: PRINT "FNL:"; ForNextLevelExp&
    LOCATE 12, 47: PRINT "LEV:"; Level
    LOCATE 13, 47: PRINT "MON:"; Money
END IF

'Show Enemy info at Box left up
BossHP& = BossHitPoints(Boss)
LOCATE 5, 22: PRINT "TYP: " + BossData(Boss); " "
LOCATE 6, 22: PRINT "HP: ??? / ???"
LOCATE 7, 22: PRINT "ATK: ??"
LOCATE 8, 22: PRINT "DEF: ??"
LOCATE 9, 22: PRINT "MG1: ??"
LOCATE 10, 22: PRINT "MG2: ??"

'Print text at Box left down
IF Boss = 1 THEN
    LOCATE 14, 22: PRINT UCASE$(BossData(Boss)) + ": You"
    LOCATE 15, 22: PRINT "are in trouble"
    LOCATE 16, 22: PRINT "now!"
    LOCATE 17, 22: PRINT UCASE$(YouData$) + ": Let's see!"
ELSEIF Boss = 2 THEN
    LOCATE 14, 22: PRINT UCASE$(BossData(Boss)) + ": So,"
    LOCATE 15, 22: PRINT "You want out? "
    LOCATE 16, 22: PRINT "Hehe, beat me"
    LOCATE 17, 22: PRINT "first!"
END IF

g$ = INPUT$(1)
ClearDialogBox 1
'Start inkey
StartBossInkey:
LOCATE 18, 47: PRINT "(F)ight  "
LOCATE 19, 47: PRINT "(R)un    "
LOCATE 14, 22: PRINT "What do you do?"
Choise$ = INKEY$
IF UCASE$(Choise$) = "F" THEN       'If key = F
    ClearDialogBox 1                 'Clear box left down
FightBossInkey:
    LOCATE 14, 22: PRINT "Make your choise"
    a$ = INKEY$
    LOCATE 18, 47: PRINT "(A)ttack"     'Print Attack
    IF Itemn(2) = 1 THEN                'If you have a Magic wand
        LOCATE 19, 47: PRINT "(M)agic"  'Print Magic
    END IF
  
    'Magic
    IF UCASE$(a$) = "M" THEN            'If Key = M use Magic
        IF Itemn(2) = 0 THEN GOTO FightBossInkey    'If you don't have a magic
                                                'wand then goto fightinkey
        ClearDialogBox 1
        LOCATE 14, 22: PRINT "Make your choise"
        LOCATE 18, 47: PRINT "Fire      (1)"
        LOCATE 19, 47: PRINT "Lightning (2)"
        DO
            SELECT CASE INKEY$
            CASE "1"
                Pressed = TRUE
                MagicChoise = 1
            CASE "2"
                Pressed = TRUE
                MagicChoise = 2
            END SELECT
        LOOP UNTIL Pressed
        Pressed = FALSE
        SELECT CASE MagicChoise
        CASE 1
            Magictmp = Mana
            Magictmp = Magictmp - NeedMagic(1)
            IF Magictmp < 0 THEN
                ClearDialogBox 1
                LOCATE 14, 22: PRINT "You attacked the"
                LOCATE 15, 22: PRINT BossData(Boss) + " with"
                LOCATE 16, 22: PRINT "Fire and failed."
            ELSE
                Mana = Mana - NeedMagic(1)
                LOCATE 11, 51: PRINT Mana; "  "
                Hit = (YouMagic(1)) * INT(RND * 5) - (BossLevel(Boss) * INT(RND * 5 + 1))
                IF Hit <= 0 THEN
                     Hit = 0
                     LOCATE 14, 22: PRINT "You attacked the"
                     LOCATE 15, 22: PRINT BossData(Boss) + " with"
                     LOCATE 16, 22: PRINT "Fire and missed."
                ELSE
                     LOCATE 14, 22: PRINT "You attacked the"
                     LOCATE 15, 22: PRINT BossData(Boss) + " with"
                     LOCATE 16, 22: PRINT "Fire and doing "
                     LOCATE 17, 22: PRINT LTRIM$(STR$(Hit)) + " damage."
                END IF
                BossHP& = BossHP& - Hit
                IF BossHP& <= 0 THEN
                    BossDead = TRUE
                END IF
            END IF
        CASE 2
            Magictmp = Mana
            Magictmp = Magictmp - NeedMagic(2)
            IF Magictmp < 0 THEN
                ClearDialogBox 1
                LOCATE 14, 22: PRINT "You attacked the"
                LOCATE 15, 22: PRINT BossData(Boss) + " with"
                LOCATE 16, 22: PRINT "Lightning and "
                LOCATE 17, 22: PRINT "failed."
            ELSE
                Mana = Mana - NeedMagic(2)
                LOCATE 12, 51: PRINT Mana; "  "
               
                Hit = (YouMagic(2)) * INT(RND * 10 + 1) + Level
               
                IF Hit <= 0 THEN
                     Hit = 0
                     LOCATE 14, 22: PRINT "You attacked the"
                     LOCATE 15, 22: PRINT BossData(Boss) + " with"
                     LOCATE 16, 22: PRINT "Lightning and "
                     LOCATE 17, 22: PRINT "missed."
                ELSE
                     LOCATE 14, 22: PRINT "You attacked the"
                     LOCATE 15, 22: PRINT BossData(Boss) + " with"
                     LOCATE 16, 22: PRINT "Lightning and "
                     LOCATE 17, 22: PRINT "doing " + LTRIM$(STR$(Hit)) + " damage."
                END IF
                BossHP& = BossHP& - Hit
                IF BossHP& <= 0 THEN
                    BossDead = TRUE
                END IF
            END IF
        END SELECT
  
'*****************************************************************************
'*********************************USE ATTACK**********************************
'*****************************************************************************

    ELSEIF UCASE$(a$) = "A" THEN        'If key = A use Attack
        ClearDialogBox 1
        RANDOMIZE TIMER
        Attack = YouAttack
        IF Itemn(12) = TRUE THEN Attack = Attack + YouAttack / 10
        Hit = Attack + INT(RND(1) * Weapon(User, User) + 1) + Level
        ChanceToDouble = INT(RND(1) * 20 + 1)
        ChanceToDoubleAgain = INT(RND(1) * 20 + 1)
        IF ChanceToDouble = 1 THEN
            Hit = Hit * 2
            LOCATE 12, 22: PRINT "Critical!"
            IF ChanceToDoubleAgain = 1 THEN
                Hit = Hit * 2
                LOCATE 12, 22: PRINT "CRITICAL!"
            END IF
        END IF
        Hit = Hit - (BossDefence(Boss) + BossArmour(Boss)) + INT(RND(1) * BossWeapon(Boss, Boss + 1) + 1)

       
        IF Hit < 1 THEN
            Hit = 0
            LOCATE 14, 22: PRINT "You attacked the"
            LOCATE 15, 22: PRINT BossData(Boss) + " with"
            LOCATE 16, 22: PRINT WeaponType(User) + " and"
            LOCATE 17, 22: PRINT "missed."
        ELSE
            LOCATE 14, 22: PRINT "You attacked the"
            LOCATE 15, 22: PRINT BossData(Boss) + " with "
            LOCATE 16, 22: PRINT WeaponType(User) + " and"
            LOCATE 17, 22: PRINT "doing " + LTRIM$(STR$(Hit))
            LOCATE 18, 22: PRINT "damage."
        END IF
        BossHP& = BossHP& - Hit
        IF BossHP& <= 0 THEN
            BossDead = TRUE
        END IF
    ELSE GOTO FightBossInkey                'Else
    END IF
  
    g$ = INPUT$(1)

    IF BossDead = TRUE THEN
        ClearDialogBox 1
        LOCATE 14, 22: PRINT "You have defeated"
        LOCATE 15, 22: PRINT "the " + BossData(Boss) + "."
         
        g$ = INPUT$(1)
        KEY(15) ON
        EXIT SUB
    END IF
     
'*****************************************************************************
'********************************ENEMY ATTACK*********************************
'*****************************************************************************

        RANDOMIZE TIMER
        'Count Hit
        WhatMagic = INT(RND(1) * 10 + 1)
        IF WhatMagic = 10 THEN
            Hit = (BossMagic(Boss, 2)) * INT(RND(1) * 5) + BossLevel(Boss)
        ELSEIF WhatMagic = 8 OR WhatMagic = 9 THEN
            Hit = (BossMagic(Boss, 1)) * INT(RND(1) * 5) + BossLevel(Boss)
        ELSE
            Hit = (BossAttack(Boss)) + INT(RND(1) * BossWeapon(Boss, Boss) + 1)
            Hit = Hit - ((YouDefence + YouArmour) + INT(RND(1) * Weapon(User, User + 1) + 1))
        END IF
       
        IF Hit < 1 THEN
            Hit = 0
            IF WhatMagic > 7 THEN
                LOCATE 18, 22: PRINT BossData(Boss) + " attacks"
                LOCATE 19, 22: PRINT "you with magic and"
                LOCATE 20, 22: PRINT "missed."
            ELSE
                LOCATE 18, 22: PRINT BossData(Boss) + " attacks"
                LOCATE 19, 22: PRINT "you with"
                LOCATE 20, 22: PRINT BossWeaponType$(Boss) + " and"
                LOCATE 21, 22: PRINT "missed."
            END IF
        ELSE
            IF WhatAttack > 7 THEN
                LOCATE 18, 22: PRINT BossData(Boss) + " attacks"
                LOCATE 19, 22: PRINT "you with magic and"
                LOCATE 20, 22: PRINT "doing" + STR$(Hit) + " damage."
            ELSE
                LOCATE 18, 22: PRINT BossData(Boss) + " attacks "
                LOCATE 19, 22: PRINT "you with "
                LOCATE 20, 22: PRINT BossWeaponType$(Boss) + " and"
                LOCATE 21, 22: PRINT "doing" + STR$(Hit) + " damage."
            END IF
        END IF
        YouHitPoints(1) = YouHitPoints(1) - Hit
        IF YouHitPoints(1) <= 0 THEN
            PlayerDie
        ELSE
            LOCATE 6, 50: PRINT YouHitPoints(1); "/"; YouHitPoints(2); " "
            g$ = INPUT$(1)
            ClearDialogBox 1
            GOTO StartBossInkey
        END IF

ELSEIF UCASE$(Choise$) = "R" THEN       'If key = R run away
    ClearDialogBox 1
    LOCATE 14, 22: PRINT UCASE$(BossData(Boss)) + ": You can't"
    LOCATE 15, 22: PRINT "run now!"
    g$ = INPUT$(1)
    ClearDialogBox 1
    GOTO FightBossInkey
ELSE
    GOTO StartBossInkey
END IF

SaveBG 1, 4, 20, 22, 65, BG()
KEY(15) ON                              'Put on key 15
END SUB

SUB FightEnemy

KEY(15) OFF
                                    
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 2, 20, 11, 40, 0, 1, 1, ForeGround, BackGround  'V„nster Uppe   EnemyBox
Box 11, 20, 13, 40, 1, 1, 1, ForeGround, BackGround 'Mellan V„nster ExtraBox
Box 13, 20, 22, 40, 1, 1, 1, ForeGround, BackGround 'V„nster Nere   DialogBox
Box 3, 45, 20, 78, 0, 1, 1, ForeGround, BackGround  'H”ger          YouBox

'************************WHO SHOULD THE PLAYER MEET***************************

RANDOMIZE TIMER
IF Bana = 1 THEN
    EnemyType = INT((RND * 3) + 1)  'Goblin, Berzerker, Soldier
ELSEIF Bana = 2 THEN
    Eneme = INT(RND * 12) + 1
    IF Eneme <= 0 OR Eneme >= 0 AND Eneme < 2 THEN
       EnemyType = 1    'Goblin
    ELSEIF Eneme >= 2 AND Eneme < 7 THEN
       EnemyType = 2    'Berzerker
    ELSEIF Eneme >= 7 AND Eneme < 9 THEN
       EnemyType = 3    'Soldier
    ELSEIF Eneme >= 10 AND Eneme < 13 THEN
       EnemyType = 4    'Mage
    ELSE
       EnemyType = 1    'Goblin
    END IF
ELSEIF Bana = 3 THEN
    EnemyType = INT((RND * 5) + 1)  'Goblin, Mage, Soldier, Berzerker, Warrior
    Eneme = INT((RND * 10) + 1)
    IF Level >= 30 THEN
        IF Eneme >= 1 AND Eneme <= 4 THEN
            EnemyType = Eneme
        ELSEIF Eneme >= 5 AND Eneme <= 7 THEN
            EnemyType = 7           'Dragon
        ELSEIF Eneme = 8 OR Eneme = 9 THEN
            EnemyType = 8           'Knight
        ELSEIF Eneme = 10 THEN
            EnemyType = 9           'Master
        END IF
    ELSEIF Level >= 25 THEN
        IF Eneme >= 1 AND Eneme <= 7 THEN
            EnemyType = INT((RND * 5) + 1)
        ELSEIF Eneme = 8 OR Eneme = 9 THEN
            EnemyType = 7           'Dragon
        ELSEIF Eneme = 10 THEN
            EnemyType = 8           'Knight
        END IF
    ELSEIF Level >= 20 THEN
        IF Eneme >= 1 AND Eneme <= 9 THEN
            EnemyType = INT((RND * 5) + 1)
        ELSE
            EnemyType = 7           'Dragon
        END IF
    END IF
ELSEIF Bana = 4 THEN
    Eneme = INT((RND * 12) + 1)
    IF Eneme >= 1 AND Eneme <= 5 THEN
        EnemyType = 7               'Dragon
    ELSEIF Eneme >= 6 AND Eneme <= 9 THEN
        EnemyType = 8               'Knight
    ELSEIF Eneme >= 10 AND Eneme <= 12 THEN
        EnemyType = 9               'Master
    END IF
ELSEIF Bana = 5 THEN
    EnemyType = 6                   'Trainer
ELSEIF Bana = 6 THEN
    IF YouAttack > 900 OR YouDefence > 900 THEN
        Eneme = INT((RND * 4) + 1)
    ELSE
        Eneme = INT((RND * 3) + 1)
    END IF
    IF Eneme = 1 THEN
        EnemyType = 11
    ELSEIF Eneme = 4 THEN
        EnemyType = 12
    ELSE
        EnemyType = 10
    END IF
END IF

'*****************************************************************************

'**************************PRINT THE PLAYERS INFO*****************************

LOCATE 4, 47: PRINT YouData$
LOCATE 5, 47: PRINT "------------------------------"

LOCATE 6, 47: PRINT "Hitpoints:"
LOCATE 6, 59: PRINT USING "#### / ####"; YouHitPoints(1); YouHitPoints(2)

LOCATE 7, 47: PRINT "Attack:"
    LOCATE 7, 67: PRINT USING "###"; YouAttack
LOCATE 8, 47: PRINT "Defence:"
    LOCATE 8, 67: PRINT USING "###"; YouDefence
LOCATE 9, 47: PRINT "Armour:"
    LOCATE 9, 68: PRINT USING "##"; YouArmour

IF Itemn(2) = 1 THEN                'IF THE PLAYER HAVE A MAGIC WAND
    LOCATE 10, 47: PRINT "Magic Fire:"
        LOCATE 10, 67: PRINT USING "###"; YouMagic(1)

    LOCATE 11, 47: PRINT "Magic Lightning:"
        LOCATE 11, 67: PRINT USING "###"; YouMagic(2)

    LOCATE 12, 47: PRINT "Mana:"
        LOCATE 12, 65: PRINT USING "#####"; Mana

    LOCATE 13, 47: PRINT "Experience:"
        LOCATE 13, 62: PRINT USING "########"; Experience&

    LOCATE 14, 47: PRINT "For Next Level:"
        LOCATE 14, 62: PRINT USING "########"; ForNextLevelExp&

    LOCATE 15, 47: PRINT "Level:"
        LOCATE 15, 67: PRINT USING "###"; Level

    LOCATE 16, 47: PRINT "Money:"
        LOCATE 16, 65: PRINT USING "#####"; Money

ELSE                                'IF THE PLAYER DONT HAVE A MAGIC WAND
    LOCATE 10, 47: PRINT "Experience:"
        LOCATE 10, 62: PRINT USING "########"; Experience&

    LOCATE 11, 47: PRINT "For Next Level:"
        LOCATE 11, 62: PRINT USING "########"; ForNextLevelExp&

    LOCATE 12, 47: PRINT "Level:"
        LOCATE 12, 67: PRINT USING "###"; Level

    LOCATE 13, 47: PRINT "Money:"
        LOCATE 13, 65: PRINT USING "#####"; Money
END IF

'*****************************************************************************

'*****************************PRINT THE ENEMYS INFO***************************

EnemyHP = 0
EnemyHP = EnemyHitPoints(EnemyType)
LOCATE 3, 22: PRINT "TYP: " + EnemyData(EnemyType); " "
LOCATE 4, 22: PRINT "HP:"; EnemyHP; "/"; EnemyHitPoints(EnemyType); " "
LOCATE 5, 22: PRINT "ATK:"; EnemyAttack(EnemyType); " "
LOCATE 6, 22: PRINT "DEF:"; EnemyDefence(EnemyType); " "
LOCATE 7, 22: PRINT "ARM:"; EnemyArmour(EnemyType); " "
IF EnemyType = 4 OR EnemyType = 7 OR EnemyType = 9 THEN
    LOCATE 8, 22: PRINT "MG1:"; EnemyMagic(EnemyType, 1); " "
    LOCATE 9, 22: PRINT "MG2:"; EnemyMagic(EnemyType, 2); " "
    LOCATE 10, 22: PRINT "EXP:"; EnemyExperience(EnemyType); " "
ELSE
    LOCATE 8, 22: PRINT "EXP:"; EnemyExperience(EnemyType); " "
END IF

'*****************************************************************************

'MESSAGE TO PLAYER
LOCATE 14, 22: PRINT "Look out! a"
LOCATE 15, 22: PRINT EnemyData(EnemyType) + " attacks "
LOCATE 16, 22: PRINT "you."


'ASK PLAYER WHAT TO DO
startinkey:
LOCATE 18, 47: PRINT "(F)ight  "
LOCATE 19, 47: PRINT "(R)un    "
IF Startfight = TRUE THEN
    LOCATE 14, 22: PRINT "What do you do?"
ELSE
    LOCATE 17, 22: PRINT "What do you do?"
END IF

Choise$ = INKEY$

IF UCASE$(Choise$) = "F" THEN       'IF THE PLAYER CHOOSED TO FIGHT THEN...



'*****************************************************************************
'**********************************FIGHT**************************************
'*****************************************************************************
  


    ClearDialogBox 1                 'CLEAR BOX DOWN LEFT
fightinkey:
    LOCATE 14, 22: PRINT "Make your choise"
    a$ = INKEY$
    LOCATE 18, 47: PRINT "(A)ttack"
    IF Itemn(2) = 1 THEN                'IF YOU HAVE A MAGIC WAND
        LOCATE 19, 47: PRINT "(M)agic"
    END IF
  
    IF AutoAttack THEN
        a$ = "A"
        Delay .01, 0
    END IF


'*****************************************************************************
'*******************************USE MAGIC*************************************
'***************************************************************************** 



    IF UCASE$(a$) = "M" THEN            'If Key = M use Magic
        Startfight = TRUE
        IF Itemn(2) = 0 THEN GOTO fightinkey    'IF YOU DON'T HAVE A MAGIC
                                                'WAND YOU CAN'T USE MAGIC!
        ClearDialogBox 1
        LOCATE 14, 22: PRINT "Make your choise"
        LOCATE 18, 47: PRINT "Fire      (1)"
        LOCATE 19, 47: PRINT "Lightning (2)"
        DO
            SELECT CASE INKEY$
                CASE "1"
                    Pressed = TRUE
                    MagicChoise = 1
                CASE "2"
                    Pressed = TRUE
                    MagicChoise = 2
            END SELECT
        LOOP UNTIL Pressed
        Pressed = FALSE
       
       
        SELECT CASE MagicChoise
           

'***************************USE MAGIC NO. 1***********************************


            CASE 1
                Magictmp = Mana
                Magictmp = Magictmp - NeedMagic(1)
                IF Magictmp < 0 THEN
                    ClearDialogBox 1
                    LOCATE 14, 22: PRINT "You attacked the"
                    LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with"
                    LOCATE 16, 22: PRINT "Fire and failed."
                ELSE
                    Mana = Mana - NeedMagic(1)
                    LOCATE 12, 65: PRINT USING "#####"; Mana
                   
                    Hit = (YouMagic(1)) * INT(RND * 5 + 1) + Level
                    Hit = Hit - EnemyLevel(EnemyType)


'                   *** GET REDUCE OR BONUS ON MAGIC ATTACK ***
                    RANDOMIZE TIMER
                    HitPlusMinus = INT(RND * 2 + 1)
                    IF HitPlusMinus = 1 THEN
                        HitMinus = INT(RND * EnemyLevel(EnemyType) + 1)
                        Hit = Hit - HitMinus
                    ELSEIF HitPlusMinus = 2 THEN
                        HitPlus = INT(RND * Level + 1)
                        Hit = Hit + HitPlus
                    END IF

                    IF Hit > HighestDamage(2) THEN HighestDamage(2) = Hit
                   
                    IF Hit <= 0 THEN
                        LOCATE 14, 22: PRINT "You attacked the"
                        LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with"
                        LOCATE 16, 22: PRINT "Fire and missed."
                    ELSE
                        LOCATE 14, 22: PRINT "You attacked the"
                        LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with"
                        LOCATE 16, 22: PRINT "Fire and doing "
                        LOCATE 17, 22: PRINT LTRIM$(STR$(Hit)) + " damage."
'********************************MAGIC ADVANCE!*******************************                      
                        MagicCount(1) = MagicCount(1) + 1
                        IF MagicCount(1) >= MagicCounter(MagLevUp(1), 1) THEN
                            SkillsAdvance ("Fire")
                        END IF
'*****************************************************************************                      
                        EnemyHP = EnemyHP - Hit
                        IF EnemyHP <= 0 THEN
                            EnemyDead = TRUE
                            IF EnemyType = 6 THEN
                                EnemyHP = EnemyHP + 3500
                                EnemyDead = FALSE
                                GOTO NotDeadByMagic1
                            END IF
                        ELSE
NotDeadByMagic1:
                            LOCATE 4, 25: PRINT EnemyHP; "/"; EnemyHitPoints(EnemyType); " "
                        END IF
                    END IF
                END IF
'*****************************************************************************         


'*********************************USE MAGIC NO. 2*****************************
           
           
            CASE 2
                Magictmp = Mana
                Magictmp = Magictmp - NeedMagic(2)
                IF Magictmp < 0 THEN
                    ClearDialogBox 1
                    LOCATE 14, 22: PRINT "You attacked the"
                    LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with"
                    LOCATE 16, 22: PRINT "Lightning and "
                    LOCATE 17, 22: PRINT "failed."
                ELSE
                    Mana = Mana - NeedMagic(2)
                    LOCATE 12, 65: PRINT USING "#####"; Mana
                   
                    Hit = (YouMagic(2)) * INT(RND * 10 + 1) + Level
                    Hit = Hit - EnemyLevel(EnemyType)

'                   *** GET REDUCE OR BONUS ON MAGIC ATTACK ***
                    RANDOMIZE TIMER
                    HitPlusMinus = INT(RND * 2 + 1)
                    IF HitPlusMinus = 1 THEN
                        HitMinus = INT(RND * EnemyLevel(EnemyType) + 1)
                        Hit = Hit - HitMinus
                    ELSEIF HitPlusMinus = 2 THEN
                        HitPlus = INT(RND * Level + 1)
                        Hit = Hit + HitPlus
                    END IF
                   
                    IF Hit > HighestDamage(3) THEN HighestDamage(3) = Hit
                    IF Hit <= 0 THEN
                        LOCATE 14, 22: PRINT "You attacked the"
                        LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with"
                        LOCATE 16, 22: PRINT "Lightning and "
                        LOCATE 17, 22: PRINT "missed."
                    ELSE
                        LOCATE 14, 22: PRINT "You attacked the"
                        LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with"
                        LOCATE 16, 22: PRINT "Lightning and "
                        LOCATE 17, 22: PRINT "doing " + LTRIM$(STR$(Hit)) + " damage."

'****************************MAGIC ADVANCE!***********************************                     
                        MagicCount(2) = MagicCount(2) + 1
                        IF MagicCount(2) >= MagicCounter(MagLevUp(2), 2) THEN
                            SkillsAdvance ("Lightning")
                        END IF
'*****************************************************************************                      
                        EnemyHP = EnemyHP - Hit
                        IF EnemyHP <= 0 THEN
                            EnemyDead = TRUE
                            IF EnemyType = 6 THEN
                                EnemyHP = EnemyHP + 3000
                                EnemyDead = FALSE
                                GOTO NotDeadByMagic2
                            END IF
                        ELSE
NotDeadByMagic2:                     
                            LOCATE 4, 25: PRINT EnemyHP; "/"; EnemyHitPoints(EnemyType); " "
                        END IF
                    END IF
                END IF
        END SELECT
'***************************************************************************** 


'*****************************************************************************
'********************************USE ATTACK***********************************
'*****************************************************************************



    ELSEIF UCASE$(a$) = "A" THEN
        Startfight = TRUE
        ClearDialogBox 1
        RANDOMIZE TIMER
       
'                              ***COUNT HIT***
        Attack = YouAttack
        IF Itemn(12) = TRUE THEN Attack = Attack + YouAttack / 10
        Hit = Attack + INT(RND(1) * Weapon(User, User) + 1) + Level
        Hit = Hit - (EnemyDefence(EnemyType) + EnemyArmour(EnemyType)) + INT(RND(1) * EnemyWeapon(EnemyType, EnemyType + 1) + 1)
        RANDOMIZE TIMER
'                              ***************         
       
'          ***IF PLAYER SHOULD HAVE BONUS OR DEDUCTION ON ATTACK***
       
        PlusOrMinusOnAtk = INT(RND(1) * 2 + 1)
        IF Itemn(12) = TRUE THEN PlusOrMinusOnAtk = 2
        SELECT CASE PlusOrMinusOnAtk
            CASE 1
                RANDOMIZE TIMER
                MinusOnAtk = INT(RND(1) * 10 + 1)
                Hit = Hit - MinusOnAtk
            CASE 2
                RANDOMIZE TIMER
                PlusOnAtk = INT(RND(1) * 10 + 1)
                Hit = Hit + PlusOnAtk
        END SELECT
'           ************************************************      
       
'  ******************* CRITICAL ??? *************************      
        ChanceToDouble = INT(RND(1) * 20 + 1)
        ChanceToDoubleAgain = INT(RND(1) * 20 + 1)
        IF NOT EnemyType = 6 THEN
            IF ChanceToDouble = 1 THEN
                Hit = Hit * 2
                LOCATE 12, 22: PRINT "Critical!"
                IF ChanceToDoubleAgain = 1 THEN
                    Hit = Hit * 2
                    LOCATE 12, 22: PRINT "CRITICAL!"
                    CriticalDouble = CriticalDouble + 1
                    IF Hit > HighestDamage(5) THEN HighestDamage(5) = Hit
                   
                    IF CriticalDouble >= GiveReward(RewardCount(3), 3) THEN GiveAReward 3
                ELSE
                    Critical = Critical + 1
                    IF Hit > HighestDamage(4) THEN HighestDamage(4) = Hit
                   
                    IF Critical >= GiveReward(RewardCount(2), 2) THEN GiveAReward 2
                END IF
            END IF
        END IF
       
        IF ChanceToDouble <> 1 THEN
            IF Hit > HighestDamage(1) THEN HighestDamage(1) = Hit
        END IF

'*****************************************************************************
'                       ***PRINT THE HIT***      
        IF EnemyType = 6 THEN Hit = 1
        IF Hit <= 0 THEN
            LOCATE 14, 22: PRINT "You attacked the"
            LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with"
            IF LEN(WeaponType(User)) > 7 THEN
                LOCATE 16, 22: PRINT WeaponType(User) + " and"
                LOCATE 17, 22: PRINT "missed."
            ELSE
                LOCATE 16, 22: PRINT WeaponType(User) + " and missed."
            END IF
        ELSE
            'Print damage and info
PrintAttack:
            LOCATE 14, 22: PRINT "You attacked the"
            LOCATE 15, 22: PRINT EnemyData(EnemyType) + " with "
            IF LEN(WeaponType(User)) >= 7 THEN
                LOCATE 16, 22: PRINT WeaponType(User) + " and"
                LOCATE 17, 22: PRINT "doing " + LTRIM$(STR$(Hit)) + " damage."
            ELSE
                LOCATE 16, 22: PRINT WeaponType(User) + " and doing"
                LOCATE 17, 22: PRINT LTRIM$(STR$(Hit)) + " damage."
            END IF
           
            EnemyHP = EnemyHP - Hit
'                       ********************************     


'********************************FIGHTING ADVANCE*****************************        


            FightCount = FightCount + 1
            IF FightCount >= FightCounter(AtkLevUp) THEN
                SkillsAdvance ("Fighting")
           
            END IF

'*****************************************************************************
           
            IF EnemyHP <= 0 THEN
                EnemyDead = TRUE
            ELSE
NotDeadByAttack:
                LOCATE 4, 25: PRINT EnemyHP; "/"; EnemyHitPoints(EnemyType); "  "
            END IF
        END IF
    ELSE GOTO fightinkey                  'GOTO FIGHTINKEY IF NO KEY IS PRESSED
    END IF
    IF AutoAttack = FALSE THEN
        g$ = INPUT$(1)
    END IF

'*****************************************************************************
'*************************** THE ENEMY IS DEAD! ******************************
'*****************************************************************************

    IF EnemyDead = TRUE THEN              'CHECK IF THE ENEMY IS DEAD
        ClearDialogBox 1
        LOCATE 14, 22: PRINT "You have defeated"
        LOCATE 15, 22: PRINT "the " + EnemyData(EnemyType) + "."
        
'                   ***IF THE ENEMY DROPPED SOMETHING***
        RANDOMIZE TIMER
        IfDropMoney = INT(2 * RND + 1)
        IfDrop = INT(4 * RND + 1)
        IF EnemyLoot(EnemyType) = TRUE THEN
            IfDropItem = INT(EnemyLootChance(EnemyType) * RND + 1)
        END IF
        IF IfDrop = 1 THEN
           
            RANDOMIZE TIMER
            IF EnemyUsen(EnemyType, 1) > 1 THEN
                PlusUsen1 = INT(RND * EnemyUsen(EnemyType, 1) + 1)
            ELSE
                PlusUsen1 = EnemyUsen(EnemyType, 1)
            END IF
            IF EnemyUsen(EnemyType, 2) > 1 THEN
                PlusUsen2 = INT(RND * EnemyUsen(EnemyType, 2) + 1)
            ELSE
                PlusUsen2 = EnemyUsen(EnemyType, 2)
            END IF
            Usen(1) = Usen(1) + PlusUsen1
            Usen(2) = Usen(2) + PlusUsen2
            IF Usen(1) > MaxUsen THEN Usen(1) = MaxUsen
            IF Usen(2) > MaxUsen THEN Usen(2) = MaxUsen
           
            IF EnemyUsen(EnemyType, 1) > 0 THEN
                IF EnemyUsen(EnemyType, 2) > 0 THEN
                    LOCATE 16, 22: PRINT "The " + EnemyData(EnemyType)
                    LOCATE 17, 22: PRINT "dropped"; PlusUsen1
                    LOCATE 18, 22: PRINT "orange(s) and"; PlusUsen2
                    LOCATE 19, 22: PRINT "banana(s)."
                ELSE
                    LOCATE 16, 22: PRINT "The " + EnemyData(EnemyType)
                    LOCATE 17, 22: PRINT "dropped"; PlusUsen1
                    LOCATE 18, 22: PRINT "orange(s)."
                END IF
            ELSEIF EnemyUsen(EnemyType, 2) > 0 THEN
                LOCATE 16, 22: PRINT "The " + EnemyData(EnemyType)
                LOCATE 17, 22: PRINT "dropped"; PlusUsen2
                LOCATE 18, 22: PRINT "banana(s)."
            END IF
        END IF
       
        IF EnemyLoot(EnemyType) THEN
            IF IfDropItem = EnemyLootChance(EnemyType) THEN
                
                IF EnemyLootThing(EnemyType) = "Bag of Gold" THEN
                    Money = Money + 1000
                ELSEIF EnemyLootThing(EnemyType) = "Mana Refiller" THEN
                    Mana = Mana + 1000
                    IF Mana > 30000 THEN Mana = 30000

                ELSEIF EnemyLootThing(EnemyType) = "King Zolars Crown" THEN
                    IF Itemn(12) <> 1 THEN
                        Itemn(12) = 1
                    ELSE
                        GOTO CantCarry
                    END IF
                ELSEIF EnemyLootThing(EnemyType) = "Dragon Scale" THEN
                    IF Itemn(14) <> 1 THEN
                        Itemn(14) = 1
                        YouArmour = YouArmour + 50
                    ELSE
                        GOTO CantCarry
                    END IF
                END IF
               
                g$ = INPUT$(1)
                ClearDialogBox 1
                LOCATE 14, 22: PRINT "The " + EnemyData(EnemyType)
                LOCATE 15, 22: PRINT "carried a "
                LOCATE 16, 22: PRINT EnemyLootThing(EnemyType)
                LOCATE 17, 22: PRINT "You take it."
CantCarry:              
            END IF
        END IF
        IF IfDropMoney = 1 THEN
            RANDOMIZE TIMER
              
            PlusMoney = INT(RND * EnemyMoney(EnemyType) + 1)
            Money = Money + PlusMoney
            IF Money > 10000 THEN Money = 10000
        END IF
'                           *************************      
       
'                    ***IF THE ENEMY DROPPED A PASSWORD***
        IF CodeDropped THEN
            IF AutoAttack = FALSE THEN
                g$ = INPUT$(1)
            END IF
            ClearDialogBox 1
            LOCATE 14, 22: PRINT "The " + EnemyData(EnemyType)
            LOCATE 15, 22: PRINT "dropped a"
            LOCATE 16, 22: PRINT "password."
            LOCATE 17, 22: PRINT "The password is:"
            LOCATE 18, 22: PRINT PassWord$
            CodeDropped = FALSE
        END IF
'                   **************************************      
      
'                   ***GIVE PLAYER HIS EXPERIENCE POINTS***

        Experience& = Experience& + EnemyExperience(EnemyType)
        IF Experience& >= LevelQual&(Level) THEN LevelUp
        ForNextLevelExp& = LevelQual&(Level) - Experience&
'                   ***************************************

'                    ***GIVE PLAYER SOME MANA POINTS***   
        RANDOMIZE TIMER
        IF Itemn(2) = 1 THEN Mana = Mana + INT(RND * EnemyMagicPoints(EnemyType) + 1)
        IF Mana > 30000 THEN Mana = 30000

        g$ = INPUT$(1)
        SaveBG 1, 1, 1, 24, 80, BG()
        KEY(15) ON
        EXIT SUB
    END IF
    
'*****************************************************************************

'*****************************************************************************
'*********************************ENEMY ATTACK********************************
'*****************************************************************************    


        RANDOMIZE TIMER
'                   *******COUNT THE HIT FROM THE ENEMY********      
       
        IF EnemyType = 4 OR EnemyType = 7 OR EnemyType > 8 THEN 'IF THE ENEMY IS A MAGE THEN COUNT MAGIC HIT
           
            WhatMagic = INT(RND(1) * 7 + 1)
            IF WhatMagic = 7 THEN
                Hit = (EnemyMagic(EnemyType, 2)) * INT(RND(1) * 5) + EnemyLevel(EnemyType)

'                   *** GET REDUCE OR BONUS ON MAGIC ATTACK ***
                    RANDOMIZE TIMER
                    HitPlusMinus = INT(RND * 2 + 1)
                    IF HitPlusMinus = 1 THEN
                        HitMinus = INT(RND * Level + 1)
                        Hit = Hit - HitMinus
                    ELSEIF HitPlusMinus = 2 THEN
                        HitPlus = INT(RND * EnemyLevel(EnemyType) + 1)
                        Hit = Hit + HitPlus
                    END IF
                  
               
            ELSEIF WhatMagic = 5 OR WhatMagic = 6 THEN
                Hit = (EnemyMagic(EnemyType, 1)) * INT(RND(1) * 5) + EnemyLevel(EnemyType)

'                   *** GET REDUCE OR BONUS ON MAGIC ATTACK ***
                    RANDOMIZE TIMER
                    HitPlusMinus = INT(RND * 2 + 1)
                    IF HitPlusMinus = 1 THEN
                        HitMinus = INT(RND * Level + 1)
                        Hit = Hit - HitMinus
                    ELSEIF HitPlusMinus = 2 THEN
                        HitPlus = INT(RND * EnemyLevel(EnemyType) + 1)
                        Hit = Hit + HitPlus
                    END IF
            ELSE
                GOTO UseWeapon
           
            END IF
       
        ELSE                                'IF THE ENEMY USE A WEAPON...
            RANDOMIZE TIMER
           
'                             ***COUNT HIT***
UseWeapon:
            Defence = YouDefence
            IF Itemn(12) AND EnemyType <> 12 THEN Defence = Defence + (YouDefence / 10)
            Hit = (EnemyAttack(EnemyType)) + INT(RND(1) * EnemyWeapon(EnemyType, EnemyType) + 1)
            Hit = Hit - ((Defence + YouArmour) + INT(RND(1) * Weapon(User, User + 1) + 1))

'                             ***************       

            RANDOMIZE TIMER
           
'          ***IF ENEMY SHOULD HAVE BONUS OR DEDUCTION ON ATTACK***
            PlusOrMinusOnAtk = INT(RND(1) * 2 + 1)
            IF Itemn(12) THEN PlusOrMinusOnAtk = 1
            SELECT CASE PlusOrMinusOnAtk
                CASE 1
                    RANDOMIZE TIMER
                    MinusOnAtk = INT(RND(1) * 30 + 1)
                    Hit = Hit - MinusOnAtk
                CASE 2
                    RANDOMIZE TIMER
                    PlusOnAtk = INT(RND(1) * 30 + 1)
                    Hit = Hit + PlusOnAtk
            END SELECT
'                   ********************************

        END IF
'*****************************************************************************      
        IF EnemyType = 6 THEN Hit = 0
        IF Hit <= 0 THEN
            Hit = 0
            LOCATE 18, 22: PRINT EnemyData(EnemyType) + " attacked"
            LOCATE 19, 22: PRINT "you with "
            LOCATE 20, 22: PRINT EnemyWeaponType(EnemyType) + " and"
            LOCATE 21, 22: PRINT "missed."
            
        ELSE
            IF EnemyType = 4 OR EnemyType = 7 OR EnemyType > 8 THEN
                IF WhatMagic > 7 THEN
                    LOCATE 18, 22: PRINT EnemyData(EnemyType) + " attacked"
                    LOCATE 19, 22: PRINT "you with lightning and"
                    LOCATE 20, 22: PRINT "doing" + STR$(Hit) + " damage."
                ELSEIF WhatMagic = 5 OR WhatMagic = 6 THEN
                    LOCATE 18, 22: PRINT EnemyData(EnemyType) + " attacked"
                    LOCATE 19, 22: PRINT "you with fire and"
                    LOCATE 20, 22: PRINT "doing" + STR$(Hit) + " damage."

                ELSE
                    LOCATE 18, 22: PRINT EnemyData(EnemyType) + " attacked"
                    LOCATE 19, 22: PRINT "you with "
                    LOCATE 20, 22: PRINT EnemyWeaponType(EnemyType) + " and"
                    LOCATE 21, 22: PRINT "doing" + STR$(Hit) + " damage. "
                END IF
            ELSE
                LOCATE 18, 22: PRINT EnemyData(EnemyType) + " attacked"
                LOCATE 19, 22: PRINT "you with "
                LOCATE 20, 22: PRINT EnemyWeaponType(EnemyType) + " and"
                LOCATE 21, 22: PRINT "doing" + STR$(Hit) + " damage."
            END IF
        END IF
       
        YouHitPoints(1) = YouHitPoints(1) - Hit
       
        IF YouHitPoints(1) <= 0 THEN
            PlayerDie               'YOU ARE DEAD!!! HA HA HA HA HA!!!!!!
            YouHitPoints(1) = YouHitPoints(2)
            LOCATE 6, 59: PRINT USING "#### / ####"; YouHitPoints(1); YouHitPoints(2)
            GOTO startinkey
        ELSE
           
'**********************CHECK FOR SHIELDING ADVANCE****************************
           
            ShieldCount = ShieldCount + 1
            IF ShieldCount >= ShieldCounter(DefLevUp) THEN
                SkillsAdvance ("Shielding")
            END IF

'*****************************************************************************       
          
    LOCATE 6, 59: PRINT USING "#### / ####"; YouHitPoints(1); YouHitPoints(2)
            IF AutoAttack = FALSE THEN
                g$ = INPUT$(1)
            END IF
            ClearDialogBox 1
            GOTO startinkey
        END IF
        
'*****************************************************************************
'************************IF PLAYER TRIES TO RUN AWAY**************************
'*****************************************************************************

ELSEIF UCASE$(Choise$) = "R" THEN
    RunAway = (Level * INT(10 * RND + 1)) - (EnemyLevel(EnemyType) * INT(10 * RND + 1))
    IF RunAway < 1 THEN
        ClearDialogBox 1
        LOCATE 14, 22: PRINT "You tryed to run"
        LOCATE 15, 22: PRINT "but the enemy"
        LOCATE 16, 22: PRINT "blocked you."
        g$ = INPUT$(1)
        ClearDialogBox 1
        GOTO fightinkey
    ELSE
        StillEnemy = TRUE
    END IF
ELSE                                    'Else
    GOTO startinkey
END IF

SaveBG 1, 1, 1, 24, 80, BG()
KEY(15) ON                              'Put on key 15
END SUB

SUB GameWin

KEY(15) OFF
COLOR 7, 0
CLS
Box 2, 30, 4, 50, 0, 0, 0, ForeGround, 0
Box 6, 10, 19, 70, 0, 0, 0, ForeGround, 0
LOCATE 7, 12: PRINT "You did it. The new king let the murder be hanged the day "
LOCATE 8, 12: PRINT "after. The king also gave you a BIG reward. All the people"
LOCATE 9, 12: PRINT "was very thankful to you. Now you can rest easy when the"
LOCATE 10, 12: PRINT "bad man is gone... BUT BEWARE OF AN CONTINUE OF THE GAME!"
LOCATE 11, 12: PRINT "HA HA HA HA HA HA HA HA HA HA HA"
DO WHILE INKEY$ = ""
Center 3, "Congratulations"
Center 20, "Press any key..."
Delay .8, 1
IF c$ <> "" THEN EXIT DO
Center 3, "               "
Center 20, "                "
Delay .8, 1
IF c$ <> "" THEN EXIT DO
LOOP
COLOR 14, 0
CLS
ResetGame
Menu

END SUB

SUB GiveAReward (Skill)
DIM BG(24, 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 5, 5, 15, 50, 0, 1, 1, ForeGround, 0

SELECT CASE Skill
CASE 1      '********************* LEVEL ************************
    RewardCount(1) = RewardCount(1) + 1
   
    LOCATE 6, 7: PRINT "Level Reward!"
    LOCATE 7, 7: PRINT "Because you have killed so much you will"
    LOCATE 8, 7: PRINT "recieve:"
   
    IF RewardCount(1) < 5 OR RewardCount(1) > 8 THEN
        LOCATE 9, 12: PRINT RewardName(1)
        IF RewardSpecial(1) = 1 THEN Money = Money + 1000
    ELSEIF RewardCount(1) = 5 THEN
        LOCATE 9, 12: PRINT "Radar 5x5"
        Itemn(15) = 1
    ELSEIF RewardCount(1) = 6 THEN
        LOCATE 9, 12: PRINT "Teleporter"
        Itemn(16) = 1
    ELSEIF RewardCount(1) = 8 THEN
        LOCATE 9, 12: PRINT "Secret Paper"
        g$ = INPUT$(1)
        Box 7, 14, 14, 54, 0, 1, 1, ForeGround, 0
        LOCATE 8, 16: PRINT "You read:"
        LOCATE 9, 16: PRINT "On the fourth track, you will go as"
        LOCATE 10, 16: PRINT "far to the west and as much south as"
        LOCATE 11, 16: PRINT "possible. There, press CTRL+Y and you"
        LOCATE 12, 16: PRINT "Will find a bonus track."
        LOCATE 13, 16: PRINT "(Make sure you save before ;-).)"
    END IF

CASE 2      '******************** Critical! *********************
    RewardCount(2) = RewardCount(2) + 1
    LOCATE 6, 15: PRINT "Critical! Reward!"
    LOCATE 7, 7: PRINT "You will be rewarded for good fighting"
    LOCATE 8, 7: PRINT "and you recieve:"
    LOCATE 9, 12: PRINT RewardName(2)
    IF RewardSpecial(2) = 3 THEN
        YouHitPoints(1) = YouHitPoints(1) + 20
        YouHitPoints(2) = YouHitPoints(2) + 20
        LOCATE 10, 10: PRINT "Hit Points: + 20"
    END IF

CASE 3      '******************** CRITICAL! *********************
    RewardCount(3) = RewardCount(3) + 1
    LOCATE 6, 15: PRINT "CRITICAL! Reward!"
    LOCATE 7, 7: PRINT "You will be rewarded for great fighting"
    LOCATE 8, 7: PRINT "and you recieve:"
    LOCATE 9, 12: PRINT RewardName(3)
    IF RewardSpecial(3) = 4 THEN
        YouHitPoints(1) = YouHitPoints(1) + 50
        YouHitPoints(2) = YouHitPoints(2) + 50
        LOCATE 10, 10: PRINT "Hit Points: + 50"
    END IF

CASE 4      '******************** MAGIC FIRE ********************
    RewardCount(4) = RewardCount(4) + 1
    LOCATE 6, 7: PRINT "Magic Fire Reward!"


CASE 5      '****************** MAGIC LIGHTNING *****************
    RewardCount(5) = RewardCount(5) + 1
    LOCATE 6, 7: PRINT "Magic Lightning Reward!"


END SELECT

g$ = INPUT$(1)
SaveBG 1, 1, 1, 24, 80, BG()
END SUB

SUB HandleHouse
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()


Box 3, 5, 14, 40, 0, 1, 1, ForeGround, 0  'V„nster Uppe
Box 14, 5, 21, 40, 1, 1, 1, ForeGround, 0 'V„nster Nere

Box 3, 43, 5, 71, 0, 1, 1, ForeGround, 0    'H”ger Uppe
Box 6, 43, 22, 65, 0, 1, 1, ForeGround, 0  'H”ger Nere

LOCATE 4, 45: PRINT YouData$
LOCATE 7, 45: PRINT "HP:"; YouHitPoints(1); "/"; YouHitPoints(2); " "
LOCATE 8, 45: PRINT "ATK:"; YouAttack
LOCATE 9, 45: PRINT "DEF:"; YouDefence
LOCATE 10, 45: PRINT "ARM:"; YouArmour
IF Itemn(2) = 1 THEN
    LOCATE 11, 45: PRINT "MG1:"; YouMagic(1)
    LOCATE 12, 45: PRINT "MG2:"; YouMagic(2)
    LOCATE 13, 45: PRINT "MAN:"; Mana
    LOCATE 14, 45: PRINT "EXP:"; Experience&
    LOCATE 15, 45: PRINT "FNL:"; ForNextLevelExp&
    LOCATE 16, 45: PRINT "LEV:"; Level
    LOCATE 17, 45: PRINT "MON:"; Money
ELSE
    LOCATE 11, 45: PRINT "EXP:"; Experience&
    LOCATE 12, 45: PRINT "FNL:"; ForNextLevelExp&
    LOCATE 13, 45: PRINT "LEV:"; Level
    LOCATE 14, 45: PRINT "MON:"; Money
END IF

IF HousePass THEN
    LOCATE 15, 7: PRINT "GUARD: Welcome back,"
    LOCATE 16, 7: PRINT "Sir " + YouData$ + "!"
    g$ = INPUT$(1)
    ClearDialogBox 2
ELSEIF InHouse AND HousePass = FALSE THEN
    LOCATE 15, 7: PRINT "GUARD: Do you have"
    LOCATE 16, 7: PRINT "the password now?"
    g$ = INPUT$(1): GOTO passwordinput
ELSEIF HousePass = FALSE AND InHouse = FALSE THEN
    LOCATE 15, 7: PRINT "GUARD: Who are you?"
    g$ = INPUT$(1)
    LOCATE 16, 7: PRINT UCASE$(YouData$) + ": I am a"
    LOCATE 17, 7: PRINT "soldier to beat the"
    LOCATE 18, 7: PRINT "Bad man who killed"
    LOCATE 19, 7: PRINT "the king."
    g$ = INPUT$(1)
    LOCATE 20, 17: PRINT "GUARD: Is it sure?"
    g$ = INPUT$(1)
    ClearDialogBox 2
    LOCATE 15, 7: PRINT "GUARD: I mean, I don't"
    LOCATE 16, 7: PRINT "like him. In here you"
    LOCATE 17, 7: PRINT "you can find some"
    LOCATE 18, 7: PRINT "good stuffs. I am"
    LOCATE 19, 7: PRINT "sorry but I can't let"
    LOCATE 20, 7: PRINT "you pass if you don't"
    g$ = INPUT$(1)
    ClearDialogBox 2
    LOCATE 15, 7: PRINT "have the right"
    LOCATE 16, 7: PRINT "password."
    g$ = INPUT$(1)

passwordinput:
    LOCATE 19, 45: PRINT "Password:"
    pass$ = SInput$(20, 45, SPACE$(18))
    IF UCASE$(pass$) = UCASE$(PassWord$) THEN
        ClearDialogBox 2
        LOCATE 15, 7: PRINT "Correct Password!"
        LOCATE 16, 7: PRINT "Come on in!"
        LOCATE 19, 45: PRINT "               "
        LOCATE 20, 45: PRINT "                   "
        HousePass = TRUE
        g$ = INPUT$(1)
        GOTO In
    ELSE
        ClearDialogBox 2
        LOCATE 15, 7: PRINT "Incorrect Password!"
        LOCATE 16, 7: PRINT "I'am sorry! go away."
        LOCATE 19, 45: PRINT "               "
        LOCATE 20, 45: PRINT "                   "
        InHouse = TRUE
        g$ = INPUT$(1)
        SaveBG 1, 1, 1, 24, 80, BG()
        ERASE BG
        EXIT SUB
    END IF
END IF

'*****************************************************************************
'*******************************INSIDE THE SHOP*******************************
'*****************************************************************************

In:
ClearDialogBox 2
LOCATE 15, 7: PRINT "EXPEDITE: Well, what"
LOCATE 16, 7: PRINT "do you like to have."
LOCATE 4, 7: PRINT "1 " + Items(5); TAB(35); ItemCost(5)
LOCATE 5, 7: PRINT "2 " + Items(6); TAB(34); ItemCost(6)
LOCATE 6, 7: PRINT "3 " + Items(7); TAB(34); ItemCost(7)
LOCATE 7, 7: PRINT "4 " + Items(8); TAB(33); ItemCost(8)
LOCATE 8, 7: PRINT "5 " + Items(13); TAB(34); ItemCost(9)
LOCATE 9, 7: PRINT "6 " + "Training Area"; TAB(35); "500"
IF Itemn(2) = TRUE THEN
    LOCATE 10, 7: PRINT "7 " + "Mana Refiller"; TAB(35); "500"
    LOCATE 11, 7: PRINT "0 Bye bye!"
ELSE
    LOCATE 10, 7: PRINT "0 Bye bye!"
END IF

DoLoop:
KeyPressed = FALSE
Choise = 0
DO
    SELECT CASE INKEY$
    CASE "0"
        KeyPressed = TRUE
    CASE "1"
        KeyPressed = TRUE
        Choise = 1
    CASE "2"
        KeyPressed = TRUE
        Choise = 2
    CASE "3"
        KeyPressed = TRUE
        Choise = 3
    CASE "4"
        KeyPressed = TRUE
        Choise = 4
    CASE "5"
        KeyPressed = TRUE
        Choise = 5
    CASE "6"
        KeyPressed = TRUE
        Choise = 6
    CASE "7"
        IF Itemn(2) THEN
            KeyPressed = TRUE
            Choise = 7
        END IF
    END SELECT
LOOP UNTIL KeyPressed
ClearDialogBox 2
SELECT CASE Choise
CASE 0
    LOCATE 15, 7: PRINT "EXPEDITE: Ok, Bye bye!"
    Delay 2, 1
CASE 1
IF Itemn(5) = 1 THEN
    LOCATE 15, 7: PRINT "EXPEDITE: You already"
    LOCATE 16, 7: PRINT "have"
    LOCATE 17, 7: PRINT Items(5) + "!"
    GOTO DoLoop
ELSE
    IF Money >= ItemCost(5) THEN
        LOCATE 15, 7: PRINT "EXPEDITE: Ok, "
        LOCATE 16, 7: PRINT Items(5)
        LOCATE 17, 7: PRINT "for 75 gold peices."
        LOCATE 18, 7: PRINT "Anything else?"
        Itemn(5) = Itemn(5) + 1
        Money = Money - ItemCost(5)
        IF Itemn(2) = 1 THEN
            LOCATE 17, 45: PRINT "MON:"; Money
        ELSE
            LOCATE 14, 45: PRINT "MON:"; Money
        END IF
        GOTO DoLoop
    ELSE
        LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
        LOCATE 16, 7: PRINT "you don't have enough"
        LOCATE 17, 7: PRINT "money."
        GOTO DoLoop
    END IF
END IF
CASE 2
IF Itemn(6) = 1 THEN
    LOCATE 15, 7: PRINT "EXPEDITE: You already"
    LOCATE 16, 7: PRINT "have"
    LOCATE 17, 7: PRINT Items(6) + "!"
    GOTO DoLoop
ELSE
    IF Money >= ItemCost(6) THEN
        LOCATE 15, 7: PRINT "EXPEDITE: Ok, "
        LOCATE 16, 7: PRINT Items(6)
        LOCATE 17, 7: PRINT "for 200 gold peices."
        LOCATE 18, 7: PRINT "Anything else?"
        Itemn(6) = Itemn(6) + 1
        YouArmour = YouArmour + 7
        LOCATE 10, 45: PRINT "ARM:"; YouArmour
        Money = Money - ItemCost(6)
        IF Itemn(2) = 1 THEN
            LOCATE 17, 45: PRINT "MON:"; Money
        ELSE
            LOCATE 14, 45: PRINT "MON:"; Money
        END IF
        GOTO DoLoop
    ELSE
        LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
        LOCATE 16, 7: PRINT "you don't have enough"
        LOCATE 17, 7: PRINT "money."
        GOTO DoLoop
    END IF
END IF
CASE 3
IF Itemn(7) = 1 THEN
    LOCATE 15, 7: PRINT "EXPEDITE: You already"
    LOCATE 16, 7: PRINT "have"
    LOCATE 17, 7: PRINT Items(7) + "!"
    GOTO DoLoop
ELSE
    IF Money >= ItemCost(7) THEN
        LOCATE 15, 7: PRINT "EXPEDITE: Ok, "
        LOCATE 16, 7: PRINT Items(7)
        LOCATE 17, 7: PRINT "for 400 gold peices."
        LOCATE 18, 7: PRINT "Anything else?"
        Itemn(7) = Itemn(7) + 1
        YouArmour = YouArmour + 10
        LOCATE 10, 45: PRINT "ARM:"; YouArmour
        Money = Money - ItemCost(7)
        IF Itemn(2) = 1 THEN
            LOCATE 17, 45: PRINT "MON:"; Money
        ELSE
            LOCATE 14, 45: PRINT "MON:"; Money
        END IF
        GOTO DoLoop
    ELSE
        LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
        LOCATE 16, 7: PRINT "you don't have enough"
        LOCATE 17, 7: PRINT "money."
        GOTO DoLoop
    END IF
END IF
CASE 4
IF Itemn(8) = 1 THEN
    LOCATE 15, 7: PRINT "EXPEDITE: You already"
    LOCATE 16, 7: PRINT "have"
    LOCATE 17, 7: PRINT Items(8) + "!"
    GOTO DoLoop
ELSE
    IF Money >= ItemCost(8) THEN
        LOCATE 15, 7: PRINT "EXPEDITE: Ok, "
        LOCATE 16, 7: PRINT Items(8)
        LOCATE 17, 7: PRINT "for 1000 gold peices."
        LOCATE 18, 7: PRINT "Anything else?"
        Itemn(8) = Itemn(8) + 1
        Money = Money - ItemCost(8)
        IF Itemn(2) = 1 THEN
            LOCATE 17, 45: PRINT "MON:"; Money
        ELSE
            LOCATE 14, 45: PRINT "MON:"; Money
        END IF
        GOTO DoLoop
    ELSE
        LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
        LOCATE 16, 7: PRINT "you don't have enough"
        LOCATE 17, 7: PRINT "money."
        GOTO DoLoop
    END IF
END IF

CASE 5
IF Itemn(13) = 1 THEN
    LOCATE 15, 7: PRINT "EXPEDITE: You already"
    LOCATE 16, 7: PRINT "have"
    LOCATE 17, 7: PRINT Items(13) + "!"
    GOTO DoLoop
ELSE
    IF Money >= ItemCost(9) THEN
        LOCATE 15, 7: PRINT "EXPEDITE: Ok, "
        LOCATE 16, 7: PRINT Items(13)
        LOCATE 17, 7: PRINT "for 100 gold peices."
        LOCATE 18, 7: PRINT "Anything else?"
        Itemn(13) = Itemn(13) + 1
        Money = Money - ItemCost(9)
        IF Itemn(2) = 1 THEN
            LOCATE 17, 45: PRINT "MON:"; Money
        ELSE
            LOCATE 14, 45: PRINT "MON:"; Money
        END IF
        GOTO DoLoop
    ELSE
        LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
        LOCATE 16, 7: PRINT "you don't have enough"
        LOCATE 17, 7: PRINT "money."
        GOTO DoLoop
    END IF
END IF

CASE 6
IF Money >= 500 THEN
    Money = Money - 500
    MoveToTrain
ELSE
    LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
    LOCATE 16, 7: PRINT "you don't have enought"
    LOCATE 17, 7: PRINT "money."
    GOTO DoLoop
END IF

CASE 7
IF Money >= 500 THEN
    IF Mana <= 29000 THEN
        LOCATE 15, 7: PRINT "EXPEDITE: Ok, "
        LOCATE 16, 7: PRINT "Mana Refiller"
        LOCATE 17, 7: PRINT "for 100 gold peices."
        LOCATE 18, 7: PRINT "Anything else?"
        Mana = Mana + 1000
        Money = Money - 500
        LOCATE 13, 45: PRINT "MAN:"; Mana; "+1000"
        LOCATE 17, 45: PRINT "MON:"; Money
        g$ = INPUT$(1)
        LOCATE 13, 45: PRINT "MAN:"; Mana; "     "
        GOTO DoLoop
    ELSE
        LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
        LOCATE 16, 7: PRINT "you have too much"
        LOCATE 17, 7: PRINT "mana already to buy"
        LOCATE 18, 7: PRINT "this."
    END IF
ELSE
    LOCATE 15, 7: PRINT "EXPEDITE: Sorry, but"
    LOCATE 16, 7: PRINT "you don't have enought"
    LOCATE 17, 7: PRINT "money."
    GOTO DoLoop
END IF

END SELECT

IF DontBg = FALSE THEN                  'Check on MoveToTrain for more info
    SaveBG 1, 1, 1, 24, 80, BG()
END IF
DontBg = FALSE
END SUB

SUB Help
StartHelp:
esc$ = CHR$(27)
PgDn$ = CHR$(0) + CHR$(81)
PgUp$ = CHR$(0) + CHR$(73)

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Page1:
CLS

Box 1, 1, 24, 80, 0, 0, 0, ForeGround, BackGround
Center 2, "Symbols in SaRpg:"
COLOR PlayerColor
Center 3, CHR$(2) + "                "
COLOR 7
Center 4, CHR$(1) + "                "
COLOR ForeGround, 0
Center 3, " = Player      "
Center 4, " = Enemy       "
Center 5, "¨ = Key          "
COLOR DoorColor, 0
Center 6, "{                "
Center 7, "}                "
Center 9, "°                "
Center 10, "±                "
Center 11, "²                "
COLOR ForeGround, 0
LOCATE 6, 34: PRINT "= Switch on"
LOCATE 7, 34: PRINT "= Switch off"
Center 8, "Û = Wall         "
LOCATE 9, 34: PRINT "= Locked door"
LOCATE 10, 34: PRINT "= Locked door"
LOCATE 11, 34: PRINT "= Unlocked door"
Center 13, "Shorts: "
Center 14, "ATK = Attack/Fighting Skill"
Center 15, "DEF = Defence/Shielding Skill"
Center 16, "HP = Hit Points"
Center 17, "ARM = Armor"
Center 18, "MGn = Magic n"
Center 19, "MAN = Mana"
Center 20, "TYP = Type/Name"
Center 21, "FNL = Experience Points For Next Level"
Center 22, "LEV = Level"
Center 23, "PgDn " + LTRIM$(CHR$(25))
DO
    a$ = INKEY$
    IF a$ = esc$ THEN
        SaveBG 1, 1, 1, 24, 80, BG()
        EXIT SUB
    ELSEIF a$ = PgDn$ THEN
        GOTO Page2
    END IF
LOOP

DIM BG2(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG2()
Page2:
CLS

Box 1, 1, 24, 80, 0, 0, 0, ForeGround, BackGround
Center 2, "InGame Commands:"
Center 3, "Left Arrow = Move Player Left"
Center 4, "Right Arrow = Move Player Right"
Center 5, "Up Arrow = Move Player Up"
Center 6, "Down Arrow = Move Player Down"
Center 7, "Esc = Pause Menu"
Center 8, "Space = Show player info and some extra commands"
Center 9, CHR$(34) + "Y" + CHR$(34) + " = ???"
Center 10, CHR$(34) + "D" + CHR$(34) + " = Dig in the ground"

Center 12, "If you wonder what the shovel do:"
Center 13, "If you are at a place, mostly a corner or a small area, like this:"
Center 14, "ÛÛÛ           Û  Û"
Center 15, "ÛxÛÛÛ   or   ÛxÛÛxÛ"
Center 16, "Û           Ûx     "
Center 17, "ÛÛÛÛÛ        ÛÛÛÛÛÛ"
Center 18, "then press a big " + CHR$(34) + "D" + CHR$(34) + ". If you are lucky, you might find something."
Center 19, "At areas like this can many things be. Like the big " + CHR$(34) + "Y" + CHR$(34) + " might be a "
Center 20, "key to use at such spaces."
Center 23, "PgUp " + LTRIM$(RTRIM$(CHR$(24)))

DO
    a$ = INKEY$
    IF a$ = esc$ THEN
        SaveBG 1, 1, 1, 24, 80, BG()
        EXIT SUB
    ELSEIF a$ = PgUp$ THEN
        GOTO Page1
    END IF
LOOP

END SUB

SUB Info (Track)

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)

SaveBG 0, 1, 1, 24, 80, BG()

Box 1, 1, 24, 80, 0, 1, 0, ForeGround, BackGround

SELECT CASE Track

CASE 1
Center 2, "About the key"
Center 3, "You can use the key to get to the bad man."
Center 4, "By defeating him you will complete the game."
Center 5, "Good luck!"

CASE 2
Center 2, "About the Sword"
Center 3, "The sword is better weapon than the club. You just press"
Center 4, "space and then " + CHR$(34) + "C" + CHR$(34) + ". There you can change to use the sword instead."

CASE 3
Center 2, "About the Magic Wand"
Center 3, "The magic wand will make you be able to use magic."
Center 4, "The magic wand is quite useful because the enemy cant block"
Center 5, "magic."
Center 6, "You can choose to use magic when you have met an enemy."

CASE 4
Center 2, "About the Radar"
Center 3, "The radar will make you see the enemy around you in 1 square."
Center 4, "Very useful if you dont have much hit points and no food."
END SELECT

Center 23, "Press any key..."
g$ = INPUT$(1)

END SUB

SUB Introduction


DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

up$ = CHR$(0) + CHR$(72)
down$ = CHR$(0) + CHR$(80)
esc$ = CHR$(27)

IntroPage1:

Box 1, 1, 24, 80, 0, 0, 0, ForeGround, BackGround

LOCATE 2, 70: PRINT "Part 1"
Center 2, "Introduction to SaRpg"

Center 4, "You start the game by choosing <Play Game> in the menu."
Center 5, "Then you will start on a map. The figure that is you character is the"
Center 6, "figure that looks like this: " + CHR$(2) + ". You can move it in any direction,"
Center 7, "that is empty, just by pressing the arrow keys. These:Û are walls."
Center 8, "You can't move through them."

Center 10, "You will know all the information about your character just by pressing"
Center 11, "the space button. Some boxes will be shown and there you will see some "
Center 12, "commands like <(E)at> and <(C)hange weapon>. Then you eat food by pressing"
Center 13, "<E> and you will change the current weapon by pressing <C>."
Center 14, "Check the help menu to find out what the shortcuts means. They show you"
Center 15, "your attack skill, defence skill, armor, hit points, experience points"
Center 16, "and so on... There may be more commands while you find items."
Center 17, "you close the window by pressing space again."

Center 19, "While you walk around, you will find out that you will meet some strange"
Center 20, "enemies. Like Goblin or Berzerker. You fight them by pressing <A> for "
Center 21, "attack and <R> for run(It is written on the right window, (A)ttack, (R)un)."
Center 23, CHR$(25)
inputkey1:
DO: key$ = INKEY$: LOOP UNTIL key$ <> ""
IF key$ = down$ THEN
    GOTO IntroPage2
ELSEIF key$ = esc$ THEN
    GOTO exitsub
ELSE
    GOTO inputkey1
END IF

IntroPage2:


Box 1, 1, 24, 80, 0, 0, 0, ForeGround, BackGround

LOCATE 2, 70: PRINT "Part 2"
Center 2, "Introduction to SaRpg"
Center 4, "It will be displayed in the window down to the left what has happened. If"  '
Center 5, "If you did any damage to the enemy and if you did, how much damage and if"
Center 6, "you missed. The damage that you took is depending on your attack skills,"
Center 7, "your weapon and the enemys defence skill. And the damage is taken on the"
Center 8, "enemys hit points. When the hit points is down on zero the enemy is dead."
Center 9, "If the enemy isn't dead, he will strike back. The damage is also here "
Center 10, "depending on the enemys attack skill, his weapon and your defence skill."
Center 11, "The fight is over when either the enemy or you are dead. If the enemy is"
Center 12, "dead you will get some experience points. You can't use them but by the "
Center 13, "time you will get much of them and you will get level up. Some of the"
Center 14, "damage that is taken on enemies is depending on the level(but not so much)."
Center 15, "Your max HP(Hit Points) increase when you get a level up. So it is good to "
Center 16, "have lots of level ups. You will also sometimes get food like bananas and"
Center 17, "oranges left in the dead enemys bodies. But only sometimes. You use the "
Center 18, "food to heal yourself when the fight is over. You can't get more HP than"
Center 19, "max. Your info about HP says when you start: 40 / 40. That means: "
Center 20, "Current HP / Max HP. So, you can't get more the 40 HP in the beginning. But"
Center 21, "when you get a level up, you will be able to get more HP."

Center 23, CHR$(24)

inputkey2:
DO: key$ = INKEY$: LOOP UNTIL key$ <> ""
IF key$ = up$ THEN
    GOTO IntroPage1
ELSEIF key$ = esc$ THEN
    GOTO exitsub
ELSE
    GOTO inputkey2
END IF

exitsub:
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

SUB LevelList

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)

OPEN "level.lst" FOR INPUT AS #1
FOR a = 1 TO 10
    INPUT #1, nam$(a), scor(a), levl(a)
NEXT a
CLOSE #1

exppoints& = Experience&

IF exppoints& > scor(10) THEN        'Is experience great enough to reach top 10??

    'Write new highscore file
    OPEN "level.lst" FOR OUTPUT AS #1
    FOR a = 1 TO 10
        IF exppoints& > scor(a) THEN
            WRITE #1, YouData$, exppoints&, Level
            exppoints& = 0
        END IF
        WRITE #1, nam$(a), scor(a), levl(a)
    NEXT a
    CLOSE #1
   
    SaveBG 0, 1, 1, 24, 80, BG()
   
    Box 7, 14, 12, 45, 0, 1, 1, ForeGround, 0
    LOCATE 8, 16: PRINT "You have reached the top 10"
    LOCATE 9, 16: PRINT "in the LEVEL HIGHSCORE list."
    LOCATE 10, 20: PRINT "Show highscores?(Y/N)"
    DO: k$ = UCASE$(INKEY$): LOOP UNTIL k$ = "Y" OR k$ = "N"
    IF k$ = "Y" THEN
        SaveBG 1, 1, 1, 24, 80, BG()
        ShowLevelList
    ELSE
        SaveBG 1, 1, 1, 24, 80, BG()
    END IF
END IF

END SUB

'Count Points To Next Level and Level Up
SUB LevelUp

IF OnHardMap = FALSE THEN
    YouHitPoints(1) = YouHitPoints(1) + 5
    YouHitPoints(2) = YouHitPoints(2) + 5
ELSE
    YouHitPoints(1) = YouHitPoints(1) + 20
    YouHitPoints(2) = YouHitPoints(2) + 20
END IF
Money = Money + 100
Level = Level + 1

IF Level >= GiveReward(RewardCount(1), 1) THEN GiveAReward 1

ForNextLevelExp& = LevelQual&(Level) - Experience&
LOCATE 17, 47: PRINT "Level Up!"
IF Usen(1) < MaxUsen THEN Usen(1) = Usen(1) + 5
IF Usen(1) > MaxUsen THEN Usen(1) = MaxUsen
IF Usen(2) < MaxUsen THEN Usen(2) = Usen(2) + 5
IF Usen(2) > MaxUsen THEN Usen(2) = MaxUsen

LevelList

END SUB

SUB LoadGame
KEY(15) OFF

ON ERROR GOTO SavGame.DatError
OPEN "SAVED.GAM" FOR INPUT AS #1
ON ERROR GOTO ErrorHandler
IF SavErr THEN
    SavErr = FALSE
    CLOSE #1
    KILL "SAVED.GAM"
    EXIT SUB
END IF
DIM BG(9 TO 11, 30 TO 50, 0 TO 1)
SaveBG 0, 9, 30, 11, 50, BG()
Box 9, 30, 11, 51, 0, 1, 1, ForeGround, 0
LOCATE 10, 32: PRINT "Loading";
   
    INPUT #1, pRow, pCol
    INPUT #1, PassWord$, InHouse, HousePass
    INPUT #1, YouAttack, YouDefence, YouHitPoints(1), YouHitPoints(2)
    INPUT #1, YouData$, YouArmour
    INPUT #1, Mana, Money, Experience&, Level, ForNextLevelExp&
    INPUT #1, User, Itemn(1), Itemn(2), Itemn(3), Itemn(4), Itemn(5), Itemn(6)
    Delay .05, 0
    PRINT ".";
    INPUT #1, Itemn(7), Itemn(8), Itemn(9), Itemn(10), Itemn(11), Itemn(12), Itemn(13), Itemn(14), Itemn(15), Itemn(16), Itemn(17), Usen(1), Usen(2), Usen(3)
    INPUT #1, MaxUsen, Increased
    INPUT #1, Code, Load, Key11, Key12, Key21, Key22, Key31, Key1, Bana
    INPUT #1, AtkLevUp, DefLevUp, MagLevUp(1), MagLevUp(2)
    INPUT #1, ShieldCount, FightCount, MagicCount(1), MagicCount(2), YouMagic(1), YouMagic(2)
    INPUT #1, MaxUsen, OnHardMap, PlayMovie, AutoAttack
    INPUT #1, PlayerColor, DoorColor, ForeGround, CriticalDouble, Critical
    INPUT #1, AmuletRow, AmuletCol, OldHousePass
    FOR HDmg = 1 TO 5
        INPUT #1, HighestDamage(HDmg)
    NEXT HDmg
    FOR Rewards = 1 TO 5
        INPUT #1, RewardCount(Rewards)
    NEXT Rewards
    FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
            i = i + 1
            INPUT #1, area(r, c)
            IF i > 180 THEN i = 0: Delay .05, 0: PRINT ".";
        NEXT c
    NEXT r
   
CLOSE #1

CLS
DrawArea
Meeting Bana
PlayGame 1
END SUB

SUB Loads

SCREEN 0
WIDTH 80
COLOR ForeGround, 0
KEY OFF
VIEW PRINT
CLS

DoBG
DIM BG(5 TO 15, 25 TO 51, 0 TO 1)
SaveBG 0, 5, 25, 15, 51, BG()


Box 5, 25, 7, 57, 0, 1, 1, 7, 0
COLOR 3, 0
LOCATE 6, 27: PRINT "Loading Enemies: "
LOCATE 6, 44
OPEN "ENEMY.DAT" FOR INPUT AS #1
    COLOR 1, 0
    FOR i = 1 TO 12
        PRINT "Û";
    NEXT i
    COLOR 14, 0
    LOCATE 6, 44
    FOR e = 1 TO 12
        INPUT #1, EnemyData(e), EnemyHitPoints(e), EnemyAttack(e), EnemyDefence(e), EnemyMagic(e, 1), EnemyMagic(e, 2), EnemyExperience(e), EnemyUsen(e, 1), EnemyUsen(e, 2), EnemyLevel(e), EnemyMagicPoints(e), EnemyArmour(e), EnemyMoney(e),  _
EnemyLoot(e), EnemyLootThing(e), EnemyLootChance(e), Itemn(e)
        PRINT "Û";
    NEXT e
    FOR i = 1 TO 12
        INPUT #1, EnemyWeaponType(i), EnemyWeapon(i, i), EnemyWeapon(i, i + 1)
    NEXT i
CLOSE #1

Box 9, 25, 11, 51, 0, 1, 1, 7, 0
COLOR 3, 0
LOCATE 10, 27: PRINT "Loading Boss:"
LOCATE 10, 44
OPEN "BOSS.DAT" FOR INPUT AS #1
    COLOR 1, 0
    PRINT "Û"; : PRINT "Û";
    COLOR 14, 0
    LOCATE 10, 44
    FOR Bosses = 1 TO 2
        INPUT #1, BossData(Bosses), BossHitPoints(Bosses), BossAttack(Bosses), BossDefence(Bosses), BossMagic(Bosses, 1), BossMagic(Bosses, 2), BossExperience(Bosses), BossUsen(Bosses, 1), BossUsen(Bosses, 2), BossLevel(Bosses), BossMagicPoints( _
Bosses), BossArmour(Bosses), BossMoney(Bosses)
        PRINT "Û";
    NEXT Bosses
    FOR Weapons = 1 TO 2
        INPUT #1, BossWeaponType(Weapons), BossWeapon(Weapons, Weapons), BossWeapon(Weapons, Weapons + 1)
    NEXT Weapons
    CLOSE #1
COLOR 3, 0


Box 13, 21, 15, 56, 0, 1, 1, 7, 0
COLOR 3, 0
LOCATE 14, 23: PRINT "Loading Data: "
LOCATE 14, 40

OPEN "DATA.DAT" FOR INPUT AS #1
    COLOR 1, 0
    FOR i = 1 TO 14
        PRINT "Û";
    NEXT i
    COLOR 14, 0
    LOCATE 14, 40
  
    RANDOMIZE TIMER
    FOR i = 1 TO 15
        INPUT #1, PassWor$(i)
    NEXT i
    PassWord$ = PassWor$(INT(15 * RND + 1))
   
    PRINT "Û";

    INPUT #1, YouAttack
    INPUT #1, YouDefence
    INPUT #1, YouHitPoints(2)
   
    PRINT "Û";

    YouHitPoints(1) = YouHitPoints(2)
    INPUT #1, YouData$
    INPUT #1, YouMagic(1)
    INPUT #1, YouMagic(2)
    INPUT #1, YouArmour
   
    PRINT "Û";

    OPEN "WEAPONS.DAT" FOR INPUT AS #2
        FOR i = 1 TO 6
            INPUT #2, WeaponType(i), Weapon(i, i), Weapon(i, i + 1)
        NEXT i
    CLOSE #2

    INPUT #1, NeedMagic(1)
    INPUT #1, NeedMagic(2)
    INPUT #1, Mana
    INPUT #1, Money
    INPUT #1, Experience&
    INPUT #1, Level
    INPUT #1, MaxUsen
    INPUT #1, User
   
    PRINT "Û";

    FOR i = 1 TO 17
        INPUT #1, Items(i)
    NEXT i
   
    PRINT "Û";

    FOR i = 1 TO 17
        INPUT #1, Itemn(i)
    NEXT i

    PRINT "Û";

    FOR i = 5 TO 9
        INPUT #1, ItemCost(i)
    NEXT i
   
    PRINT "Û";

    INPUT #1, Uses(1)
    INPUT #1, Uses(2)
    INPUT #1, Uses(3)
    INPUT #1, Usen(1)
    INPUT #1, Usen(2)
    INPUT #1, Usen(3)
    INPUT #1, Code
    INPUT #1, Load
    INPUT #1, Key11
   
    PRINT "Û";

    INPUT #1, Key12
    INPUT #1, Key21
    INPUT #1, Key22
    INPUT #1, Key31
    INPUT #1, Key1
    INPUT #1, Bana
    INPUT #1, NxtLvlPtsCount
    INPUT #1, ForeGround
    INPUT #1, DoorColor
    INPUT #1, PlayerColor
    INPUT #1, MaxMagic
    INPUT #1, MaxAttack
    INPUT #1, MaxDefence
   
    PRINT "Û";

    DefLevUp = 1
    AtkLevUp = 1
    MagLevUp(1) = 1
    MagLevUp(2) = 1
    FOR Rewards = 1 TO 5
        RewardCount(Rewards) = 1
    NEXT Rewards
CLOSE #1

Counting


g$ = INPUT$(1)
SaveBG 1, 5, 25, 15, 51, BG()
END SUB

SUB Market

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 3, 10, 12, 45, 0, 1, 1, ForeGround, 0   'V„nster Uppe
Box 13, 15, 20, 45, 1, 1, 1, ForeGround, 0  'V„nster Nere
Box 2, 47, 4, 78, 0, 1, 1, ForeGround, 0    'H”ger Uppe
Box 5, 47, 22, 68, 0, 1, 1, ForeGround, 0   'H”ger Nere

LOCATE 3, 49: PRINT YouData$
LOCATE 6, 49: PRINT "HP:"; YouHitPoints(1); "/"; YouHitPoints(2); " "
LOCATE 7, 49: PRINT "ATK:"; YouAttack
LOCATE 8, 49: PRINT "DEF:"; YouDefence
LOCATE 9, 49: PRINT "ARM:"; YouArmour
IF Itemn(2) = 1 THEN
    LOCATE 10, 49: PRINT "MG1:"; YouMagic(1)
    LOCATE 11, 49: PRINT "MG2:"; YouMagic(2)
    LOCATE 12, 49: PRINT "MAN:"; Mana
    LOCATE 13, 49: PRINT "EXP:"; Experience&
    LOCATE 14, 49: PRINT "FNL:"; ForNextLevelExp&
    LOCATE 15, 49: PRINT "LEV:"; Level
    LOCATE 16, 49: PRINT "MON:"; Money
ELSE
    LOCATE 10, 49: PRINT "EXP:"; Experience&
    LOCATE 11, 49: PRINT "FNL:"; ForNextLevelExp&
    LOCATE 12, 49: PRINT "LEV:"; Level
    LOCATE 13, 49: PRINT "MON:"; Money
END IF

LOCATE 4, 12: PRINT "1 Orange"; TAB(42); "10"
LOCATE 5, 12: PRINT "2 Banana"; TAB(42); "20"
LOCATE 6, 12: PRINT "3 Increase carry capacity   1000"
LOCATE 7, 12: PRINT "4 Leave the market"

LOCATE 14, 17: PRINT "SELLER: Greetings, my "
LOCATE 15, 17: PRINT "friend! Do you come here to"
LOCATE 16, 17: PRINT "buy food? I sell Bananas and"
LOCATE 17, 17: PRINT "Oranges. Best quality!"

PressKey:
DO: key$ = INKEY$: LOOP UNTIL key$ <> ""
SELECT CASE VAL(key$)
CASE 1
    IF Money - 10 < 0 THEN
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: I'm so sorry, but"
        LOCATE 15, 17: PRINT "you can't buy it until you"
        LOCATE 16, 17: PRINT "have enought money."
        GOTO PressKey
    ELSE
        Usen(1) = Usen(1) + 1
        IF Usen(1) > MaxUsen THEN
            Usen(1) = MaxUsen
            ClearDialogBox 3
            LOCATE 14, 17: PRINT "SELLER: I would sell"
            LOCATE 15, 17: PRINT "the Orange to you if you"
            LOCATE 16, 17: PRINT "could carry it.. but you"
            LOCATE 17, 17: PRINT "can't."
            LOCATE 18, 17: PRINT "Want to buy a Banana  "
            LOCATE 19, 17: PRINT "instead?"
            GOTO PressKey
        END IF
        Money = Money - 10
        IF Itemn(2) = 1 THEN
            LOCATE 16, 49: PRINT "MON:"; Money
        ELSE
            LOCATE 13, 49: PRINT "MON:"; Money
        END IF
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: Ok, an Orange."
        LOCATE 15, 17: PRINT "Here you go. Very fresh and"
        LOCATE 16, 17: PRINT "good. 10 gold peices please."
        LOCATE 17, 17: PRINT "... Thank You!"
        LOCATE 18, 17: PRINT "Do you want anything else?"
        GOTO PressKey
    END IF
CASE 2
    IF Money - 20 < 0 THEN
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: I'm so sorry, but"
        LOCATE 15, 17: PRINT "you can't buy it until you"
        LOCATE 16, 17: PRINT "have enought money."
        GOTO PressKey
    ELSE
        Usen(2) = Usen(2) + 1
        IF Usen(2) > MaxUsen THEN
            Usen(2) = MaxUsen
            ClearDialogBox 3
            LOCATE 14, 17: PRINT "SELLER: I would sell"
            LOCATE 15, 17: PRINT "the banana to you if you"
            LOCATE 16, 17: PRINT "could carry it.. but you"
            LOCATE 17, 17: PRINT "can't."
            LOCATE 18, 17: PRINT "Want to buy an Orange "
            LOCATE 19, 17: PRINT "instead?"
            GOTO PressKey
        END IF
        Money = Money - 20
        IF Itemn(2) = 1 THEN
            LOCATE 16, 49: PRINT "MON:"; Money
        ELSE
            LOCATE 13, 49: PRINT "MON:"; Money
        END IF
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: Ok, a Banana."
        LOCATE 15, 17: PRINT "Here you go. Very fresh and"
        LOCATE 16, 17: PRINT "good. 20 gold peices please."
        LOCATE 17, 17: PRINT "... Thank You!"
        LOCATE 18, 17: PRINT "Do you want anything else?"
        GOTO PressKey
    END IF
CASE 3
    IF Increased = TRUE THEN
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: But... you have"
        LOCATE 15, 17: PRINT "increased your capacity."
        LOCATE 16, 17: PRINT "I can't increase it more."
        LOCATE 17, 17: PRINT "But you maybe want "
        LOCATE 18, 17: PRINT "something else?"
        GOTO PressKey
    END IF
    IF Money - 1000 < 0 THEN
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: I'm so sorry, but"
        LOCATE 15, 17: PRINT "you can't buy it until you"
        LOCATE 16, 17: PRINT "have enought money."
        GOTO PressKey
    ELSE
        Money = Money - 1000
        IF Itemn(2) = 1 THEN
            LOCATE 16, 49: PRINT "MON:"; Money
        ELSE
            LOCATE 13, 49: PRINT "MON:"; Money
        END IF
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: Aah.. you want me to"
        LOCATE 15, 17: PRINT "increase your carry"
        LOCATE 16, 17: PRINT "capacity? Ok. Give me 1000"
        LOCATE 17, 17: PRINT "gold peacies then..."
        LOCATE 19, 17: PRINT "Thank You! ...(Press a key)"
        g$ = INPUT$(1)
        ClearDialogBox 3
        LOCATE 14, 17: PRINT "SELLER: Done! Now you can "
        LOCATE 15, 17: PRINT "carry 200 of each fruit"
        LOCATE 16, 17: PRINT "instead of 100."
        LOCATE 17, 17: PRINT "Do you want anything else?"
        MaxUsen = 200
        Increased = TRUE
        GOTO PressKey
    END IF
CASE 4
    ClearDialogBox 3
    LOCATE 14, 17: PRINT "SELLER: Ok, thank you"
    LOCATE 15, 17: PRINT "for visiting. You're"
    LOCATE 16, 17: PRINT "welcome back!"
    LOCATE 17, 17: PRINT "Bye bye."
    Delay 3, 1
CASE ELSE
    GOTO PressKey
END SELECT
SaveBG 1, 1, 1, 24, 80, BG()

END SUB

SUB Meeting (Bana)

'Type in 10 PgDn to go to CASE 2

IF area(Key11Row, Key11Col) = ENEMY THEN area(Key11Row, Key11Col) = WAY
IF area(Key12Row, Key12Col) = ENEMY THEN area(Key12Row, Key12Col) = WAY

IF area(Key21Row, Key21Col) = ENEMY THEN area(Key21Row, Key21Col) = WAY
IF area(Key22Row, Key22Col) = ENEMY THEN area(Key22Row, Key22Col) = WAY

SELECT CASE Bana
CASE 1
IF Key11 = PASSED AND Key12 = PASSED AND Key21 = PASSED AND Key22 = PASSED AND Key31 = PASSED THEN
    area(SecretRow, SecretCol) = 0
    lct = (SecretRow - 1) * 160 + ((SecretCol - 1) * 2)
    IF pRow = SecretRow AND pCol = SecretCol THEN
        Key1 = PASSED
        DEF SEG = &HB800
            POKE lct + 1, PlayerColor
            POKE lct, 2
        DEF SEG
    ELSE
        DEF SEG = &HB800
            POKE lct + 1, ForeGround
            POKE lct, 4
        DEF SEG
    END IF
END IF


IF Key11 = PASSED THEN
    area(Door11Row, Door11Col) = 0
END IF
IF Key12 = PASSED THEN
    area(Door12Row, Door12Col) = 0
END IF
IF pRow = Key11Row AND pCol = Key11Col THEN area(12, 31) = 0: Key11 = PASSED
IF pRow = Key12Row AND pCol = Key12Col THEN area(22, 16) = 0: Key12 = PASSED

IF Key1 = PASSED THEN
    area(Door13Row, Door13Col) = 0
    area(Door14Row, Door14Col) = 0
    IF pRow = Door13Row AND pCol = Door13Col THEN
        lct = (Door13Row - 1) * 160 + ((Door13Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, PlayerColor
            POKE lct, 2
        DEF SEG
        lct = (Door14Row - 1) * 160 + ((Door14Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
    ELSEIF pRow = Door14Row AND pCol = Door14Col THEN
        lct = (Door13Row - 1) * 160 + ((Door13Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
        lct = (Door14Row - 1) * 160 + ((Door14Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, PlayerColor
            POKE lct, 2
        DEF SEG
    ELSE
        lct = (Door13Row - 1) * 160 + ((Door13Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
        lct = (Door14Row - 1) * 160 + ((Door14Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
    END IF
ELSE
    lct = (Door13Row - 1) * 160 + ((Door13Col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 177
    DEF SEG
    lct = (Door14Row - 1) * 160 + ((Door14Col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 177
    DEF SEG
END IF
IF Key11 = NOT PASSED THEN
        lct = (Key11Row - 1) * 160 + ((Key11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 125
        DEF SEG
        lct = (Door11Row - 1) * 160 + ((Door11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Key11Row AND pCol = Key11Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, PlayerColor
            POKE lct, 2
        DEF SEG
        lct = (Door11Row - 1) * 160 + ((Door11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
ELSEIF pRow = Door11Row AND pCol = Door11Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, PlayerColor
                POKE lct, 2
        DEF SEG
ELSEIF Key11 = PASSED THEN
        lct = (Key11Row - 1) * 160 + ((Key11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 123
        DEF SEG
        lct = (Door11Row - 1) * 160 + ((Door11Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
END IF

IF Key12 = NOT PASSED THEN
        lct = (Key12Row - 1) * 160 + ((Key12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 125
        DEF SEG
        lct = (Door12Row - 1) * 160 + ((Door12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Key12Row AND pCol = Key12Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, PlayerColor
            POKE lct, 2
        DEF SEG
        lct = (Door12Row - 1) * 160 + ((Door12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
ELSEIF pRow = Door12Row AND pCol = Door12Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, PlayerColor
                POKE lct, 2
        DEF SEG
ELSEIF Key12 = PASSED THEN
        lct = (Key12Row - 1) * 160 + ((Key12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 123
        DEF SEG
        lct = (Door12Row - 1) * 160 + ((Door12Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
END IF

IF Key11 = NOT PASSED THEN
        lct = (ExitDoor1Row - 1) * 160 + ((ExitDoor1Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 176
        DEF SEG
ELSEIF Key11 = PASSED AND Key12 = NOT PASSED THEN
        lct = (ExitDoor1Row - 1) * 160 + ((ExitDoor1Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 177
        DEF SEG
ELSEIF Key12 = PASSED THEN
        lct = (ExitDoor1Row - 1) * 160 + ((ExitDoor1Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
END IF

'*****************************************************************************
'*****************************************************************************
'*****************************************************************************
'*****************************************************************************
'*****************************************************************************

CASE 2

IF Key21 = PASSED THEN
    area(Door21Row, Door21Col) = 0
END IF
IF Key22 = PASSED THEN
    area(Door22Row, Door22Col) = 0
END IF

IF pRow = Key21Row AND pCol = Key21Col THEN area(Door21Row, Door21Col) = 0: Key21 = PASSED
IF pRow = Key22Row AND pCol = Key22Col THEN area(Door22Row, Door22Col) = 0: Key22 = PASSED

lct = (BackDoor2Row - 1) * 160 + ((BackDoor2Col - 1) * 2)
IF Key11 = PASSED AND Key12 = PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 178
    DEF SEG
ELSEIF Key11 = PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 177
    DEF SEG
ELSE
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 176
    DEF SEG
END IF

'*****************************************************************************

IF Key21 = NOT PASSED THEN
        lct = (Key21Row - 1) * 160 + ((Key21Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 125
        DEF SEG
        lct = (Door21Row - 1) * 160 + ((Door21Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Door21Row AND pCol = Door21Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, PlayerColor
                POKE lct, 2
        DEF SEG
       
        'COLOR DoorColor: LOCATE Key21Row, Key21Col: PRINT CHR$(123) "{"
        lct = (Key21Row - 1) * 160 + ((Key21Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 123
        DEF SEG

ELSEIF Key21 = PASSED THEN
        IF pRow = Key21Row AND pCol = Key21Col THEN
            'COLOR DoorColor: LOCATE Dorr21Row, Door21Col: PRINT CHR$(178) "²"
            lct = (Door21Row - 1) * 160 + ((Door21Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, DoorColor
                POKE lct, 178
            DEF SEG
        ELSE
           
            'COLOR 4: LOCATE Key21Row, Key21Col: PRINT CHR$(123) "{"
            lct = (Key21Row - 1) * 160 + ((Key21Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, DoorColor
                POKE lct, 123
            DEF SEG

            'COLOR 4: LOCATE Door21Row, Door21Col: PRINT CHR$(178) "²"
            lct = (Door21Row - 1) * 160 + ((Door21Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, DoorColor
                POKE lct, 178
            DEF SEG
       
        END IF
END IF

'*****************************************************************************
IF Key22 = NOT PASSED THEN
        lct = (Key22Row - 1) * 160 + ((Key22Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 125
        DEF SEG
        lct = (Door22Row - 1) * 160 + ((Door22Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 177
        DEF SEG
ELSEIF pRow = Door22Row AND pCol = Door22Col THEN
        lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
        DEF SEG = &HB800
                POKE lct + 1, PlayerColor
                POKE lct, 2
        DEF SEG
ELSEIF Key22 = PASSED THEN
        IF pRow = Key22Row AND pCol = Key22Col THEN
            lct = (Door22Row - 1) * 160 + ((Door22Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, DoorColor
                POKE lct, 178
            DEF SEG
        ELSE
            lct = (Key22Row - 1) * 160 + ((Key22Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, DoorColor
                POKE lct, 123
            DEF SEG
            lct = (Door22Row - 1) * 160 + ((Door22Col - 1) * 2)
            DEF SEG = &HB800
                POKE lct + 1, DoorColor
                POKE lct, 178
            DEF SEG
        END IF
END IF

lct = (ExitDoor2Row - 1) * 160 + ((ExitDoor2Col - 1) * 2)
IF Key21 = NOT PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 176
    DEF SEG
ELSEIF Key21 = PASSED AND Key22 = NOT PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 177
    DEF SEG
ELSEIF Key21 = PASSED AND Key22 = PASSED THEN
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 178
    DEF SEG
END IF
  
'*****************************************************************************
'*****************************************************************************
'******************************* B A N A   3 *********************************
'*****************************************************************************
'*****************************************************************************
'*****************************************************************************
'*****************************************************************************

CASE 3

IF pRow = Key31Row AND pCol = Key31Col THEN Key31 = PASSED

IF Key21 = PASSED AND Key22 = PASSED THEN
    lct = (BackDoor3Row - 1) * 160 + ((BackDoor3Col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 178
    DEF SEG
END IF

IF Key31 = NOT PASSED THEN
    lct = (Key31Row - 1) * 160 + ((Key31Col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 125
    DEF SEG
ELSEIF Key31 = PASSED THEN
    lct = (Key31Row - 1) * 160 + ((Key31Col - 1) * 2)
    IF pRow = Key31Row AND pCol = Key31Col THEN
        DEF SEG = &HB800
            POKE lct + 1, PlayerColor
            POKE lct, 2
        DEF SEG
    ELSE
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 123
        DEF SEG
    END IF
END IF

IF Key31 = PASSED THEN
    area(DoorRow, Door1Col) = 0
    area(DoorRow, Door2Col) = 0
    area(DoorRow, Door3Col) = 0
    
    offset = (DoorRow - 1) * 160
    IF pRow = DoorRow THEN
        IF pCol = Door1Col THEN
            DEF SEG = &HB800
                lct = offset + ((Door1Col - 1) * 2)
                POKE lct + 1, PlayerColor
                POKE lct, 2
                lct = offset + ((Door2Col - 1) * 2)
                POKE lct + 1, DoorColor
                POKE lct, 178
                lct = offset + ((Door3Col - 1) * 2)
                POKE lct + 1, DoorColor
                POKE lct, 178
            DEF SEG
        ELSEIF pCol = Door2Col THEN
            DEF SEG = &HB800
                lct = offset + ((Door2Col - 1) * 2)
                POKE lct + 1, PlayerColor
                POKE lct, 2
                lct = offset + ((Door3Col - 1) * 2)
                POKE lct + 1, DoorColor
                POKE lct, 178
                lct = offset + ((Door1Col - 1) * 2)
                POKE lct + 1, DoorColor
                POKE lct, 178
            DEF SEG
        ELSEIF pCol = Door3Col THEN
            DEF SEG = &HB800
                lct = offset + ((Door3Col - 1) * 2)
                POKE lct + 1, PlayerColor
                POKE lct, 2
                lct = offset + ((Door2Col - 1) * 2)
                POKE lct + 1, DoorColor
                POKE lct, 178
                lct = offset + ((Door1Col - 1) * 2)
                POKE lct + 1, DoorColor
                POKE lct, 178
            DEF SEG
        END IF
    ELSE
        lct = offset + ((Door1Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, DoorColor
            POKE lct, 178
            POKE lct + 3, DoorColor
            POKE lct + 2, 178
            POKE lct + 5, DoorColor
            POKE lct + 4, 178
        DEF SEG
    END IF
ELSE
offset = (DoorRow - 1) * 160
DEF SEG = &HB800
    lct = offset + ((Door1Col - 1) * 2)
    POKE lct + 1, DoorColor
    POKE lct, 177
    lct = offset + ((Door2Col - 1) * 2)
    POKE lct + 1, DoorColor
    POKE lct, 177
    lct = offset + ((Door3Col - 1) * 2)
    POKE lct + 1, DoorColor
    POKE lct, 177
    DEF SEG
END IF
IF Key1 = NOT PASSED THEN
    lct = (Door31Row - 1) * 160 + ((Door31Col - 1) * 2)
    DEF SEG = &HB800
        POKE lct + 1, DoorColor
        POKE lct, 177
        lct = (EndDoorRow - 1) * 160 + ((EndDoorCol - 1) * 2)
        POKE lct + 1, DoorColor
        POKE lct, 177
    DEF SEG
ELSEIF Key1 = PASSED THEN
    area(Door31Row, Door31Col) = 0
    IF pRow = Door31Row AND pCol = Door31Col THEN
        DEF SEG = &HB800
            lct = (Door31Row - 1) * 160 + ((Door31Col - 1) * 2)
            POKE lct + 1, PlayerColor
            POKE lct, 2
        DEF SEG
    ELSE
        DEF SEG = &HB800
            lct = (Door31Row - 1) * 160 + ((Door31Col - 1) * 2)
            POKE lct + 1, DoorColor
            POKE lct, 178
            lct = (EndDoorRow - 1) * 160 + ((EndDoorCol - 1) * 2)
            POKE lct + 1, DoorColor
            POKE lct, 178
        DEF SEG
    END IF
END IF
END SELECT
END SUB

SUB Menu
u$ = CHR$(0) + CHR$(72)
D$ = CHR$(0) + CHR$(80)
r$ = CHR$(0) + CHR$(77)
l$ = CHR$(0) + CHR$(75)
enter$ = CHR$(13)

KEY(15) OFF

Setup
DoBG
 
Box 1, 25, 3, 55, 0, 0, 1, ForeGround, 0
Box 5, 32, 13, 50, 0, 1, 1, ForeGround, 0
Box 15, 25, 18, 55, 0, 0, 1, ForeGround, 0

FOR c = 30 TO 50
    LOCATE 23, c: PRINT "ß"
NEXT c
LOCATE 23, 30: PRINT "Û"
LOCATE 23, 50: PRINT "Û"
LOCATE 24, 30: PRINT "Û"
LOCATE 24, 50: PRINT "Û"
FOR D = 31 TO 49
    COLOR 0, 0
    LOCATE 24, D: PRINT "Û"
NEXT D

DEF SEG = &HB800
COLOR 8, 0
offset = 23 * 160 + (2 * 50)
LOCATE 24, 51
PRINT CHR$(PEEK(offset));
PRINT CHR$(PEEK(offset + 2))
DEF SEG

COLOR 7, 0
Center 24, "Beta Version 0.9"
COLOR 2, 0
Center 2, "I " + CHR$(24) + " " + CHR$(178) + " { " + CHR$(2) + "       " + CHR$(2) + " } " + CHR$(178) + " " + CHR$(24) + " I"
COLOR 3, 0
Center 2, "SaRpg"

DIM MCStr(8) AS STRING
DIM MCColor(2, 8)

MCColor(1, 1) = 1: MCColor(2, 1) = 7
MCColor(1, 2) = 3: MCColor(2, 2) = 5
MCColor(1, 3) = 5: MCColor(2, 3) = 2
MCColor(1, 4) = 7: MCColor(2, 4) = 4
MCColor(1, 5) = 6: MCColor(2, 5) = 3
MCColor(1, 6) = 11: MCColor(2, 6) = 2
MCColor(1, 7) = 13: MCColor(2, 7) = 1
MCColor(1, 8) = 15: MCColor(2, 8) = 0
MCStr(1) = "  Play Game  "
MCStr(2) = "  Load Game  "
MCStr(3) = "   Options   "
MCStr(4) = "    Help     "
MCStr(5) = "Introduction "
MCStr(6) = " Delete Game "
MCStr(7) = "Highest Level"
MCStr(8) = "  Exit Game  "

MenuTriple = 1
Cursor = 1

MenuStart:
DO
    IF MenuTriple = 1 THEN
        COLOR 7, 0
        IF Cursor = 1 THEN COLOR MCColor(1, 1), MCColor(2, 1): LOCATE 7, 35: PRINT MCStr(1) ELSE LOCATE 7, 35: PRINT MCStr(1)
        COLOR 7, 0
        IF Cursor = 2 THEN COLOR MCColor(1, 2), MCColor(2, 2): LOCATE 9, 35: PRINT MCStr(2) ELSE LOCATE 9, 35: PRINT MCStr(2)
        COLOR 7, 0
        IF Cursor = 3 THEN COLOR MCColor(1, 3), MCColor(2, 3): LOCATE 11, 35: PRINT MCStr(3) ELSE LOCATE 11, 35: PRINT MCStr(3)
    ELSEIF MenuTriple = 2 THEN
        COLOR 7, 0
        IF Cursor = 2 THEN COLOR MCColor(1, 2), MCColor(2, 2): LOCATE 7, 35: PRINT MCStr(2) ELSE LOCATE 7, 35: PRINT MCStr(2)
        COLOR 7, 0
        IF Cursor = 3 THEN COLOR MCColor(1, 3), MCColor(2, 3): LOCATE 9, 35: PRINT MCStr(3) ELSE LOCATE 9, 35: PRINT MCStr(3)
        COLOR 7, 0
        IF Cursor = 4 THEN COLOR MCColor(1, 4), MCColor(2, 4): LOCATE 11, 35: PRINT MCStr(4) ELSE LOCATE 11, 35: PRINT MCStr(4)
    ELSEIF MenuTriple = 3 THEN
        COLOR 7, 0
        IF Cursor = 3 THEN COLOR MCColor(1, 3), MCColor(2, 3): LOCATE 7, 35: PRINT MCStr(3) ELSE LOCATE 7, 35: PRINT MCStr(3)
        COLOR 7, 0
        IF Cursor = 4 THEN COLOR MCColor(1, 4), MCColor(2, 4): LOCATE 9, 35: PRINT MCStr(4) ELSE LOCATE 9, 35: PRINT MCStr(4)
        COLOR 7, 0
        IF Cursor = 5 THEN COLOR MCColor(1, 5), MCColor(2, 5): LOCATE 11, 35: PRINT MCStr(5) ELSE LOCATE 11, 35: PRINT MCStr(5)
    ELSEIF MenuTriple = 4 THEN
        COLOR 7, 0
        IF Cursor = 4 THEN COLOR MCColor(1, 4), MCColor(2, 4): LOCATE 7, 35: PRINT MCStr(4) ELSE LOCATE 7, 35: PRINT MCStr(4)
        COLOR 7, 0
        IF Cursor = 5 THEN COLOR MCColor(1, 5), MCColor(2, 5): LOCATE 9, 35: PRINT MCStr(5) ELSE LOCATE 9, 35: PRINT MCStr(5)
        COLOR 7, 0
        IF Cursor = 6 THEN COLOR MCColor(1, 6), MCColor(2, 6): LOCATE 11, 35: PRINT MCStr(6) ELSE LOCATE 11, 35: PRINT MCStr(6)
    ELSEIF MenuTriple = 5 THEN
        COLOR 7, 0
        IF Cursor = 5 THEN COLOR MCColor(1, 5), MCColor(2, 5): LOCATE 7, 35: PRINT MCStr(5) ELSE LOCATE 7, 35: PRINT MCStr(5)
        COLOR 7, 0
        IF Cursor = 6 THEN COLOR MCColor(1, 6), MCColor(2, 6): LOCATE 9, 35: PRINT MCStr(6) ELSE LOCATE 9, 35: PRINT MCStr(6)
        COLOR 7, 0
        IF Cursor = 7 THEN COLOR MCColor(1, 7), MCColor(2, 7): LOCATE 11, 35: PRINT MCStr(7) ELSE LOCATE 11, 35: PRINT MCStr(7)
    ELSEIF MenuTriple = 6 THEN
        COLOR 7, 0
        IF Cursor = 6 THEN COLOR MCColor(1, 6), MCColor(2, 6): LOCATE 7, 35: PRINT MCStr(6) ELSE LOCATE 7, 35: PRINT MCStr(6)
        COLOR 7, 0
        IF Cursor = 7 THEN COLOR MCColor(1, 7), MCColor(2, 7): LOCATE 9, 35: PRINT MCStr(7) ELSE LOCATE 9, 35: PRINT MCStr(7)
        COLOR 7, 0
        IF Cursor = 8 THEN COLOR MCColor(1, 8), MCColor(2, 8): LOCATE 11, 35: PRINT MCStr(8) ELSE LOCATE 11, 35: PRINT MCStr(8)

    END IF
   
    COLOR 7, 0
    IF Cursor = 1 THEN
        LOCATE 16, 27: PRINT "     Starts a New Game"
    ELSEIF Cursor = 2 THEN
        LOCATE 16, 27: PRINT "     Load a saved game "
    ELSEIF Cursor = 3 THEN
        LOCATE 16, 27: PRINT "    Options in the game"
    ELSEIF Cursor = 4 THEN
        LOCATE 16, 27: PRINT "    Help about the game    "
        LOCATE 17, 35: PRINT "           "
    ELSEIF Cursor = 5 THEN
        LOCATE 16, 27: PRINT " Gives you an introduction "
        LOCATE 17, 35: PRINT "to the game"
    ELSEIF Cursor = 6 THEN
        LOCATE 16, 27: PRINT "    Deletes a saved game   "
        LOCATE 17, 27: PRINT "                         "
    ELSEIF Cursor = 7 THEN
        LOCATE 16, 27: PRINT "Shows a list of the highest"
        LOCATE 17, 27: PRINT "levels through history..."
    ELSEIF Cursor = 8 THEN
        LOCATE 16, 27: PRINT "     Exit the program      "
        LOCATE 17, 27: PRINT "                         "
    END IF
    IF MenuTriple <> 1 THEN LOCATE 6, 40: PRINT CHR$(24) ELSE LOCATE 6, 40: PRINT " "
    IF MenuTriple <> 6 THEN LOCATE 12, 40: PRINT CHR$(25) ELSE LOCATE 12, 40: PRINT " "
    DO
        a$ = INKEY$
        IF a$ = u$ OR a$ = D$ OR a$ = enter$ THEN EXIT DO
    LOOP
    SELECT CASE a$
    CASE enter$
        IF Cursor = 1 THEN CLS : PlayGame 0: GOTO MenuStart
        IF Cursor = 2 THEN LoadGame
        IF Cursor = 3 THEN Options: DrawAreas = FALSE: GOTO MenuStart
        IF Cursor = 4 THEN Help: GOTO MenuStart
        IF Cursor = 5 THEN Introduction: GOTO MenuStart
        IF Cursor = 6 THEN DeleteGame: GOTO MenuStart
        IF Cursor = 7 THEN ShowLevelList: GOTO MenuStart
        IF Cursor = 8 THEN COLOR 7, 0: CLS : END
    CASE u$
        Cursor = Cursor - 1
        IF MenuTriple = 6 AND Cursor < 6 THEN MenuTriple = 5
        IF MenuTriple = 5 AND Cursor < 5 THEN MenuTriple = 4
        IF MenuTriple = 4 AND Cursor < 4 THEN MenuTriple = 3
        IF MenuTriple = 3 AND Cursor < 3 THEN MenuTriple = 2
        IF MenuTriple = 2 AND Cursor < 2 THEN MenuTriple = 1
        IF MenuTriple = 1 AND Cursor < 1 THEN Cursor = 1
    CASE D$
        Cursor = Cursor + 1
        IF MenuTriple = 1 AND Cursor > 3 THEN MenuTriple = 2
        IF MenuTriple = 2 AND Cursor > 4 THEN MenuTriple = 3
        IF MenuTriple = 3 AND Cursor > 5 THEN MenuTriple = 4
        IF MenuTriple = 4 AND Cursor > 6 THEN MenuTriple = 5
        IF MenuTriple = 5 AND Cursor > 7 THEN MenuTriple = 6
        IF MenuTriple = 6 AND Cursor > 8 THEN Cursor = 8
    END SELECT
LOOP

END SUB

SUB MovePlayer

Load = TRUE
LARROW$ = CHR$(0) + "K"
RARROW$ = CHR$(0) + "M"
UARROW$ = CHR$(0) + "H"
DARROW$ = CHR$(0) + "P"
spaces$ = CHR$(32)
dig$ = UCASE$("D")
special$ = "Y"

direction$ = INKEY$

LOCATE pRow, pCol
SELECT CASE direction$
    CASE LARROW$                'MOVE LEFT
        IF pCol - 1 < LBOUND(area, 2) THEN EXIT SUB
        IF area(pRow, pCol - 1) = Item THEN
            PickItem
            area(pRow, pCol - 1) = 0
            LOCATE pRow, pCol - 1: PRINT " "
            LOCATE pRow, pCol
            area(pRow, pCol) = 0
            PRINT " "
            pCol = pCol - 1
        ELSEIF area(pRow, pCol - 1) = ENEMY THEN
            FightEnemy
            IF StillEnemy = FALSE THEN
                area(pRow, pCol - 1) = WAY
                LOCATE pRow, pCol - 1: PRINT " "
                LOCATE pRow, pCol
                area(pRow, pCol) = WAY
                PRINT " "
                pCol = pCol - 1
            ELSE
                StillEnemy = FALSE
            END IF
        ELSEIF area(pRow, pCol - 1) = DOOR THEN
            IF Bana = 3 THEN
                IF pRow = BackDoor3Row AND (pCol - 1) = BackDoor3Col THEN
                    TunnelMovie 0
                    CLS
                    LOCATE 1, 1: PRINT "Please wait..."
                    Bana = Bana - 1
                    Walls
                    DoEnemies
                    DrawArea
                    area(pRow, pCol) = 0
                    pRow = 2
                    pCol = 79
                ELSE
                    FightBoss 1
                    GameWin
                END IF
            ELSEIF Bana = 1 THEN
                CLS
                LOCATE 1, 1
                PRINT "Please wait..."
                Bana = Bana + 1
                Walls
                DoEnemies
                DrawArea
                pRow = 23
                pCol = 79
                EXIT SUB
            ELSEIF Bana = 5 THEN
                CLS
                LOCATE 1, 1
                PRINT "Please wait..."
                Bana = 2
                Walls
                DoEnemies
                DrawArea
                pRow = 3
                pCol = 61
                EXIT SUB
            END IF
        ELSEIF area(pRow, pCol - 1) = WAY THEN
            area(pRow, pCol) = 0
            PRINT " "
            pCol = pCol - 1
            area(pRow, pCol) = 1
        ELSEIF area(pRow, pCol - 1) = WALL THEN
            IF Itemn(16) THEN
                IF area(pRow, pCol - 2) = WAY AND (pCol - 2) > 1 THEN
                    area(pRow, pCol) = 0
                    PRINT " "
                    pCol = pCol - 2
                    area(pRow, pCol) = 1
                END IF
            END IF
           
        END IF
    CASE RARROW$
        IF pCol + 1 > UBOUND(area, 2) THEN EXIT SUB
        IF area(pRow, pCol + 1) = Item THEN
            IF Bana = 1 THEN
                PickItem
                area(pRow, pCol + 1) = 0
                LOCATE pRow, pCol + 1: PRINT " "
                LOCATE pRow, pCol
                area(pRow, pCol) = 0
                PRINT " "
                pCol = pCol + 1
            ELSEIF Bana = 3 THEN
                PickItem
                area(pRow, pCol + 1) = 0
                LOCATE pRow, pCol + 1: PRINT " "
                LOCATE pRow, pCol
                area(pRow, pCol) = 0
                PRINT " "
                pCol = pCol + 1
            ELSEIF Bana = 4 THEN
                PickItem
                area(pRow, pCol + 1) = WAY
                LOCATE pRow, pCol + 1: PRINT " "
                LOCATE pRow, pCol
                area(pRow, pCol) = WAY
                PRINT " "
                pCol = pCol + 1
            END IF
        ELSEIF area(pRow, pCol + 1) = house THEN
            HandleHouse
        ELSEIF area(pRow, pCol + 1) = ENEMY THEN
            IF pCol + 1 = CodeCol AND pRow = CodeRow THEN
                CodeDropped = TRUE
                Code = TRUE
            ELSE
                CodeDropped = FALSE
            END IF
            FightEnemy
            IF StillEnemy = FALSE THEN
                area(pRow, pCol + 1) = 0
                LOCATE pRow, pCol + 1: PRINT " "
                LOCATE pRow, pCol
                area(pRow, pCol) = 0
                PRINT " "
                pCol = pCol + 1
            ELSE
                StillEnemy = FALSE
            END IF
        ELSEIF area(pRow, pCol + 1) = DOOR THEN
            IF Bana = 2 THEN
                IF pRow = BackDoor2Row AND pCol + 1 = BackDoor2Col THEN
                    CLS
                    LOCATE 1, 1
                    PRINT "Please wait..."
                    Bana = Bana - 1
                    Walls
                    DoEnemies
                    DrawArea
                    pRow = 23
                    pCol = 2
                    EXIT SUB
                ELSE
                    TunnelMovie 1
                    CLS
                    LOCATE 1, 1: PRINT "Please wait..."
                    Bana = Bana + 1
                    Walls
                    DoEnemies
                    DrawArea
                    pRow = 2
                    pCol = 2
                END IF
            ELSEIF Bana = 3 THEN
                FightBoss 1
                GameWin
            ELSE
                CLS
                LOCATE 1, 1
                PRINT "Please wait..."
                Bana = Bana + 1
                Walls
                DrawArea
            END IF
        ELSEIF area(pRow, pCol + 1) = WAY THEN
            area(pRow, pCol) = 0
            PRINT " "
            pCol = pCol + 1
            area(pRow, pCol) = 1
        ELSEIF area(pRow, pCol + 1) = WALL THEN
            IF Itemn(16) THEN
                IF area(pRow, pCol + 2) = WAY AND (pCol + 2) < 80 THEN
                    area(pRow, pCol) = 0
                    PRINT " "
                    pCol = pCol + 2
                    area(pRow, pCol) = 1
                END IF
            END IF
            
        END IF
    CASE UARROW$
        IF pRow - 1 < LBOUND(area, 1) THEN EXIT SUB
        IF area(pRow - 1, pCol) = Item THEN
            PickItem
            area(pRow - 1, pCol) = 0
            LOCATE pRow - 1, pCol: PRINT " "
            LOCATE pRow, pCol
            area(pRow, pCol) = 0
            PRINT " "
            pRow = pRow - 1
        ELSEIF area(pRow - 1, pCol) = MarketPlace THEN
            Market
        ELSEIF area(pRow - 1, pCol) = OldHouse THEN
            OldMansHouse
        ELSEIF area(pRow - 1, pCol) = ENEMY THEN
            IF pCol = CodeCol AND pRow - 1 = CodeRow THEN
                CodeDropped = TRUE
                Code = TRUE
            ELSE
                CodeDropped = FALSE
            END IF
                FightEnemy
            IF StillEnemy = FALSE THEN
                area(pRow - 1, pCol) = 0
                LOCATE pRow - 1, pCol: PRINT " "
                LOCATE pRow, pCol
                area(pRow, pCol) = 0
                PRINT " "
                pRow = pRow - 1
            ELSE
                StillEnemy = FALSE
            END IF
        ELSEIF area(pRow - 1, pCol) = DOOR THEN
            IF Bana = 4 THEN
                FightBoss 2
                OutOfGame
            END IF
        ELSEIF area(pRow - 1, pCol) = WAY THEN
            area(pRow, pCol) = 0
            pRow = pRow - 1
            area(pRow, pCol) = 1
            PRINT " "
        ELSEIF area(pRow - 1, pCol) = WALL THEN
            IF Itemn(16) THEN
                IF area(pRow - 2, pCol) = WAY AND (pRow - 2) > 1 THEN
                    area(pRow, pCol) = 0
                    PRINT " "
                    pRow = pRow - 2
                    area(pRow, pCol) = 1
                END IF
            END IF
        END IF
    CASE DARROW$
        IF pRow + 1 > UBOUND(area, 1) THEN EXIT SUB
        IF area(pRow + 1, pCol) = Item THEN
            PickItem
            area(pRow + 1, pCol) = 0
            LOCATE pRow + 1, pCol: PRINT " "
            LOCATE pRow, pCol
            area(pRow, pCol) = 0
            PRINT " "
            pRow = pRow + 1
        ELSEIF area(pRow + 1, pCol) = ENEMY THEN
            IF pCol = CodeCol AND pRow + 1 = CodeRow THEN
                CodeDropped = TRUE
                Code = TRUE
            ELSE
                CodeDropped = FALSE
            END IF
            FightEnemy
            IF StillEnemy = FALSE THEN
                area(pRow + 1, pCol) = 0
                LOCATE pRow + 1, pCol: PRINT " "
                LOCATE pRow, pCol
                area(pRow, pCol) = 0
                PRINT " "
                pRow = pRow + 1
            ELSE
                StillEnemy = FALSE
            END IF
        ELSEIF area(pRow + 1, pCol) = OldHouse THEN
            OldMansHouse
        ELSEIF area(pRow + 1, pCol) = WAY THEN
            area(pRow, pCol) = 0
            PRINT " "
            pRow = pRow + 1
            area(pRow, pCol) = 1
        ELSEIF area(pRow + 1, pCol) = WALL THEN
            IF Itemn(16) THEN
                IF area(pRow + 2, pCol) = WAY AND (pRow + 2) < 24 THEN
                    area(pRow, pCol) = 0
                    PRINT " "
                    pRow = pRow + 2
                    area(pRow, pCol) = 1
                END IF
            END IF
        END IF
    CASE spaces$
        ShowInfo
    CASE dig$
        IF Bana = 3 THEN
            IF pRow = 22 AND pCol = 77 THEN
                IF Itemn(13) = 1 AND Itemn(11) = 0 THEN
                    RecieveItem 1
                END IF
            END IF
        ELSEIF Bana = 5 THEN
            IF pRow = AmuletRow AND pCol = AmuletCol THEN
                IF Itemn(13) = 1 AND Itemn(17) = 0 THEN
                    RecieveItem 2
                END IF
            END IF
        END IF
    CASE special$
        IF Bana = 4 THEN
            IF pRow = 18 AND pCol = 20 THEN
                Bana = 3
                Walls
                DoEnemies
                DrawArea
                pRow = 21
                pCol = 65
            ELSEIF pRow = 23 AND pCol = 2 THEN
                Bana = 6
                Walls
                DoEnemies
                DrawArea
                pRow = 23
                pCol = 2
            END IF
        ELSEIF Bana = 6 THEN
            IF pRow = 23 AND pCol = 2 THEN
                Bana = 4
                Walls
                DoEnemies
                DrawArea
                pRow = 23
                pCol = 2
            END IF
        ELSEIF Bana = 3 THEN
            IF pRow = 21 AND pCol = 65 THEN
                Bana = 4
                Itemn(9) = 1
                Walls
                DoEnemies
                DrawArea
                pRow = 18
                pCol = 20
            END IF
        END IF
END SELECT

Radar           'If Player Have a Radar of any kind

lct = (pRow - 1) * 160 + ((pCol - 1) * 2)
DEF SEG = &HB800
    POKE lct + 1, PlayerColor
    POKE lct, 2
DEF SEG

END SUB

'DontBg is a variable that tells sub Handlehouse not to write the background
'that was saved earlier in the program.
'
SUB MoveToTrain

Bana = 5
Walls
FOR Col = 33 TO 51 STEP 3
    area(11, Col) = ENEMY
    area(13, Col) = ENEMY
NEXT Col
DrawArea

'*****************
'Make a place for the "amulet of life".
RANDOMIZE TIMER
place = INT(RND * 10 + 1)
SELECT CASE place
CASE 1  'Upper left corner
    AmuletRow = 2: AmuletCol = 2
CASE 2  'Upper "N" and down
    AmuletRow = 5: AmuletCol = 50
CASE 3  'Lower "N" and up
    AmuletRow = 17: AmuletCol = 51
CASE 4  'Lower "N" and down
    AmuletRow = 19: AmuletCol = 55
CASE 5  'Upper "R" and down
    AmuletRow = 6: AmuletCol = 20
CASE 6  'Upper "N" and up
    AmuletRow = 4: AmuletCol = 47
CASE 7  'Lower "R" and up
    AmuletRow = 17: AmuletCol = 34
CASE 8  'Upper "E" and up
    AmuletRow = 4: AmuletCol = 14
CASE 9  'Upper "E" and down
    AmuletRow = 6: AmuletCol = 14
CASE 10 'Center Left
    AmuletRow = 12: AmuletCol = 15
END SELECT
'*************

pRow = 12
pCol = 31
DontBg = TRUE
END SUB

SUB NewGame
KEY(15) OFF
CLS
LOCATE 1, 1: PRINT "Please wait..."
ResetGame
Setup
Walls
DoEnemies
DrawArea
KEY(15) ON
PlayGame 0
END SUB

SUB OldMansHouse
DIM BG(24, 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 3, 5, 10, 40, 0, 1, 1, ForeGround, 0  'V„nster Uppe
Box 10, 5, 21, 40, 1, 1, 1, ForeGround, 0 'V„nster Nere

Box 3, 43, 5, 76, 0, 1, 1, ForeGround, 0    'H”ger Uppe
Box 6, 43, 22, 76, 0, 1, 1, ForeGround, 0  'H”ger Nere

LOCATE 4, 45: PRINT YouData$
LOCATE 7, 45: PRINT "Hit Points:": LOCATE 7, 64: PRINT USING "#### /#####"; YouHitPoints(1); YouHitPoints(2)
LOCATE 8, 45: PRINT "Attack: ": LOCATE 8, 72: PRINT USING "###"; YouAttack
LOCATE 9, 45: PRINT "Defence: ": LOCATE 9, 72: PRINT USING "###"; YouDefence
LOCATE 10, 45: PRINT "Armour: ": LOCATE 10, 73: PRINT USING "##"; YouArmour
IF Itemn(2) = 1 THEN
    LOCATE 11, 45: PRINT "Magic 1: ": LOCATE 11, 72: PRINT USING "###"; YouMagic(1)
    LOCATE 12, 45: PRINT "Magic 2: ": LOCATE 12, 72: PRINT USING "###"; YouMagic(2)
    LOCATE 13, 45: PRINT "Mana: ": LOCATE 13, 70: PRINT USING "#####"; Mana
    LOCATE 14, 45: PRINT "Experience: ": LOCATE 14, 66: PRINT USING "#########"; Experience&
    LOCATE 15, 45: PRINT "For Next Level: ": LOCATE 15, 66: PRINT USING "#########"; ForNextLevelExp&
    LOCATE 16, 45: PRINT "Level: ": LOCATE 16, 73: PRINT USING "##"; Level
    LOCATE 17, 45: PRINT "Money: ": LOCATE 17, 70: PRINT USING "#####"; Money
ELSE
    LOCATE 11, 45: PRINT "Experience: ": LOCATE 11, 68: PRINT USING "#######"; Experience&
    LOCATE 12, 45: PRINT "For Next Level: ": LOCATE 12, 68: PRINT USING "#######"; ForNextLevelExp&
    LOCATE 13, 45: PRINT "Level: ": LOCATE 13, 73: PRINT USING "##"; Level
    LOCATE 14, 45: PRINT "Money: ": LOCATE 14, 70: PRINT USING "#####"; Money
END IF

IF OldHousePass THEN
    LOCATE 11, 7: PRINT "Oh, its you again... Do you want"
    LOCATE 12, 7: PRINT "more?"
ELSE
    LOCATE 11, 7: PRINT "Hello, young wanderer. I'm an   "
    LOCATE 12, 7: PRINT "old man that is sitting and     "
    LOCATE 13, 7: PRINT "watching over this landscape,   "
    LOCATE 14, 7: PRINT "filled with evil creatures like "
    LOCATE 15, 7: PRINT "demons and dragons. Luckily, not"
    LOCATE 16, 7: PRINT "an evil thing may enter the pass"
    LOCATE 17, 7: PRINT "and into my little building."
    g$ = INPUT$(1)
    LOCATE 18, 7: PRINT "..."
    g$ = INPUT$(1)
    LOCATE 19, 7: PRINT "Do you want something?"
    g$ = INPUT$(1)
    ClearDialogBox 4
    LOCATE 11, 7: PRINT "Maybe you have heard about a    "
    LOCATE 12, 7: PRINT "magic drink that I have here.   "
    LOCATE 13, 7: PRINT "I make these bottles of healing "
    LOCATE 14, 7: PRINT "water because of that someone   "
    LOCATE 15, 7: PRINT "someday want to buy any. Do you?"
    OldHousePass = 1
END IF
LOCATE 4, 7: PRINT "(M)agic Healing Fluid      1000"
LOCATE 5, 7: PRINT "(N)o thanks"

DoLopp:
DO: k$ = INKEY$: LOOP UNTIL k$ <> ""
IF UCASE$(k$) = "M" THEN
    ClearDialogBox 4
    IF Money >= 1000 THEN
        LOCATE 11, 7: PRINT "A nice fresh new-made bottle"
        LOCATE 12, 7: PRINT "of LIFEFLUID. Here you are. "
        LOCATE 13, 7: PRINT "Do you want more?"
        Usen(3) = Usen(3) + 1
        Money = Money - 1000
        IF Itemn(2) THEN
            LOCATE 17, 70: PRINT USING "#####"; Money
        ELSE
            LOCATE 14, 70: PRINT USING "#####"; Money
        END IF
        GOTO DoLopp
    ELSE
        LOCATE 11, 7: PRINT "Come back when you have more"
        LOCATE 12, 7: PRINT "money."
        g$ = INPUT$(1)
    END IF
ELSEIF UCASE$(k$) = "N" THEN
    ClearDialogBox 4
    LOCATE 11, 7: PRINT "Very well, I'll see you later."
    g$ = INPUT$(1)
ELSE
    GOTO DoLopp
END IF

SaveBG 1, 1, 1, 24, 80, BG()

END SUB

SUB Options
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 5, 20, 14, 50, 0, 1, 1, ForeGround, 0
LOCATE 6, 30: PRINT "Options"
LOCATE 13, 22: PRINT "Esc = Accept"

Mark = 1
StartLoop:
DO
    COLOR ForeGround, 0
    LOCATE 8, 22: PRINT "Set Outfit"
    LOCATE 9, 22: PRINT "Change name"
    LOCATE 10, 22: PRINT "Play Movie:"
    LOCATE 11, 22: PRINT "Automate attacking:"
    IF AutoAttack = TRUE THEN
        IF Mark = 4 THEN COLOR 7, 4
        LOCATE 11, 41: PRINT " Yes"
    ELSEIF AutoAttack = FALSE THEN
        IF Mark = 4 THEN COLOR 7, 4
        LOCATE 11, 41: PRINT " No "
    END IF
    COLOR ForeGround, 0
    IF PlayMovie = TRUE THEN
        IF Mark = 3 THEN COLOR 7, 4
        LOCATE 10, 33: PRINT " Yes"
    ELSEIF PlayMovie = FALSE THEN
        IF Mark = 3 THEN COLOR 7, 4
        LOCATE 10, 33: PRINT " No "
    END IF
    IF ForeGround = 4 THEN
        COLOR ForeGround, 5
    ELSE
        COLOR ForeGround, 4
    END IF
    IF Mark = 1 THEN LOCATE 8, 22: PRINT "Set Outfit"
    IF Mark = 2 THEN LOCATE 9, 22: PRINT "Change name"
    IF Mark = 3 THEN LOCATE 10, 22: PRINT "Play Movie:"
    IF Mark = 4 THEN LOCATE 11, 22: PRINT "Automate attacking:"
    DO: key$ = INKEY$: LOOP UNTIL key$ <> ""
    SELECT CASE key$
    CASE u$
        Mark = Mark - 1
        IF Mark < 1 THEN Mark = 1
    CASE D$
        Mark = Mark + 1
        IF Mark > 4 THEN Mark = 4
    CASE esc$
        EXIT DO
    CASE enter$
        IF Mark = 1 THEN SetOutfit: GOTO StartLoop
        IF Mark = 2 THEN ChangeName: GOTO StartLoop
        IF Mark = 3 THEN
            IF PlayMovie = TRUE THEN
                PlayMovie = FALSE
            ELSE
                PlayMovie = TRUE
            END IF
        END IF
        IF Mark = 4 THEN
            IF AutoAttack = TRUE THEN
                AutoAttack = FALSE
            ELSE
                AutoAttack = TRUE
            END IF
        END IF
    END SELECT
LOOP

SaveBG 1, 1, 1, 24, 80, BG()
END SUB

SUB OutOfGame

Box 5, 10, 19, 70, 0, 1, 1, ForeGround, 0
LOCATE 6, 12: PRINT "You didn't got the Bad man. But you got out of this mess."
LOCATE 7, 12: PRINT "Now you is on a beach in Madeira or Thailand or any place"
LOCATE 8, 12: PRINT "away from the Bad man. The only connection you have with"
LOCATE 9, 12: PRINT "him is on the news where he is almost every day making"
LOCATE 10, 12: PRINT "bad things to people..."
LOCATE 18, 12: PRINT "Press any key..."
g$ = INPUT$(1)
ResetGame
Menu
END SUB

SUB PauseMenu

KEY(15) OFF
DIM BG(6 TO 19, 17 TO 62, 0 TO 1)

SaveBG 0, 6, 17, 19, 62, BG()

Mark = 1

Box 6, 17, 18, 60, 0, 1, 1, ForeGround, 0
Center 7, "SaRpg:Menu"
PauseMenuStart:

DO
    FG = 7
    IF Mark = 1 THEN
        BG1 = 1: BG2 = 0
    ELSEIF Mark = 2 THEN
        BG2 = 1: BG1 = 0: BG3 = 0
    ELSEIF Mark = 3 THEN
        BG3 = 1: BG2 = 0: BG4 = 0
    ELSEIF Mark = 4 THEN
        BG4 = 1: BG3 = 0: BG5 = 0
    ELSEIF Mark = 5 THEN
        BG5 = 1: BG4 = 0: BG6 = 0
    ELSEIF Mark = 6 THEN
        BG6 = 1: BG5 = 0: BG7 = 0
    ELSEIF Mark = 7 THEN
        BG7 = 1: BG6 = 0: BG8 = 0
    ELSEIF Mark = 8 THEN
        BG8 = 1: BG7 = 0: BG9 = 0
    ELSEIF Mark = 9 THEN
        BG9 = 1: BG8 = 0
    END IF
    COLOR FG, BG1
    Center 9, "Continue"
    COLOR FG, BG2
    Center 10, "Help"
    COLOR FG, BG3
    Center 11, "Options"
    COLOR FG, BG4
    Center 12, "New Game"
    COLOR FG, BG5
    Center 13, "Save Game"
    COLOR FG, BG6
    Center 14, "Load Game"
    COLOR FG, BG7
    Center 15, "Delete Game"
    COLOR FG, BG8
    Center 16, "Exit to Menu"
    COLOR FG, BG9
    Center 17, "Exit to your OS"
    COLOR ForeGround, 0
    DO
        a$ = INKEY$
        IF a$ = u$ OR a$ = D$ OR a$ = enter$ THEN EXIT DO
    LOOP
    SELECT CASE a$
    CASE u$
        Mark = Mark - 1
        IF Mark < 1 THEN Mark = 1
    CASE D$
        Mark = Mark + 1
        IF Mark > 9 THEN Mark = 9
    CASE enter$
        IF Mark = 1 THEN EXIT DO
        IF Mark = 2 THEN Help: GOTO PauseMenuStart
        IF Mark = 3 THEN Options: GOTO PauseMenuStart
        IF Mark = 4 THEN NewGame: GOTO PauseMenuStart
        IF Mark = 5 THEN SaveGame: GOTO PauseMenuStart
        IF Mark = 6 THEN LoadGame: GOTO PauseMenuStart
        IF Mark = 7 THEN DeleteGame: GOTO PauseMenuStart
        IF Mark = 8 THEN ResetGame: Menu
        IF Mark = 9 THEN CLS : COLOR 7, 0: END
    END SELECT
LOOP

KEY(15) ON


SaveBG 1, 6, 17, 19, 62, BG()
ERASE BG

END SUB

SUB PickItem
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)

SELECT CASE Bana
CASE 1
    SaveBG 0, 1, 1, 24, 80, BG()
    Box 7, 30, 14, 60, 0, 1, 1, ForeGround, 0
    LOCATE 8, 32: PRINT "You have found the key."
    Itemn(1) = Itemn(1) + 1
    Key1 = PASSED
    WHILE key$ = "": key$ = INKEY$: WEND
    IF UCASE$(key$) = "I" THEN
        Info 1
    END IF
CASE 2
    SaveBG 0, 1, 1, 24, 80, BG()
    Box 7, 30, 14, 60, 0, 1, 1, ForeGround, 0
    LOCATE 8, 32: PRINT "You have found a Sword"
    LOCATE 9, 32: PRINT "Nice!"
    Itemn(4) = Itemn(4) + 1
    WHILE key$ = "": key$ = INKEY$: WEND
    IF UCASE$(key$) = "I" THEN
        Info 2
    END IF
CASE 3
    SaveBG 0, 1, 1, 24, 80, BG()
    Box 7, 30, 13, 60, 0, 1, 1, ForeGround, 0
    LOCATE 8, 32: PRINT "You have found a Magic"
    LOCATE 9, 32: PRINT "wand! For more info"
    LOCATE 10, 32: PRINT "press 'I'."
    Itemn(2) = Itemn(2) + 1
    WHILE key$ = "": key$ = INKEY$: WEND
    IF UCASE$(key$) = "I" THEN
        Info 3
    END IF
CASE 4
    SaveBG 0, 1, 1, 24, 80, BG()
    Box 7, 30, 13, 60, 0, 1, 1, ForeGround, 0
    LOCATE 8, 32: PRINT "You have found a Radar!"
    LOCATE 9, 32: PRINT "For more info press 'I'."
    Itemn(10) = Itemn(10) + 1
    WHILE key$ = "": key$ = INKEY$: WEND
    IF UCASE$(key$) = "I" THEN
        Info 4
    END IF
END SELECT
SaveBG 1, 1, 1, 24, 80, BG()

END SUB

SUB PlayerDie
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

g$ = INPUT$(1)
ClearDialogBox 1
Box 9, 34, 11, 50, 0, 1, 1, ForeGround, 0
LOCATE 10, 36: PRINT "You are dead!"
g$ = INPUT$(1)
IF Itemn(17) = 1 THEN
    Box 10, 30, 15, 55, 0, 1, 1, ForeGround, 0
    LOCATE 11, 32: PRINT "But..."
    g$ = INPUT$(1)
    LOCATE 12, 32: PRINT "Your ïAmulet Of Life`"
    LOCATE 13, 32: PRINT "starts to shine. Your"
    LOCATE 14, 32: PRINT "health is restored."
    Itemn(17) = 0
    g$ = INPUT$(1)
    SaveBG 1, 1, 1, 24, 80, BG()
    ClearDialogBox 1
    Itemn(17) = 0
    EXIT SUB

END IF
ResetGame

Menu
END SUB

SUB PlayGame (a)

IF a THEN GOTO Main

CLS
LOCATE 1, 1: PRINT "Please Wait..."
'*** Setup Labyrint ***
COLOR ForeGround, 0
Load = FALSE
Walls
DoEnemies
DrawArea

Main:
KEY(15) ON
'*** Main loop ***
DO
    IF DrawAreas = TRUE THEN
        DrawArea
        DrawAreas = FALSE
    END IF
    DestroyLock
    Meeting Bana
    MovePlayer
LOOP
END SUB

SUB Radar

IF Itemn(15) = 1 THEN   '************If player have a "Radar 5x5"*********
    IF area(pRow - 2, pCol - 2) = ENEMY THEN LOCATE pRow - 2, pCol - 2: PRINT CHR$(1)
    IF area(pRow - 1, pCol - 2) = ENEMY THEN LOCATE pRow - 1, pCol - 2: PRINT CHR$(1)
    IF area(pRow, pCol - 2) = ENEMY THEN LOCATE pRow, pCol - 2: PRINT CHR$(1)
    IF area(pRow + 1, pCol - 2) = ENEMY THEN LOCATE pRow + 1, pCol - 2: PRINT CHR$(1)
    IF area(pRow + 2, pCol - 2) = ENEMY THEN LOCATE pRow + 2, pCol - 2: PRINT CHR$(1)

    IF area(pRow - 2, pCol - 1) = ENEMY THEN LOCATE pRow - 2, pCol - 1: PRINT CHR$(1)
    IF area(pRow - 1, pCol - 1) = ENEMY THEN LOCATE pRow - 1, pCol - 1: PRINT CHR$(1)
    IF area(pRow, pCol - 1) = ENEMY THEN LOCATE pRow, pCol - 1: PRINT CHR$(1)
    IF area(pRow + 1, pCol - 1) = ENEMY THEN LOCATE pRow + 1, pCol - 1: PRINT CHR$(1)
    IF area(pRow + 2, pCol - 1) = ENEMY THEN LOCATE pRow + 2, pCol - 1: PRINT CHR$(1)

    IF area(pRow - 2, pCol) = ENEMY THEN LOCATE pRow - 2, pCol: PRINT CHR$(1)
    IF area(pRow - 1, pCol) = ENEMY THEN LOCATE pRow - 1, pCol: PRINT CHR$(1)
    IF area(pRow + 1, pCol) = ENEMY THEN LOCATE pRow + 1, pCol: PRINT CHR$(1)
    IF area(pRow + 2, pCol) = ENEMY THEN LOCATE pRow + 2, pCol: PRINT CHR$(1)

    IF area(pRow - 2, pCol + 1) = ENEMY THEN LOCATE pRow - 2, pCol + 1: PRINT CHR$(1)
    IF area(pRow - 1, pCol + 1) = ENEMY THEN LOCATE pRow - 1, pCol + 1: PRINT CHR$(1)
    IF area(pRow, pCol + 1) = ENEMY THEN LOCATE pRow, pCol + 1: PRINT CHR$(1)
    IF area(pRow + 1, pCol + 1) = ENEMY THEN LOCATE pRow + 1, pCol + 1: PRINT CHR$(1)
    IF area(pRow + 2, pCol + 1) = ENEMY THEN LOCATE pRow + 2, pCol + 1: PRINT CHR$(1)
 
    IF area(pRow - 2, pCol + 2) = ENEMY THEN LOCATE pRow - 2, pCol + 2: PRINT CHR$(1)
    IF area(pRow - 1, pCol + 2) = ENEMY THEN LOCATE pRow - 1, pCol + 2: PRINT CHR$(1)
    IF area(pRow, pCol + 2) = ENEMY THEN LOCATE pRow, pCol + 2: PRINT CHR$(1)
    IF area(pRow + 1, pCol + 2) = ENEMY THEN LOCATE pRow + 1, pCol + 2: PRINT CHR$(1)
    IF area(pRow + 2, pCol + 2) = ENEMY THEN LOCATE pRow + 2, pCol + 2: PRINT CHR$(1)


ELSEIF Itemn(10) = 1 THEN       '************If Player have a "Radar 3x3"*********
    IF area(pRow - 1, pCol - 1) = ENEMY THEN LOCATE pRow - 1, pCol - 1: PRINT CHR$(1)
    IF area(pRow, pCol - 1) = ENEMY THEN LOCATE pRow, pCol - 1: PRINT CHR$(1)
    IF area(pRow + 1, pCol - 1) = ENEMY THEN LOCATE pRow + 1, pCol - 1: PRINT CHR$(1)
        
    IF area(pRow - 1, pCol) = ENEMY THEN LOCATE pRow - 1, pCol: PRINT CHR$(1)
    IF area(pRow + 1, pCol) = ENEMY THEN LOCATE pRow + 1, pCol: PRINT CHR$(1)
            
    IF area(pRow - 1, pCol + 1) = ENEMY THEN LOCATE pRow - 1, pCol + 1: PRINT CHR$(1)
    IF area(pRow, pCol + 1) = ENEMY THEN LOCATE pRow, pCol + 1: PRINT CHR$(1)
    IF area(pRow + 1, pCol + 1) = ENEMY THEN LOCATE pRow + 1, pCol + 1: PRINT CHR$(1)


END IF

END SUB

SUB RecieveItem (Thing)

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

SELECT CASE Thing
    CASE 1          'Magic Sword
        Box 10, 30, 16, 56, 0, 1, 1, ForeGround, 0
        LOCATE 11, 32: PRINT "You dig a hole in the "
        LOCATE 12, 32: PRINT "ground and you recieve:"
        LOCATE 14, 32: PRINT "     MAGIC SWORD!     "
        Itemn(11) = 1
        g$ = INPUT$(1)
    CASE 2
        Box 10, 30, 16, 56, 0, 1, 1, ForeGround, 0
        LOCATE 11, 32: PRINT "You dig a hole in the "
        LOCATE 12, 32: PRINT "ground and you recieve:"
        LOCATE 14, 32: PRINT "    AMULET OF LIFE     "
        Itemn(17) = 1
        g$ = INPUT$(1)
    CASE 3
    CASE 4
    CASE 5
END SELECT
SaveBG 1, 1, 1, 24, 80, BG()
END SUB

SUB ResetGame

OPEN "DATA.DAT" FOR INPUT AS #1
    RANDOMIZE TIMER
    FOR i = 1 TO 15
        INPUT #1, PassWor$(i)
    NEXT i
    PassWord$ = PassWor$(INT(15 * RND + 1))
  
    INPUT #1, YouAttack
    INPUT #1, YouDefence
    INPUT #1, YouHitPoints(2)
    YouHitPoints(1) = YouHitPoints(2)
    INPUT #1, YouData$
    INPUT #1, YouMagic(1)
    INPUT #1, YouMagic(2)
    INPUT #1, YouArmour
  
    OPEN "WEAPONS.DAT" FOR INPUT AS #2
        FOR i = 1 TO 6
            INPUT #2, WeaponType(i), Weapon(i, i), Weapon(i, i + 1)
        NEXT i
    CLOSE #2

    INPUT #1, NeedMagic(1)
    INPUT #1, NeedMagic(2)
    INPUT #1, Mana
    INPUT #1, Money
    INPUT #1, Experience&
    INPUT #1, Level
    INPUT #1, MaxUsen
    INPUT #1, User
  
    FOR i = 1 TO 17
        INPUT #1, Items(i)
    NEXT i
  
    FOR i = 1 TO 17
        INPUT #1, Itemn(i)
    NEXT i

    FOR i = 5 TO 9
        INPUT #1, ItemCost(i)
    NEXT i
  
    INPUT #1, Uses(1)
    INPUT #1, Uses(2)
    INPUT #1, Usen(1)
    INPUT #1, Usen(2)
    INPUT #1, Code
    INPUT #1, Load
    INPUT #1, Key11
    INPUT #1, Key12
    INPUT #1, Key21
    INPUT #1, Key22
    INPUT #1, Key31
    INPUT #1, Key1
    INPUT #1, Bana
    INPUT #1, NxtLvlPtsCount
    INPUT #1, ForeGround
    INPUT #1, DoorColor
    INPUT #1, PlayerColor
    INPUT #1, MaxMagic
    INPUT #1, MaxAttack
    INPUT #1, MaxDefence
      
    HousePass = 0
    InHouse = 0
    DefLevUp = 1
    AtkLevUp = 1
    MagLevUp(1) = 1
    MagLevUp(2) = 1
    ShieldCount = 0
    FightCount = 0
    MagicCount(1) = 0
    MagicCount(2) = 0
    ForNextLevelExp& = LevelQual&(Level) - Experience&
    CriticalDouble = 0
    Critical = 0
    FOR HDmg = 1 TO 5
        HighestDamage(HDmg) = 0
    NEXT HDmg
    FOR Rewards = 1 TO 5
        RewardCount(Rewards) = 1
    NEXT Rewards
CLOSE #1



END SUB

SUB SaveBG (Restr, Row1, Col1, Row2, Col2, BG())

DEF SEG = &HB800
IF Restr THEN
    FOR Row = Row1 TO Row2
        FOR Col = Col1 TO Col2
            offset = (Row - 1) * 160 + (2 * (Col - 1))
            POKE offset, BG(Row, Col, 0)          'Poke char
            POKE offset + 1, BG(Row, Col, 1)      'Poke color
        NEXT Col
    NEXT Row
EXIT SUB
END IF
DEF SEG

DEF SEG = &HB800
FOR Row = Row1 TO Row2
    FOR Col = Col1 TO Col2
        'Peek char
        BG(Row, Col, 0) = PEEK((Row - 1) * 160 + (2 * (Col - 1)))
        'Peek color
        BG(Row, Col, 1) = PEEK(((Row - 1) * 160 + (2 * (Col - 1))) + 1)
    NEXT Col
NEXT Row
DEF SEG

END SUB

SUB SaveGame

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
Box 9, 30, 11, 50, 0, 1, 1, ForeGround, 0
LOCATE 10, 32: PRINT "Saving";

OPEN "SAVED.GAM" FOR OUTPUT AS #1
    WRITE #1, pRow, pCol
    WRITE #1, PassWord$, InHouse, HousePass
    WRITE #1, YouAttack, YouDefence, YouHitPoints(1), YouHitPoints(2)
    WRITE #1, YouData$, YouArmour
    WRITE #1, Mana, Money, Experience&, Level, ForNextLevelExp&
    WRITE #1, User, Itemn(1), Itemn(2), Itemn(3), Itemn(4), Itemn(5), Itemn(6)
    Delay .05, 0
    PRINT ".";
    WRITE #1, Itemn(7), Itemn(8), Itemn(9), Itemn(10), Itemn(11), Itemn(12), Itemn(13), Itemn(14), Itemn(15), Itemn(16), Itemn(17), Usen(1), Usen(2), Usen(3)
    WRITE #1, MaxUsen, Increased
    WRITE #1, Code, Load, Key11, Key12, Key21, Key22, Key31, Key1, Bana
    WRITE #1, AtkLevUp, DefLevUp, MagLevUp(1), MagLevUp(2)
    WRITE #1, ShieldCount, FightCount, MagicCount(1), MagicCount(2), YouMagic(1), YouMagic(2)
    WRITE #1, MaxUsen, OnHardMap, PlayMovie, AutoAttack
    WRITE #1, PlayerColor, DoorColor, ForeGround, CriticalDouble, Critical
    WRITE #1, AmuletRow, AmuletCol, OldHousePass
    FOR HDmg = 1 TO 5
        WRITE #1, HighestDamage(HDmg)
    NEXT HDmg
    FOR Rewards = 1 TO 5
        WRITE #1, RewardCount(Rewards)
    NEXT Rewards
    FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
            i = i + 1
            WRITE #1, area(r, c)
            IF i > 180 THEN i = 0: Delay .05, 0: PRINT ".";
        NEXT c
    NEXT r

CLOSE #1
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

SUB SeePassword

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
Box 7, 30, 10, 60, 0, 1, 1, ForeGround, 0

LOCATE 8, 32: PRINT "The password is:"
LOCATE 9, 32: PRINT PassWord$
WHILE INKEY$ = "": WEND
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

SUB SetOutfit
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
Box 6, 10, 15, 70, 0, 1, 1, ForeGround, 0

Row = 1
Col = 1

FOR Colour = 1 TO 15
    COLOR Colour, 0
    LOCATE 8, 35 + Colour
    PRINT CHR$(2)
    LOCATE 10, 35 + Colour
    PRINT "Û"
    LOCATE 12, 35 + Colour
    PRINT "²"
NEXT Colour



DO
    COLOR PlayerColor, 0: LOCATE 8, (28 + 38): PRINT CHR$(2)
    COLOR DoorColor, 0: LOCATE 12, (24 + 38): PRINT "²±°{}"
    COLOR ForeGround, 0: LOCATE 10, (28 + 38): PRINT "Û"
   
    LOCATE 7, 33: PRINT "Set outfit"
    LOCATE 8, 12: PRINT "Player:"
    LOCATE 10, 12: PRINT "ForeGround:"
    LOCATE 12, 12: PRINT "Doors and switches:"
    LOCATE 14, 12: PRINT "Esc = Accept"
   
    IF Row = 1 THEN
        LOCATE Row + 8, Col + 34: PRINT " "
        LOCATE Row + 8, Col + 35: PRINT CHR$(24)
        LOCATE Row + 8, Col + 36: PRINT " "
        LOCATE Row + 10, Col + 35: PRINT " "
    ELSEIF Row = 2 THEN
        LOCATE Row + 7, Col + 35: PRINT " "
        LOCATE Row + 9, Col + 34: PRINT " "
        LOCATE Row + 9, Col + 35: PRINT CHR$(24)
        LOCATE Row + 9, Col + 36: PRINT " "
        LOCATE Row + 11, Col + 35: PRINT " "
    ELSEIF Row = 3 THEN
        LOCATE Row + 8, Col + 35: PRINT " "
        LOCATE Row + 10, Col + 34: PRINT " "
        LOCATE Row + 10, Col + 35: PRINT CHR$(24)
        LOCATE Row + 10, Col + 36: PRINT " "
    END IF
    DO: key$ = INKEY$: LOOP WHILE key$ = ""
    SELECT CASE key$
    CASE l$
        Col = Col - 1
        IF Col < 1 THEN Col = 1
    CASE r$
        Col = Col + 1
        IF Col > 15 THEN Col = 15
    CASE u$
        Row = Row - 1
        IF Row < 1 THEN Row = 1
    CASE D$
        Row = Row + 1
        IF Row > 3 THEN Row = 3
    CASE enter$
        IF Row = 1 THEN
            PlayerColor = Col
        ELSEIF Row = 2 THEN
            ForeGround = Col
            DrawAreas = TRUE
        ELSEIF Row = 3 THEN
            DoorColor = Col
        END IF
    CASE esc$
        EXIT DO
    END SELECT
LOOP
SaveBG 1, 1, 1, 24, 80, BG()
END SUB

SUB Setup

'Clear the area array
FOR r = 1 TO MAXROW
    FOR c = 1 TO MAXCOL
        area(r, c) = WAY
    NEXT c
NEXT r

'Define keys
u$ = CHR$(0) + CHR$(72)
D$ = CHR$(0) + CHR$(80)
enter$ = CHR$(13)
esc$ = CHR$(27)
spaces$ = CHR$(32)

'Game values
END SUB

SUB ShowHighDmg
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 4, 15, 13, 40, 0, 1, 1, ForeGround, BackGround

LOCATE 5, 17: PRINT "Max Damage with...:"
LOCATE 6, 17: PRINT "----------------------"

LOCATE 7, 17: PRINT "Weapon:     "
LOCATE 7, 35: PRINT USING "####"; HighestDamage(1)

LOCATE 8, 17: PRINT "Fire:       "
LOCATE 8, 35: PRINT USING "####"; HighestDamage(2)

LOCATE 9, 17: PRINT "Lightning:  "
LOCATE 9, 35: PRINT USING "####"; HighestDamage(3)

LOCATE 10, 17: PRINT "Critical!:  "
LOCATE 10, 35: PRINT USING "####"; HighestDamage(4)

LOCATE 11, 17: PRINT "CRITICAL!:  "
LOCATE 11, 35: PRINT USING "####"; HighestDamage(5)

LOCATE 12, 17: PRINT "Press a key..."
g$ = INPUT$(1)
SaveBG 1, 1, 1, 24, 80, BG()
END SUB

SUB ShowInfo
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 5, 8, 19, 36, 0, 1, 1, ForeGround, 0
IF Code THEN
    Box 6, 38, 12, 58, 0, 1, 1, ForeGround, 0
ELSE
    Box 6, 38, 11, 58, 0, 1, 1, ForeGround, 0
END IF

LOCATE 6, 10: PRINT YouData$
LOCATE 7, 10: PRINT "-------------------------"
LOCATE 8, 10: PRINT "Hit Points:": LOCATE 8, 24: PRINT USING "#### /#####"; YouHitPoints(1); YouHitPoints(2)
LOCATE 9, 10: PRINT "Attack: ": LOCATE 9, 32: PRINT USING "###"; YouAttack
LOCATE 10, 10: PRINT "Defence: ": LOCATE 10, 32: PRINT USING "###"; YouDefence
LOCATE 11, 10: PRINT "Armour: ": LOCATE 11, 33: PRINT USING "##"; YouArmour
IF Itemn(2) = 1 THEN
    LOCATE 12, 10: PRINT "Magic 1: ": LOCATE 12, 32: PRINT USING "###"; YouMagic(1)
    LOCATE 13, 10: PRINT "Magic 2: ": LOCATE 13, 32: PRINT USING "###"; YouMagic(2)
    LOCATE 14, 10: PRINT "Mana: ": LOCATE 14, 30: PRINT USING "#####"; Mana
    LOCATE 15, 10: PRINT "Experience: ": LOCATE 15, 26: PRINT USING "#########"; Experience&
    LOCATE 16, 10: PRINT "For Next Level: ": LOCATE 16, 26: PRINT USING "#########"; ForNextLevelExp&
    LOCATE 17, 10: PRINT "Level: ": LOCATE 17, 33: PRINT USING "##"; Level
    LOCATE 18, 10: PRINT "Money: ": LOCATE 18, 30: PRINT USING "#####"; Money
ELSE
    LOCATE 12, 10: PRINT "Experience: ": LOCATE 12, 28: PRINT USING "#######"; Experience&
    LOCATE 13, 10: PRINT "For Next Level: ": LOCATE 13, 28: PRINT USING "#######"; ForNextLevelExp&
    LOCATE 14, 10: PRINT "Level: ": LOCATE 14, 33: PRINT USING "##"; Level
    LOCATE 15, 10: PRINT "Money: ": LOCATE 15, 30: PRINT USING "#####"; Money
END IF

LOCATE 7, 40: PRINT "(E)at"
LOCATE 8, 40: PRINT "(I)tem"
LOCATE 9, 40: PRINT "(C)hange Weapon"
LOCATE 10, 40: PRINT "(O)ther"
IF Code THEN LOCATE 11, 40: PRINT "(S)ee password"

DO
    a$ = INKEY$
    IF UCASE$(a$) = "E" THEN CALL Eat
    IF UCASE$(a$) = "I" THEN CALL ShowItem
    IF UCASE$(a$) = "C" THEN CALL WeaponChange
    IF UCASE$(a$) = "S" THEN
        IF Code THEN CALL SeePassword
    END IF
    IF UCASE$(a$) = "O" THEN CALL ShowOther
LOOP UNTIL a$ = CHR$(32)
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

SUB ShowItem
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 3, 25, 20, 50, 0, 1, 1, ForeGround, 0
Box 3, 50, 20, 75, 2, 1, 1, ForeGround, 0
LOCATE 4, 34: PRINT "Item-list"
LOCATE 5, 27: PRINT "----------------------"
FOR Items = 1 TO 14
    IF Itemn(Items) = 1 THEN
        LOCATE Items + 5, 27: PRINT Items(Items)
    END IF
NEXT Items
FOR Items = 15 TO 29
    IF Itemn(Items) = 1 THEN
        LOCATE Items - 11, 52: PRINT Items(Items)
    END IF
NEXT Items

g$ = INPUT$(1)
SaveBG 1, 1, 1, 24, 80, BG()

END SUB

SUB ShowLevelList

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 4, 13, 20, 67, 0, 1, 1, ForeGround, 0
OPEN "level.lst" FOR INPUT AS #1
Center 5, "LEVEL HIGHSCORE"
'Center 6, "---------------------------------------------------------------------"
LOCATE 7, 15: PRINT "Place:"
LOCATE 7, 23: PRINT "Name:"
LOCATE 7, 43: PRINT "Exp:"
LOCATE 7, 55: PRINT "Level:"
'Center 8, "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
FOR a = 1 TO 10
        INPUT #1, nam$(a), scor(a), levl(a)
        LOCATE 8 + a, 18: PRINT USING "##."; a
        LOCATE 8 + a, 23: PRINT nam$(a)
        LOCATE 8 + a, 40: PRINT USING "#######"; scor(a)
        LOCATE 8 + a, 58: PRINT USING "###"; levl(a)
NEXT a
CLOSE #1

g$ = INPUT$(1)
SaveBG 1, 1, 1, 24, 80, BG()

END SUB

SUB ShowOther
DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

Box 7, 30, 15, 60, 0, 1, 1, ForeGround, 0
LOCATE 8, 32: PRINT "Critical Hits:"
    LOCATE 8, 47: PRINT USING "####"; Critical
LOCATE 9, 32: PRINT "CRITICAL Hits:"
    LOCATE 9, 47: PRINT USING "####"; CriticalDouble
LOCATE 11, 32: PRINT "Highest Damage(Press " + CHR$(34) + "H" + CHR$(34) + ")"

PressAKey:
g$ = INPUT$(1)
IF UCASE$(g$) = "H" THEN
    ShowHighDmg
    GOTO PressAKey
END IF
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

FUNCTION SInput$ (Row, Col, Text$)

COLOR ForeGround, 0
DEF SEG = &H40
InsertStatus = PEEK(&H17) AND 128
IF NOT InsertStatus THEN POKE &H17, PEEK(&H17) OR 128
DEF SEG
eCol = Col + LEN(Text$) - 1
posCol = Col + LEN(RTRIM$(Text$))
LOCATE Row, Col: PRINT Text$
LOCATE Row, posCol, 1, 7, 8
DO
    DEF SEG = &H40: Insert = PEEK(&H17) AND 128
        IF Insert THEN LOCATE Row, posCol, 1, 7, 8 ELSE LOCATE Row, posCol, 1, 0, 7
    DEF SEG
    DO: ky$ = INKEY$: LOOP WHILE ky$ = ""
    ky = ASC(ky$)
    IF LEN(ky$) > 1 THEN ky = -ASC(MID$(ky$, 2, 1))
    SELECT CASE ky
    CASE 27
        LOCATE , , 0
        EXIT FUNCTION
    CASE 13
        EXIT DO
    CASE -79
        DEF SEG = &HB800
        FOR endCol = eCol TO Col STEP -1
            lct = (Row - 1) * 160 + ((endCol - 1) * 2)
            IF PEEK(lct - 2) <> 32 THEN
                posCol = endCol
                EXIT FOR
            END IF
            posCol = endCol
        NEXT endCol
        DEF SEG
    CASE -71
        DEF SEG = &HB800
        hCol = Col
        FOR c = Col TO eCol
            IF PEEK(Row - 1) * 160 + ((c - 1) * 2) <> 32 THEN hCol = hCol + 1
        NEXT c
        FOR sCol = Col TO eCol
            lct = (Row - 1) * 160 + ((sCol - 1) * 2)
            IF hCol = (eCol + 1) THEN posCol = Col
            IF PEEK(lct) <> 32 THEN
                posCol = sCol
                EXIT FOR
            END IF
        NEXT sCol
        DEF SEG
    CASE -75
        IF posCol > Col THEN posCol = posCol - 1
    CASE -77
        IF posCol < eCol THEN posCol = posCol + 1
    CASE -83
        FOR dCol = posCol TO eCol
            DEF SEG = &HB800
                lct = (Row - 1) * 160 + ((dCol - 1) * 2)
                POKE lct, PEEK(lct + 2)
            DEF SEG
        NEXT dCol
    CASE 8
        DEF SEG = &HB800
        IF posCol > Col THEN
            IF posCol = eCol THEN
                IF SCREEN(Row, eCol) = 32 THEN
                    FOR dCol = posCol TO eCol
                        lct = (Row - 1) * 160 + (((dCol - 1) - 1) * 2)
                        POKE lct, PEEK(lct + 2)
                    NEXT dCol
                    POKE (Row - 1) * 160 + ((eCol - 1) * 2), 32
                    posCol = posCol - 1
                ELSE
                    LOCATE Row, eCol: PRINT " ";
                END IF
            ELSE
                FOR dCol = posCol TO eCol
                    lct = (Row - 1) * 160 + (((dCol - 1) - 1) * 2)
                    POKE lct, PEEK(lct + 2)
                NEXT dCol
                POKE (Row - 1) * 160 + ((eCol - 1) * 2), 32
                posCol = posCol - 1
            END IF
        END IF
        DEF SEG
    CASE 32
        DEF SEG = &HB800
        IF posCol < eCol THEN
            IF Insert THEN
                lct = (Row - 1) * 160 + ((eCol - 1) * 2)
                IF PEEK(lct) = 32 THEN
                    FOR spCol = eCol TO posCol STEP -1
                        lct = (Row - 1) * 160 + ((spCol - 1) * 2)
                        POKE lct, PEEK(lct - 2)
                    NEXT spCol
                    lct = (Row - 1) * 160 + ((posCol - 1) * 2)
                    POKE lct, 32
                    posCol = posCol + 1
                END IF
            ELSE
                LOCATE Row, posCol: PRINT " ";
                IF posCol < eCol THEN posCol = posCol + 1
            END IF
        END IF
        DEF SEG
    CASE IS > 32
        DEF SEG = &HB800
            IF Insert THEN
                IF PEEK((Row - 1) * 160 + ((eCol - 1) * 2)) = 32 THEN
                    FOR bCol = eCol TO posCol STEP -1
                        lct = (Row - 1) * 160 + ((bCol - 1) * 2)
                        POKE lct, PEEK(lct - 2)
                    NEXT bCol
                    lct = (Row - 1) * 160 + ((posCol - 1) * 2)
                    POKE lct, ASC(ky$)
                    IF posCol < eCol THEN posCol = posCol + 1
                END IF
            ELSE
                LOCATE Row, posCol
                PRINT ky$;
                IF posCol < eCol THEN posCol = posCol + 1
            END IF
        DEF SEG
    END SELECT
LOOP

DEF SEG = &HB800
strang$ = ""
strng$ = ""
FOR kol = Col TO eCol
    lct = (Row - 1) * 160 + ((kol - 1) * 2)
    strng$ = strng$ + CHR$(PEEK(lct))
NEXT kol
DEF SEG
strang$ = LTRIM$(RTRIM$(strng$))
LOCATE , , 0
SInput$ = strang$

END FUNCTION

SUB SkillsAdvance (Skill$)

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()

SELECT CASE Skill$

'************ FIGHTING *********************
CASE "Fighting"

IF YouAttack < MaxAttack THEN
    AtkLevUp = AtkLevUp + 1
    FightCount = 0
    YouAttack = YouAttack + 1
   
    Box 6, 18, 13, 48, 0, 1, 1, ForeGround, 0
    LOCATE 8, 28: PRINT "A D V A N C E "
    LOCATE 9, 20: PRINT "---------------------------"
    LOCATE 10, 26: PRINT "You advanced in:"
    LOCATE 11, 28: PRINT "FIGHTING!"
    LOCATE 12, 26: PRINT "Press any key..."
    LOCATE 7, 67: PRINT USING "###"; YouAttack
    LOCATE 7, 71: PRINT "+1"
    g$ = INPUT$(1)
    LOCATE 7, 71: PRINT "  "
END IF


'************* SHIELDING **********************
CASE "Shielding"

IF YouDefence < MaxDefence THEN
    DefLevUp = DefLevUp + 1
    ShieldCount = 0
    YouDefence = YouDefence + 1

    Box 6, 18, 13, 48, 0, 1, 1, ForeGround, 0
    LOCATE 8, 28: PRINT "A D V A N C E "
    LOCATE 9, 20: PRINT "---------------------------"
    LOCATE 10, 26: PRINT "You advanced in:"
    LOCATE 11, 27: PRINT "SHIELDING!"
    LOCATE 12, 26: PRINT "Press any key..."
    LOCATE 8, 67: PRINT USING "###"; YouDefence
    LOCATE 8, 71: PRINT "+1"
    g$ = INPUT$(1)
    LOCATE 8, 71: PRINT "  "
   
END IF


'*************** MAGIC FIRE ********************
CASE "Fire"
IF YouMagic(1) < MaxMagic THEN
    MagLevUp(1) = MagLevUp(1) + 1
    MagicCount(1) = 0
    YouMagic(1) = YouMagic(1) + 1
   
    IF YouMagic(1) >= GiveReward(RewardCount(4), 4) THEN GiveAReward 4
   
    Box 6, 18, 13, 48, 0, 1, 1, ForeGround, 0
    LOCATE 8, 28: PRINT "A D V A N C E "
    LOCATE 9, 20: PRINT "---------------------------"
    LOCATE 10, 26: PRINT "You advanced in:"
    LOCATE 11, 28: PRINT "MAGIC FIRE!"
    LOCATE 12, 26: PRINT "Press any key..."
    LOCATE 10, 67: PRINT USING "###"; YouMagic(1)
    LOCATE 10, 71: PRINT "+1"
    g$ = INPUT$(1)
    LOCATE 10, 71: PRINT "  "
END IF


'************** MAGIC LIGHTNING *********************
CASE "Lightning"
IF YouMagic(2) < MaxMagic THEN
    MagLevUp(2) = MagLevUp(2) + 1
    MagicCount(2) = 0
    YouMagic(2) = YouMagic(2) + 1
       
    IF YouMagic(2) >= GiveReward(RewardCount(5), 5) THEN GiveAReward 5
   
    Box 6, 18, 13, 48, 0, 1, 1, ForeGround, 0
    LOCATE 8, 28: PRINT "A D V A N C E "
    LOCATE 9, 20: PRINT "---------------------------"
    LOCATE 10, 26: PRINT "You advanced in:"
    LOCATE 11, 26: PRINT "MAGIC LIGHTNING!"
    LOCATE 12, 26: PRINT "Press any key..."
    LOCATE 11, 67: PRINT USING "####"; YouMagic(2)
    LOCATE 11, 71: PRINT "+1"
    g$ = INPUT$(1)
    LOCATE 11, 71: PRINT "  "
END IF



END SELECT

SaveBG 1, 6, 18, 14, 50, BG()

END SUB

SUB TunnelMovie (WAY)
IF PlayMovie THEN
    SELECT CASE WAY
    CASE 1
    COLOR , 0
    CLS
    FOR Col = 10 TO 70
        Delay .01, 0
        lct = (12 - 1) * 160 + ((Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 3, PlayerColor
            POKE lct + 2, 2
            POKE lct + 1, 0
            POKE lct, 32
        DEF SEG
        LOCATE 12, Col
        IF Col = 20 THEN PRINT "Y"
        IF Col = 22 THEN PRINT "o"
        IF Col = 24 THEN PRINT "u"
        IF Col = 28 THEN PRINT "a"
        IF Col = 30 THEN PRINT "r"
        IF Col = 32 THEN PRINT "e"
        IF Col = 36 THEN PRINT "i"
        IF Col = 38 THEN PRINT "n"
        IF Col = 42 THEN PRINT "t"
        IF Col = 44 THEN PRINT "h"
        IF Col = 46 THEN PRINT "e"
        IF Col = 50 THEN PRINT "t"
        IF Col = 52 THEN PRINT "u"
        IF Col = 54 THEN PRINT "n"
        IF Col = 56 THEN PRINT "n"
        IF Col = 58 THEN PRINT "e"
        IF Col = 60 THEN PRINT "l"
    NEXT Col
    CASE 0
    CLS
    FOR Col = 70 TO 10 STEP -1
        Delay .01, 0
        lct = 11 * 160 + ((Col - 1) * 2)
        DEF SEG = &HB800
            POKE lct + 1, PlayerColor
            POKE lct, 2
            POKE lct + 3, 0
            POKE lct + 2, 32
        DEF SEG
        LOCATE 12, Col + 1
        IF Col = 20 THEN PRINT "Y"
        IF Col = 22 THEN PRINT "o"
        IF Col = 24 THEN PRINT "u"
        IF Col = 28 THEN PRINT "a"
        IF Col = 30 THEN PRINT "r"
        IF Col = 32 THEN PRINT "e"
        IF Col = 36 THEN PRINT "i"
        IF Col = 38 THEN PRINT "n"
        IF Col = 42 THEN PRINT "t"
        IF Col = 44 THEN PRINT "h"
        IF Col = 46 THEN PRINT "e"
        IF Col = 50 THEN PRINT "t"
        IF Col = 52 THEN PRINT "u"
        IF Col = 54 THEN PRINT "n"
        IF Col = 56 THEN PRINT "n"
        IF Col = 58 THEN PRINT "e"
        IF Col = 60 THEN PRINT "l"
    NEXT Col
    Delay 1, 1
    END SELECT
END IF
END SUB

SUB Walls

IF Bana = 1 THEN WALLSFILE$ = "MAP1.MAP"
IF Bana = 2 THEN WALLSFILE$ = "MAP2.MAP"
IF Bana = 3 THEN WALLSFILE$ = "MAP3.MAP"
IF Bana = 4 THEN WALLSFILE$ = "MAP4.MAP"
IF Bana = 5 THEN WALLSFILE$ = "TRAIN.MAP"
IF Bana = 6 THEN WALLSFILE$ = "MAP5.MAP"

OPEN WALLSFILE$ FOR INPUT AS #1
FOR format = 1 TO MAXROW
        INPUT #1, partOfFormat$
        formatstring$ = formatstring$ + partOfFormat$
NEXT format
CLOSE #1

FOR r = 1 TO MAXROW
        FOR c = 1 TO MAXCOL
                i = i + 1
                area(r, c) = VAL(MID$(formatstring$, i, 1))
                IF Load = TRUE THEN
                ELSE
                    IF area(r, c) = PLAYER THEN pRow = r: pCol = c
                END IF
        NEXT c
NEXT r

IF Bana = 2 THEN
    area(HouseRow, HouseCol) = house
END IF
IF Bana = 4 THEN
    area(MarketRow, MarketCol) = MarketPlace
END IF
IF Bana = 6 THEN
    area(OldHouseRow, OldHouseCol) = OldHouse
END IF
END SUB

SUB WeaponChange

DIM BG(1 TO 24, 1 TO 80, 0 TO 1)
SaveBG 0, 1, 1, 24, 80, BG()
Box 7, 25, 18, 70, 0, 1, 1, ForeGround, 0

LOCATE 8, 27: PRINT "Weapon: " + WeaponType(User)
LOCATE 8, 53: PRINT "Attack / Defence"
IF Itemn(3) = 1 THEN
    LOCATE 9, 27: PRINT "1 " + WeaponType(1)
    LOCATE 9, 58: PRINT "7 / 7"
END IF

IF Itemn(4) = 1 THEN
    LOCATE 10, 27: PRINT "2 " + WeaponType(2)
    LOCATE 10, 57: PRINT "13 / 13"
END IF

IF Itemn(5) = 1 THEN
    LOCATE 11, 27: PRINT "3 " + WeaponType(3)
    LOCATE 11, 57: PRINT "30 / 20"
END IF

IF Itemn(8) = 1 THEN
    LOCATE 12, 27: PRINT "4 " + WeaponType(4)
    LOCATE 12, 57: PRINT "50 / 30"
END IF

IF Itemn(9) = 1 THEN
    LOCATE 13, 27: PRINT "5 " + WeaponType(5)
    LOCATE 13, 57: PRINT "80 / 40"
END IF

IF Itemn(11) = 1 THEN
    LOCATE 14, 27: PRINT "6 " + WeaponType(6)
    LOCATE 14, 56: PRINT "400 / 300"
END IF

LOCATE 15, 27: PRINT "0 cancels"

WeaponChangeStart:
Choise = 0
KeyPressed = FALSE
DO
    SELECT CASE INKEY$
    CASE "0"
        KeyPressed = TRUE
        GOTO EndSub
    CASE "1"
        KeyPressed = TRUE
        Choise = 1
    CASE "2"
        KeyPressed = TRUE
        Choise = 2
    CASE "3"
        KeyPressed = TRUE
        Choise = 3
    CASE "4"
        KeyPressed = TRUE
        Choise = 4
    CASE "5"
        KeyPressed = TRUE
        Choise = 5
    CASE "6"
        KeyPressed = TRUE
        Choise = 6
    END SELECT
LOOP UNTIL KeyPressed
SELECT CASE Choise
CASE 1
    IF Itemn(3) = 1 THEN
        User = 1
        GOTO EndSub
    ELSE
        GOTO DontHave
    END IF
CASE 2
    IF Itemn(4) = 1 THEN
        User = 2
        GOTO EndSub
    ELSE
        GOTO DontHave
    END IF
CASE 3
    IF Itemn(5) = 1 THEN
        User = 3
        GOTO EndSub
    ELSE
        GOTO DontHave
    END IF
CASE 4
    IF Itemn(8) = 1 THEN
        User = 4
        GOTO EndSub
    ELSE
        GOTO DontHave
    END IF
CASE 5
    IF Itemn(9) = 1 THEN
        User = 5
        GOTO EndSub
    ELSE
        GOTO DontHave
    END IF
CASE 6
    IF Itemn(11) = 1 THEN
        User = 6
        GOTO EndSub
    ELSE
        GOTO DontHave
    END IF

END SELECT

DontHave:
LOCATE 16, 27: PRINT "You don't have that"
g$ = INPUT$(1)
LOCATE 16, 27: PRINT "                   "
GOTO WeaponChangeStart

EndSub:
SaveBG 1, 1, 1, 24, 80, BG()
ERASE BG
END SUB

