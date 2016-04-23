
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
     ENTERO = 258,
     DECIMAL = 259,
     TEXTO = 260,
     NUMBER = 261,
     IDENTIFICADOR = 262,
     BANDERA = 263,
     PLUS = 264,
     MINUS = 265,
     TIMES = 266,
     SLASH = 267,
     LPAREN = 268,
     RPAREN = 269,
     LCURLY = 270,
     RCURLY = 271,
     SEMICOLON = 272,
     COMMA = 273,
     DOT = 274,
     EQL = 275,
     EQLEQL = 276,
     NEQ = 277,
     COLON = 278,
     LSS = 279,
     GTR = 280,
     CONDICIONSYM = 281,
     PROGRAMASYM = 282,
     FALLOSYM = 283,
     VARSYM = 284,
     MUESTRASYM = 285,
     MUESTRALINEASYM = 286,
     LEESYM = 287,
     BANDERASYM = 288,
     CARACTERSYM = 289,
     ENTEROSYM = 290,
     GRANENTEROSYM = 291,
     DECIMALSYM = 292,
     TEXTOSYM = 293,
     ARREGLOSYM = 294,
     MATRIZSYM = 295,
     CICLOSYM = 296,
     HAZSYM = 297,
     MIENTRASSYM = 298,
     FUNCIONSYM = 299,
     REGRESASYM = 300,
     INCLUIRSYM = 301,
     FALSOSYM = 302,
     VERDADEROSYM = 303,
     OBJETOSYM = 304,
     PRIVADOSYM = 305,
     PUBLICOSYM = 306
   };
#endif
/* Tokens.  */
#define ENTERO 258
#define DECIMAL 259
#define TEXTO 260
#define NUMBER 261
#define IDENTIFICADOR 262
#define BANDERA 263
#define PLUS 264
#define MINUS 265
#define TIMES 266
#define SLASH 267
#define LPAREN 268
#define RPAREN 269
#define LCURLY 270
#define RCURLY 271
#define SEMICOLON 272
#define COMMA 273
#define DOT 274
#define EQL 275
#define EQLEQL 276
#define NEQ 277
#define COLON 278
#define LSS 279
#define GTR 280
#define CONDICIONSYM 281
#define PROGRAMASYM 282
#define FALLOSYM 283
#define VARSYM 284
#define MUESTRASYM 285
#define MUESTRALINEASYM 286
#define LEESYM 287
#define BANDERASYM 288
#define CARACTERSYM 289
#define ENTEROSYM 290
#define GRANENTEROSYM 291
#define DECIMALSYM 292
#define TEXTOSYM 293
#define ARREGLOSYM 294
#define MATRIZSYM 295
#define CICLOSYM 296
#define HAZSYM 297
#define MIENTRASSYM 298
#define FUNCIONSYM 299
#define REGRESASYM 300
#define INCLUIRSYM 301
#define FALSOSYM 302
#define VERDADEROSYM 303
#define OBJETOSYM 304
#define PRIVADOSYM 305
#define PUBLICOSYM 306




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 187 "parser.y"

	int ival;
	float fval;
	char *sval;
	bool bval;



/* Line 1676 of yacc.c  */
#line 163 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


