%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

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
int validarString(char *palabra);
int validarInteger(int num);
int validarReal(double num);
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

%%
"DEFVAR"		{return DEFVAR;}
"ENDDEF"		{return ENDDEF;}
"FLOAT"			{strcpy(regTS.tipo, "FLOAT"); return FLOAT;}
"INT"			{strcpy(regTS.tipo, "INT"); return INT;}
"STRING"		{strcpy(regTS.tipo, "STRING"); return STRING;}
"DISPLAY"		{return DISPLAY;}
"GET"			{return GET;}
"WHILE"			{return WHILE;}
"ENDWHILE"		{return ENDWHILE;}
"IF"			{return IF;}
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
{CONS_FLO}		{if (validarReal(atof(yytext))) { insertarEnTS(yytext, 0); return CONS_FLO; } else { printf("La constante esta fuera de rango %s\n", yytext); }}
{CONS_ENTERO}	{if (validarInteger(atoi(yytext))) { insertarEnTS(yytext, 0); return CONS_ENTERO; } else { printf("La constante esta fuera de rango %s\n", yytext); }}
{CONS_CAD}		{if (validarString(yytext)) {insertarEnTS(yytext, 1); return CONS_CAD;} else {printf("La constante excede los caracteres permitidos %d\n", strlen(yytext));}}
{ID}			{strcpy(regTS.nombre, yytext); insertarVarEnTS(); return ID;}
{COMEN}			{ }
{COMEN_ANI}		{ }
" "				{ }
"\t"			{ }
"\n"			{ }
%%

void insertarEnTS(char *yytext, int isString)
{
	if ((ts = fopen("ts.txt", "a")) == NULL)
	{
		printf("No se puede abrir el archivo ts.txt\n");
	}
	else 
	{
		if(!guardadoEnTabla(yytext))
		{
			if (isString)
			{
				fprintf(ts, "_%s\t\t\t%s\t%d\n", yytext, yytext, strlen(yytext));
			}
			else 
			{
				fprintf(ts, "_%s\t\t\t%s\t\n", yytext, yytext);
			}
		}
	}
	fclose(ts);
}

void insertarVarEnTS() 
{
	if ((ts = fopen("ts.txt", "a")) == NULL)
	{
		printf("No se puede abrir el archivo: ts.txt\n");
	}
	else 
	{
		if(!guardadoEnTabla(regTS.nombre))
		{
			fprintf(ts, "%s\t\t\t\t\t%s\t-\t\n", regTS.nombre, regTS.tipo);
		}
	}
	fclose(ts);
}

void guardadoEnTabla(char *yytext)
{
    char str[100];
    if ((ts = fopen("ts.txt", "r")) == NULL)
    {
        printf("No se puede abrir el archivo ts.txt");
    }
    else
    {
        while(fgets(str,100,fp)!=NULL))
		{
            if(strstr(str, yytext) != NULL)
			{
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
