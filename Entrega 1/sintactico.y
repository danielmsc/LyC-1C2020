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
programa: bloquedef bloquemain {printf("Regla 1: <programa> ::= <bloquedef> <bloquemain>\nCompilacion realizada con exito.\n");};

bloquedef: DEFVAR bloquevar ENDDEF {printf("Regla 2: <bloquedef> ::= DEFVAR <bloquevar> ENDDEF\n");}
			| DEFVAR ENDDEF {printf("Regla 3: <bloquedef> ::= DEFVAR ENDDEF\n");};
			
bloquevar: declaracion {printf("Regla 4: <bloquevar> ::= <declaracion>\n");}
			| bloquevar declaracion {printf("Regla 5: <bloquevar> ::= <bloquevar> <declaracion>\n");};

declaracion:	INT OP_DEF listadef {printf("Regla 6: <declaracion> ::= INT OP_DEF <listadef>\n");}
				| STRING OP_DEF listadef {printf("Regla 7: <declaracion> ::= STRING OP_DEF <listadef>\n");}
				| FLOAT OP_DEF listadef {printf("Regla 8: <declaracion> ::= FLOAT OP_DEF listadef\n");};
				
listadef:  ID {printf("Regla 9: <listadef> ::= ID\n");}
			| listadef PYC ID {printf("Regla 10: <listadef> ::= <listadef> PYC ID\n");};

bloquemain: sentencia {printf("Regla 11: <bloquemain> ::= <sentencia>\n");}
			| bloquemain sentencia {printf("Regla 12: <bloquemain> ::= <bloquemain> <sentencia>\n");};
			
sentencia: asignacion {printf("Regla 13: <sentencia> ::= <asignacion>\n");}
			| ciclo {printf("Regla 14: <sentencia> ::= <ciclo>\n");}
			| seleccion {printf("Regla 15: <sentencia> ::= <seleccion>\n");}
			| unario {printf("Regla 16: <sentencia> ::= <unario>\n");}
			| display {printf("Regla 17: <sentencia> ::= <display>\n");}
			| get {printf("Regla 18: <sentencia> ::= <get>\n");};

asignacion: ID OP_ASIG expresion {printf("Regla 19: <asignacion> ::= ID OP_ASIG <expresion>\n");}
			| ID OP_ASIG CONS_STRING {printf("Regla 20: <asignacion> ::= ID OP_ASIG CONS_STRING\n");};

expresion: expresion OP_SUM termino {printf("Regla 21: <expresion> ::= <expresion> OP_SUM <termino>\n");}
			| expresion OP_RES termino {printf("Regla 22: <expresion> ::= <expresion> OP_RES <termino>\n");}
			| termino {printf("Regla 23: <expresion> ::= <termino>\n");};
			
termino: termino OP_MUL factor {printf("Regla 24: <termino> ::= <termino> OP_MUL <factor>\n");}
		 | termino OP_DIV factor {printf("Regla 25: <termino> ::= <termino> OP_DIV <factor>\n");}
		 | factor {printf("Regla 26: <termino> ::= <factor>\n");};
		 
factor: ID {printf("Regla 27: <factor> ::= ID\n");}
		| CONS_ENTERO {printf("Regla 28: <factor> ::= CONS_ENTERO\n");}
		| CONS_REAL {printf("Regla 29: <factor> ::= CONS_REAL\n");}
		| PAR_A expresion PAR_C {printf("Regla 30: <factor> ::= PAR_A <expresion> PAR_C\n");}
		| factorial {printf("Regla 31: <factor> ::= <factorial>\n");}
		| combinatoria {printf("Regla 32: <factor> ::= <combinatoria>\n");};
		
combinatoria: COMB PAR_A expresion COMA expresion PAR_C {printf("Regla 33: <combinatoria> ::= COMB PAR_A <expresion> COMA <expresion> PAR_C\n");};

factorial: FACT PAR_A expresion PAR_C {printf("Regla 34: <factorial> ::= FACT PAR_A <expresion> PAR_C\n");};

ciclo: WHILE PAR_A condicion PAR_C bloquemain ENDWHILE {printf("Regla 35: <ciclo> ::= WHILE PAR_A <condicion> PAR_C <bloquemain> ENDWHILE\n");};

seleccion: IF PAR_A condicion PAR_C bloquemain ENDIF {printf("Regla 36: <seleccion> ::= IF PAR_A <condicion> PAR_C <bloquemain> ENDIF\n");};

condicion: argumento {printf("Regla 37: <condicion> ::= <argumento>\n");}
			| NOT argumento {printf("Regla 38: <condicion> ::= NOT argumento\n");}
			| argumento AND argumento {printf("Regla 39: <condicion> ::= <argumento> AND <argumento>\n");}
			| argumento OR  argumento {printf("Regla 40: <condicion> ::= <argumento> OR  <argumento>\n");};

argumento: expresion operador expresion {printf("Regla 41: <argumento> ::= <expresion> <operador> <expresion>\n");};
			
operador: OP_LT {printf("Regla 42: <operador> ::= OP_LT\n");}
			| OP_GT {printf("Regla 43: <operador> ::= OP_GT\n");}
			| OP_EQ {printf("Regla 44: <operador> ::= OP_EQ\n");}
			| OP_LE {printf("Regla 45: <operador> ::= OP_LE\n");}
			| OP_GE {printf("Regla 46: <operador> ::= OP_GE\n");}
			| OP_NE {printf("Regla 47: <operador> ::= OP_NE\n");};
		
unario: ID OP_ASIG IF PAR_A condicion COMA expresion COMA expresion PAR_C {printf("Regla 48: <unario> ::= ID OP_ASIG IF PAR_A <condicion> COMA <expresion> COMA <expresion> PAR_C\n");};

display: DISPLAY ID {printf("Regla 49: <display> ::= DISPLAY ID\n");}	
		 | DISPLAY CONS_STRING {printf("Regla 50: <display> ::= DISPLAY CONS_STRING\n");};

get: GET ID {printf("Regla 51: <get> ::= GET ID\n");};
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
