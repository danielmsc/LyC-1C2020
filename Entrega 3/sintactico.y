%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

FILE *yyin;
FILE *ts;

// ESTRUCTURAS
typedef struct filaTS {
	char nombre[50];
	char tipo[50];
} filaTS;

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

typedef struct saltoCondicional{
	int tercetoACambiar;
	int tipoCondicion; // 1 Si es Simple, 2 si es AND, 3 Si es OR
	int segundoTerceto;
	int indexterjump;
}saltoCondicional;

typedef saltoCondicional t_dato_salto;

typedef struct s_nodo_salto{
    t_dato_salto dato;
    struct s_nodo_salto *sig;
} t_nodo_salto;

typedef t_nodo_salto* t_pilaSalto;

typedef struct listaEtiquetas {
	int numTerceto;
	char etiq[31];
} listaEtiquetas;

typedef listaEtiquetas t_dato_lista; 

typedef struct s_nodo_lista{
    t_dato_lista info;
	struct s_nodo_lista *sig;
} t_nodo_lista;

typedef t_nodo_lista* t_lista;

typedef int (*t_cmp) (const void*,const void*);

// LISTA DE TIPOS
typedef struct listaTS {
	char nom[32];
	char tipo[32];
	char valor[32];
	char longi[32];
} listaTS;

typedef listaTS t_dato_listaTS; 

typedef struct s_nodo_listaTS{
    t_dato_listaTS info;
	struct s_nodo_listaTS *sig;
} t_nodo_listaTS;

typedef t_nodo_listaTS* t_listaTS;

//typedef int (*t_cmp) (const void*,const void*);

// Lista campos terceto
typedef struct listaAux {
	int nroTerceto;
	char res[10];
	int tipo;
	int resuli;
	float resulf;
} listaAux;

typedef listaAux t_dato_listaAux; 

typedef struct s_nodo_listaAux{
    t_dato_listaAux info;
	struct s_nodo_listaAux *sig;
} t_nodo_listaAux;

typedef t_nodo_listaAux* t_listaAux;

//Cola
typedef struct datoCola
{
	char var[10];
	int tipo;
} datoCola;

typedef datoCola t_dato_cola;

typedef struct s_nodo_cola
{
    t_dato_cola info;
    struct s_nodo_cola *sig;
}t_nodo_cola;

typedef struct
{
    t_nodo_cola* fr; //Marca el frente.
    t_nodo_cola* fo; //Marca el fondo.
}t_cola;

//VARIABLES AUXILIARES
int AuxIndiceProximo; // 1 Si es Factor, 2 si es termino, 3 si es expresion.
extern int linea;
int indexter;
int indexterunario;
int indexterwhile;
int proximoTerceto;
int Aind;
int Eind;
int Tind;
int Find;
int FACind;
int COMBind;
int nCombinatoria;
int xCombinatoria;
int nFactorial;
int xFactorial;
int nxFactorial;
char auxchar[30];
char auxchar2[30];
char auxchar3[30];
int parentesis;
char opCond[6];
int notbandera;
filaTS regTS;
t_pilaTerceto pilaAuxTerceto;
t_pila pilaIndices;
t_pilaSalto pilaSalto;
t_dato_terceto auxTerceto;
t_dato_salto auxSalto;
t_dato_listaTS nodo;
t_listaTS pts;
t_listaAux pla;
t_lista pll;
t_cola cola;

//FUNCIONES
void crearPila(t_pila *p);
void crearPilaTerceto(t_pilaTerceto *p);
void crearPilaSalto(t_pilaSalto *p);

int pilaVacia(const t_pila *p);
int pilaSaltoVacia(const t_pilaSalto *p);

int apilar(t_pila *p, const t_dato *d);
int desapilar(t_pila *p, t_dato *d);

int apilarTerceto(t_pilaTerceto *p, const t_dato_terceto *d);
int desapilarTerceto(t_pilaTerceto *p, t_dato_terceto *d);

int apilarSalto(t_pilaSalto *p, const t_dato_salto *d);
int desapilarSalto(t_pilaSalto *p, t_dato_salto *d);

int yylex();
int yyerror();
int crearTS();
int validarTipos(char *id, int tipo);
void buscarTipoEnTS(char *id);
int crearTerceto(char* ptr1, char* ptr2, char* ptr3);
int actualizarTerceto(int numTerceto);
void funcionFactorial();
void guardarParentesisAbre();
void guardarParentesisCierra();
void generarAssembler();

void crear_lista (t_lista *pl);
int insertar_actualizar_en_lista_ord(t_lista *pl,const t_dato_lista* d, t_cmp cmp);
int buscar_en_lista_ord_rec(const t_lista* pl, t_dato_lista* d,t_cmp cmp);
int cmp_int (const void* pve1, const void* pve2);

void crear_listaTS(t_listaTS* pl);
int insertar_actualizar_en_lista_ordTS(t_listaTS* pl,const t_dato_listaTS* d);
int buscar_en_lista_ord_recTS(const t_listaTS* pl,t_dato_listaTS* d);

void crear_listaAux(t_listaAux* pl);
int insertar_actualizar_en_lista_ordAux(t_listaAux* pl,const t_dato_listaAux* d,t_cmp cmp);
int buscar_en_lista_ord_recAux(const t_listaAux* pl,t_dato_listaAux* d, t_cmp cmp);
int cmp_intAux(const void* pve1, const void* pve2);

void crear_cola(t_cola* pc);
int poner_en_cola(t_cola* pc, const t_dato_cola* d);
int sacar_de_cola(t_cola* pc,t_dato_cola* d);
int cola_vacia(const t_cola* pc);

int esVariable(char *var);
int esSalto(char *var);
int esOperador(char *var);

int verTipo(t_dato_listaTS *info);
void eliminarCorchetes(char *str);
void obtenerInstruccion(char *operador, int tipo);

int obtenerTipo(int tipo1, int tipo2);
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
programa: bloquedef { 	
						indexter = 0;
						proximoTerceto = 0;  
						Eind = 1; 
						Tind = 1; 
						Find = 1; 
						parentesis = 0;
						notbandera = 0;
						auxSalto.tercetoACambiar = -1;
						auxSalto.tipoCondicion = 0;
						auxSalto.segundoTerceto = -1;
						auxSalto.indexterjump = -1;
						crearPilaSalto(&pilaSalto);
						crearPilaTerceto( &pilaAuxTerceto);  
						crearPila( &pilaIndices);  
					} bloquemain {
						crearTerceto("MOV", "4c00h", "ax");
						printf("Compilacion realizada con exito.\n");
						generarAssembler();
					};

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
		| PAR_A 		{ guardarParentesisAbre(); } 
		expresion PAR_C { guardarParentesisCierra(); }
		| factorial 
		| combinatoria;
		
combinatoria: 	COMB PAR_A { guardarParentesisAbre(); }
				expresion { nCombinatoria = indexter; funcionFactorial(); nFactorial = indexter; }
				COMA
				expresion { xCombinatoria = indexter; funcionFactorial(); xFactorial = indexter;
							sprintf(auxchar,"[%d]", xCombinatoria);
							sprintf(auxchar2,"[%d]", nCombinatoria);
							crearTerceto("-", auxchar2, auxchar);
							funcionFactorial(); nxFactorial = indexter;
							sprintf(auxchar,"[%d]", xFactorial);
							sprintf(auxchar2,"[%d]", nxFactorial);
							crearTerceto("*", auxchar, auxchar2);
							sprintf(auxchar,"[%d]", nFactorial);
							sprintf(auxchar2,"[%d]", indexter);
							crearTerceto("/", auxchar, auxchar2);
							sprintf(auxchar,"[%d]", indexter);
							crearTerceto(":=", "@res", auxchar); }
				PAR_C { guardarParentesisCierra(); };

factorial: 	FACT PAR_A { guardarParentesisAbre(); } 
			expresion { funcionFactorial(); } 
			PAR_C { guardarParentesisCierra(); };

ciclo: WHILE PAR_A { 
						indexterwhile = indexter + 1;
						if(auxSalto.tercetoACambiar != -1){
							apilarSalto(&pilaSalto, &auxSalto);
						}
					} condiciones PAR_C { 
										if( auxSalto.tipoCondicion == 3)
										{
											actualizarTerceto(auxSalto.tercetoACambiar);
											actualizarTerceto( auxSalto.segundoTerceto );
										}
									 }bloquemain ENDWHILE { 															
															sprintf(auxchar3,"[%d]", indexterwhile);
															crearTerceto("JMP", auxchar3, " " );
															
															if( auxSalto.tipoCondicion == 1)
															{
																actualizarTerceto(auxSalto.tercetoACambiar);
															}else if( auxSalto.tipoCondicion == 2){
																actualizarTerceto(auxSalto.tercetoACambiar);
																actualizarTerceto(auxSalto.segundoTerceto );
															}else if( auxSalto.tipoCondicion == 3){
																	actualizarTerceto(auxSalto.segundoTerceto + 1 );
															}
															
															if(pilaSaltoVacia(&pilaSalto) == 0){
																desapilarSalto(&pilaSalto, &auxSalto);
															}else{
																auxSalto.tercetoACambiar = -1; 
																auxSalto.tipoCondicion = 0; 
															}
														}
		| WHILE PAR_A NOT { 
							indexterwhile = indexter + 1;
							if(auxSalto.tercetoACambiar != -1){
								apilarSalto(&pilaSalto, &auxSalto);
							}
							notbandera = 1; 
						} condicion PAR_C bloquemain ENDWHILE{ 
																sprintf(auxchar3,"[%d]", indexterwhile);
																crearTerceto("JMP", auxchar3, " " );
																
																if( auxSalto.tipoCondicion == 1)
																{
																	actualizarTerceto(auxSalto.tercetoACambiar);
																}
	
																if(pilaSaltoVacia(&pilaSalto) == 0){
																	desapilarSalto(&pilaSalto, &auxSalto);
																}else{
																	auxSalto.tercetoACambiar = -1; 
																	auxSalto.tipoCondicion = 0; 
																}
															};

seleccion: IF PAR_A{ 
						if(auxSalto.tercetoACambiar != -1){
							apilarSalto(&pilaSalto, &auxSalto);
						}
					}  condiciones PAR_C{ 
										if( auxSalto.tipoCondicion == 3)
										{
											actualizarTerceto(auxSalto.tercetoACambiar);
											actualizarTerceto( auxSalto.segundoTerceto);
										}
									 } bloquemain bloqueelse
			| IF PAR_A NOT { 
						if(auxSalto.tercetoACambiar != -1){
							apilarSalto(&pilaSalto, &auxSalto);
						}
						notbandera = 1;
					} 
					condicion PAR_C{ 
										notbandera = 0;
									 } bloquemain bloqueelse;
										 
bloqueelse: ELSE {
				indexter = indexter + 1;
				if( auxSalto.tipoCondicion == 1)
				{
					actualizarTerceto(auxSalto.tercetoACambiar);
				}else if( auxSalto.tipoCondicion == 2){
					actualizarTerceto(auxSalto.tercetoACambiar);
					actualizarTerceto(auxSalto.segundoTerceto );
				}else if( auxSalto.tipoCondicion == 3){
						actualizarTerceto(auxSalto.segundoTerceto + 1 );
				}
				indexter = indexter - 1;
				crearTerceto("JMP", " ", " " );
				auxSalto.indexterjump = indexter;
			 } bloquemain ENDIF { 
								actualizarTerceto(auxSalto.indexterjump );
								if(pilaSaltoVacia(&pilaSalto) == 0){
									desapilarSalto(&pilaSalto, &auxSalto);
									
								}else{
									auxSalto.tercetoACambiar = -1; 
									auxSalto.tipoCondicion = 0; 
									auxSalto.segundoTerceto = -1;
									auxSalto.indexterjump = -1;
								}
							}
			| ENDIF { 
						if( auxSalto.tipoCondicion == 1)
						{
							actualizarTerceto(auxSalto.tercetoACambiar);
						}else if( auxSalto.tipoCondicion == 2){
							actualizarTerceto(auxSalto.tercetoACambiar);
							actualizarTerceto(auxSalto.tercetoACambiar + 4 );
						}else if( auxSalto.tipoCondicion == 3){
								actualizarTerceto(auxSalto.tercetoACambiar + 5 );
						}
						
						if(pilaSaltoVacia(&pilaSalto) == 0){
							desapilarSalto(&pilaSalto, &auxSalto);
						}else{
							auxSalto.tercetoACambiar = -1; 
							auxSalto.tipoCondicion = 0; 
						}
					} ;

condicion:  argumento  {
							crearTerceto(opCond, " " , " " );
							auxSalto.tercetoACambiar = indexter;
							auxSalto.tipoCondicion = 1;
						};
						
condiciones:  argumento  {
							crearTerceto(opCond, " " , " " );
							auxSalto.tercetoACambiar = indexter;
							auxSalto.tipoCondicion = 1;
						}
			| argumento  AND { 
								crearTerceto(opCond, " ", " "  );  
								auxSalto.tercetoACambiar = indexter;
								auxSalto.tipoCondicion = 2;	
							}argumento { crearTerceto(opCond, " ", " "  );
											auxSalto.segundoTerceto = indexter;
										}
			|  argumento OR  { 
								if(strcmp(opCond, "BGE") == 0)
								{
									sprintf(opCond,"%s", "BLT");
								}
								else if (strcmp (opCond , "BLT") == 0)
								{
									sprintf(opCond,"%s", "BGE");
								}
								else if(strcmp(opCond, "BLE") == 0)
								{
									sprintf(opCond,"%s", "BGT");
								}
								else if (strcmp (opCond , "BGT") == 0)
								{
									sprintf(opCond,"%s", "BLE");
								}
								else if(strcmp(opCond, "BNE") == 0)
								{
									sprintf(opCond,"%s", "BEQ");
								}
								else if (strcmp (opCond , "BEQ") == 0)
								{
									sprintf(opCond,"%s", "BNE");
								}
								notbandera = 1;
								crearTerceto(opCond, " ", " " );  
								auxSalto.tercetoACambiar = indexter ;
								auxSalto.tipoCondicion = 3;
							}  argumento { 
											notbandera = 0; 
											crearTerceto(opCond, " "," "  );
											auxSalto.segundoTerceto = indexter;
											crearTerceto("JMP", " ", " " );
										};

argumento: expresion { 
							sprintf(auxchar3,"[%d]", indexter);
						} operador expresion  { 
											sprintf(auxchar,"[%d]", indexter);
											crearTerceto("CMP", auxchar3 , auxchar);
										};
				
operador: OP_LT {	
					if(notbandera == 0){
						sprintf(opCond,"%s", "BGE");
					}else{
						sprintf(opCond,"%s", "BLT");
					}
				}
            | OP_GT {	
						if(notbandera == 0){
							sprintf(opCond,"%s", "BLE");
						}else{
							sprintf(opCond,"%s", "BGT");
						}
					}
            | OP_EQ {	
						if(notbandera == 0){
							sprintf(opCond,"%s", "BNE");
						}else{
							sprintf(opCond,"%s", "BEQ");
						}
					}
            | OP_LE {	
						if(notbandera == 0){
							sprintf(opCond,"%s", "BGT");
						}else{
							sprintf(opCond,"%s", "BLE");
						}
					}
            | OP_GE {	
						if(notbandera == 0){
							sprintf(opCond,"%s", "BLT");
						}else{
							sprintf(opCond,"%s", "BGE");
						}
					}
            | OP_NE {	
						if(notbandera == 0){
							sprintf(opCond,"%s", "BEQ");
						}else{
							sprintf(opCond,"%s", "BNE");
						}
					};
			
unario: ID OP_ASIG IF PAR_A { 
								if(auxSalto.tercetoACambiar != -1){
									apilarSalto(&pilaSalto, &auxSalto);
								}
							}condiciones COMA{ 
											//indexter = indexter + 1; 
											if( auxSalto.tipoCondicion == 3)
											{
												actualizarTerceto(auxSalto.tercetoACambiar);
												actualizarTerceto( auxSalto.segundoTerceto);
											}
											//indexter = indexter - 1;
										 } expresion  COMA{
																sprintf(auxchar,"[%d]", indexter);
																crearTerceto(":=", $1 , auxchar );
																indexter = indexter + 1; 
																if( auxSalto.tipoCondicion == 1)
																{
																	actualizarTerceto(auxSalto.tercetoACambiar);
																}else if( auxSalto.tipoCondicion == 2){
																	actualizarTerceto(auxSalto.tercetoACambiar);
																	actualizarTerceto(auxSalto.segundoTerceto );
																}else if( auxSalto.tipoCondicion == 3){
																		actualizarTerceto(auxSalto.segundoTerceto + 1  );
																}
																indexter = indexter - 1;
																crearTerceto("JMP"," "," ");
																indexterunario = indexter;
															 }  expresion PAR_C { 
																					sprintf(auxchar,"[%d]", indexter);
																					crearTerceto(":=", $1 , auxchar );
																					if(pilaSaltoVacia(&pilaSalto) == 0){
																						desapilarSalto(&pilaSalto, &auxSalto);
																					}else{
																						auxSalto.tercetoACambiar = -1;
																						auxSalto.segundoTerceto = -1;
																						auxSalto.tipoCondicion = 0; 
																					}
																					//indexter = indexter + 1; 
																					actualizarTerceto(indexterunario);
																					//indexter = indexter - 1;
																				}
		|ID OP_ASIG IF PAR_A NOT{ 
									if(auxSalto.tercetoACambiar != -1){
										apilarSalto(&pilaSalto, &auxSalto);
									}
									notbandera = 1;
								} condicion COMA expresion  COMA{
																sprintf(auxchar,"[%d]", indexter);
																crearTerceto(":=", $1 , auxchar );
																indexter = indexter + 1; 
																if( auxSalto.tipoCondicion == 1)
																{
																	actualizarTerceto(auxSalto.tercetoACambiar);
																}
																indexter = indexter - 1;
																crearTerceto("JMP"," "," ");
																indexterunario = indexter;
															 }  expresion PAR_C { 
																					sprintf(auxchar,"[%d]", indexter);
																					crearTerceto(":=", $1 , auxchar );
																					if(pilaSaltoVacia(&pilaSalto) == 0){
																						desapilarSalto(&pilaSalto, &auxSalto);
																					}else{
																						auxSalto.tercetoACambiar = -1; 
																						auxSalto.tipoCondicion = 0; 
																					}
																					//indexter = indexter + 1; 
																					actualizarTerceto(indexterunario);
																					//indexter = indexter - 1;
																				};

display: DISPLAY ID { crearTerceto( "DisplayFloat", $2, " "); }
		 | DISPLAY CONS_CAD { crearTerceto( "DisplayString", $2, " "); };

get: GET ID { crearTerceto( "GetFloat", $2, " "); } ;
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
	
	if ((at = fopen("intermedia.txt", "a")) == NULL)
	{
		printf("No se pudo crear el archivo intermedia.txt\n");
	}
	else 
	{
		 indexter++;
		 fprintf(at, "[%d] (%s,%s,%s)\n",indexter, ptr1, ptr2, ptr3);
	}
	
	fclose(at);
	return indexter;
}

int actualizarTerceto(int numTerceto)
{
	FILE *at;
	FILE *to;
	char str[200];
	char pt1[50]; 
	char pt2[50]; 
	char pt3[50];
	char *ptr1; 
	char *ptr2; 
	char *ptr3;
	int tercetoLeido;
	
	if((to =  fopen("intermediaaux.txt", "w")) == NULL)
	{
		printf("No se pudo crear el archivo intermediaaux.txt\n");
	}else
	{
		if ((at = fopen("intermedia.txt", "r")) == NULL)
		{
			printf("No se pudo crear el archivo intermedia.txt\n");
		}
		else 
		{
			fseek( at, 0, SEEK_SET );
			while(fgets(str, 200, at) != NULL){ 
				sscanf( str, "[%d] %s %s %s ", &tercetoLeido,  pt1,  pt2,  pt3 );
				ptr1 = strtok(str,  "(");
				ptr1 = strtok(NULL,  ",");
				ptr2 = strtok(NULL,  ",");
				ptr3 = strtok(NULL,  ")");
				if(tercetoLeido == numTerceto){
					indexter = indexter + 1;
					fprintf(to, "[%d] (%s,[%d],%s)\n",numTerceto, ptr1, indexter, ptr3);
					indexter = indexter - 1;
				}else{
					fprintf(to, "[%d] (%s,%s,%s)\n",tercetoLeido, ptr1, ptr2, ptr3);
				}
			}
		}
		fclose(at);
	}
	
	fclose(to);
	remove("intermedia.txt");
	rename("intermediaaux.txt" , "intermedia.txt");
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

void crearPilaSalto(t_pilaSalto *p)
{
    *p = NULL;
}

int apilarSalto(t_pilaSalto *p, const t_dato_salto *d)
{
    t_nodo_salto *nue = (t_nodo_salto *)malloc(sizeof(t_nodo_salto));
    if(!nue)
        return 0;

    nue -> dato = *d;
    nue -> sig = *p;
    *p = nue;

    return 1;
}

int desapilarSalto(t_pilaSalto *p, t_dato_salto *d)
{
    t_nodo_salto *aux = *p;

    if(!*p)
        return 0;

    *d = (*p) -> dato;
    *p = (*p) -> sig;
    free(aux);

    return 1;
}

int pilaSaltoVacia(const t_pilaSalto *p)
{
    return *p == NULL;
}

void funcionFactorial()
{
	sprintf(auxchar, "[%d]", indexter);
	crearTerceto(":=", "@resFact", auxchar);
	crearTerceto("CMP","@resFact", "1");
	sprintf(auxchar2, "[%d]", indexter + 4);
	crearTerceto("BGT", auxchar2, " ");
	crearTerceto(":=", "@resFact", "1");
	sprintf(auxchar2, "[%d]", indexter + 12);
	crearTerceto("JMP", auxchar2, " ");
	crearTerceto(":=", "@auxFact", auxchar);
	crearTerceto("-", "@auxFact", "1");
	crearTerceto("CMP","@auxFact", "1");
	sprintf(auxchar, "[%d]", indexter + 3);
	crearTerceto("BGT", auxchar, " ");
	sprintf(auxchar, "[%d]", indexter + 7);
	crearTerceto("JMP", auxchar, " ");
	crearTerceto("*", "@resFact", "@auxFact");
	sprintf(auxchar, "[%d]", indexter);
	crearTerceto(":=", "@resFact", auxchar);
	crearTerceto("-", "@auxFact", "1");
	sprintf(auxchar, "[%d]", indexter);
	crearTerceto(":=", "@auxFact", auxchar);
	sprintf(auxchar, "[%d]", indexter - 6);
	crearTerceto("JMP", auxchar, " ");
	crearTerceto("@resFact", " ", " ");
}

void guardarParentesisAbre()
{
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

void guardarParentesisCierra()
{
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

void generarAssembler()
{
	FILE *interm;
	FILE *asem;
	FILE *ts;
	char str[200];
	int nroToken = 1;
	char pt1[50]; 
	char pt2[50]; 
	char pt3[50];
	char *ptr1; 
	char *ptr2; 
	char *ptr3;
	int tercetoLeido;
	int tipo;
	char *ptr4;
	char ptr5[10];
	char res[10];
	char accion[6];
	int tipoPtr2;
	int tipoPtr3;
	char aux[50];
	char *aux2;
	t_dato_listaAux infoAux;
	t_dato_lista infoEtiq;
	t_dato_listaTS infoTS;
	t_dato_cola infoCola;
	
	crear_lista(&pll);
	crear_listaAux(&pla);
	crear_listaTS(&pts);
	crear_cola(&cola);
	
	if ((interm =  fopen("intermedia.txt", "r")) == NULL)
	{
		printf("No se pudo abrir el archivo intermedia.txt\n");
	}
	else
	{
		if ((asem = fopen("encabezado.txt", "w")) == NULL)
		{
			printf("No se pudo crear el archivo encabezado.txt\n");
		}
		else 
		{	
			fprintf(asem, "%s\n%s\n%s\n%s\n%s\n%s\n%s\n", "include macros2.asm", "include number.asm", ".MODEL	LARGE", ".386", ".STACK 200h", "MAXTEXTSIZE equ 50", ".DATA");
			
			if ((ts = fopen("ts.txt", "r")) == NULL)
			{
				printf("No se pudo abrir el archivo ts.txt\n");
				fclose(asem);
			}
			else 
			{
				char delim[] = "|";
				crear_listaTS(&pts);
				
				fgets(str, 200, ts);
				fgets(str, 200, ts);
				while(fgets(str, 200, ts) != NULL)
				{
					char *token = strtok(str, delim);
					if(token != NULL){
						while(token != NULL){
							// sacar espacios finales
							char *strPtr = strrchr(token, ' ');
							while(*strPtr == ' ')
								strPtr--;
							*(++strPtr) = '\0';
							
							if ((nroToken == 2 || nroToken == 3) && strcmp(token, "") != 0)
							{
								token = &token[1];
							}

							switch(nroToken)
							{
								case 1:
									strcpy(nodo.nom, token);
									break;
								case 2:
									strcpy(nodo.tipo, token);
									break;
								case 3:
									strcpy(nodo.valor, token);
									break;
								case 4:
									strcpy(nodo.longi, token);
									break;
								default:
									break;
							}
							token = strtok(NULL, delim);
							nroToken++;
						}
					}
					
					
					
					//printf("Linea: %s -%s- %s -%s-\n", nodo.nom, nodo.tipo, nodo.valor, nodo.longi);
					strcpy(infoTS.nom, nodo.nom);
					strcpy(infoTS.longi, nodo.longi);

					if (strcmp(nodo.tipo, "INT") == 0)
					{
						tipo = 1;
					}
					else if (strcmp(nodo.tipo, "FLOAT") == 0)
					{
						tipo = 2;
					}
					else if (strcmp(nodo.tipo, "STRING") == 0)
					{
						tipo = 3;
					}
					else if (strcmp(nodo.longi, "") != 0)
					{
						tipo = 3;
					}
					else if (strstr(nodo.valor, ".") != NULL)
					{
						tipo = 2;
					}
					else if (strstr(nodo.valor, ".") == NULL)
					{
						tipo = 1;
					}
					
					if (tipo == 1)
					{
						if(strcmp(nodo.tipo, "INT") == 0) 
						{
							if(strcmp(nodo.valor, "-") == 0) 
							{
								fprintf(asem, "\t%s %s %s\n", nodo.nom, "dw", "?");
							}
							else
							{
								fprintf(asem, "\t%s %s %s\n", nodo.nom, "dw", nodo.valor);
							}
						}
						else 
						{
							if(strcmp(nodo.valor, "-") == 0 || strcmp(nodo.valor, " ") == 0) 
							{
								fprintf(asem, "\t%s %s ?\n", nodo.nom, "dw");
							}
							else 
							{
								fprintf(asem, "\t%s %s \"%s\", '$'\n", nodo.nom, "dw", nodo.valor);
							}
						}
					}
					
					else if (tipo == 2)
					{
						if(strcmp(nodo.tipo, "FLOAT") == 0) 
						{
							if(strcmp(nodo.valor, "-") == 0) 
							{
								fprintf(asem, "\t%s %s %s\n", nodo.nom, "dd", "?");
							}
							else
							{
								fprintf(asem, "\t%s %s %s\n", nodo.nom, "dd", nodo.valor);
							}
						}
						else 
						{
							if(strcmp(nodo.valor, "-") == 0 || strcmp(nodo.valor, " ") == 0) 
							{
								fprintf(asem, "\t%s %s %s\n", nodo.nom, "dd", "?");
							}
							else 
							{
								fprintf(asem, "\t%s %s \"%s\", '$'\n", nodo.nom, "dd", nodo.valor);
							}
						}
					}
					
					else if (tipo == 3)
					{
						if(strcmp(nodo.valor, "-") == 0 || strcmp(nodo.valor, " ") == 0) 
						{
							fprintf(asem, "\t%s %s\n", nodo.nom, "db ?");
						}
						else 
						{
							fprintf(asem, "\t%s %s \"%s\", '$', %s dup (?)\n", nodo.nom, "db", nodo.valor, nodo.longi);
						}
					}
					
					strcpy(infoTS.valor, nodo.valor);
					itoa(tipo, infoTS.tipo, 10);
					//printf("%s %s %s %s\n", infoTS.nom, infoTS.valor, infoTS.tipo, infoTS.longi);

					insertar_actualizar_en_lista_ordTS(&pts, &infoTS);
					nroToken = 1;
				}
				fclose(ts);
			}
		}
		fprintf(asem, "\t@res\tdd\t?\n");
		strcpy(infoTS.nom, "@res");
		strcpy(infoTS.tipo, "FLOAT");
		strcpy(infoTS.valor, " ");
		strcpy(infoTS.longi, " ");
		insertar_actualizar_en_lista_ordTS(&pts, &infoTS);
		fprintf(asem, "\t@resFact\tdd\t?\n");
		strcpy(infoTS.nom,"@resFact");
		strcpy(infoTS.tipo, "FLOAT");
		strcpy(infoTS.valor, " ");
		strcpy(infoTS.longi, " ");
		insertar_actualizar_en_lista_ordTS(&pts, &infoTS);
		fprintf(asem, "\t@auxFact\tdd\t?\n");
		strcpy(infoTS.nom, "@auxFact");
		strcpy(infoTS.tipo, "FLOAT");
		strcpy(infoTS.valor, " ");
		strcpy(infoTS.longi, " ");
		insertar_actualizar_en_lista_ordTS(&pts, &infoTS);
		
		fclose(asem);
		
		if ((asem = fopen("cuerpo.txt", "w")) == NULL)
		{
			printf("No se pudo crear el archivo cuerpo.txt\n");
			fclose(interm);
		}
		else 
		{	
			// Leer tercetos
			//Leo Tercetos Creo los saltos. (Metodo: Busco todos los saltos. Si es salto Creo la etiqueta pongo el numero de terceto a saltar lo pongo en la lista.)
			while(fgets(str, 200, interm) != NULL)
			{
				sscanf(str, "[%d] %s %s %s ", &tercetoLeido,  pt1,  pt2,  pt3);
				ptr1 = strtok(str,  "(");
				ptr1 = strtok(NULL,  ",");
				ptr2 = strtok(NULL,  ",");
				ptr3 = strtok(NULL,  ")");
				if( esSalto(ptr1) == 1 )
				{
					eliminarCorchetes(ptr2);
					infoEtiq.numTerceto = atoi(ptr2);
					strcpy(infoEtiq.etiq, "ETIQ");
					strcat(infoEtiq.etiq, ptr2);
					strcat(infoEtiq.etiq, ":");
					insertar_actualizar_en_lista_ord(&pll, &infoEtiq, &cmp_int);
				}else if( strcmp(ptr2, " ") == 0 && strcmp(ptr3, " ") == 0)
				{
					//A TODOS los Tercetos que sean solo numeros o variables (osea ptr2 y ptr3 es vacio) los pongo en una lista con: NroTerceto, Res, Tipo
					infoAux.nroTerceto = tercetoLeido;
					strcpy(infoTS.nom, ptr1);
					if (buscar_en_lista_ord_recTS(&pts, &infoTS) == 1)
					{
						strcpy(aux, "_");
						strcat(aux, ptr1);
						if ((aux2 = strchr(aux, '.')) != NULL)
						{
							*aux2 = '_';
						}
						strcpy(infoTS.nom, aux);
						buscar_en_lista_ord_recTS(&pts, &infoTS);
						strcpy(infoAux.res, aux);
						
						infoAux.tipo = verTipo(&infoTS);
						insertar_actualizar_en_lista_ordAux(&pla, &infoAux, &cmp_intAux);
					}
					else
					{
						strcpy(infoAux.res, ptr1);
						strcpy(infoTS.nom, ptr1); 
						//buscar_en_lista_ord_recTS(&pts,
						infoAux.tipo = verTipo(&infoTS);
						//printf(";infoaux %d %s %d\n", infoAux.nroTerceto, infoAux.res, infoAux.tipo);
						insertar_actualizar_en_lista_ordAux(&pla, &infoAux, &cmp_intAux);
						
					}
					
				}
			}
		   
			
			//Leo Tercetos de Nuevo.
			fseek(interm, 0, SEEK_SET);
			//fseek al inicio
			while(fgets(str, 200, interm) != NULL)
			{
				sscanf(str, "[%d] %s %s %s ", &tercetoLeido,  pt1,  pt2,  pt3);
				ptr1 = strtok(str,  "(");
				ptr1 = strtok(NULL,  ",");
				ptr2 = strtok(NULL,  ",");
				ptr3 = strtok(NULL,  ")");
			
				//1- Veo si el NUMERO de terceto leido esta en la lista de saltos, si está, pongo la etiqueta.
				infoEtiq.numTerceto = tercetoLeido;
				if (buscar_en_lista_ord_rec(&pll, &infoEtiq, &cmp_int) == 0)
				{
					fprintf(asem, "%s\n", infoEtiq.etiq);
				}			
				
				//2- Si es salto, coloco la accion y la etiqueta (la busco en la lista). Corto ejecucion y leo el proximo.
				if(esSalto(ptr1) == 1 )
				{
					strcpy(ptr5, ptr1);
					obtenerInstruccion(ptr5, 0);
					eliminarCorchetes(ptr2);
					infoEtiq.numTerceto = atoi(ptr2);
					buscar_en_lista_ord_rec(&pll, &infoEtiq, &cmp_int);
					strcpy(aux, infoEtiq.etiq);
					if ((aux2 = strchr(aux, ':')) != NULL) 
					{
						*aux2 = '\0';
					}
					fprintf(asem, "%s %s\n", ptr5, aux);
				}
				//3- Si es un Operador:
				else if (esOperador(ptr1) == 1)
				{
					//    1.2- Leo ptr2 y veo:
					//        1.2.1- Es un Numero de terceto?(Lo busco en la lista).
					//        1.2.2- Es una Variable o un numero? lo pongo en la pila ST(0).
					if (strchr(ptr2, '[') != NULL)
					{
						// tiene corchete
						eliminarCorchetes(ptr2);
						infoAux.nroTerceto = atoi(ptr2);
						buscar_en_lista_ord_recAux(&pla, &infoAux, &cmp_intAux);
						//fprintf(asem, ";infoaux: %d %d %s\n", infoAux.nroTerceto, infoAux.tipo, infoAux.res);
						tipoPtr2 = infoAux.tipo;
						if (infoAux.tipo == 1) 
						{
							strcpy(ptr5, "FILD");
						}
						else 
						{
							strcpy(ptr5, "FLD");
						}
						fprintf(asem, "%s %s\n", ptr5, infoAux.res);
					}
					else 
					{
						strcpy(infoTS.nom, ptr2);
						buscar_en_lista_ord_recTS(&pts, &infoTS);
						if (strcmp(ptr2, "@resFact") == 0 || strcmp(ptr2, "@auxFact") == 0 || strcmp(ptr2, "@res") == 0)
						{
							strcpy(ptr5, "FLD");
						}
						else
						{
							//fprintf(asem, "infots: %s %s %s %s\n", infoTS.nom, infoTS.tipo, infoTS.valor, infoTS.longi);
							tipoPtr2 = atoi(infoTS.tipo);
							//if (verTipo(&infoTS) == 1) 
							if (tipoPtr2 == 1) 
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr2 == 2) 
							{
								strcpy(ptr5, "FLD");
							}
						}
						if (buscar_en_lista_ord_recTS(&pts, &infoTS) == 0)
						{
							fprintf(asem, "%s %s\n", ptr5, ptr2);
						}
						else
						{
							strcpy(aux, "_");
							strcat(aux, ptr2);
							if ((aux2 = strchr(aux, '.')) != NULL)
							{
								*aux2 = '_';
							}
							strcpy(infoTS.nom, aux);
							buscar_en_lista_ord_recTS(&pts, &infoTS);
							tipoPtr2 = atoi(infoTS.tipo);
							
							if (tipoPtr2 == 1)
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr2 == 2)
							{
								strcpy(ptr5, "FLD");
							}
							
							fprintf(asem, "%s %s\n", ptr5, aux); 
						}

					}
					
					//    1.1- Leo ptr3 y veo:
					//        1.1.1- Es un Numero de terceto?(Lo busco en la lista).
					//        1.1.2- Es una Variable o un numero? lo pongo en la pila ST(1).
					if (strchr(ptr3, '[') != NULL)
					{
						// tiene corchete
						eliminarCorchetes(ptr3);
						infoAux.nroTerceto = atoi(ptr3);
						buscar_en_lista_ord_recAux(&pla, &infoAux, &cmp_intAux);

						tipoPtr3 = infoAux.tipo;
						if (infoAux.tipo == 1) 
						{
							strcpy(ptr5, "FILD");
						}
						else 
						{
							strcpy(ptr5, "FLD");
						}
						fprintf(asem, "%s %s\n", ptr5, infoAux.res);
					}
					else
					{
						strcpy(infoTS.nom, ptr3);
						buscar_en_lista_ord_recTS(&pts, &infoTS);
						if (strcmp(ptr3, "@resFact") == 0 || strcmp(ptr3, "@auxFact") == 0 || strcmp(ptr3, "@res") == 0)
						{
							strcpy(ptr5, "FLD");
						}
						else
						{
							tipoPtr3 = atoi(infoTS.tipo);
							//if (verTipo(&infoTS) == 1) 
							if (tipoPtr3 == 1)
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr3 == 2)
							{
								strcpy(ptr5, "FLD");
							}
						}
						
						if (buscar_en_lista_ord_recTS(&pts, &infoTS) == 0)
						{
							fprintf(asem, "%s %s\n", ptr5, ptr3);
						}
						else
						{
							strcpy(aux, "_");
							strcat(aux, ptr3);
							if ((aux2 = strchr(aux, '.')) != NULL)
							{
								*aux2 = '_';
							}
							strcpy(infoTS.nom, aux);
							buscar_en_lista_ord_recTS(&pts, &infoTS);
							tipoPtr3 = atoi(infoTS.tipo);
							
							if (tipoPtr3 == 1)
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr3 == 2)
							{
								strcpy(ptr5, "FLD");
							}
							fprintf(asem, "%s %s\n", ptr5, aux); 
						}
					}
					
					
					if (strcmp(ptr1, ":=") == 0)
					{
						//    1.3- Realizo la instruccion.
						strcpy(ptr5, ptr1);
						tipo = obtenerTipo(tipoPtr2, tipoPtr3);
						obtenerInstruccion(ptr5, tipo);
						fprintf(asem, "%s %s\n", ptr5, ptr2);
						strcpy(infoAux.res, "@res");
						strcat(infoAux.res, itoa(tercetoLeido, ptr5, 10));
						fprintf(asem, "FSTP %s \n", infoAux.res);
						infoAux.nroTerceto = tercetoLeido;
						infoAux.tipo = tipo;
						insertar_actualizar_en_lista_ordAux(&pla, &infoAux, &cmp_intAux);
						infoCola.tipo = tipo;
						strcpy(infoCola.var, infoAux.res);
						poner_en_cola(&cola, &infoCola);
						//    1.4- Creo una variable @res"NroTerceto" y lo coloco con: NroTerceto, Res, Tipo en la lista.
					}
					else 
					{
						//    1.3- Realizo la instruccion.
						strcpy(ptr5, ptr1);
						tipo = obtenerTipo(tipoPtr2, tipoPtr3);
						obtenerInstruccion(ptr5, tipo);
						fprintf(asem, "%s\n", ptr5);
						strcpy(infoAux.res, "@res");
						strcat(infoAux.res, itoa(tercetoLeido, ptr5, 10));
						fprintf(asem, "FSTP %s \n", infoAux.res);
						infoAux.nroTerceto = tercetoLeido;
						infoAux.tipo = tipo;
						insertar_actualizar_en_lista_ordAux(&pla, &infoAux, &cmp_intAux);
						infoCola.tipo = tipo;
						strcpy(infoCola.var, infoAux.res);
						poner_en_cola(&cola, &infoCola);
						//    1.4- Creo una variable @res"NroTerceto" y lo coloco con: NroTerceto, Res, Tipo en la lista.
					}
					
				}
				//4- Si es una Comp.*/	
				else if (strcmp(ptr1, "CMP") == 0) 
				{
					//    1.2- Leo ptr2 y veo:
					//        1.2.1- Es un Numero de terceto?(Lo busco en la lista).
					//        1.2.2- Es una Variable o un numero? lo pongo en la pila ST(0).
					if (strchr(ptr2, '[') != NULL)
					{
						// tiene corchete
						//fprintf(asem, "ptr2 terceto");
						eliminarCorchetes(ptr2);
						infoAux.nroTerceto = atoi(ptr2);
						buscar_en_lista_ord_recAux(&pla, &infoAux, &cmp_intAux);
						
						if (infoAux.tipo == 1) 
						{
							strcpy(ptr5, "FILD");
						}
						else 
						{
							strcpy(ptr5, "FLD");
						}
						fprintf(asem, "%s %s\n", ptr5, infoAux.res);
					}
					else 
					{
						
						strcpy(infoTS.nom, ptr2);
						buscar_en_lista_ord_recTS(&pts, &infoTS);
						//fprintf(asem, "fprintf %s %s %s %s\n", infoTS.nom, infoTS.tipo, infoTS.valor, infoTS.longi);
						
						if (strcmp(ptr2, "@resFact") == 0 || strcmp(ptr2, "@auxFact") == 0 || strcmp(ptr2, "@res") == 0)
						{
							strcpy(ptr5, "FLD");
						}
						else
						{
							tipoPtr2 = atoi(infoTS.tipo);
							//if (verTipo(&infoTS) == 1) 
							if (tipoPtr2 == 1) 
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr2 == 2) 
							{
								strcpy(ptr5, "FLD");
							}
						}
						
						if (buscar_en_lista_ord_recTS(&pts, &infoTS) == 0)
						{
							fprintf(asem, "%s %s\n", ptr5, ptr2);
						}
						else
						{
							strcpy(aux, "_");
							strcat(aux, ptr2);
							if ((aux2 = strchr(aux, '.')) != NULL)
							{
								*aux2 = '_';
							}
							strcpy(infoTS.nom, aux);
							buscar_en_lista_ord_recTS(&pts, &infoTS);
							tipoPtr2 = atoi(infoTS.tipo);
							
							if (tipoPtr2 == 1)
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr2 == 2)
							{
								strcpy(ptr5, "FLD");
							}
							
							fprintf(asem, "%s %s\n", ptr5, aux); 
						}
					}
					
					//    1.1- Leo ptr3 y veo:
					//        1.1.1- Es un Numero de terceto?(Lo busco en la lista).
					//        1.1.2- Es una Variable o un numero? lo pongo en la pila ST(1).
					if (strchr(ptr3, '[') != NULL)
					{
						// tiene corchete
						eliminarCorchetes(ptr3);
						infoAux.nroTerceto = atoi(ptr3);
						buscar_en_lista_ord_recAux(&pla, &infoAux, &cmp_intAux);
						if (infoAux.tipo == 1) 
						{
							strcpy(ptr5, "FILD");
						}
						else 
						{
							strcpy(ptr5, "FLD");
						}
						fprintf(asem, "%s %s\n", ptr5, infoAux.res);
					}
					else 
					{
						strcpy(infoTS.nom, ptr3);
						buscar_en_lista_ord_recTS(&pts, &infoTS);
						
						if (strcmp(ptr3, "@resFact") == 0 || strcmp(ptr3, "@auxFact") == 0 || strcmp(ptr3, "@res") == 0)
						{
							strcpy(ptr5, "FLD");
						}
						else 
						{
							tipoPtr3 = atoi(infoTS.tipo);
							//if (verTipo(&infoTS) == 1) 
							if (tipoPtr3 == 1)
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr3 == 2)
							{
								strcpy(ptr5, "FLD");
							}
						}
						
						if (buscar_en_lista_ord_recTS(&pts, &infoTS) == 0)
						{
							fprintf(asem, "%s %s\n", ptr5, ptr3);
						}
						else
						{
							strcpy(aux, "_");
							strcat(aux, ptr3);
							if ((aux2 = strchr(aux, '.')) != NULL)
							{
								*aux2 = '_';
							}
							strcpy(infoTS.nom, aux);
							buscar_en_lista_ord_recTS(&pts, &infoTS);
							tipoPtr3 = atoi(infoTS.tipo);
							
							if (tipoPtr3 == 1)
							{
								strcpy(ptr5, "FILD");
							}
							//else if (verTipo(&infoTS) == 2)
							else if (tipoPtr3 == 2)
							{
								strcpy(ptr5, "FLD");
							}
							fprintf(asem, "%s %s\n", ptr5, aux); 
						}
					}
					fprintf(asem, "FXCH\nFCOM\nFSTSW\tax\nSAHF\n");
				}
				else if (strcmp(ptr1, "DisplayFloat") == 0)
				{
					fprintf(asem, "displayFloat %s, 2\n", ptr2);
				}
				else if (strcmp(ptr1, "DisplayString") == 0)
				{
					fprintf(asem, "displayString %s\n", ptr2);
				}
				else if (strcmp(ptr1, "GetFloat") == 0)
				{
					fprintf(asem, "getFloat %s\n", ptr2);
				}
			}

			fclose(asem);
			fclose(interm);
			if ((asem = fopen("Final.asm", "w")) == NULL) 
			{
				printf("No se pudo abrir el archivo Final.asm\n");
			}
			else
			{
				if ((ts =  fopen("encabezado.txt", "r")) == NULL)
				{
					printf("No se pudo abrir el archivo encabezado.txt\n");
				}
				else 
				{
					while(fgets(str, 200, ts) != NULL)
					{
						//printf("%s\n", str);
						fprintf(asem, "%s\n", str);
					}
					fclose(ts);
				
					while(!cola_vacia(&cola))
					{
						sacar_de_cola(&cola, &infoCola);
						if (infoCola.tipo == 1)
						{
							fprintf(asem, "\t%s\tdd\t?\n", infoCola.var);
						}
						else 
						{
							fprintf(asem, "\t%s\tdd\t?\n", infoCola.var);
						}
					}
					
					fprintf(asem, ".CODE\n");
					if ((ts =  fopen("cuerpo.txt", "r")) == NULL)
					{
						printf("No se pudo abrir el archivo cuerpo.txt\n");
					}
					else 
					{
						while(fgets(str, 200, ts) != NULL)
						{
							//printf("%s\n", str);
							fprintf(asem, "%s\n", str);
						}
						fclose(ts);
					}
					fprintf(asem, "ffree\nmov ax,4c00h\nint 21h\nEnd");
					fclose(asem);
					remove("encabezado.txt");
					remove("cuerpo.txt");
					//fclose(interm);
				}
			}
		}
	}
}

int esVariable(char *var)
{
	if (strcmp(var, ":=") != 0 && strcmp(var, "+") != 0 && strcmp(var, "-") != 0 &&
		strcmp(var, "*") != 0 && strcmp(var, "/") != 0 && strcmp(var, "BGT") != 0 &&
		strcmp(var, "BGE") != 0 && strcmp(var, "BLT") != 0 && strcmp(var, "BLE") != 0 &&
		strcmp(var, "BEQ") != 0 && strcmp(var, "BNE") != 0 && strcmp(var, "JMP") != 0)
	{
		return 1;
	}
	return 0;
}

int esSalto(char *var)
{
	if (strcmp(var, "BGT") == 0 || strcmp(var, "BGE") == 0 || strcmp(var, "BLT") == 0 ||
		strcmp(var, "BLE") == 0 || strcmp(var, "BEQ") == 0 || strcmp(var, "BNE") == 0 ||
		strcmp(var, "JMP") == 0)
	{
		return 1;
	}
	return 0;
}

int esOperador(char *var)
{
	if (strcmp(var, ":=") == 0 || strcmp(var, "+") == 0 || strcmp(var, "-") == 0 ||
		strcmp(var, "*") == 0 || strcmp(var, "/") == 0)
	{
		return 1;
	}
	return 0;
}

