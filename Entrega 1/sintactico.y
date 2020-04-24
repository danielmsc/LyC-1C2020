%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
FILE  *yyin;
%}


%%

DEFVAR
	FLOAT : a1; b1
	STRING: variable1
	FLOAT : p1; p2; p3
	INT : a;b
ENDDEF
Asignacion Simple :=
WHILE ( AND OR NOT ){}
IF ( AND OR NOT ) {}
comen
ID = IF (,,)
FACT (Expresion)
COMB (Expresión,Expresión)



programa: DIGITO {printf("El numero es: %d\n", yylval.number);}
		| PALABRA {printf("La palabra es: %s\n", yylval.string);};
		
		
		
		
%%
int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	yyparse();
  }
  fclose(yyin);
  return 0;
}

int yyerror(void)
{
    printf("Syntax Error\n");
	system ("Pause");
	exit (1);
}

