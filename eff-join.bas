DECLARE FUNCTION nospc$ (s$)
DECLARE FUNCTION crc (a AS INTEGER)
DEFLNG L
null$ = CHR$(0)

CLS
INPUT "PIC file(common part)"; f1$
INPUT "Range start"; r1
INPUT "Range end"; r2
INPUT "WMP file"; f2$
f2$ = f2$ + ".wmp"

PRINT "Reading . . ."
OPEN "B", #1, nospc$(f1$ + STR$(r1) + ".pic")
SEEK #1, 1
xx$ = INPUT$(2, #1)
SEEK #1, 3
yy$ = INPUT$(2, #1)
CLOSE #1
OPEN "B", #1, f2$
ss = ABS(r2 - r1) + 1
ss1 = crc(ss - 255)
ss2 = ss - ss1
wrt$ = CHR$(ss1) + CHR$(ss2)
SEEK #1, 1
PUT #1, 1, wrt$
wrt$ = xx$ + yy$
SEEK #1, 3
PUT #1, 3, wrt$
ps = 7
lx = ASC(LEFT$(xx$, 1)) + ASC(RIGHT$(xx$, 1))
ly = ASC(LEFT$(yy$, 1)) + ASC(RIGHT$(yy$, 1))
lll = lx * ly + 4
PRINT "Joining PIC files into WMP file . . ."
FOR i = r1 TO r2 STEP SGN(r2 - r1)
OPEN "B", #2, nospc$(f1$ + STR$(i) + ".pic")
        FOR j = 5 TO LOF(2)'lll
        SEEK #2, j
        read$ = INPUT$(1, #2)
        SEEK #1, ps
        PUT #1, ps, read$
        ps = ps + 1
        NEXT
CLOSE #2
NEXT
PRINT "Done."
PRINT ""

SCREEN 13

'check
INPUT "Movie file name"; ff$
INPUT "Time gap"; t

OPEN "B", #3, ff$ + ".wmp"
SEEK #3, 1
read$ = INPUT$(2, #3)
ss = ASC(LEFT$(read$, 1)) + ASC(RIGHT$(read$, 1))

SEEK #3, 3
read$ = INPUT$(2, #3)
xx = ASC(LEFT$(read$, 1)) + ASC(RIGHT$(read$, 1))
SEEK #3, 5
read$ = INPUT$(2, #3)
yy = ASC(LEFT$(read$, 1)) + ASC(RIGHT$(read$, 1))

CLS
SCREEN 13

FOR i = 1 TO ss
FOR y = yy TO 0 STEP -1
FOR x = 0 TO xx
cl = ASC(INPUT$(1, #3) + null$)
LINE (x, y)-(x, y), cl
NEXT
NEXT
BEEP'SOUND 21000, t
NEXT

CLOSE #3
SYSTEM

DEFSNG L
FUNCTION crc (a AS INTEGER)
IF (a < 0) THEN crc = 0 ELSE crc = a
END FUNCTION

FUNCTION nospc$ (s$)
FOR i = 1 TO LEN(s$)
d$ = MID$(s$, i, 1)
IF (d$ <> " ") THEN b$ = b$ + d$
NEXT
nospc$ = b$
END FUNCTION