void obtenerInstruccion(char *operador, int tipo)
{
	if (strcmp(operador, ":=") == 0)
	{
		if (tipo == 1) 
		{
			strcpy(operador, "FIST");
		}
		else if (tipo == 2)
		{
			strcpy(operador, "FST");
		}
		else
		{
			strcpy(operador, "STR");
		}
	}
	else if (strcmp(operador, "+") == 0)
	{
		strcpy(operador, "FADD");
	}
	else if (strcmp(operador, "-") == 0)
	{
		strcpy(operador, "FSUB");
	}
	else if (strcmp(operador, "*") == 0)
	{
		strcpy(operador, "FMUL");
	}
	else if (strcmp(operador, "/") == 0)
	{
		strcpy(operador, "FDIV");
	}
	else if (strcmp(operador, "BGT") == 0)
	{
		strcpy(operador, "JG");
	}
	else if (strcmp(operador, "BGE") == 0)
	{
		strcpy(operador, "JGE");
	}
	else if (strcmp(operador, "BLT") == 0)
	{
		strcpy(operador, "JL");
	}
	else if (strcmp(operador, "BLE") == 0)
	{
		strcpy(operador, "JLE");
	}
	else if (strcmp(operador, "BEQ") == 0)
	{
		strcpy(operador, "JE");
	}
	else if (strcmp(operador, "BNE") == 0)
	{
		strcpy(operador, "JNE");
	}
	else if (strcmp(operador, "JMP") == 0)
	{
		strcpy(operador, "JMP");
	}
	else
	{
		strcpy(operador, "Error");
	}
}

