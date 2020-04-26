%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "y.tab.h"

FILE *yyin;
FILE *ts;

struct filaTS {
	char *nombre;
	char *tipo;
};

struct filaTS regTS;
%}

%option noyywrap  
%option yylineno 

DIGITO 			[0-9]
LETRA 			[a-zA-Z]
BLANCO			{" "}
COMILLAS		{"""}
SIMBOLO			( "@" | "%" | {BLANCO} | ":" | {COMILLAS} )
CONS_REAL		( {DIGITO}+"."{DIGITO}+ | {DIGITO}*"."{DIGITO}+ | {DIGITO}+"."{DIGITO}* )
CONS_ENTERO		{DIGITO}+
CONS_STRING		{COMILLAS}( {LETRA}|{SIMBOLO}|{DIGITO}|{BLANCO} )*{COMILLAS}
ID				{LETRA}({LETRA}|{DIGITO})*
COMEN			{"***/"}({DIGITO}|{SIMBOLO}|{LETRA})*{"/***"}
COMEN_ANI		{"***/"}({DIGITO}|{SIMBOLO}|{LETRA})* {COMEN}? ({DIGITO}|{SIMBOLO}|{LETRA})* {"/***"}

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
{CONS_REAL}		{if (validarReal(atof(yytext))) { insertarEnTS(yytext, 0); return CONS_REAL; } else { printf(\"La constante esta fuera de rango %s\", yytext); }}
{CONS_ENTERO}	{if (validarInteger(atoi(yytext))) { insertarEnTS(yytext, 0); return CONS_ENTERO; } else { printf(\"La constante esta fuera de rango %s\", yytext); }}
{CONS_STRING}	{if (validarString(yytext)) { insertarEnTS(yytext, 1); return CONS_STRING; } else { printf(\"La constante excede los caracteres permitidos %d\", strlen(yytext)); }}
{ID}			{strcpy(regTS.nombre, yytext); return ID;}
{COMEN}			{ }
{COMEN_ANI}		{ }
{BLANCO}		{ }
\t				{ }
\n				{ }
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
			yylex();
		}
		else 
		{
			return 2;
		}
	}
	fclose(yyin);
	return 0;
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

void insertarEnTS(char *yytext, int isString)
{
	if ((ts = fopen("ts.txt", "a")) == NULL)
	{
		printf("No se puede abrir el archivo ts.txt");
		return;
	}
	else 
	{
		if (isString)
		{
			fprintf(ts, "_%s\t\t%s\t%d", yytext, yytext, strlen(yytext));
		}
		else 
		{
			fprintf(ts, "_%s\t\t%s\t", yytext, yytext);
		}
	}
	fclose(ts);
}

void insertarVarEnTS() {
	if ((ts = fopen("ts.txt", "a")) == NULL)
	{
		printf("No se puede abrir el archivo: ts.txt");
		return;
	}
	else 
	{
		fprintf(ts, "%s\t%s\t-\t", regTS.nombre, regTS.tipo);
	}
	fclose(ts);
}

int validarString(char *palabra) {
    if (strlen(palabra) <= 30) {
		return 1;
    } else {
        return 0;
    }
}

int validarInteger(int num) {
    if ( 0 <= num  &&  num <= 65535) {
		return 1;
    } else {
        return 0;
    }
}

int validarReal(double num) {
    if ( num >= 0.0 && num <= pow(3.4,+38)) {
        return 1;
    } else {
        return 0;
    }
}
