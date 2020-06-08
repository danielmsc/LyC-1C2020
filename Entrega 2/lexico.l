%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

int linea = 1;
int findec = 0;
FILE *yyin;
FILE *ts;

typedef struct filaTS {
	char nombre[50];
	char tipo[50];
} filaTS;

filaTS regTS;

int yylex();
void insertarEnTS(char *yytext, int isString);
void insertarVarEnTS();
void removerComillas(char *str, char *aux);
int validarString(char *palabra);
int validarInteger(int num);
int validarReal(double num);
int guardadoEnTabla(char *nombre, int var);
void errorCharInvalido();
%}

%option noyywrap  
%option yylineno 

DIGITO 			[0-9]
LETRA 			[a-zA-Z]
SIMBOLO			("-"|"@"|"%"|" "|":"|"\n"|"\t")
CONS_FLO		({DIGITO}+"."{DIGITO}+|{DIGITO}*"."{DIGITO}+|{DIGITO}+"."{DIGITO}*)
CONS_ENTERO		{DIGITO}+
ALFANUMERICO	({LETRA}|{SIMBOLO}|{DIGITO})*
CONS_CAD		\"({ALFANUMERICO})\"
ID				{LETRA}({LETRA}|{DIGITO})*
COMEN			"***/"({ALFANUMERICO})"/***"
COMEN_ANI		"***/"({ALFANUMERICO}){COMEN}?({ALFANUMERICO})"/***"
ANY				.

%%
"DEFVAR"		{return DEFVAR;}
"ENDDEF"		{findec=1; return ENDDEF;}
"FLOAT"			{strcpy(regTS.tipo, "FLOAT"); return FLOAT;}
"INT"			{strcpy(regTS.tipo, "INT"); return INT;}
"STRING"		{strcpy(regTS.tipo, "STRING"); return STRING;}
"DISPLAY"		{return DISPLAY;}
"GET"			{return GET;}
"WHILE"			{return WHILE;}
"ENDWHILE"		{return ENDWHILE;}
"IF"			{return IF;}
"ELSE"			{return ELSE;}
"ENDIF"			{return ENDIF;}
"AND"			{return AND;}
"OR"			{return OR;}
"NOT"			{return NOT;}
"FACT"			{return FACT;}
"COMB"			{return COMB;}
";"				{return PYC;}
"("				{return PAR_A;}
")"				{return PAR_C;}
","				{return COMA;}
":"				{return OP_DEF;}
":="			{return OP_ASIG;}
"+"				{return OP_SUM;}
"-"				{return OP_RES;}
"/"				{return OP_DIV;}
"*"				{return OP_MUL;}
"<"				{return OP_LT;}
">"				{return OP_GT;}
"=="			{return OP_EQ;}
"<="			{return OP_LE;}
">="			{return OP_GE;}
"!="			{return OP_NE;}
{CONS_FLO}		{	
					if (validarReal(atof(yytext))) 
					{ 
						insertarEnTS(yytext, 0); 
						yylval.flo=atof(yytext);
						return CONS_FLO; 
					} else 
					{ 
						printf("La constante esta fuera de rango %s\n", yytext); 
					}  
				}
{CONS_ENTERO}	{	
					if (validarInteger(atoi(yytext))) 
					{ 
						insertarEnTS(yytext, 0); 
						yylval.ent=atoi(yytext);						
						return CONS_ENTERO; 
					} else 
					{ 
						printf("La constante esta fuera de rango %s\n", yytext); 
					} 
				}
{CONS_CAD}		{	
					if (validarString(yytext)) 
					{ 
						insertarEnTS(yytext, 1); 
						yylval.cad = strdup(yytext); 
						return CONS_CAD;
					} else 
					{ 
						printf("La constante string excede el maximo permitido\n"); 
					} 
				}
{ID}			{
					if(strlen(yytext) <= 10 )
					{
						if(findec == 0)
						{
							if(!guardadoEnTabla(yytext,1))
							{
								strcpy(regTS.nombre, yytext);
								insertarVarEnTS();
								yylval.id = strdup(yytext);
								return ID;
							}else
							{
								printf("Error: Declaracion de dos variables con el mismo nombre.\n");
							}
						}else
						{
							if(guardadoEnTabla(yytext,1))
							{
								yylval.id = strdup(yytext);
								return ID;
							}else
							{
								printf("Error: Utilizacion de variable sin declaracion\n");
							}
						}
					}else
					{
						printf("Las variables deben tener un largo maximo de 10 caracteres.\n");
					}
				}
{COMEN}			{ }
{COMEN_ANI}		{ }
" "				{ }
"\t"			{ }
\n				{ ++linea; }
{ANY}			{ errorCharInvalido();}
%%

void insertarEnTS(char *yytext, int isString)
{
	if(!guardadoEnTabla(yytext,0))
	{
		if ((ts = fopen("ts.txt", "a")) == NULL)
		{
			printf("No se puede abrir el archivo ts.txt\n");
		}
		else 
		{
			if (isString)
			{
				char *str = yytext + 1;
				char *aux = malloc(sizeof(char)*40);

				removerComillas(str, aux);
				
				fprintf(ts, "_%-30s | %-30s | %-30s | %-30d\n", aux,"", aux, strlen(aux));
				
				free(aux);
			}
			else 
			{
				fprintf(ts, "_%-30s | %-30s | %-30s |\n", yytext,"", yytext);
			}
			
		}
		fclose(ts);
	}
}

void removerComillas(char *str, char *aux)
{
    int longStr = strlen(str);
    strncpy(aux, str, longStr);
    *(aux + longStr - 1) = '\0';
}

void insertarVarEnTS() 
{
	if ((ts = fopen("ts.txt", "a")) == NULL)
	{
		printf("No se puede abrir el archivo: ts.txt\n");
	}
	else 
	{
			fprintf(ts, "%-31s | %-30s | %-30s | \n", regTS.nombre, regTS.tipo, "-");
	}
	fclose(ts);
}

int guardadoEnTabla(char *nombre, int var)
{
    char str[200];
	char nom[50];
	char nompar[50];
	if (!var)
	{
		char par[50];
		strcpy(nompar,"");
		strcpy(par,"");
		strcpy(par,"_");
		strcat(nompar, par);
		strcat(nompar, nombre);
	}
	else
	{
		strcpy(nompar,nombre);
	}
	
    if ((ts = fopen("ts.txt", "r")) == NULL)
    {
        printf("No se puede abrir el archivo ts.txt\n");
    }
    else
    {
        while(fgets(str,200,ts)!=NULL)
		{
			sscanf( str, "%s", nom );
			if(strcmp(nompar, nom)==0)
			{
			    fclose(ts);
				return 1;
			}
        }
    }
    fclose(ts);
    return 0;
}

int validarString(char *palabra) 
{
    if (strlen(palabra) <= 30) 
	{
		return 1;
    } 
	else 
	{
        return 0;
    }
}

int validarInteger(int num) 
{
    if ( 0 <= num  &&  num <= 65535)
	{
		return 1;
    } 
	else
	{
        return 0;
    }
}

int validarReal(double num)
{
    if ( num >= 0.0 && num <= pow(3.4,+38))
	{
        return 1;
    } 
	else 
	{
        return 0;
    }
}

void errorCharInvalido()
{
	printf("Caracter invalido ingresado\n");
	system ("Pause");
    exit (1);
}
