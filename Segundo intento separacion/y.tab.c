
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 1 "parser.y"

#include <cstdio>
#include <iostream>
#include <string.h>
#include "cuadruplo.cpp"
#include "estructura.cpp"
#include <stack>
#include <string>     // std::string, std::to_string
#include <vector>
#include <sstream>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern char * yytext;
extern "C" FILE *yyin;
extern int line_num;

 
const bool debug = false;

struct constante
{
	int direccion;
	int tipo;
	string valor;
};
void yyerror(const char *s);
void printCuboSemantico();
void printCuadruplos();
void rellenar(int fin, int cont);

//Expresiones
void accion_1_expresiones(string yytext, int tipo);
void accion_2_expresiones(string operador);
void accion_3_expresiones(string operador);
void accion_4_expresiones();
void accion_5_expresiones();
void accion_6_expresiones(string fondoFalso);
void accion_7_expresiones();
void accion_8_expresiones(string operador);
void accion_9_expresiones();

//Assignaciones
void accion_1_assignacion(int dirOperando);
void accion_2_assignacion(string operador);
void accion_3_assignacion();


//Estatuto CONDICION-FALLO
void accion_1_condicion_fallo();
void accion_2_condicion_fallo();
void accion_3_condicion_fallo();


//Estatuto Ciclo
void accion_1_ciclo();
void accion_2_ciclo();
void accion_3_ciclo();


//Estatuto Haz-Mientras
void accion_1_haz_mientras();
void accion_2_haz_mientras();

//Definicion de un procedimiento
void accion_1_definicion_proc(string tipo, string nombre);
void accion_2_definicion_proc(string tipo, string nombre, int direccion);
void accion_3_definicion_proc();
void accion_4_definicion_proc();
void accion_5_definicion_proc();
void accion_6_definicion_proc();
void accion_7_definicion_proc();

// Llamada un procedimiento
void accion_1_llamada_proc(string objetoNombre, string metodoNombre);
void accion_2_llamada_proc();
void accion_3_llamada_proc();
void accion_4_llamada_proc();
void accion_5_llamada_proc();
void accion_6_llamada_proc(string nombreProc);


int getIndexOperador(string operador);
int getSiguienteDireccion(string tipo, bool constante);
template <typename T> string to_string(T value);


dirProcedimientos dirProcedimientos ;
string yyTipo = "";
string objetoNombre = "default";
string metodoNombre = "";
string funcionNombre = "";


int offsetEntero     = 1000;
int offsetEnteroConstante = 4500;

int offsetDecimal    = 5000;
int offsetDecimalConstante = 9500;


int offsetBandera    = 10000;
int offsetBanderaConstante = 12500;

int offsetTexto      = 13000;
int offsetTextoConstante = 19500;

int offsetTemporales = 20000;
int offsetTemporalesConstante = 29500;

int offsetVacio 	=	30000;
int offsetVacioConstante 	=	35000;

int indexEnteros    = 0;
int indexDecimal    = 0;
int idnexBandera    = 0;
int indexTexto      = 0;
int indexTemporales = 0;
int indexVacio		= 0;
int indexEnteroConstantes    = 0;
int indexDecimalConstantes    = 0;
int idnexBanderaConstantes    = 0;
int indexTextoConstantes      = 0;
int indexTemporalesConstantes = 0;
int indexVacioConstantes 	  = 0;

int indexParametro = 0;

bool metodo = false;
stack<int> pilaOperandos;
stack<string> pilaOperadores;
stack<int> pilaTipos;
stack<int> pilaSaltos;

vector<Cuadruplo> cuadruplos; 
vector<constante> constantes;

int cuboSemantico[4][4][13] = 	{
								  	{  // bandera 0
                                        //  0     1     2     3     4     5     6     7     8     9    10    11     12
                                        //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
                                        {  -1  , -1  , -1  , -1  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0  ,  0   },  // bandera 0
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1   },  // entero  1
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1   },  // decimal 2
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1   },  // texto   3
                                    }, 

                                    {   // entero 1  
                                        //  0     1     2     3     4     5     6     7     8     9    10    11     12
                                        //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1   },  // bandera 0
                                        {   1  ,  1  ,  1  ,  1  ,  0  ,  0  ,  0  ,  0  ,  1  ,  0  ,  0  , -1  , -1   },  // entero  1
                                        {   2  ,  2  ,  2  ,  2  ,  0  ,  0  ,  0  ,  0  ,  1  ,  0  ,  0  , -1  , -1   },  // decimal 2
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1   },  // texto   3
                                    },

                                    {   // decimal 2
                                        //  0     1     2     3     4     5     6     7     8     9    10    11     12
                                        //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  ,  -1  },  // bandera 0
                                        {   2  ,  2  ,  2  ,  2  ,  0  ,  0  ,  0  ,  0  ,  2  ,  0  ,  0  , -1  ,  -1  },  // entero  1
                                        {   2  ,  2  ,  2  ,  2  ,  0  ,  0  ,  0  ,  0  ,  2  ,  0  ,  0  , -1  ,  -1  },  // decimal 2
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  ,  -1  },  // texto   3
                                    },  

                                    {   // texto 3
                                        //  0     1     2     3     4     5     6     7     8     9    10    11     12
                                        //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  ,  -1  },  // bandera 0
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  ,  -1  },  // entero  1
                                        {  -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  , -1  ,  -1  },  // decimal 2
                                        {  -1  , -1  , -1  , -1  ,  0  ,  0  , -1  , -1  ,  3  , -1  , -1  , -1  ,  -1  },  // texto   3
                                    }   
                              	};

//dirProcedimientos dirProcs; 



/* Line 189 of yacc.c  */
#line 255 "y.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


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

/* Line 214 of yacc.c  */
#line 187 "parser.y"

	int ival;
	float fval;
	char *sval;
	bool bval;



/* Line 214 of yacc.c  */
#line 402 "y.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 414 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  6
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   243

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  52
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  89
/* YYNRULES -- Number of rules.  */
#define YYNRULES  141
/* YYNRULES -- Number of states.  */
#define YYNSTATES  255

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   306

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     8,    10,    11,    20,    26,    28,    34,
      36,    39,    44,    46,    47,    49,    51,    52,    53,    54,
      65,    67,    68,    69,    70,    81,    83,    85,    87,    89,
      91,    93,    97,   101,   102,   103,   109,   111,   114,   116,
     117,   118,   124,   126,   129,   131,   132,   136,   138,   139,
     144,   146,   151,   155,   157,   163,   167,   169,   172,   174,
     176,   178,   180,   182,   184,   186,   187,   192,   193,   198,
     200,   201,   206,   208,   209,   210,   216,   219,   222,   224,
     226,   228,   230,   232,   233,   237,   238,   242,   243,   247,
     249,   250,   254,   255,   259,   260,   264,   266,   267,   268,
     274,   277,   279,   281,   283,   285,   287,   289,   291,   293,
     295,   297,   299,   301,   303,   307,   309,   313,   315,   316,
     321,   322,   327,   328,   336,   337,   341,   343,   344,   345,
     357,   358,   366,   368,   370,   375,   380,   382,   384,   386,
     389,   392
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      53,     0,    -1,    59,    54,    62,   139,    -1,    55,    -1,
      -1,    49,     7,    56,    15,    57,    58,    16,    17,    -1,
      50,    15,   122,    62,    16,    -1,   140,    -1,    51,    15,
     121,    63,    16,    -1,   140,    -1,    60,    61,    -1,    46,
      24,     7,    25,    -1,    60,    -1,    -1,    64,    -1,    68,
      -1,    -1,    -1,    -1,    44,    72,    65,     7,    66,    73,
      89,    17,    67,    64,    -1,   140,    -1,    -1,    -1,    -1,
      44,    72,    69,     7,    70,    74,    89,    17,    71,    68,
      -1,   140,    -1,    35,    -1,    37,    -1,    38,    -1,    33,
      -1,     7,    -1,    13,    75,    14,    -1,    13,    79,    14,
      -1,    -1,    -1,    72,    76,     7,    77,    78,    -1,   140,
      -1,    18,    75,    -1,   140,    -1,    -1,    -1,    72,    80,
       7,    81,    82,    -1,   140,    -1,    18,    79,    -1,   140,
      -1,    -1,   102,    84,    85,    -1,   140,    -1,    -1,    18,
     102,    86,    85,    -1,   140,    -1,    15,   121,    88,    16,
      -1,    92,    17,    88,    -1,   140,    -1,    15,   121,    90,
      91,    16,    -1,    92,    17,    90,    -1,   140,    -1,    45,
     102,    -1,   140,    -1,    99,    -1,   127,    -1,   131,    -1,
     136,    -1,   138,    -1,    93,    -1,    -1,     7,    94,    95,
      97,    -1,    -1,    19,     7,    96,    95,    -1,   140,    -1,
      -1,    13,    98,    83,    14,    -1,   140,    -1,    -1,    -1,
       7,   100,    20,   101,   102,    -1,   105,   103,    -1,   104,
     105,    -1,   140,    -1,    24,    -1,    25,    -1,    21,    -1,
      22,    -1,    -1,   110,   106,   107,    -1,    -1,     9,   108,
     105,    -1,    -1,    10,   109,   105,    -1,   140,    -1,    -1,
     115,   111,   112,    -1,    -1,    11,   113,   110,    -1,    -1,
      12,   114,   110,    -1,   140,    -1,    -1,    -1,    13,   116,
     102,   117,    14,    -1,   118,   119,    -1,     9,    -1,    10,
      -1,   140,    -1,    93,    -1,     3,    -1,     8,    -1,     5,
      -1,     4,    -1,     7,    -1,     3,    -1,     8,    -1,     5,
      -1,     4,    -1,   123,    17,   121,    -1,   140,    -1,   125,
      17,   122,    -1,   140,    -1,    -1,    29,    72,   124,     7,
      -1,    -1,    29,    72,   126,     7,    -1,    -1,    26,    13,
     102,    14,   128,    87,   129,    -1,    -1,    28,   130,    87,
      -1,   140,    -1,    -1,    -1,    41,   132,    13,   135,    18,
     102,   133,    18,   135,    14,    87,    -1,    -1,    42,   134,
      87,    43,    13,   102,    14,    -1,    99,    -1,   140,    -1,
      31,    13,   137,    14,    -1,    30,    13,   137,    14,    -1,
      93,    -1,   120,    -1,   140,    -1,    32,   120,    -1,    27,
      87,    -1,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   268,   268,   270,   272,   272,   280,   281,   283,   284,
     288,   289,   290,   290,   295,   296,   298,   298,   301,   298,
     305,   307,   307,   313,   307,   317,   320,   321,   322,   323,
     324,   327,   328,   330,   330,   330,   335,   336,   337,   339,
     339,   339,   345,   346,   347,   350,   350,   353,   355,   355,
     358,   362,   363,   364,   366,   371,   372,   373,   376,   379,
     380,   381,   382,   383,   384,   387,   387,   409,   409,   414,
     415,   415,   422,   434,   444,   434,   454,   455,   456,   458,
     459,   460,   461,   463,   463,   464,   464,   468,   468,   471,
     473,   473,   474,   474,   477,   477,   480,   482,   482,   482,
     483,   484,   485,   486,   490,   494,   498,   502,   506,   513,
     514,   515,   516,   517,   522,   523,   524,   525,   529,   529,
     539,   539,   551,   551,   554,   554,   558,   562,   564,   562,
     569,   569,   574,   575,   577,   578,   580,   581,   582,   585,
     587,   589
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "ENTERO", "DECIMAL", "TEXTO", "NUMBER",
  "IDENTIFICADOR", "BANDERA", "PLUS", "MINUS", "TIMES", "SLASH", "LPAREN",
  "RPAREN", "LCURLY", "RCURLY", "SEMICOLON", "COMMA", "DOT", "EQL",
  "EQLEQL", "NEQ", "COLON", "LSS", "GTR", "CONDICIONSYM", "PROGRAMASYM",
  "FALLOSYM", "VARSYM", "MUESTRASYM", "MUESTRALINEASYM", "LEESYM",
  "BANDERASYM", "CARACTERSYM", "ENTEROSYM", "GRANENTEROSYM", "DECIMALSYM",
  "TEXTOSYM", "ARREGLOSYM", "MATRIZSYM", "CICLOSYM", "HAZSYM",
  "MIENTRASSYM", "FUNCIONSYM", "REGRESASYM", "INCLUIRSYM", "FALSOSYM",
  "VERDADEROSYM", "OBJETOSYM", "PRIVADOSYM", "PUBLICOSYM", "$accept",
  "programa", "Objetos", "Objeto", "$@1", "AtributosPrivados",
  "AtributosPublicos", "Librerias", "Libreria", "Libreria1", "Funciones",
  "FuncionesObjetos", "Funcion", "$@2", "$@3", "$@4", "FuncionObjeto",
  "$@5", "$@6", "$@7", "Tipo", "Params", "ParamsObjeto", "Param", "$@8",
  "$@9", "Param1", "ParamObjeto", "$@10", "$@11", "ParamObjeto1", "Args",
  "$@12", "Args1", "$@13", "Bloque", "Bloque1", "BloqueFuncion",
  "BloqueFuncion1", "BloqueFuncion2", "Estatuto", "Llamada", "$@14",
  "Llamada1", "$@15", "Llamada2", "$@16", "Asignacion", "$@17", "$@18",
  "Expresion", "Expresion1", "Expresion2", "Exp", "$@19", "Exp1", "$@20",
  "$@21", "Termino", "$@22", "Termino1", "$@23", "$@24", "Factor", "$@25",
  "$@26", "Factor1", "VarCteExp", "VarCte", "Variables",
  "VariablesObjetos", "Variable", "$@27", "VariableObjeto", "$@28",
  "Condicion", "$@29", "Condicion1", "$@30", "Ciclo", "$@31", "$@32",
  "$@33", "Ciclo1", "Escritura", "EstatutosSalida", "Lectura", "Main",
  "epsilon", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    52,    53,    54,    56,    55,    57,    57,    58,    58,
      59,    60,    61,    61,    62,    63,    65,    66,    67,    64,
      64,    69,    70,    71,    68,    68,    72,    72,    72,    72,
      72,    73,    74,    76,    77,    75,    75,    78,    78,    80,
      81,    79,    79,    82,    82,    84,    83,    83,    86,    85,
      85,    87,    88,    88,    89,    90,    90,    91,    91,    92,
      92,    92,    92,    92,    92,    94,    93,    96,    95,    95,
      98,    97,    97,   100,   101,    99,   102,   103,   103,   104,
     104,   104,   104,   106,   105,   108,   107,   109,   107,   107,
     111,   110,   113,   112,   114,   112,   112,   116,   117,   115,
     115,   118,   118,   118,   119,   119,   119,   119,   119,   120,
     120,   120,   120,   120,   121,   121,   122,   122,   124,   123,
     126,   125,   128,   127,   130,   129,   129,   132,   133,   131,
     134,   131,   135,   135,   136,   136,   137,   137,   137,   138,
     139,   140
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     4,     1,     0,     8,     5,     1,     5,     1,
       2,     4,     1,     0,     1,     1,     0,     0,     0,    10,
       1,     0,     0,     0,    10,     1,     1,     1,     1,     1,
       1,     3,     3,     0,     0,     5,     1,     2,     1,     0,
       0,     5,     1,     2,     1,     0,     3,     1,     0,     4,
       1,     4,     3,     1,     5,     3,     1,     2,     1,     1,
       1,     1,     1,     1,     1,     0,     4,     0,     4,     1,
       0,     4,     1,     0,     0,     5,     2,     2,     1,     1,
       1,     1,     1,     0,     3,     0,     3,     0,     3,     1,
       0,     3,     0,     3,     0,     3,     1,     0,     0,     5,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     1,     3,     1,     0,     4,
       0,     4,     0,     7,     0,     3,     1,     0,     0,    11,
       0,     7,     1,     1,     4,     4,     1,     1,     1,     2,
       2,     0
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,    13,     0,     1,     0,   141,     3,
      12,    10,     0,     4,     0,     0,    14,    20,    11,     0,
      30,    29,    26,    27,    28,    16,     0,     2,   141,     0,
     141,   140,     0,   141,     7,    17,     0,   141,     0,   115,
     141,     0,     0,     9,     0,   118,    65,     0,     0,     0,
       0,   127,   130,     0,     0,    64,    59,    60,    61,    62,
      63,    53,   141,     0,   141,     0,   117,   141,     0,   141,
       0,     0,   141,     0,   141,   141,   141,   110,   113,   112,
     109,   111,   139,     0,     0,    51,   141,   114,   120,     0,
     141,   141,     5,    33,     0,    36,   141,     0,   119,     0,
     141,    69,    74,   101,   102,    97,     0,   141,    83,    90,
       0,   103,    65,   136,   137,     0,   138,     0,   141,     0,
      52,     0,     6,   116,     0,     0,    15,    25,     0,    31,
     141,    18,    67,    70,    66,    72,   141,   141,   122,    81,
      82,    79,    80,    76,   141,    78,   141,   141,   105,   108,
     107,    65,   106,   104,   100,   135,   134,    73,   132,     0,
     133,     0,   121,    21,     8,    34,   141,     0,    56,   141,
     141,   141,    75,    98,     0,    77,    85,    87,    84,    89,
      92,    94,    91,    96,   141,   141,     0,   141,   141,     0,
      58,   141,    19,    68,     0,    45,   103,     0,   141,   141,
     141,   141,   141,   128,     0,    22,   141,    35,    38,    57,
      54,    55,    71,   141,    99,   124,   123,   126,    86,    88,
      93,    95,     0,   131,     0,    37,   141,    46,    50,     0,
     141,   141,     0,    48,   125,     0,    39,     0,    42,     0,
     141,     0,     0,    32,    23,    49,   129,    40,   141,   141,
      24,   141,    41,    44,    43
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     8,     9,    19,    33,    42,     3,     4,    11,
      15,   125,    16,    29,    44,   169,   126,   186,   224,   248,
      93,    70,   232,    94,   128,   187,   207,   237,   242,   249,
     252,   194,   213,   227,   240,    31,    53,    97,   166,   189,
      54,    55,    72,   100,   170,   134,   171,    56,    73,   136,
     106,   143,   144,   107,   146,   178,   199,   200,   108,   147,
     182,   201,   202,   109,   137,   197,   110,   154,   114,    37,
      64,    38,    71,    65,   121,    57,   174,   216,   229,    58,
      83,   222,    84,   159,    59,   115,    60,    27,   111
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -160
static const yytype_int16 yypact[] =
{
     -38,    -5,    21,   -25,   -38,    19,  -160,    24,   -16,  -160,
    -160,  -160,    14,  -160,    20,     6,  -160,  -160,  -160,    29,
    -160,  -160,  -160,  -160,  -160,  -160,    32,  -160,    -2,    44,
      23,  -160,    45,    18,  -160,  -160,    20,     4,    53,  -160,
      52,    58,    68,  -160,    61,  -160,    71,    94,    95,    96,
      72,  -160,  -160,    78,    98,  -160,  -160,  -160,  -160,  -160,
    -160,  -160,    23,    20,   -16,    99,  -160,    23,   100,    20,
      80,   105,   101,   103,     0,    82,    82,  -160,  -160,  -160,
    -160,  -160,  -160,   106,    32,  -160,     4,  -160,  -160,    97,
      52,    74,  -160,  -160,   107,  -160,    23,   108,  -160,   117,
     113,  -160,  -160,  -160,  -160,  -160,   114,    81,  -160,  -160,
      93,  -160,  -160,  -160,  -160,   115,  -160,   116,   120,    88,
    -160,   125,  -160,  -160,    20,   118,  -160,  -160,   126,  -160,
       4,  -160,  -160,  -160,  -160,  -160,     0,     0,  -160,  -160,
    -160,  -160,  -160,  -160,     0,  -160,     8,    26,  -160,  -160,
    -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,   119,
    -160,   122,  -160,  -160,  -160,  -160,    91,   123,  -160,   -16,
     101,     0,  -160,  -160,    32,  -160,  -160,  -160,  -160,  -160,
    -160,  -160,  -160,  -160,     0,     0,   134,   124,     0,   127,
    -160,     4,  -160,  -160,   130,  -160,   131,   132,   121,     0,
       0,     0,     0,  -160,   133,  -160,    20,  -160,  -160,  -160,
    -160,  -160,  -160,   135,  -160,  -160,  -160,  -160,  -160,  -160,
    -160,  -160,   136,  -160,   137,  -160,     0,  -160,  -160,    32,
     120,    20,    80,  -160,  -160,   138,  -160,   141,  -160,   139,
     135,    32,   144,  -160,  -160,  -160,  -160,  -160,    74,   146,
    -160,    20,  -160,  -160,  -160
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,   153,  -160,
     102,  -160,   -10,  -160,  -160,  -160,   -83,  -160,  -160,  -160,
     -13,  -160,  -160,   -39,  -160,  -160,  -160,   -82,  -160,  -160,
    -160,  -160,  -160,   -72,  -160,   -81,    84,   -61,   -19,  -160,
    -126,   -70,  -160,     3,  -160,  -160,  -160,  -116,  -160,  -160,
    -122,  -160,  -160,  -128,  -160,  -160,  -160,  -160,  -159,  -160,
    -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,   128,   -55,
      85,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,  -160,
    -160,  -160,  -160,   -56,  -160,   104,  -160,  -160,    -8
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -74
static const yytype_int16 yytable[] =
{
      17,    25,   158,   119,   167,   113,   113,    87,     1,   103,
     104,    46,    91,   105,   172,   173,   175,   176,   177,     5,
      34,     6,    39,    45,     7,    43,    12,    20,    14,    61,
      47,    13,    66,    26,    48,    49,    50,   180,   181,    18,
     153,   130,   220,   221,    28,    51,    52,    30,    32,   195,
      88,    35,    36,    21,    39,    22,    17,    23,    24,    39,
      40,    95,   203,   204,   101,   167,   209,   116,   116,    41,
      62,   218,   219,    67,    69,    77,    78,    79,    61,    80,
      81,    63,    66,   127,    68,    77,    78,    79,    39,   112,
      81,   -73,   135,   198,    85,    96,   148,   149,   150,   145,
     151,   152,   139,   140,   233,   141,   142,    74,    75,    76,
     160,   163,    98,   122,   158,    86,    90,    92,   124,   118,
      99,   129,   168,   102,   132,   131,   133,   157,   138,   155,
     156,   161,   162,   165,   164,   185,   188,   184,   179,   183,
     191,   205,   206,   210,   212,   -47,   214,   223,   234,   215,
     231,   247,   241,   226,   230,   243,   244,    10,   190,   192,
     246,    17,   101,   196,   251,   250,    89,   225,   245,   254,
     120,   239,   211,   193,   235,   123,     0,     0,    82,   208,
     117,     0,     0,   168,     0,     0,     0,     0,     0,     0,
     217,     0,     0,     0,     0,     0,     0,     0,    95,     0,
       0,     0,     0,     0,     0,   228,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   236,     0,
       0,     0,   160,   238,     0,     0,     0,     0,     0,     0,
       0,     0,   228,     0,     0,     0,     0,     0,   236,     0,
     127,   253,     0,   238
};

static const yytype_int16 yycheck[] =
{
       8,    14,   118,    84,   130,    75,    76,    62,    46,     9,
      10,     7,    67,    13,   136,   137,   144,     9,    10,    24,
      28,     0,    30,    36,    49,    33,     7,     7,    44,    37,
      26,     7,    40,    27,    30,    31,    32,    11,    12,    25,
     110,    96,   201,   202,    15,    41,    42,    15,    50,   171,
      63,     7,    29,    33,    62,    35,    64,    37,    38,    67,
      15,    69,   184,   185,    72,   191,   188,    75,    76,    51,
      17,   199,   200,    15,    13,     3,     4,     5,    86,     7,
       8,    29,    90,    91,    16,     3,     4,     5,    96,     7,
       8,    20,   100,   174,    16,    15,     3,     4,     5,   107,
       7,     8,    21,    22,   226,    24,    25,    13,    13,    13,
     118,   124,     7,    16,   230,    17,    17,    17,    44,    13,
      19,    14,   130,    20,     7,    17,    13,     7,    14,    14,
      14,    43,     7,     7,    16,    13,    45,    18,   146,   147,
      17,     7,    18,    16,    14,    14,    14,    14,   229,    28,
      13,     7,    14,    18,    18,    14,    17,     4,   166,   169,
     241,   169,   170,   171,    18,   248,    64,   206,   240,   251,
      86,   232,   191,   170,   230,    90,    -1,    -1,    50,   187,
      76,    -1,    -1,   191,    -1,    -1,    -1,    -1,    -1,    -1,
     198,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   206,    -1,
      -1,    -1,    -1,    -1,    -1,   213,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   231,    -1,
      -1,    -1,   230,   231,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   240,    -1,    -1,    -1,    -1,    -1,   251,    -1,
     248,   249,    -1,   251
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    46,    53,    59,    60,    24,     0,    49,    54,    55,
      60,    61,     7,     7,    44,    62,    64,   140,    25,    56,
       7,    33,    35,    37,    38,    72,    27,   139,    15,    65,
      15,    87,    50,    57,   140,     7,    29,   121,   123,   140,
      15,    51,    58,   140,    66,    72,     7,    26,    30,    31,
      32,    41,    42,    88,    92,    93,    99,   127,   131,   136,
     138,   140,    17,    29,   122,   125,   140,    15,    16,    13,
      73,   124,    94,   100,    13,    13,    13,     3,     4,     5,
       7,     8,   120,   132,   134,    16,    17,   121,    72,    62,
      17,   121,    17,    72,    75,   140,    15,    89,     7,    19,
      95,   140,    20,     9,    10,    13,   102,   105,   110,   115,
     118,   140,     7,    93,   120,   137,   140,   137,    13,    87,
      88,   126,    16,   122,    44,    63,    68,   140,    76,    14,
     121,    17,     7,    13,    97,   140,   101,   116,    14,    21,
      22,    24,    25,   103,   104,   140,   106,   111,     3,     4,
       5,     7,     8,    93,   119,    14,    14,     7,    99,   135,
     140,    43,     7,    72,    16,     7,    90,    92,   140,    67,
      96,    98,   102,   102,   128,   105,     9,    10,   107,   140,
      11,    12,   112,   140,    18,    13,    69,    77,    45,    91,
     140,    17,    64,    95,    83,   102,   140,   117,    87,   108,
     109,   113,   114,   102,   102,     7,    18,    78,   140,   102,
      16,    90,    14,    84,    14,    28,   129,   140,   105,   105,
     110,   110,   133,    14,    70,    75,    18,    85,   140,   130,
      18,    13,    74,   102,    87,   135,    72,    79,   140,    89,
      86,    14,    80,    14,    17,    85,    87,     7,    71,    81,
      68,    18,    82,   140,    79
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:

/* Line 1455 of yacc.c  */
#line 272 "parser.y"
    { 
						objetoNombre = yytext; 
						dirProcedimientos.crearObjeto(objetoNombre); 

					}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 276 "parser.y"
    {
						dirProcedimientos.terminaBloque();
					}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 298 "parser.y"
    { yyTipo = yytext }
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 298 "parser.y"
    {
						funcionNombre = (yyvsp[(4) - (4)].sval);
						accion_1_definicion_proc(yyTipo, (yyvsp[(4) - (4)].sval));
					}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 301 "parser.y"
    {

					  dirProcedimientos.terminaBloque();
					}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 307 "parser.y"
    { yyTipo = yytext }
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 307 "parser.y"
    {
						funcionNombre = (yyvsp[(4) - (4)].sval);
						//dirProcedimientos.crearMetodo(yyTipo, $4);
						accion_1_definicion_proc(yyTipo, (yyvsp[(4) - (4)].sval));


					}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 313 "parser.y"
    {

					  dirProcedimientos.terminaBloque();
					}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 330 "parser.y"
    { yyTipo = yytext }
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 330 "parser.y"
    {
						int direccion_virtual = getSiguienteDireccion(yyTipo, 0);

						accion_2_definicion_proc(yyTipo, (yyvsp[(3) - (3)].sval), direccion_virtual);
					}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 339 "parser.y"
    { yyTipo = yytext }
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 339 "parser.y"
    {
						int direccion_virtual = getSiguienteDireccion(yyTipo, 0);
						accion_2_definicion_proc(yyTipo, (yyvsp[(3) - (3)].sval), direccion_virtual);
						// dirProcedimientos.agregaParametro(yyTipo, $3, direccion_virtual);

					}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 350 "parser.y"
    { 
					  accion_3_llamada_proc();
					}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 355 "parser.y"
    {
					  accion_3_llamada_proc();
					}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 366 "parser.y"
    {		

						Cuadruplo cuadruploTemp = Cuadruplo("retorno", "", "" , "");
						cuadruplos.push_back( cuadruploTemp );	
					}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 373 "parser.y"
    {
						accion_7_definicion_proc();
					}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 387 "parser.y"
    {
					 	
					// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
					// si es 4, entonces es un identificador

					   metodo = false;
					   objetoNombre = (yyvsp[(1) - (1)].sval);
					   metodoNombre = (yyvsp[(1) - (1)].sval);
					   int variableIndex = dirProcedimientos.buscaVariable(objetoNombre);

					   if (variableIndex == -1 ) { 
							cerr << "ERROR: Variable not found:  \"" << objetoNombre;
							cerr << "\" on line " << line_num << endl;
							exit(-1);
						}






					}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 409 "parser.y"
    {
					  metodoNombre = (yyvsp[(2) - (2)].sval);
					  metodo = true;
						accion_1_llamada_proc(objetoNombre, metodoNombre);
					}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 415 "parser.y"
    {
						//cout << "Metodo nombre" << metodoNombre << endl;
						accion_2_llamada_proc();
					}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 418 "parser.y"
    {
						accion_6_llamada_proc(metodoNombre);

					}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 422 "parser.y"
    {
						if ( metodo ) {
							//cout << "Metodo: " << metodoNombre << endl;
							accion_1_expresiones(metodoNombre, 4);
						}
						else {
							//cout << "Variable: " << objetoNombre << endl;
							accion_1_expresiones(objetoNombre, 4);

						}
					}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 434 "parser.y"
    {
										int direccionVariable = dirProcedimientos.buscaDireccion((yyvsp[(1) - (1)].sval));
										accion_1_assignacion(direccionVariable );
										int variableIndex = dirProcedimientos.buscaVariable((yyvsp[(1) - (1)].sval));
										if (variableIndex == -1 ) { 
											cerr << "ERROR: at symbol \"" << yytext;
											cerr << "\" on line " << line_num << endl;
											exit(-1);
										}
									}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 444 "parser.y"
    {
								accion_2_assignacion("=");
						}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 447 "parser.y"
    {
								accion_3_assignacion();
								
						}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 455 "parser.y"
    { accion_9_expresiones(); }
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 458 "parser.y"
    { accion_8_expresiones(yytext); }
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 459 "parser.y"
    { accion_8_expresiones(yytext); }
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 460 "parser.y"
    { accion_8_expresiones(yytext); }
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 461 "parser.y"
    { accion_8_expresiones(yytext); }
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 463 "parser.y"
    { accion_4_expresiones(); }
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 464 "parser.y"
    {
								accion_2_expresiones(yytext);
								
						   }
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 468 "parser.y"
    {
								accion_2_expresiones(yytext);
						   }
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 473 "parser.y"
    { accion_5_expresiones(); }
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 474 "parser.y"
    {
								accion_3_expresiones(yytext);
						   }
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 477 "parser.y"
    {
								accion_3_expresiones(yytext);
						   }
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 482 "parser.y"
    { accion_6_expresiones("("); }
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 482 "parser.y"
    { accion_7_expresiones(); }
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 490 "parser.y"
    { 

										
									 }
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 494 "parser.y"
    { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 1);
								}
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 498 "parser.y"
    { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 0);
									}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 502 "parser.y"
    { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 3);
									}
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 506 "parser.y"
    { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 2);

									}
    break;

  case 118:

/* Line 1455 of yacc.c  */
#line 529 "parser.y"
    { yyTipo = yytext }
    break;

  case 119:

/* Line 1455 of yacc.c  */
#line 529 "parser.y"
    {  
									//TODO Hace funcion que me regrese la direccion. 
									if (debug ) {
									}
									int direccion = getSiguienteDireccion(yyTipo, 0);
										cout << "Crear variable Tipo: " << yyTipo << " Nombre: " << (yyvsp[(4) - (4)].sval) << " Direccion: " <<   direccion   << endl;
									
									dirProcedimientos.crearVariable(yyTipo, (yyvsp[(4) - (4)].sval), 1, direccion );

								   }
    break;

  case 120:

/* Line 1455 of yacc.c  */
#line 539 "parser.y"
    { yyTipo = yytext }
    break;

  case 121:

/* Line 1455 of yacc.c  */
#line 539 "parser.y"
    {  
									//TODO Hace funcion que me regrese la direccion. 
									if (debug ) {
										cout << "Crear Objeto Tipo: " << yyTipo << " Nombre: " << (yyvsp[(4) - (4)].sval) << endl;
									}

									dirProcedimientos.crearVariable(yyTipo, (yyvsp[(4) - (4)].sval), 0, getSiguienteDireccion(yyTipo, 0) );  
								   }
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 551 "parser.y"
    {
						accion_1_condicion_fallo();
					}
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 554 "parser.y"
    {
						accion_2_condicion_fallo();
					}
    break;

  case 125:

/* Line 1455 of yacc.c  */
#line 556 "parser.y"
    {
						accion_3_condicion_fallo();
					}
    break;

  case 127:

/* Line 1455 of yacc.c  */
#line 562 "parser.y"
    {
							accion_1_ciclo();
					}
    break;

  case 128:

/* Line 1455 of yacc.c  */
#line 564 "parser.y"
    {
							accion_2_ciclo();
					}
    break;

  case 129:

/* Line 1455 of yacc.c  */
#line 566 "parser.y"
    {
							accion_3_ciclo();
					}
    break;

  case 130:

/* Line 1455 of yacc.c  */
#line 569 "parser.y"
    {
						accion_1_haz_mientras();
					}
    break;

  case 131:

/* Line 1455 of yacc.c  */
#line 571 "parser.y"
    {
						accion_2_haz_mientras();
					}
    break;

  case 140:

/* Line 1455 of yacc.c  */
#line 587 "parser.y"
    { printCuadruplos(); }
    break;



/* Line 1455 of yacc.c  */
#line 2394 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 595 "parser.y"


int main(int argc, char **argv) {
	// open a file handle to a particular file:
	// FILE *myfile = fopen("a.snazzle.file", "r");
	
	
	if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  	{
    	cerr << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
    	exit( 1 );{}
  	}
  	else {
		yyparse();
		cout << "Success reading file" << endl; 
  	}
	return 0;

	

}

void yyerror(const char *s) {


	extern int yylineno;	// defined and maintained in lex.c
 	extern char *yytext;	// defined and maintained in lex.c
 		 
    cerr << "ERROR: " << s << " at symbol \"" << yytext;
	cerr << "\" on line " << line_num << endl;
	exit(-1);
}

void accion_1_expresiones(string yytext, int tipo){
	if (debug ) {
		cout << "accion_1_expresiones Empieza " << line_num <<   endl;
	}
	// Si no era una variable registrada y es constante
	if ( tipo != 4 ) {
		// crea variable constante en el scope

		constante constante; 

		switch (tipo) {
			case 0: // bandera

				constante.direccion = getSiguienteDireccion("bandera", 1);
				constante.tipo = 0;
				constante.valor = yytext;

			break;
			case 1: // entero
				constante.direccion = getSiguienteDireccion("entero", 1);
				constante.tipo = 1;
				constante.valor = yytext;
			break;
			case 2: // decimal
				constante.direccion = getSiguienteDireccion("decimal", 1);
				constante.tipo = 2;
				constante.valor = yytext;

			break;
			case 3: // texto
				constante.direccion = getSiguienteDireccion("texto", 1);
				constante.tipo = 3;
				constante.valor = yytext;

			break;
		}
		

		constantes.push_back(constante);			
		pilaOperandos.push(constante.direccion);
		pilaTipos.push(constante.tipo);
		
		
		
	}
	else {

		// la variable ya estaba registrada

		int direccionVariable = dirProcedimientos.buscaDireccion(yytext);
		if (debug ) {

		cout << "accion_1_expresiones Else >>> " << yytext <<  " <<< " <<  endl;
		}
		if (direccionVariable != -1 ) {

			
			int tipoVariable = dirProcedimientos.checaTipo(yytext);

			int estructuraVariable = dirProcedimientos.checaEstructura(yytext);


			//0 bandera, 1 entero, 2 decimal, 3 texto
			if (tipoVariable < 4 && estructuraVariable == 0) {
			


				pilaOperandos.push(direccionVariable);
				pilaTipos.push(tipoVariable);

			}
			else  {
				cout << "No se permiten operaciones entre objetos";
				exit(0);
			}
		}
		else {
			cout << "Linea: " << line_num << endl;
			exit(0);
		}
	}
	if (debug ) {
		cout << "accion_1_expresiones Termina  " << line_num <<  endl;
	}

}

void accion_2_expresiones(string operador){
	if (debug ) { 
		cout << "accion_2_expresiones Empieza  " <<  line_num <<  endl;
	}
	pilaOperadores.push(operador);
	if (debug ) {
		cout << "accion_2_expresiones Termina  " <<  line_num <<  endl;
	}
}

void accion_3_expresiones(string operador){
	if (debug ) {
		cout << "accion_3_expresiones Empieza  " <<  line_num <<  endl;
	}
	pilaOperadores.push(operador);
	if (debug ) {
		cout << "accion_3_expresiones Termina  " << line_num  << endl;
	}
}

void accion_4_expresiones() {
	// Si top de pOperadores = + or -
	if (debug ) {
		cout << "accion_4_expresiones Empieza   " << line_num <<  endl;
	}
	if ( pilaOperadores.size() != 0 ) {

		if ( pilaOperadores.top() == "+" || pilaOperadores.top() == "-") {

			int tipoDer = -1, tipoIzq = -1;
			int tipoResultado = -1, tipoOperador;
			tipoDer = pilaTipos.top();
			pilaTipos.pop();

			tipoIzq = pilaTipos.top();
			pilaTipos.pop();

			//Checa si son permitidas las operaciones
			string operador = pilaOperadores.top();
			pilaOperadores.pop();

			tipoOperador  = getIndexOperador(operador);



			tipoResultado = cuboSemantico[tipoIzq][tipoDer][tipoOperador];

			if (tipoResultado != -1 ) {


				int der, izq;

				der = pilaOperandos.top();
				pilaOperandos.pop();

				izq = pilaOperandos.top();
				pilaOperandos.pop();

				// Aumenta los temporales en 1
				int resultado = getSiguienteDireccion("temporal",0);
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);

			}	
			else {
				cout << "Tipos incompatibles" << endl;
			}	

		}
	}
	if (debug ) {
		cout << "accion_4_expresiones Termina   " << line_num <<  endl;
	}
}


void accion_5_expresiones() {
	// Si top de pOperadores = * or /
	if (debug ) {
		cout << "accion_5_expresiones Empieza  " << line_num <<  endl;
	}
	if ( pilaOperadores.size() != 0 ) {
		if ( pilaOperadores.top() == "/" || pilaOperadores.top() == "*") {
			if (debug ) { 
				cout << "accion_5_expresiones If 1  >>>  <<< " <<  endl;
			}
			int tipoDer = -1, tipoIzq = -1;
			int tipoResultado = -1, tipoOperador;
			tipoDer = pilaTipos.top();
			pilaTipos.pop();

			tipoIzq = pilaTipos.top();
			pilaTipos.pop();
			if (debug ) {

				cout << "accion_5_expresiones If 2   " << line_num <<   endl;
			}
			//Checa si son permitidas las operaciones
			string operador = pilaOperadores.top();
			pilaOperadores.pop();
			if (debug ) {
				cout << "accion_5_expresiones If 3  >>>   " << line_num << endl;
			}
			tipoOperador  = getIndexOperador(operador);
			if (debug ) {
				cout << "accion_5_expresiones If 4  >>>   " << line_num <<  endl;
			}
			tipoResultado = cuboSemantico[tipoIzq][tipoDer][tipoOperador];
			if (debug ) {
				cout << "accion_5_expresiones If 5  >>>   " << line_num <<  endl;
			}

			if (tipoResultado != -1 ) {


				int der, izq;

				der = pilaOperandos.top();
				pilaOperandos.pop();

				izq = pilaOperandos.top();
				pilaOperandos.pop();

				// Aumenta los temporales en 1
				int resultado = getSiguienteDireccion("temporal", 0);
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);

			}	
			else {
				cout << "Tipos incompatibles" << endl;
			}	

		}
	}
	if (debug ) {
		cout << "accion_5_expresiones Termina  " << line_num <<  endl;
	}
}

void accion_6_expresiones(string fondoFalso){
	if (debug ) {
		cout << "accion_6_expresiones Empieza  " <<  line_num <<  endl;
	}
	pilaOperadores.push(fondoFalso);
	if (debug ) {
		cout << "accion_6_expresiones Termina  " <<  line_num <<  endl;
	}
}
void accion_7_expresiones(){
	if (debug ) {
		cout << "accion_7_expresiones Empieza   " << line_num << endl;
	}
	pilaOperadores.pop();
	if (debug ) {
		cout << "accion_7_expresiones Termina   " << line_num << endl;
	}
}
void accion_8_expresiones(string operador){
	if (debug ) {
		cout << "accion_8_expresiones Empieza  " <<  line_num << endl;
	}
	
	pilaOperadores.push(operador);
	if (debug ) {
		cout << "accion_8_expresiones Termina  " <<  line_num << endl;
	}
}

void accion_9_expresiones(){
	if (debug ) {
		cout << "accion_9_expresiones Empieza   " << line_num  << endl;
	}
	
	// Si top de pOperadores = > or < 
	if ( pilaOperadores.size() != 0 ) {
		if ( pilaOperadores.top() == ">" || pilaOperadores.top() == "<" || pilaOperadores.top() == "==" || pilaOperadores.top() == "!=") {

			int tipoDer = -1, tipoIzq = -1;
			int tipoResultado = -1, tipoOperador;
			tipoDer = pilaTipos.top();
			pilaTipos.pop();

			tipoIzq = pilaTipos.top();
			pilaTipos.pop();

			//Checa si son permitidas las operaciones
			string operador = pilaOperadores.top();
			pilaOperadores.pop();

			tipoOperador  = getIndexOperador(operador);
			tipoResultado = cuboSemantico[tipoIzq][tipoDer][tipoOperador];

			if (tipoResultado != -1 ) {


				int der, izq;

				der = pilaOperandos.top();
				pilaOperandos.pop();

				izq = pilaOperandos.top();
				pilaOperandos.pop();

				// Aumenta los temporales en 1
				int resultado = getSiguienteDireccion("temporal", 0);
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);

			}	
			else {
				cout << "Tipos incompatibles" << endl;
			}	

		}
	}
	if (debug ) {
		cout << "accion_9_expresiones Termina   " << line_num <<  endl;
	}
}


void accion_1_assignacion(int dirOperando){
	//Meter id en PilaO
	if (debug ) {
		cout << "accion_1_assignacion Empieza" <<  endl;
	}
	pilaOperandos.push(dirOperando);
	if (debug ) {
		cout << "accion_1_assignacion Termina" <<  endl;
	}
}

void accion_2_assignacion(string operador){
	//Meter = en pilaOperadores
	if (debug ) {
		cout << "accion_2_assignacion Empieza" <<  endl;
	}
	pilaOperadores.push(operador);
	if (debug ) {
		cout << "accion_2_assignacion Termina" <<  endl;
	}
}
void accion_3_assignacion( ){
	// sacar der de pilaO
	// sacar izq de pilaO
	// asigna = pOperadores.pop()
	// genera
	//		asigna, der, , izq
	if (debug ) {
		cout << "accion_3_assignacion Empieza" <<  endl;
	}



	cout << "Pila Operandos: " << pilaOperandos.size() << endl;
	
	int der = pilaOperandos.top();
	pilaOperandos.pop();
	int tipoDer = pilaTipos.top();
	pilaTipos.pop();
	
	//cout << "Der: " << der <<  " Tipo: " << tipoDer << endl;

	int izq = pilaOperandos.top();
	pilaOperandos.pop();
	int tipoIzq = pilaTipos.top();
	pilaTipos.pop();
	
	//cout << "Izq: " << izq <<  " Tipo: " << tipoIzq << endl;

	string asigna = pilaOperadores.top();
	pilaOperadores.pop();

	// Si son vacios, entocnes error..
	if ( tipoDer == 4 || tipoIzq == 4 ){ 
		cerr << "SEMANTIC ERROR, WRONG TYPE OF VARIABLE on line " << line_num << endl;
		exit(-1);
	}
	Cuadruplo cuadruploTemp = Cuadruplo(asigna, to_string(der), "", to_string(izq));
	cuadruplos.push_back( cuadruploTemp );

	if (debug ) {
		cout << "accion_3_assignacion Termina" <<  endl;
	}


}

