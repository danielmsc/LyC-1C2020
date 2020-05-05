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
programa: bloquedef bloquemain {printf("Compilacion realizada con exito.\n");};

bloquedef: DEFVAR bloquevar ENDDEF 
			| DEFVAR ENDDEF ;
			
bloquevar: declaracion 
			| bloquevar declaracion ;

declaracion:	INT OP_DEF listadef 
				| STRING OP_DEF listadef 
				| FLOAT OP_DEF listadef ;
				
listadef:  ID 
			| listadef PYC ID ;

bloquemain: sentencia 
			| bloquemain sentencia ;
			
sentencia: asignacion 
			| ciclo 
			| seleccion 
			| unario 
			| display 
			| get 
			| factorial 
			| combinatoria ;

asignacion: ID OP_ASIG expresion {if(validarTipos($1,2) || validarTipos($1,3)){ ;}else{printf("Error: Asignacion de un FLOAT o INT a un string\n");yyerror();};}
			| ID OP_ASIG CONS_CAD {if(validarTipos($1,1)){ }else{printf("Error: Asignacion de un STRING a un FLOAT o INT\n");yyerror();};};

expresion: expresion OP_SUM termino 
			| expresion OP_RES termino 
			| termino ;
			
termino: termino OP_MUL factor 
		 | termino OP_DIV factor 
		 | factor ;
		 
factor: ID 
		| CONS_ENTERO 
		| CONS_FLO 
		| PAR_A expresion PAR_C 
		| factorial 
		| combinatoria;
		
combinatoria: COMB PAR_A expresion COMA expresion PAR_C ;

factorial: FACT PAR_A expresion PAR_C ;

ciclo: WHILE PAR_A condicion PAR_C bloquemain ENDWHILE ;

seleccion: IF PAR_A condicion PAR_C bloquemain ENDIF ;

condicion: argumento 
			| NOT argumento 
			| argumento AND argumento 
			| argumento OR  argumento ;

argumento: expresion operador expresion ;
			
operador: OP_LT 
			| OP_GT 
			| OP_EQ 
			| OP_LE 
			| OP_GE 
			| OP_NE ;
		
unario: ID OP_ASIG IF PAR_A condicion COMA expresion COMA expresion PAR_C ;

display: DISPLAY ID 	
		 | DISPLAY CONS_CAD ;

get: GET ID ;
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












