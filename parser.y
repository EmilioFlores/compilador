%{
#include <cstdio>
#include <iostream>
#include <string.h>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern char * yytext;
extern "C" FILE *yyin;
extern int line_num;

 
void yyerror(const char *s);


string yyTipo = "";
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	float fval;
	char *sval;
	bool bval;
}



// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:



%start programa
%token <ival> ENTERO
%token <fval> DECIMAL
%token <sval> TEXTO
%token <num>  NUMBER
%token <sval> IDENTIFICADOR
%token <bval> BANDERA

%token PLUS
%token MINUS
%token TIMES
%token SLASH
%token LPAREN
%token RPAREN
%token LCURLY
%token RCURLY
%token SEMICOLON
%token COMMA
%token DOT
%token EQL
%token NEQ
%token COLON
%token LSS
%token GTR


%token CONDICIONSYM
%token PROGRAMASYM
%token FALLOSYM
%token VARSYM
%token MUESTRASYM
%token MUESTRALINEASYM
%token LEESYM
%token BANDERASYM
%token CARACTERSYM
%token ENTEROSYM
%token GRANENTEROSYM
%token DECIMALSYM
%token TEXTOSYM
%token ARREGLOSYM
%token MATRIZSYM
%token CICLOSYM
%token HAZSYM
%token MIENTRASSYM
%token FUNCIONSYM
%token REGRESASYM
%token INCLUIRSYM
%token FALSOSYM
%token VERDADEROSYM
%token OBJETOSYM
%token PRIVADOSYM
%token PUBLICOSYM







%left INCLUIRSYM 




%%

programa  			: Librerias Objetos Funciones Main ;

Objetos				:  Objeto ;

Objeto 				: OBJETOSYM IDENTIFICADOR LCURLY AtributosPrivados AtributosPublicos RCURLY SEMICOLON ;

AtributosPrivados	: PRIVADOSYM LCURLY Variables Funciones RCURLY
					|  epsilon ;

AtributosPublicos	: PUBLICOSYM LCURLY Variables Funciones RCURLY 
					|  epsilon ;



Librerias 			: Libreria Libreria1 ;

Libreria  			: INCLUIRSYM LSS IDENTIFICADOR GTR  ;
Libreria1			: Libreria | ;




Funciones 			: Funcion ;

Funcion  			: FUNCIONSYM { cout << "Crear tabla de variables" << endl; } Tipo IDENTIFICADOR Params BloqueFuncion SEMICOLON Funcion
					| epsilon ;



Tipo				: ENTEROSYM  
					| DECIMALSYM  
					| CARACTERSYM  
					| TEXTOSYM 
					| BANDERASYM ;


Params				: LPAREN Param RPAREN ;

Param 				: Tipo IDENTIFICADOR  Param1 
					| epsilon ;
Param1				: COMMA Param 
					| epsilon ;


Args				: IDENTIFICADOR   Args1
					| epsilon ;
Args1				: COMMA IDENTIFICADOR Args1
					|  epsilon ;



Bloque				: LCURLY Variables Bloque1 RCURLY ;
Bloque1				:	Estatuto Bloque1 
					| epsilon ;

BloqueFuncion		: LCURLY Variables BloqueFuncion1 REGRESASYM IDENTIFICADOR SEMICOLON RCURLY
BloqueFuncion1		:	Estatuto BloqueFuncion1 
					| epsilon ;


Estatuto			: Asignacion SEMICOLON
					| Condicion
					| Ciclo
					| Escritura
					| Lectura
					| Llamada ;


Llamada				: IDENTIFICADOR  Llamada1 LPAREN Args RPAREN SEMICOLON ;
Llamada1			: DOT IDENTIFICADOR Llamada1
					| epsilon ;

Asignacion 			: IDENTIFICADOR EQL Expresion  ;

Expresion			: Exp Expresion1 ;
Expresion1 			: Expresion2 Exp  ;
					| epsilon ;

Expresion2 			: GRANENTEROSYM 
					| LEESYM 
					| NEQ ;

Exp 				: Termino	Exp1 ;
Exp1				: PLUS Exp 
					| MINUS Exp
					| epsilon	;

Termino				: Factor Termino1	;
Termino1			: TIMES Termino
					| SLASH Termino
					| epsilon	;

Factor				: LPAREN Expresion RPAREN
					| Factor1	VarCte ;
Factor1 			: PLUS
					| MINUS
					| epsilon	;



VarCte				:	IDENTIFICADOR 
					|	ENTERO 
					|	BANDERA 
					|	TEXTO 
					|	DECIMAL   ;

Variables			: Variable SEMICOLON Variables
					| epsilon ;



Variable			: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR {cout << "Variable: " << yyTipo  << ":" <<  $4 << endl; }   ;
//Variable2			: COMMA IDENTIFICADOR Variable2
//					| epsilon ;


Condicion			: CONDICIONSYM LPAREN Expresion RPAREN Bloque Condicion1 SEMICOLON
Condicion1			: FALLOSYM Bloque | epsilon ;



Ciclo				: CICLOSYM LPAREN Ciclo1 COMMA Expresion COMMA Ciclo1 RPAREN Bloque SEMICOLON ; 
					| HAZSYM Bloque MIENTRASSYM LPAREN Expresion RPAREN SEMICOLON ;
Ciclo1 				: Asignacion 
					| epsilon ;

Escritura			: MUESTRALINEASYM LPAREN EstatutosSalida RPAREN SEMICOLON ;
					| MUESTRASYM LPAREN EstatutosSalida RPAREN SEMICOLON ;

EstatutosSalida		: Llamada
					| VarCte
					| epsilon ;


Lectura				: LEESYM VarCte SEMICOLON ;

Main 				: PROGRAMASYM Bloque 

epsilon				:	;





%%

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