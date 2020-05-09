flex lexico.l
pause
bison -dyv sintactico.y
pause
gcc lex.yy.c y.tab.c -o Segunda.exe
pause
.\Segunda.exe p.txt
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause