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
	
	if((to =  fopen("tercetosaux.txt", "w")) == NULL)
	{
		printf("No se pudo crear el archivo tercetos.txt\n");
	}else
	{
		if ((at = fopen("tercetos.txt", "r")) == NULL)
		{
			printf("No se pudo crear el archivo tercetos.txt\n");
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
	remove("tercetos.txt");
	rename("tercetosaux.txt" , "tercetos.txt");
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















