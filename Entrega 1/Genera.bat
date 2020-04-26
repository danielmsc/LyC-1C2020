flex lexico.l
pause
bison -dyv sintactico.y
pause
gcc lex.yy.c y.tab.c -o ejercicio.exe
pause
.\ejercicio.exe prueba.txt
pause
