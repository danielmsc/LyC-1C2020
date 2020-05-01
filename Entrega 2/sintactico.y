%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

FILE *yyin;
FILE *ts;
extern int linea;

typedef struct filaTS {
	char nombre[50];
	char tipo[50];
} filaTS;

filaTS regTS;

int yylex();
int yyerror();
int crearTS();
int validarTipos(char *id, int tipo);
void buscarTipoEnTS(char *id);
%}

%union
{
	char *id;
	float flo;
	int ent;
	char *cad;
}

%right OP_ASIG
%token DEFVAR ENDDEF
%token <flo>CONS_FLO <ent>CONS_ENTERO <cad>CONS_CAD <id>ID
%token FLOAT INT STRING
%token DISPLAY GET
%token WHILE ENDWHILE IF ENDIF
%token AND OR NOT
%token FACT COMB
%token PYC PAR_A PAR_C COMA
%token OP_DEF OP_SUM OP_RES OP_DIV OP_MUL
%token OP_LT OP_GT OP_EQ OP_LE OP_GE OP_NE

%locations

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
			| factorial {printf("Regla 19: <sentencia> ::= <factorial>\n");};
			| combinatoria {printf("Regla 20: <sentencia> ::= <combinatoria>\n");};

asignacion: ID OP_ASIG expresion {if(validarTipos($1,2) || validarTipos($1,3)){printf("Regla 21 <asignacion> ::= ID OP_ASIG <expresion>\n");}else{printf("Error: Asignacion de un FLOAT o INT a un string\n");yyerror();};}
			| ID OP_ASIG CONS_CAD {if(validarTipos($1,1)){printf("Regla 22: <asignacion> ::= ID OP_ASIG CONS_CAD\n");}else{printf("Error: Asignacion de un STRING a un FLOAT o INT\n");yyerror();};};

expresion: expresion OP_SUM termino {printf("Regla 23: <expresion> ::= <expresion> OP_SUM <termino>\n");}
			| expresion OP_RES termino {printf("Regla 24: <expresion> ::= <expresion> OP_RES <termino>\n");}
			| termino {printf("Regla 25: <expresion> ::= <termino>\n");};
			
termino: termino OP_MUL factor {printf("Regla 26: <termino> ::= <termino> OP_MUL <factor>\n");}
		 | termino OP_DIV factor {printf("Regla 27: <termino> ::= <termino> OP_DIV <factor>\n");}
		 | factor {printf("Regla 28: <termino> ::= <factor>\n");};
		 
factor: ID { printf("Regla 29: <factor> ::= ID\n"); }
		| CONS_ENTERO { printf("Regla 30: <factor> ::= CONS_ENTERO\n");} 
		| CONS_FLO { printf("Regla 31: <factor> ::= CONS_FLO\n");} 
		| PAR_A expresion PAR_C {printf("Regla 32: <factor> ::= PAR_A <expresion> PAR_C\n");}
		| factorial {printf("Regla 33: <factor> ::= <factorial>\n");}
		| combinatoria {printf("Regla 34: <factor> ::= <combinatoria>\n");};
		
combinatoria: COMB PAR_A expresion COMA expresion PAR_C {printf("Regla 35: <combinatoria> ::= COMB PAR_A <expresion> COMA <expresion> PAR_C\n");};

factorial: FACT PAR_A expresion PAR_C {printf("Regla 36: <factorial> ::= FACT PAR_A <expresion> PAR_C\n");};

ciclo: WHILE PAR_A condicion PAR_C bloquemain ENDWHILE {printf("Regla 37: <ciclo> ::= WHILE PAR_A <condicion> PAR_C <bloquemain> ENDWHILE\n");};

seleccion: IF PAR_A condicion PAR_C bloquemain ENDIF {printf("Regla 38: <seleccion> ::= IF PAR_A <condicion> PAR_C <bloquemain> ENDIF\n");};

condicion: argumento {printf("Regla 39: <condicion> ::= <argumento>\n");}
			| NOT argumento {printf("Regla 40: <condicion> ::= NOT argumento\n");}
			| argumento AND argumento {printf("Regla 41: <condicion> ::= <argumento> AND <argumento>\n");}
			| argumento OR  argumento {printf("Regla 42: <condicion> ::= <argumento> OR  <argumento>\n");};

argumento: expresion operador expresion {printf("Regla 43: <argumento> ::= <expresion> <operador> <expresion>\n");};
			
operador: OP_LT {printf("Regla 44: <operador> ::= OP_LT\n");}
			| OP_GT {printf("Regla 45: <operador> ::= OP_GT\n");}
			| OP_EQ {printf("Regla 46: <operador> ::= OP_EQ\n");}
			| OP_LE {printf("Regla 47: <operador> ::= OP_LE\n");}
			| OP_GE {printf("Regla 48: <operador> ::= OP_GE\n");}
			| OP_NE {printf("Regla 49: <operador> ::= OP_NE\n");};
		
unario: ID OP_ASIG IF PAR_A condicion COMA expresion COMA expresion PAR_C {printf("Regla 50: <unario> ::= ID OP_ASIG IF PAR_A <condicion> COMA <expresion> COMA <expresion> PAR_C\n");};

display: DISPLAY ID {printf("Regla 51: <display> ::= DISPLAY ID\n");}	
		 | DISPLAY CONS_CAD {printf("Regla 52: <display> ::= DISPLAY CONS_CAD\n");};

get: GET ID {printf("Regla 53: <get> ::= GET ID\n");};
%%

int main(int argc, char *argv[])
{
	if ((yyin = fopen(argv[1], "rt")) == NULL)
	{
		printf("No se puede abrir el archivo: %s\n", argv[1]);
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

int yyerror()
{
    printf("Syntax Error - Linea %d\n", linea);
    system ("Pause");
    exit (1);
}

int crearTS()
{
	if ((ts = fopen("ts.txt", "w")) == NULL)
	{
		printf("No se puede abrir el archivo ts.txt\n");
		return 0;
	}
	else 
	{
		fprintf(ts, "%s\n", "NOMBRE                          |TIPODATO                        |VALOR                           |LONGITUD");
		fprintf(ts, "%s\n", "-----------------------------------------------------------------------------------------------------------");
	}
	fclose(ts);
	return 1;
}

int validarTipos(char *id, int tipo) 
{
	buscarTipoEnTS(id);
	
	if (tipo == 1)
	{
		if (strcmp(regTS.tipo, "STRING") == 0) return 1;
		else return 0;
	}
	else if (tipo == 2) 
	{ 
		if (strcmp(regTS.tipo, "INT") == 0) return 1;
		else return 0; 
	}
	else if (tipo == 3) 
	{ 
		if (strcmp(regTS.tipo, "FLOAT") == 0) return 1;
		else return 0; 
	}
}

void buscarTipoEnTS(char *id)
{
	FILE *ts;
	int linea = 1;
    char strLinea[200];
	
	if ((ts = fopen("ts.txt", "r")) == NULL)
	{
		printf("No se puede abrir el archivo ts.txt\n");
	}
	else 
	{
		while(fgets(strLinea, 200, ts) != NULL) 
		{
			if (linea != 1 && linea != 2 && strLinea[0] != '_') 
			{
				sscanf(strLinea, "%s | %s", regTS.nombre, regTS.tipo);
				if (strcmp(id, regTS.nombre) == 0)
				{
					break;
				}	
			}
			linea++;
		}
	}
	
	fclose(ts);
}












