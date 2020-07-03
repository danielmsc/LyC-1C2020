flex lexico.l
pause
bison -dyv sintactico.y
pause
gcc lex.yy.c y.tab.c -o Tercera.exe
pause
.\Tercera.exe prueba.txt
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause