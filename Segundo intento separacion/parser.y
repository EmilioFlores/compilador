%{
#include <cstdio>
#include <iostream>
#include <string.h>
#include "cuadruplo.h"
//#include "estructura.cpp"
#include <stack>
#include <string>     // std::string, std::to_string
#include <vector>
#include <sstream>

#include "estructuras.h"
#include "memoria.h"
#include "trie.h"
#include "dirProcedimientos.h"
#include "declaraciones.h"
#include "definiciones.h"
#include "prototipos.h"

using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern char * yytext;
extern "C" FILE *yyin;

bool debug = false;






string yyTipo = "";
string objetoNombre = "default";
string metodoNombre = "";
string funcionNombre = "";


int offsetGlobales[4] = { 0, 1000, 2000, 3000 };
int offsetTemporales[4] = {4000, 5000, 6000, 7000};
int offsetConstantes[4] = {8000, 9000, 10000, 11000};
int offsetDirObjetos[4] = {12000, 13000, 14000, 15000};
int offsetDirFunciones[4] = {16000, 17000, 18000, 19000};

int indexGlobales[4] = {0};
int indexTemporales[4] = {0};
int indexConstantes[4] = {0};
int indexDirObjetos[4] = {0};
int indexDirFunciones[4] = {0};



int indexParametro = 0;

bool metodo = false;
bool global = true;
bool objeto = false;
bool temporal = false;
bool funcion = false; 

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
%token LBRACKET
%token RBRACKET
%token SEMICOLON
%token COMMA
%token DOT
%token EQL
%token EQLEQL
%token NEQ
%token COLON
%token LSS
%token GTR
%token LSSOEQL
%token GTROEQL
%token OR
%token AND



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

Objeto 				: OBJETOSYM  IDENTIFICADOR { 
						objetoNombre = yytext; 
						objeto = true;
						dirProcedimientos.crearObjeto(objetoNombre); 

					}  LCURLY AtributosPrivados AtributosPublicos RCURLY SEMICOLON {
						//resetOffsetIndexes(local);
						objeto = false;
						dirProcedimientos.terminaBloque();
					} ;

AtributosPrivados	: PRIVADOSYM LCURLY  VariablesObjetos Funciones   RCURLY
					|  epsilon ;

AtributosPublicos	: PUBLICOSYM LCURLY  Variables FuncionesObjetos   RCURLY 
					|  epsilon ;



Librerias 			: Libreria Libreria1 ;
Libreria  			: INCLUIRSYM LSS IDENTIFICADOR GTR  ;
Libreria1			: Libreria | ;




Funciones 			: Funcion ;
FuncionesObjetos	: FuncionObjeto ;

Funcion  			: FUNCIONSYM  Tipo { yyTipo = yytext } IDENTIFICADOR {
						funcionNombre = $4;
						accion_1_definicion_proc(yyTipo, $4);
					 	funcion = true; 
					 	global = false;
					} Params BloqueFuncion SEMICOLON {
						
						
					 	global = true;
						funcion = false; 
					  	dirProcedimientos.terminaBloque();
					} Funcion
					| epsilon ;

FuncionObjeto		: FUNCIONSYM  Tipo { yyTipo = yytext } IDENTIFICADOR {
						funcionNombre = $4;
						//dirProcedimientos.crearMetodo(yyTipo, $4);
						accion_1_definicion_proc(yyTipo, $4);
						global = false; 

					} ParamsObjeto BloqueFuncion SEMICOLON {
					  // resetOffsetIndexes(local);
					  global = true; 
					  dirProcedimientos.terminaBloque();
					} FuncionObjeto
					| epsilon ;


Tipo				: ENTEROSYM  
					| DECIMALSYM  
					| TEXTOSYM 
					| BANDERASYM 
					| IDENTIFICADOR ;


Params				: LPAREN  Param  RPAREN ;
ParamsObjeto		: LPAREN  ParamObjeto  RPAREN ;

Param 				: Tipo { yyTipo = yytext } IDENTIFICADOR {
						int direccion_virtual = getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0, global, temporal, objeto, funcion);

						accion_2_definicion_proc(yyTipo, $3, direccion_virtual);
					} Param1 
					| epsilon ;
Param1				: COMMA Param 
					| epsilon ;

ParamObjeto 		: Tipo { yyTipo = yytext } IDENTIFICADOR {
						int direccion_virtual = getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0, global, temporal, objeto, funcion);
						accion_2_definicion_proc(yyTipo, $3, direccion_virtual);
						// dirProcedimientos.agregaParametro(yyTipo, $3, direccion_virtual);

					} ParamObjeto1 
					| epsilon ;