void accion_1_condicion_fallo() {
	// aux = pop PTipos
	// si aux diferente de boleano, entonces error semantico
	// sino 
	//		sacar resultado de pilaO
	//		Generar gotoF, resultado, , ___
	//		PUSH PSaltos(cont-1)

	if ( debug ) {
		cout << "accion_1_condicion_fallo Empieza" << endl;
	}
	int aux = pilaTipos.top();
	pilaTipos.pop();

	if ( aux != 0 ) {
		cerr << "SEMANTIC ERROR: on line " << line_num << endl;
		exit(-1);
	}

	else {
		int resultado = pilaOperandos.top();
		pilaOperandos.pop();
	
		Cuadruplo cuadruploTemp = Cuadruplo("gotoF", to_string(resultado), "" , to_string(-1));
		cuadruplos.push_back( cuadruploTemp );
		
		pilaSaltos.push( cuadruplos.size() -1 );

	}
	if ( debug ) {
		cout << "accion_1_condicion_fallo Termina" << endl;
	}
}

void accion_2_condicion_fallo(){
	// Genrar goto ____
	// Sacar falso de PSaltos
	//rellenar(falso,cont)
	//PUSH PSaltos (cont-1)
	if ( debug ) {
		cout << "accion_2_condicion_fallo Empieza" << endl;
	}
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(-1));
	cuadruplos.push_back( cuadruploTemp );	

	int falso = pilaSaltos.top();
	pilaSaltos.pop();
	
	rellenar(falso, cuadruplos.size()  );
	
	pilaSaltos.push( cuadruplos.size() -1 );

	if ( debug ) {
		cout << "accion_2_condicion_fallo Termina" << endl;
	}
}

void accion_3_condicion_fallo() {
	//Sacar fin de PSaltos
	//rellenar (fin, cont);
	if (debug ) {
		cout << "acciopn_3_condicion_fallo Empieza   " << line_num <<  endl;
	}
	int fin = pilaSaltos.top();
	pilaSaltos.pop();

	rellenar(fin, cuadruplos.size()  );

	if (debug ) {
		cout << "acciopn_3_condicion_fallo Termina   " << line_num <<  endl;
	}

}

void accion_1_ciclo() {
	// meter cont en PSaltos
	

	if ( debug ) {
		cout << "accion_1_ciclo Empieza" << endl;
	}

	pilaSaltos.push( cuadruplos.size() );

	if ( debug ) {
		cout << "accion_1_ciclo Termina" << endl;
	}
}

void accion_2_ciclo() {
	// sacar aux de ptipos
	/// si aux diferente booleano, generar error semantico
	// sino
	//		sacar resultado de pilaO
	//		generar gotofalso, , ,resultado
	//		PUSH PSaltos (cont-1)
	

	if ( debug ) {
		cout << "accion_2_ciclo Empieza" << endl;
	}
	
	int aux = pilaTipos.top();
	pilaTipos.pop();

	if ( aux != 0 ) {
		cerr << "SEMANTIC ERROR: on line " << line_num << endl;
		exit(-1);
	} else {
		int resultado = pilaOperandos.top();
		pilaOperandos.pop();
	
		Cuadruplo cuadruploTemp = Cuadruplo("gotoF", to_string(resultado), "" , to_string(-1));
		cuadruplos.push_back( cuadruploTemp );
		
		pilaSaltos.push( cuadruplos.size() -1 );

	}

	if ( debug ) {
		cout << "accion_2_ciclo Termina" << endl;
	}
}

void accion_3_ciclo() {
	// sacar falso de pSaltos, sacar retorno de pSaltos
	// generar goto retorno
	// rellenar(salso, cont)
	

	if ( debug ) {
		cout << "accion_3_ciclo Empieza" << endl;
	}
	
	
	int falso = pilaSaltos.top();
	pilaSaltos.pop();

	int retorno = pilaSaltos.top();
	pilaSaltos.pop();
	
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(retorno));
	cuadruplos.push_back( cuadruploTemp );

	rellenar(falso, cuadruplos.size()  );


	if ( debug ) {
		cout << "accion_3_ciclo Termina" << endl;
	}
}

void accion_1_haz_mientras() {
	// meter cont en PSaltos
	

	if ( debug ) {
		cout << "accion_1_haz_mientras Empieza" << endl;
	}

	pilaSaltos.push( cuadruplos.size() );

	if ( debug ) {
		cout << "accion_1_haz_mientras Termina" << endl;
	}
}

void accion_2_haz_mientras() {
	// sacar resultado de pSaltos, sacar retorno de pSaltos
	// generar gotofalso resultado retorno
	

	if ( debug ) {
		cout << "accion_2_haz_mientras Empieza" << endl;
	}

	int resultado = pilaOperandos.top();
	pilaOperandos.pop();

	int retorno = pilaSaltos.top();
	pilaSaltos.pop();
	

	Cuadruplo cuadruploTemp = Cuadruplo("gotoF", to_string(resultado), "", to_string(retorno));
	cuadruplos.push_back( cuadruploTemp );


	if ( debug ) {
		cout << "accion_2_haz_mientras Termina" << endl;
	}
}


void accion_1_definicion_proc(string tipo, string nombre) {
	// Dar de alta el nombre del procedimiento en el Dir de Procs
	// Verificar la semantica
	

	if ( debug ) {
		cout << "accion_1_definicion_proc Empieza" << endl;
	}
	int direccion = getSiguienteDireccion(yyTipo, 0);
	cout << "Crear metodo " << nombre << " Direccion: " << direccion << " Tipo: " << yyTipo <<  endl;
	dirProcedimientos.crearMetodo(tipo, nombre,direccion);
	//cout << "Crear variable Tipo: " << yyTipo << " Nombre: " << nombre << " Direccion: " <<   direccion   << endl;

	if ( debug ) {
		cout << "accion_1_definicion_proc Termina" << endl;
	}
}

void accion_2_definicion_proc(string tipo, string nombre, int direccion) {
	// Ligar cada parametro a la tabla de parametros del dir de procs
	
	

	if ( debug ) {
		cout << "accion_2_definicion_proc Empieza" << endl;
	}
	cout << "Crear parametro " << nombre << " Direccion: " << direccion << endl;
	dirProcedimientos.agregaParametro(tipo, nombre, direccion);

	if ( debug ) {
		cout << "accion_2_definicion_proc Termina" << endl;
	}
}


void accion_3_definicion_proc() {
	// Dar de alta el tipo de los parametros
	// Esto se hace en la accion_2_definicion_proc
	
	if ( debug ) {
		cout << "accion_3_definicion_proc Empieza" << endl;
	}


	if ( debug ) {
		cout << "accion_3_definicion_proc Termina" << endl;
	}
}


void accion_4_definicion_proc() {
	// Dar de alta en el Dir de  Procs el numero de parametros detectados
	// Esto lo conseguimos con el vector de parametros, haciendo un .size(); 

	if ( debug ) {
		cout << "accion_4_definicion_proc Empieza" << endl;
	}


	if ( debug ) {
		cout << "accion_4_definicion_proc Termina" << endl;
	}
}


void accion_5_definicion_proc() {
	// Dar de alta en el Dir de Procs el numero de variables locales definidas	
	// Esto lo conseguimos con el vector de variables haciendo un .size();
	

	if ( debug ) {
		cout << "accion_5_definicion_proc Empieza" << endl;
	}


	if ( debug ) {
		cout << "accion_5_definicion_proc Termina" << endl;
	}
}


