%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

FILE *yyin;
FILE *ts;
int AuxIndiceProximo; // 1 Si es Factor, 2 si es termino, 3 si es expresion.
extern int linea;
int indexter;
int proximoTerceto;
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

typedef int t_dato;

typedef struct s_nodo{
    t_dato dato;
    struct s_nodo *sig;
} t_nodo;

typedef t_nodo* t_pila;

typedef struct t_proximoTerceto {
	int proximoTerceto;
	int	auxproximoTerceto;
	int parentesis;
} t_proximoTerceto;

typedef t_proximoTerceto t_dato_terceto;

typedef struct s_nodo_terceto{
    t_dato_terceto dato;
    struct s_nodo_terceto *sig;
} t_nodo_terceto;

typedef t_nodo_terceto* t_pilaTerceto;

t_pilaTerceto pilaAuxTerceto;

t_pila pilaIndices;

t_dato_terceto auxTerceto;

int parentesis;

void crearPila(t_pila *p);
void crearPilaTerceto(t_pilaTerceto *p);
int pilaVacia(const t_pila *p);
int apilar(t_pila *p, const t_dato *d);
int desapilar(t_pila *p, t_dato *d);
int apilarTerceto(t_pilaTerceto *p, const t_dato_terceto *d);
int desapilarTerceto(t_pilaTerceto *p, t_dato_terceto *d);
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
programa: bloquedef { indexter = 0; proximoTerceto = 0;  Eind = 1; Tind = 1; Find = 1; parentesis = 0; crearPilaTerceto( &pilaAuxTerceto);  crearPila( &pilaIndices);  } bloquemain {printf("Compilacion realizada con exito.\n");};

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
			| get;