ParamObjeto1		: COMMA ParamObjeto 
					| epsilon ;


Args				: Expresion { 
					  accion_3_llamada_proc();
					} Args1
					| epsilon ;

Args1				: COMMA Expresion {
					  accion_3_llamada_proc();
					} Args1
					| epsilon ;



Bloque				: LCURLY   Variables Bloque1   RCURLY ;
Bloque1				:	Estatuto SEMICOLON Bloque1 
					| epsilon ;


BloqueFuncion		: LCURLY Variables BloqueFuncion1 BloqueFuncion2    RCURLY {		


						Cuadruplo cuadruploTemp = Cuadruplo("retorno", "", "" , "");
						cuadruplos.push_back( cuadruploTemp );	
					}
BloqueFuncion1		:	Estatuto SEMICOLON BloqueFuncion1 
					| epsilon ;
BloqueFuncion2		: REGRESASYM  Expresion {
						accion_7_definicion_proc();
					} SEMICOLON
					| epsilon ;


Estatuto			: Asignacion 
					| Condicion
					| Ciclo
					| Escritura
					| Lectura
					| Llamada ;


Llamada				: IDENTIFICADOR {
					 	
					// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
					// si es 4, entonces es un identificador

					   metodo = false;
					   objetoNombre = $1;
					   metodoNombre = $1;
					   int variableIndex = dirProcedimientos.buscaVariable(objetoNombre);

					   if (variableIndex == -1 ) { 
							cerr << "ERROR: Variable not found:  \"" << objetoNombre;
							cerr << "\" on line " << line_num << endl;
							exit(-1);
						}



					}  Llamada1 Llamada2  {
						accion_6_llamada_proc(metodoNombre);
					} ;
Llamada1			: DOT IDENTIFICADOR {
					  metodoNombre = $2;
					  metodo = true;
						
						accion_1_llamada_proc(objetoNombre, metodoNombre);
					} Llamada1
					| epsilon ;
Llamada2			: LPAREN {
						// mete fondo falso
						accion_6_expresiones("(");
						//cout << "Metodo nombre" << metodoNombre << endl;
						// Si es una funcion, no tenia .getX(), solo era getX()
						if ( metodo == false) {

							accion_1_llamada_proc(objetoNombre, metodoNombre);
						}
						
						
						accion_2_llamada_proc();
					} Args RPAREN  {
						accion_7_expresiones();
						accion_5_llamada_proc();

					}
					| epsilon {
						
						if ( metodo ) {
							//cout << "Metodo: " << metodoNombre << endl;
							accion_1_expresiones(metodoNombre, 4);
						}
						else {
							//cout << "Variable: " << objetoNombre << endl;
							accion_1_expresiones(objetoNombre, 4);

						}
					};

Asignacion 			: IDENTIFICADOR {
										int direccionVariable = dirProcedimientos.buscaDireccion($1);
										int tipoVariable = dirProcedimientos.checaTipo($1);
										accion_1_assignacion(direccionVariable, tipoVariable);
										int variableIndex = dirProcedimientos.buscaVariable($1);
										if (variableIndex == -1 ) { 
											cerr << "ERROR: at symbol \"" << yytext;
											cerr << "\" on line " << line_num << endl;
											exit(-1);
										}
									} 
						EQL  {
								accion_2_assignacion("=");
						}
						Expresion {
								accion_3_assignacion();
								
						} ;



Expresion			: Exp Expresion1 ;
Expresion1 			: Expresion2 Exp { accion_9_expresiones(); }
					| epsilon ;

Expresion2 			: LSS { accion_8_expresiones(yytext); }
					| GTR { accion_8_expresiones(yytext); }
					| EQLEQL { accion_8_expresiones(yytext); }
					| NEQ { accion_8_expresiones(yytext); } ;

Exp 				: Termino { accion_4_expresiones(); }	Exp1 ;
Exp1				: PLUS {
								accion_2_expresiones(yytext);
								
						   } Exp 
					| MINUS {
								accion_2_expresiones(yytext);
						   } Exp
					| epsilon	;

Termino				: Factor { accion_5_expresiones(); } Termino1	;
Termino1			: TIMES {
								accion_3_expresiones(yytext);
						   } Termino
					| SLASH {
								accion_3_expresiones(yytext);
						   } Termino
					| epsilon	;

Factor				: LPAREN { accion_6_expresiones("("); } Expresion { accion_7_expresiones(); }  RPAREN
					| Factor1 VarCteExp Factor2
