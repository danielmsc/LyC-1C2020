%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

FILE *yyin;
FILE *ts;
extern int linea;
int indexter;
int Aind;
int Eind;
int Tind;
int Find;
int FACind;
int COMBind;
char auxchar[30];
char auxchar2[30];

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
int crearTerceto(char* ptr1, char* ptr2, char* ptr3);
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
%token WHILE ENDWHILE IF ELSE ENDIF
%token AND OR NOT
%token FACT COMB
%token PYC PAR_A PAR_C COMA
%token OP_DEF OP_SUM OP_RES OP_DIV OP_MUL
%token OP_LT OP_GT OP_EQ OP_LE OP_GE OP_NE

%locations

%%
programa: bloquedef { indexter = 0;} bloquemain {printf("Compilacion realizada con exito.\n");};

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

asignacion: ID OP_ASIG expresion 	{	
										if(validarTipos($1,2) || validarTipos($1,3))
										{ 
											sprintf(auxchar,"%d", Eind);
											Aind = crearTerceto(":=",$1, auxchar);
										}else
										{
											printf("Error: Asignacion de un FLOAT o INT a un string\n");
											yyerror();
										};
									}
			| ID OP_ASIG CONS_CAD 	{
										if(validarTipos($1,1))
										{ 
											Aind = crearTerceto(":=",$1, $3);
										}else
										{
											printf("Error: Asignacion de un STRING a un FLOAT o INT\n");
											yyerror();
										};
									};

expresion: expresion OP_SUM termino {
										sprintf(auxchar,"%d", Eind);
										sprintf(auxchar2,"%d", Tind);
										Eind = crearTerceto("+",auxchar, auxchar2);
									}	
			| expresion OP_RES termino {
											sprintf(auxchar,"%d", Eind);
											sprintf(auxchar2,"%d", Tind);
											Eind = crearTerceto("-",auxchar, auxchar2);
										}	
			| termino {
							Eind = Tind  ;
						};
			
termino: termino OP_MUL factor {
									sprintf(auxchar,"%d", Tind);
									sprintf(auxchar2,"%d", Find);
									Tind = crearTerceto("*", auxchar,  auxchar2);
								}
		 | termino OP_DIV factor 	{
										sprintf(auxchar,"%d", Tind);
										sprintf(auxchar2,"%d", Find);
										Tind = crearTerceto("/", auxchar,  auxchar2);
									}
		 | factor 	{
						Tind = Find ;
					}
				;
		 
factor: ID {
				Find = crearTerceto($1, " ", " ");
			}	
		| CONS_ENTERO 	{
							sprintf(auxchar,"%d", $1);
							Find = crearTerceto(auxchar, " ", " ");
						}
		| CONS_FLO 	{
						sprintf(auxchar,"%f", $1);
						Find = crearTerceto(auxchar, " ", " ");
					}
		| PAR_A expresion PAR_C 
		| factorial 
		| combinatoria;
		
combinatoria: COMB PAR_A expresion COMA expresion PAR_C ;

factorial: FACT PAR_A expresion PAR_C ;

ciclo: WHILE PAR_A condicion PAR_C bloquemain ENDWHILE ;

seleccion: IF PAR_A condicion PAR_C bloquemain ELSE bloquemain ENDIF
			|IF PAR_A condicion PAR_C bloquemain ENDIF;

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

int crearTerceto(char* ptr1, char* ptr2, char* ptr3)
{
	FILE *at;
	
	if ((at = fopen("tercetos.txt", "a")) == NULL)
	{
		printf("No se pudo crear el archivo tercetos.txt\n");
	}
	else 
	{
		 indexter++;
		 fprintf(at, "[%d] (%s,%s,%s)\n",indexter, ptr1, ptr2, ptr3);
	}
	
	fclose(at);
	return indexter;
}