int verTipo(t_dato_listaTS *info)
{
	// si es una variable, buscar en la lista de variables y devolver tipo
	// si el tipo es vacío, ver si tiene longitud. si no tiene longitud, ver si tiene un punto
	char aux[30];
	if (strchr(info->nom, '_') == NULL && buscar_en_lista_ord_recTS(&pts, info) == 0)
	{
		//if (strcmp(info->tipo, "INT") == 0)
		/*if (strcmp(info->tipo, "INT") == 0)
		{
			return 1;
		}
		else if (strcmp(info->tipo, "FLOAT") == 0)
		{
			return 2;
		}
		else if (strcmp(info->tipo, "STRING") == 0)
		{
			return 3;
		}
		
		return 0;*/
		return atoi(info->tipo);
	}
	
	if (strchr(info->nom, '_') == NULL)
	{
		strcpy(aux, "_");
		strcat(aux, info->nom);
		strcpy(info->nom, aux);
	}
	
	if (buscar_en_lista_ord_recTS(&pts, info) == 0)
	{
		if (strcmp(info->longi, "") != 0)
		{
			return 3;
		}
		else if (strstr(info->valor, ".") != NULL)
		{
			return 2;
		}
		else if (strstr(info->valor, ".") == NULL)
		{
			return 1;
		}
		
		return 0;
	}
	
	return -1;
}