void accion_6_definicion_proc() {
	// Dar de alta en el dir de procs el numero de cuadruplo en el que inicia el proc.
	
	

	if ( debug ) {
		cout << "accion_6_definicion_proc Empieza" << endl;
	}



	if ( debug ) {
		cout << "accion_6_definicion_proc Termina" << endl;
	}
}


void accion_7_definicion_proc() {
	// Liberar la tabla de variables locales del procedimiento
	// Generar una accion de RETORNO
	
	

	if ( debug ) {
		cout << "accion_7_definicion_proc Empieza" << endl;
	}

	int resultado = pilaOperandos.top();
	pilaOperandos.pop();

	

	int direccionMetodo = dirProcedimientos.buscaDireccion(funcionNombre);


	Cuadruplo cuadruploTemp = Cuadruplo("=", to_string(resultado), "" , to_string(direccionMetodo));
	cuadruplos.push_back( cuadruploTemp );	


	if ( debug ) {
		cout << "accion_7_definicion_proc Termina" << endl;
	}
}


void accion_1_llamada_proc(string objetoNombre, string metodoNombre) {
	// Verificar que el procedimiento exista como tal en el Dir. de procs
	
	

	if ( debug ) {
		cout << "accion_1_llamada_proc Empieza" << endl;
	}

	bool existePredicado = dirProcedimientos.checaPredicado(metodoNombre);
	if (existePredicado == false ) { 
		cerr << "ERROR: Method not found:  \"" << metodoNombre << " of variable: " << objetoNombre;
		cerr << "\" on line " << line_num << endl;
		exit(-1);
	}
	

	if ( debug ) {
		cout << "accion_1_llamada_proc Termina" << endl;
	}
}

void accion_2_llamada_proc() {

	// Generar accipon: Era tamaño (expansion del reagistro de activacion, de acuerdo a tamaño definido )
	// inicializar contador de parametros k = 1;

	
	

	if ( debug ) {
		cout << "accion_2_llamada_proc Empieza" << endl;
	}
	indexParametro = 0;
	Cuadruplo cuadruploTemp = Cuadruplo("era", metodoNombre, "" , "");
	cuadruplos.push_back( cuadruploTemp );	
	



	if ( debug ) {
		cout << "accion_2_llamada_proc Termina" << endl;
	}
}

void accion_3_llamada_proc() {
	// Argumento ? pop de pilaOperandos, tipoArg = pop.Pilatipos
	// Verificar tipo de argumento contra el parametro k 
	// Generar PARAMETRO, Argumento, parametro k 


	
	

	if ( debug ) {
		cout << "x Empieza" << endl;
	}

	int tipo = pilaTipos.top();
	pilaTipos.pop();

	bool concuerdaTipo = dirProcedimientos.checaArgumentoTipo(tipo);

	if ( concuerdaTipo == false ) {
		cerr << "Wrong argument: on line " << line_num << endl;
		exit(-1);
	}


	int argument = pilaOperandos.top();
	pilaOperandos.pop();

	Cuadruplo cuadruploTemp = Cuadruplo("param", to_string(argument), "param"+to_string(indexParametro), "");
	cuadruplos.push_back( cuadruploTemp );


	if ( debug ) {
		cout << "accion_3_llamada_proc Termina" << endl;
	}
}

void accion_4_llamada_proc() {
	// K = K + 1, apuntar al siguiente parametro
	
	

	if ( debug ) {
		cout << "accion_4_llamada_proc Empieza" << endl;
	}	

	indexParametro++;

	if ( debug ) {
		cout << "accion_4_llamada_proc Termina" << endl;
	}
}

void accion_5_llamada_proc() {
	// Verificar que el ultimo parametro apunte a nulo ( en nuestro caso checar el size del vector de params contra k );

	
	

	if ( debug ) {
		cout << "accion_5_llamada_proc Empieza" << endl;
	}


	if ( debug ) {
		cout << "accion_5_llamada_proc Termina" << endl;
	}
}

void accion_6_llamada_proc(string nombreProc) {
	// Generar GOSUB , nombre proc, dir de inicio
	
	

	if ( debug ) {
		cout << "accion_6_llamada_proc Empieza" << endl;
	}

	int direccionVariable = dirProcedimientos.buscaDireccion(nombreProc);
	cout << "Direccion :" << direccionVariable << endl;
	int tipoVariable = dirProcedimientos.checaTipo(nombreProc);
	cout << "Tipe: " << tipoVariable << endl;

	pilaOperandos.push(direccionVariable);
	pilaTipos.push(tipoVariable);



	Cuadruplo cuadruploTemp = Cuadruplo("gosub", nombreProc, to_string(cuadruplos.size()) , "");
	cuadruplos.push_back( cuadruploTemp );	
	

	if ( debug ) {
		cout << "accion_6_llamada_proc Termina" << endl;
	}
}





void printCuboSemantico() {
	
	for (int i = 0; i < 4; i++ ) {
		for (int j = 0; j < 4; j++ ) {

			for (int k = 0; k < 13; k++ ) {
				printf("%d, ", cuboSemantico[i][j][k]);
			}
			printf("\n");
		}
		printf("\n");
		printf("\n");
	}
}

int getIndexOperador(string operador) {

	 //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
	if ( operador == "+")
			return 0;
	else if ( operador == "-")
			return 1;
	else if ( operador == "*")
			return 2;
	else if ( operador == "/")
			return 3;
	else if ( operador == "==")
			return 4;
	else if ( operador == "!=")
			return 5;
	else if ( operador == ">")
			return 6;
	else if ( operador == "<")
			return 7;
	else if ( operador == "=")
			return 8;
	else if ( operador == ">=")
			return 9;
	else if ( operador == "<=")
			return 10;
	else if ( operador == "||")
			return 11;
	else if ( operador == "&&")
			return 12;	
	else return -1;

}

int getSiguienteDireccion(string tipo, bool constante) {


	if ( !constante ) {

		if (tipo == "entero") {
			return offsetEntero + indexEnteros++;

		} else if ( tipo == "decimal") {
			return offsetDecimal + indexDecimal++;

		} else if ( tipo == "texto") {
			return offsetTexto + indexTexto++;

		} else if ( tipo == "bandera") {
			return offsetBandera + idnexBandera++;
			
		} else if ( tipo == "temporal") {
			return offsetTemporales + indexTemporales++;

		} else if ( tipo == "vacio") {
			return offsetVacio + indexVacio++;

		}
	}
	else {
		if (tipo == "entero") {
			return offsetEnteroConstante + indexEnteroConstantes++;

		} else if ( tipo == "decimal") {
			return offsetDecimalConstante + indexDecimalConstantes++;

		} else if ( tipo == "texto") {
			return offsetTextoConstante + indexTextoConstantes++;

		} else if ( tipo == "bandera") {
			return offsetBanderaConstante + idnexBanderaConstantes++;
			
		} else if ( tipo == "temporal") {
			return offsetTemporalesConstante + indexTemporalesConstantes++;

		} else if ( tipo == "vacio") {
			return offsetVacioConstante + indexVacioConstantes++;

		}	
	}
	return 0;

}

void printCuadruplos() { 
	for (int i = 0; i < cuadruplos.size(); i++ ) {

		cout << i << " \t \t" << cuadruplos[i].getOp() << ", \t\t" << cuadruplos[i].getIzq() << ", \t\t" << cuadruplos[i].getDer() << ", \t\t" << cuadruplos[i].getRes() << endl ;
	}
}

void rellenar(int fin, int cont) {

	
	cuadruplos[fin].setRes(to_string(cont));

}


template <typename T> string to_string(T value)
    {
      //create an output string stream
      std::ostringstream os ;

      //throw the value into the string stream
      os << value ;

      //convert the string stream into a string and return
      return os.str() ;
    }