asignacion: ID OP_ASIG expresion 	{	
										if(validarTipos($1,2) || validarTipos($1,3))
										{ 
											sprintf(auxchar,"[%d]", Eind);
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
										if( proximoTerceto != 0)
										{
											switch(AuxIndiceProximo)
											{
												case 2:
													sprintf(auxchar,"[%d]", Eind);
													sprintf(auxchar2,"[%d]", proximoTerceto);
													break;
												case 3:
													sprintf(auxchar,"[%d]", proximoTerceto);
													sprintf(auxchar2,"[%d]", Tind);
													break;
											}
										}else
										{
											sprintf(auxchar,"[%d]", Eind);
											sprintf(auxchar2,"[%d]", Tind);
										}
										proximoTerceto = 0;
										Eind = crearTerceto("+",auxchar, auxchar2);
									}	
			| expresion OP_RES termino {
											if( proximoTerceto != 0)
											{
												switch(AuxIndiceProximo)
												{
													case 2:
														sprintf(auxchar,"[%d]", Eind);
														sprintf(auxchar2,"[%d]", proximoTerceto);
														break;
													case 3:
														sprintf(auxchar,"[%d]", proximoTerceto);
														sprintf(auxchar2,"[%d]", Tind);
														break;
												}
											}else
											{
												sprintf(auxchar,"[%d]", Eind);
												sprintf(auxchar2,"[%d]", Tind);
											}
											proximoTerceto = 0;
											Eind = crearTerceto("-",auxchar, auxchar2);
										}	
			| termino {
							Eind = Tind;
							if( proximoTerceto != 0)
							{
								AuxIndiceProximo = 3;
							}
						};
			
termino: termino OP_MUL factor {
									if( proximoTerceto != 0)
									{
										switch(AuxIndiceProximo)
										{
											case 1:
												sprintf(auxchar,"[%d]", Tind);
												sprintf(auxchar2,"[%d]", proximoTerceto);
												break;
											case 2:
												sprintf(auxchar,"[%d]", proximoTerceto);
												sprintf(auxchar2,"[%d]", Find);
												break;
										}
									}else
									{
										sprintf(auxchar,"[%d]", Tind);
										sprintf(auxchar2,"[%d]", Find);
									}
									proximoTerceto = 0;
									Tind = crearTerceto("*", auxchar,  auxchar2);
								}
		 | termino OP_DIV factor 	{
										if( proximoTerceto != 0)
										{
											switch(AuxIndiceProximo)
											{
												case 1:
													sprintf(auxchar,"[%d]", Tind);
													sprintf(auxchar2,"[%d]", proximoTerceto);
													break;
												case 2:
													sprintf(auxchar,"[%d]", proximoTerceto);
													sprintf(auxchar2,"[%d]", Find);
													break;
											}
										}else
										{
											sprintf(auxchar,"[%d]", Tind);
											sprintf(auxchar2,"[%d]", Find);
										}
										proximoTerceto = 0;
										Tind = crearTerceto("/", auxchar,  auxchar2);
									}
		 | factor 	{
						Tind = Find ;
						if( proximoTerceto != 0 && AuxIndiceProximo < 2 )
						{
							AuxIndiceProximo = 2;
						}
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
		| PAR_A 		{ 	
							if(parentesis > 0 && proximoTerceto == 0)
							{
								parentesis++;
							}
							if( proximoTerceto != 0 )
							{
								auxTerceto.proximoTerceto    = proximoTerceto;
								auxTerceto.auxproximoTerceto = AuxIndiceProximo;
								auxTerceto.parentesis = parentesis;
								apilarTerceto( &pilaAuxTerceto, &auxTerceto);
								parentesis = 1;
								proximoTerceto = 0;
							}
							
							apilar( &pilaIndices, &Eind);
							apilar( &pilaIndices, &Tind);
							apilar( &pilaIndices, &Find);
						} 
		expresion PAR_C {
							desapilar( &pilaIndices, &Find);
							desapilar( &pilaIndices, &Tind);
							desapilar( &pilaIndices, &Eind);
							parentesis--;
							if(parentesis == 0)
							{
								desapilarTerceto(&pilaAuxTerceto, &auxTerceto);
								proximoTerceto = auxTerceto.proximoTerceto;
								AuxIndiceProximo = auxTerceto.auxproximoTerceto;
								parentesis	= auxTerceto.parentesis;
								Find = indexter;
								Tind = indexter;
							}else
							{
								proximoTerceto = indexter;
								AuxIndiceProximo = 1;
							}
						}
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

argumento: expresion operador expresion  ;
			
operador: OP_LT 
			| OP_GT 
			| OP_EQ 
			| OP_LE 
			| OP_GE 
			| OP_NE ;
		
unario: ID OP_ASIG IF PAR_A condicion COMA expresion COMA expresion PAR_C {  };

display: DISPLAY ID { crearTerceto( "DISPLAY", $2, ""); }
		 | DISPLAY CONS_CAD { crearTerceto( "DISPLAY", $2, ""); };

get: GET ID { crearTerceto( "=", $2, "INPUT"); } ;
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

void crearPilaTerceto(t_pilaTerceto *p)
{
    *p = NULL;
}

void crearPila(t_pila *p)
{
    *p = NULL;
}

int pilaVacia(const t_pila *p)
{
    return *p == NULL;
}


int apilar(t_pila *p, const t_dato *d)
{
    t_nodo *nue = (t_nodo *)malloc(sizeof(t_nodo));
    if(!nue)
        return 0;

    nue -> dato = *d;
    nue -> sig = *p;
    *p = nue;

    return 1;
}

int desapilar(t_pila *p, t_dato *d)
{
    t_nodo *aux = *p;

    if(!*p)
        return 0;

    *d = (*p) -> dato;
    *p = (*p) -> sig;
    free(aux);

    return 1;
}

int apilarTerceto(t_pilaTerceto *p, const t_dato_terceto *d)
{
    t_nodo_terceto *nue = (t_nodo_terceto *)malloc(sizeof(t_nodo_terceto));
    if(!nue)
        return 0;

    nue -> dato = *d;
    nue -> sig = *p;
    *p = nue;

    return 1;
}

int desapilarTerceto(t_pilaTerceto *p, t_dato_terceto *d)
{
    t_nodo_terceto *aux = *p;

    if(!*p)
        return 0;

    *d = (*p) -> dato;
    *p = (*p) -> sig;
    free(aux);

    return 1;
}