int obtenerTipo(int tipo1, int tipo2)
{
	if (tipo1 == tipo2)
	{
		return tipo1;
	}
	else
	{
		return 2;
	}
}

// FUNCIONES DE LISTA
void crear_lista (t_lista* pl)
{
    *pl = NULL;
}

int insertar_actualizar_en_lista_ord(t_lista* pl,const t_dato_lista* d,t_cmp cmp)
{
    while(*pl && cmp(&(d->numTerceto), &((*pl)->info.numTerceto)) > 0) //Si el contenido de pl no es nulo entro a comparar en cmp.
    {
        pl = &(*pl)->sig;
    }

    if(*pl && cmp(&(d->numTerceto), &((*pl)->info.numTerceto)) == 0)
    {
        return 1;
    }

    t_nodo_lista* nue = (t_nodo_lista*) malloc(sizeof(t_nodo_lista));

    if(!nue)
    {
        return 1;
    }

    nue->info = *d;
    nue->sig = *pl;
    *pl = nue;

    return 0;
}

int buscar_en_lista_ord_rec(const t_lista* pl,t_dato_lista* d, t_cmp cmp) //d es la CLAVE
{
    /*
    if(!*pl || cmp(d,&(*pl)->info) > 0)
    {
        return FALSO;
    }
    */

    if(!*pl)
    {
        return 1;
    }

    if(cmp(&(d->numTerceto), &((*pl)->info.numTerceto)) < 0)
    {
        return 1;
    }

    if(cmp(&(d->numTerceto), &((*pl)->info.numTerceto)) == 0)
    {
        *d = (*pl)->info; //Devuelvo el dato

        return 0;
    }

    return buscar_en_lista_ord_rec(&(*pl)->sig,d,cmp);
}

int cmp_int (const void* pve1, const void* pve2)
{
    int* e1 = (int*) pve1;
    int* e2 = (int*) pve2;

    return (*e1-*e2);
}

// ListaTS
void crear_listaTS(t_listaTS* pl)
{
    *pl = NULL;
}

int insertar_actualizar_en_lista_ordTS(t_listaTS* pl,const t_dato_listaTS* d)
{
    while(*pl && strcmp(d->nom, (*pl)->info.nom) > 0) //Si el contenido de pl no es nulo entro a comparar en cmp.
    {
        pl = &(*pl)->sig;
    }

    if(*pl && strcmp(d->nom, (*pl)->info.nom) == 0)
    {
        return 1;
    }

    t_nodo_listaTS* nue = (t_nodo_listaTS*) malloc(sizeof(t_nodo_listaTS));

    if(!nue)
    {
        return 1;
    }

    nue->info = *d;
    nue->sig = *pl;
    *pl = nue;

    return 0;
}

int buscar_en_lista_ord_recTS(const t_listaTS* pl,t_dato_listaTS* d) //d es la CLAVE
{
    /*
    if(!*pl || cmp(d,&(*pl)->info) > 0)
    {
        return FALSO;
    }
    */

    if(!*pl)
    {
        return 1;
    }

    if(strcmp(d->nom, (*pl)->info.nom) < 0)
    {
        return 1;
    }

    if(strcmp(d->nom, (*pl)->info.nom) == 0)
    {
        *d = (*pl)->info; //Devuelvo el dato

        return 0;
    }

    return buscar_en_lista_ord_recTS(&(*pl)->sig, d);
}

// Lista aux
void crear_listaAux(t_listaAux* pl)
{
    *pl = NULL;
}

int insertar_actualizar_en_lista_ordAux(t_listaAux* pl,const t_dato_listaAux* d,t_cmp cmp)
{
    while(*pl && cmp(&(d->nroTerceto), &((*pl)->info.nroTerceto)) > 0) //Si el contenido de pl no es nulo entro a comparar en cmp.
    {
        pl = &(*pl)->sig;
    }

    if(*pl && cmp(&(d->nroTerceto), &((*pl)->info.nroTerceto)) == 0)
    {
        return 1;
    }

    t_nodo_listaAux* nue = (t_nodo_listaAux*) malloc(sizeof(t_nodo_listaAux));

    if(!nue)
    {
        return 1;
    }

    nue->info = *d;
    nue->sig = *pl;
    *pl = nue;

    return 0;
}

int buscar_en_lista_ord_recAux(const t_listaAux* pl,t_dato_listaAux* d, t_cmp cmp) //d es la CLAVE
{
    /*
    if(!*pl || cmp(d,&(*pl)->info) > 0)
    {
        return FALSO;
    }
    */

    if(!*pl)
    {
        return 1;
    }

    if(cmp(&(d->nroTerceto), &((*pl)->info.nroTerceto)) < 0)
    {
        return 1;
    }

    if(cmp(&(d->nroTerceto), &((*pl)->info.nroTerceto)) == 0)
    {
        *d = (*pl)->info; //Devuelvo el dato

        return 0;
    }

    return buscar_en_lista_ord_recAux(&(*pl)->sig,d,cmp);
}

int cmp_intAux(const void* pve1, const void* pve2)
{
    int* e1 = (int*) pve1;
    int* e2 = (int*) pve2;

    return (*e1-*e2);
}

void eliminarCorchetes(char *str)
{
    int longi = strlen(str);
    int i;

    for(i = 1; i < longi; i++)
    {
        str[i-1] = str[i];
    }
    *(str + longi - 2) = '\0';
}

// Funciones de cola
void crear_cola(t_cola* pc)
{
    pc->fr=NULL;
    pc->fo=NULL;
}

int poner_en_cola(t_cola* pc, const t_dato_cola* d)
{
    t_nodo_cola* nue = (t_nodo_cola*)malloc(sizeof(t_nodo_cola));

    if(!nue)
        return 0; //Si no hay memoria(?).

    //Manejo del nodo
    nue->info = *d;
    nue->sig = NULL;


    if(pc->fo)
    {
        pc->fo->sig = nue; //Dentro del nodo.
    }
    else
    {
        pc->fr = nue;
    }

    pc->fo = nue;

    return 1;
}

int sacar_de_cola(t_cola* pc,t_dato_cola* d)
{
    if(!pc->fr)
    {
        return 0;
    }

    t_nodo_cola* aux = pc->fr;

    *d = pc->fr->info; // aux->info

    if(pc->fr == pc->fo) // if(!pc->fr) { pc->fo = NULL}
    {
        pc->fo = NULL;
    }

    pc->fr = pc->fr->sig; // aux->sig.

    free(aux);

    return 1;
}

int cola_vacia(const t_cola* pc)
{
    return !pc->fr;
}