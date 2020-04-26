%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

FILE *yyin;
FILE *ts;

int crearTS();

%}

%token DEFVAR ENDDEF
%token CONS_REAL CONS_ENTERO CONS_STRING ID
%token FLOAT INT STRING
%token DISPLAY GET
%token WHILE ENDWHILE IF ENDIF
%token AND OR NOT
%token FACT COMB
%token PYC PAR_A PAR_C COMA
%token OP_DEF OP_ASIG OP_SUM OP_RES OP_DIV OP_MUL
%token OP_LT OP_GT OP_EQ OP_LE OP_GE OP_NE

%%
programa: bloquedef bloquemain;

bloquedef: DEFVAR bloquevar ENDDEF
			| DEFVAR ENDDEF;
			
bloquevar: declaracion
			| bloquevar declaracion;

declaracion:	INT OP_DEF listadef
				| STRING OP_DEF listadef
				| FLOAT OP_DEF listadef;
				
listadef:  ID
			| listadef PYC ID;

bloquemain: sentencia
			| bloquemain sentencia;
			
sentencia: asignacion
			| ciclo
			| seleccion
			| unario
			| display
			| get;

asignacion: ID OP_ASIG expresion
			| ID OP_ASIG CONS_STRING;

expresion: expresion OP_SUM termino
			| expresion OP_RES termino
			| termino;
			
termino: termino OP_MUL factor
		 | termino OP_DIV factor
		 | factor;
		 
factor: ID
		| CONS_ENTERO
		| CONS_REAL
		| PAR_A expresion PAR_C
		| factorial
		| combinatoria;
		
combinatoria: COMB PAR_A expresion COMA expresion PAR_C;

factorial: FACT PAR_A expresion PAR_C;

ciclo: WHILE PAR_A condicion PAR_C bloquemain ENDWHILE;

seleccion: IF PAR_A condicion PAR_C bloquemain ENDIF;

condicion: argumento
			| NOT argumento
			| argumento AND argumento
			| argumento OR  argumento;

argumento: expresion operador expresion;
			
operador: OP_LT
			| OP_GT
			| OP_EQ
			| OP_LE
			| OP_GE
			| OP_NE;
		
unario: ID OP_ASIG IF PAR_A condicion COMA expresion COMA expresion PAR_C;

display: DISPLAY ID	
		 | DISPLAY CONS_STRING;

get: GET ID;
%%

int main(int argc,char *argv[])
{
	if ((yyin = fopen(argv[1], "rt")) == NULL)
	{
		printf("No se puede abrir el archivo: %s", argv[1]);
		return 1; 
	}
	else
	{
		if (crearTS()) 
		{
			yyparse();
		}
		else 
		{
			return 2;
		}
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

int crearTS()
{
	if ((ts = fopen("ts.txt", "w")) == NULL)
	{
		printf("No se puede abrir el archivo ts.txt");
		return 0;
	}
	else 
	{
		fprintf(ts, "%s\t%s\t%s\t%s", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");
	}
	fclose(ts);
	return 1;
}