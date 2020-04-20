%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
FILE *yyin;
%}

%option noyywrap  
%option yylineno 


DIGITO 			[0-9]
LETRA 			[a-zA-Z]
BLANCO			{" "}
SIMBOLO			( "@" | "%" | {BLANCO} | ":" )
CONS_REAL		{"-"}?( {DIGITO}+"."{DIGITO}+ | {DIGITO}*"."{DIGITO}+ | {DIGITO}+"."{DIGITO}* )
CONS_ENTERO		{"-"}?{DIGITO}+
CONS_STRING		"""( {LETRA}|{SIMBOLO}|{DIGITO} )+"""
ID				{LETRA}({LETRA}|{DIGITO})*
COMEN			{"***/"}({DIGITO}|{SIMBOLO}|{LETRA})*{"/***"}
COMEN_ANI		{"***/"}({DIGITO}|{SIMBOLO}|{LETRA})* {COMEN}? ({DIGITO}|{SIMBOLO}|{LETRA})* {"/***"}


%%
"DEFVAR"		{return DEFVAR;}
"ENDVAR"		{return ENDVAR;}
"DISPLAY"		{return DISPLAY;}
"GET"			{return GET;}
"WHILE"			{return WHILE;}
"IF"			{return IF;}
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
COMEN			{ }
COMEN_ANI		{ }
BLANCO			{ }
"\t"			{ }
"\n"			{ }

"="				{return OP_;}

