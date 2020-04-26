
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     DEFVAR = 258,
     ENDDEF = 259,
     CONS_FLO = 260,
     CONS_ENTERO = 261,
     CONS_CAD = 262,
     ID = 263,
     FLOAT = 264,
     INT = 265,
     STRING = 266,
     DISPLAY = 267,
     GET = 268,
     WHILE = 269,
     ENDWHILE = 270,
     IF = 271,
     ENDIF = 272,
     AND = 273,
     OR = 274,
     NOT = 275,
     FACT = 276,
     COMB = 277,
     PYC = 278,
     PAR_A = 279,
     PAR_C = 280,
     COMA = 281,
     OP_DEF = 282,
     OP_ASIG = 283,
     OP_SUM = 284,
     OP_RES = 285,
     OP_DIV = 286,
     OP_MUL = 287,
     OP_LT = 288,
     OP_GT = 289,
     OP_EQ = 290,
     OP_LE = 291,
     OP_GE = 292,
     OP_NE = 293
   };
#endif
/* Tokens.  */
#define DEFVAR 258
#define ENDDEF 259
#define CONS_FLO 260
#define CONS_ENTERO 261
#define CONS_CAD 262
#define ID 263
#define FLOAT 264
#define INT 265
#define STRING 266
#define DISPLAY 267
#define GET 268
#define WHILE 269
#define ENDWHILE 270
#define IF 271
#define ENDIF 272
#define AND 273
#define OR 274
#define NOT 275
#define FACT 276
#define COMB 277
#define PYC 278
#define PAR_A 279
#define PAR_C 280
#define COMA 281
#define OP_DEF 282
#define OP_ASIG 283
#define OP_SUM 284
#define OP_RES 285
#define OP_DIV 286
#define OP_MUL 287
#define OP_LT 288
#define OP_GT 289
#define OP_EQ 290
#define OP_LE 291
#define OP_GE 292
#define OP_NE 293




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