Factor1 			: PLUS
					| MINUS
					| epsilon	;
Factor2				:	LBRACKET Expresion RBRACKET 
					|	epsilon ;



VarCteExp			:	Llamada { 

										
									 };
					|	ENTERO { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 1);
								};
					|	BANDERA { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 0);
									};
					|	TEXTO   { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 3);
									};
					|	DECIMAL { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1_expresiones(yytext, 2);

									};
					 

					


Variables			: Variable SEMICOLON Variables
					| epsilon ;
VariablesObjetos	: VariableObjeto SEMICOLON VariablesObjetos
					| epsilon ;



Variable			: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR  {  
									//TODO Hace funcion que me regrese la direccion. 
									
									int direccion;
									
									direccion = getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0,  global, temporal, objeto, funcion);

									
									//cout << "Crear variable Tipo: " << yyTipo << " Nombre: " << $4 << " Direccion: " <<   direccion << " global: " << global   << endl;
									
									dirProcedimientos.crearVariable(yyTipo, $4, 1, direccion );

								   }  Variable1 ;
Variable1			: LBRACKET  Expresion  Variable2 RBRACKET 
					| epsilon;
Variable2			: COMMA  Expresion Variable2
					| epsilon;

VariableObjeto		: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR   {  
									//TODO Hace funcion que me regrese la direccion. 
									

									dirProcedimientos.crearVariable(yyTipo, $4, 0, getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0, global, temporal, objeto, funcion));
								   }  ; ;
//Variable2			: COMMA IDENTIFICADOR Variable2
//					| epsilon ;


Condicion			: CONDICIONSYM LPAREN Expresion RPAREN {
						accion_1_condicion_fallo();
					} Bloque Condicion1 
Condicion1			: FALLOSYM {
						accion_2_condicion_fallo();
					} Bloque {
						accion_3_condicion_fallo();
					} | epsilon ;



Ciclo				: CICLOSYM {
							accion_1_ciclo();
					} LPAREN Ciclo1 COMMA Expresion {
							accion_2_ciclo();
					} COMMA Ciclo1 RPAREN Bloque {
							accion_3_ciclo();
					}  ; 
					| HAZSYM {
						accion_1_haz_mientras();
					} Bloque MIENTRASSYM LPAREN Expresion RPAREN {
						accion_2_haz_mientras();
					}  ;
Ciclo1 				: Asignacion 
					| epsilon ;

Escritura			: MUESTRASYM LPAREN Expresion { accion_1_print(); }  EstatutosSalida RPAREN  ;

EstatutosSalida		: COMMA Expresion { accion_1_print(); } EstatutosSalida
					| epsilon ;


Lectura				: LEESYM IDENTIFICADOR { accion_1_read(yytext); } ;

Main 				: PROGRAMASYM Bloque { printCuadruplos(); }

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
        dirProcedimientos.inicializaMemoria();
        solve();		

		cout << "Success reading file" << endl; 
  	}
	return 0;

	

}


void yyerror(const char *s) {


    extern int yylineno;    // defined and maintained in lex.c
    extern char *yytext;    // defined and maintained in lex.c
         
    cerr << "ERROR: " << s << " at symbol \"" << yytext;
    cerr << "\" on line " << line_num << endl;
    exit(-1);
}


/**
 *  solve
 *  Metodo utilizado como si fuera la virtual machine. 
 */
void solve() {


    for(int i  = 0; i < cuadruplos.size(); i++){
        Cuadruplo current = cuadruplos[i];
        /*
                
        string op;
        string der;
        string izq;
        string res;


        */
        
        switch ( getOperandoIndex(current.getOp() ))  {
            //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
            case _PLUS    : plus_op(current);   break; // Funcion que hace la suma
            case _MINUS    : minus_op(current);   break; // Funcion que hace la resta
            case _TIMES    : times_op(current);   break; // Funcion que hace la multiplicacion
            case _SLASH    : divide_op(current);   break; // Funcion que hace la division
            case _EQLEQL    : equal_op(current);   break; // Funcion que hace ==
            case _NEQ    : notequal_op(current);   break; // Funcion que hace !=
            case _GTR    : more_op(current);   break; // Funcion que hace >
            case _LSS    : less_op(current);   break; // Funcion que hace <
            case _GTROEQL    : moreeq_op(current);   break; // Funcion que hace >=
            case _LSSOEQL    : lesseq_op(current);   break; // Funcion que hace <=
            case _OR    : or_op(current);   break; // Funcion que hace ||
            case _AND    : and_op(current);   break; // Funcion que hace &&
            
            break;
        }
    }


}

