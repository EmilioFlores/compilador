%{
#include <cstdio>
#include <iostream>
#include <string.h>
#include "cuadruplo.cpp"
//#include "estructura.cpp"
#include <stack>
#include <string>     // std::string, std::to_string
#include <vector>
#include <sstream>

#include <math.h> 
#include "prototipos.h"
#include "definiciones.h"
#include "memoria.cpp"
#include "dirProcedimientos.cpp"

using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern char * yytext;
extern "C" FILE *yyin;
extern int line_num;

 
const bool debug = false;






extern Memoria memoria; 



dirProcedimientos dirProcedimientos ;





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
vector<constante> constantesEnteras;
vector<constante> constantesDecimales;
vector<constante> constantesTexto;
vector<constante> constantesBandera;

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
                                        {   1  ,  1  ,  1  ,  2  ,  0  ,  0  ,  0  ,  0  ,  1  ,  0  ,  0  , -1  , -1   },  // entero  1
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
					| LSSOEQL { accion_8_expresiones(yytext); } ;
					| GTROEQL { accion_8_expresiones(yytext); } ;
					| AND { accion_8_expresiones(yytext); } ;
					| OR { accion_8_expresiones(yytext); } ;

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
					} COMMA {
							accion_4_ciclo();
					} Ciclo1 {
							accion_5_ciclo();
					} RPAREN Bloque {
							accion_3_ciclo();
					}; 
					| HAZSYM {
						accion_1_haz_mientras();
					} Bloque MIENTRASSYM LPAREN Expresion RPAREN {
						accion_2_haz_mientras();
					}  ;
Ciclo1 				: Asignacion 
					| epsilon ;

Escritura			: MUESTRASYM LPAREN Expresion { accion_1_print(); }  EstatutosSalida RPAREN 
					| MUESTRALINEASYM LPAREN Expresion { accion_1_print(); } EstatutosSalidaLinea RPAREN { accion_2_print(); } ;

EstatutosSalida		: COMMA Expresion { accion_1_print(); } EstatutosSalida
					| epsilon ;

EstatutosSalidaLinea		: COMMA Expresion { accion_1_print(); } EstatutosSalidaLinea
							| epsilon ;


Lectura				: LEESYM IDENTIFICADOR { accion_1_read(yytext); } ;

Main 				: PROGRAMASYM {
						int inicio = pilaSaltos.top();
						pilaSaltos.pop();
						rellenar(inicio, cuadruplos.size() + -1 );
					} Bloque { printCuadruplos(); }

epsilon				:	;




%%

int main(int argc, char **argv) {
	// open a file handle to a particular file:
	// FILE *myfile = fopen("a.snazzle.file", "r");

	yyin = fopen(argv[1], "r");
	
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(-1));
	cuadruplos.push_back( cuadruploTemp );	

	pilaSaltos.push(cuadruplos.size() -1 );

	
	yyparse();
	
    dirProcedimientos.inicializaMemoria();
    
	solve();

	cout << "Success reading file" << endl; 

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
	
	// Si no era una variable registrada y es constante
	if ( tipo != 4 ) {
		// crea variable constante en el scope
		constante constante; 
		global = false;
		switch (tipo) {
			case 0: // bandera

				constante.direccion = getSiguienteDireccion(tipo, 1, global, temporal, objeto, funcion);
				constante.tipo = 0;
				constante.valor = yytext;
				constantesBandera.push_back(constante);		

			break;
			case 1: // entero
				constante.direccion = getSiguienteDireccion(tipo, 1, global, temporal, objeto, funcion);
				constante.tipo = 1;
				constante.valor = yytext;
				constantesEnteras.push_back(constante);			
			break;
			case 2: // decimal
				constante.direccion = getSiguienteDireccion(tipo, 1, global, temporal, objeto, funcion);
				constante.tipo = 2;
				constante.valor = yytext;		
				constantesDecimales.push_back(constante);			

			break;
			case 3: // texto
				constante.direccion = getSiguienteDireccion(tipo, 1, global, temporal, objeto, funcion);
				constante.tipo = 3;
				constante.valor = yytext;
				constantesTexto.push_back(constante);

			break;
		}
		global = true;
		
		pilaOperandos.push(constante.direccion);
		pilaTipos.push(constante.tipo);
		
		
		
	}
	else {

		// la variable ya estaba registrada

		int direccionVariable = dirProcedimientos.buscaDireccion(yytext);
		
		
		if (direccionVariable != -1 ) {

			
			int tipoVariable = dirProcedimientos.checaTipo(yytext);

			int estructuraVariable = dirProcedimientos.checaEstructura(yytext);


			//0 bandera, 1 entero, 2 decimal, 3 texto
			// estructura 0 variable, 1 funcion
			if (tipoVariable < 4 && ( estructuraVariable == 0 || estructuraVariable == 1)  ) {
			


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
	

}

void accion_2_expresiones(string operador){
	
	pilaOperadores.push(operador);
	
}

void accion_3_expresiones(string operador){
	
	pilaOperadores.push(operador);
	
}

void accion_4_expresiones() {
	// Si top de pOperadores = + or -
	
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

				temporal = true;
				int der, izq;

				der = pilaOperandos.top();
				pilaOperandos.pop();

				izq = pilaOperandos.top();
				pilaOperandos.pop();

				// Aumenta los temporales en 1
				int resultado = getSiguienteDireccion(tipoResultado,0,global, temporal, objeto,  funcion);
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);
				temporal = false;				

			}	
			else {
				cerr << "Tipos incompatibles en la linea: " << line_num <<  endl;
				exit(-1);
			}	

		}
	}
	
}


void accion_5_expresiones() {
	// Si top de pOperadores = * or /
	
	if ( pilaOperadores.size() != 0 ) {
		if ( pilaOperadores.top() == "/" || pilaOperadores.top() == "*") {
			
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

				temporal = true;
				int der, izq;

				der = pilaOperandos.top();
				pilaOperandos.pop();

				izq = pilaOperandos.top();
				pilaOperandos.pop();
				cout << "getsiguietneDireccion " << tipoResultado << " const: " << 0 << " glob: " << global << " temp: " << temporal << " objeto: " << objeto << " funcion: " << funcion << endl; 
				// Aumenta los temporales en 1
				int resultado = getSiguienteDireccion(tipoResultado, 0, global, temporal, objeto, funcion);
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);
				
				temporal = false;

			}	
			else {
				cerr << "Tipos incompatibles en la linea " << line_num << endl
;				exit(-1);
			}	

		}
	}
	
}

void accion_6_expresiones(string fondoFalso){
	
	pilaOperadores.push(fondoFalso);
	
}
void accion_7_expresiones(){
	
	pilaOperadores.pop();
	
}
void accion_8_expresiones(string operador){
	
	
	pilaOperadores.push(operador);
	
}

void accion_9_expresiones(){
	
	
	// Si top de pOperadores = > or < 
	if ( pilaOperadores.size() != 0 ) {
		if ( pilaOperadores.top() == ">" || pilaOperadores.top() == "<" || pilaOperadores.top() == "==" 
			|| pilaOperadores.top() == "!=" || pilaOperadores.top() == ">=" || pilaOperadores.top() == "<="
			|| pilaOperadores.top() == "||" || pilaOperadores.top() == "&&") {

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


				temporal = true;
				int der, izq;
				der = pilaOperandos.top();
				pilaOperandos.pop();

				izq = pilaOperandos.top();
				pilaOperandos.pop();

				// Aumenta los temporales en 1
				int resultado = getSiguienteDireccion(tipoResultado, 0, global, temporal, objeto, funcion);
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);
				temporal = false;

			}	
			else {
				cerr << "Tipos incompatibles en la linea: " << line_num << endl;
				exit(-1);
			}	

		}
	}
	
}


void accion_1_assignacion(int dirOperando, int tipoVariable){
	//Meter id en PilaO
	

	pilaTipos.push(tipoVariable);
	pilaOperandos.push(dirOperando);

	
}

void accion_2_assignacion(string operador){
	//Meter = en pilaOperadores
	
	pilaOperadores.push(operador);
	
}
void accion_3_assignacion( ){
	// sacar der de pilaO
	// sacar izq de pilaO
	// asigna = pOperadores.pop()
	// genera
	//		asigna, der, , izq
	
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

	int tipoOperador  = getIndexOperador(asigna);
	int tipoResultado = cuboSemantico[tipoIzq][tipoDer][tipoOperador];


	if ( tipoResultado != -1 ) {

		Cuadruplo cuadruploTemp = Cuadruplo(asigna, to_string(der), "", to_string(izq));
		cuadruplos.push_back( cuadruploTemp );
	} else {
				cerr << "Tipos incompatibles en linea: " << line_num <<   endl;
				exit(-1);
	}

}

void accion_1_condicion_fallo() {
	// aux = pop PTipos
	// si aux diferente de boleano, entonces error semantico
	// sino 
	//		sacar resultado de pilaO
	//		Generar gotoF, resultado, , ___
	//		PUSH PSaltos(cont-1)

	
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
	
}

void accion_2_condicion_fallo(){
	// Genrar goto ____
	// Sacar falso de PSaltos
	//rellenar(falso,cont)
	//PUSH PSaltos (cont-1)
	
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(-1));
	cuadruplos.push_back( cuadruploTemp );	

	int falso = pilaSaltos.top();
	pilaSaltos.pop();
	
	rellenar(falso, cuadruplos.size()  );
	
	pilaSaltos.push( cuadruplos.size() -1 );

	
}

void accion_3_condicion_fallo() {
	//Sacar fin de PSaltos
	//rellenar (fin, cont);
	
	int fin = pilaSaltos.top();
	pilaSaltos.pop();

	rellenar(fin, cuadruplos.size()  );

}

void accion_1_print() {
	
	int res = pilaOperandos.top();
	pilaOperandos.pop();

	Cuadruplo cuadruploTemp = Cuadruplo("muestra", "", "" , to_string(res));
	cuadruplos.push_back( cuadruploTemp );	

	
}

void accion_2_print() {
	
	

	Cuadruplo cuadruploTemp = Cuadruplo("saltolinea", "", "" , "");
	cuadruplos.push_back( cuadruploTemp );	

	
}


void accion_1_read(string nombre) { 


	int variableIndex = dirProcedimientos.buscaVariable(nombre);

   if (variableIndex == -1 ) { 
		cerr << "ERROR: Variable not found:  \"" << nombre;
		cerr << "\" on line " << line_num << endl;
		exit(-1);
	}

	int direccionVariable = dirProcedimientos.buscaDireccion(nombre);
	Cuadruplo cuadruploTemp = Cuadruplo("lee", "", "" , to_string(direccionVariable) );
	cuadruplos.push_back( cuadruploTemp );	

	

}
void accion_1_ciclo() {
	// meter cont en PSaltos

	pilaSaltos.push( cuadruplos.size() );

	
}

void accion_2_ciclo() {
	// sacar aux de ptipos
	/// si aux diferente booleano, generar error semantico
	// sino
	//		sacar resultado de pilaO
	//		generar gotofalso, , ,resultado
	//		PUSH PSaltos (cont-1)
	
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

	
}

void accion_3_ciclo() {
	// sacar falso de pSaltos, sacar retorno de pSaltos
	// generar goto retorno
	// rellenar(salso, cont)
	



	int falso = pilaSaltos.top();
	pilaSaltos.pop();

	
	cuadruploTemp = Cuadruplo("goto", "", "", to_string(falso));
	cuadruplos.push_back( cuadruploTemp );

	

	cout << "PilaSalots top: " << pilaSaltos.size() << " Cuadruplo: " << cuadruplos.size() << endl;

	
}

void accion_4_ciclo() {
	

	int estatutos = pilaSaltos.top();
	pilaSaltos.pop();

	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(estatutos));
	cuadruplos.push_back( cuadruploTemp );

	pilaSaltos.push( cuadruplos.size() - 1  );
	

}
void accion_5_ciclo() {
	
	int incrementos = pilaSaltos.top();
	pilaSaltos.pop();
	
	cout << "Relleno el " << incrementos << " con " << cuadruplos.size() << endl;
	rellenar(incrementos, cuadruplos.size()  );

	


}

void accion_1_haz_mientras() {
	// meter cont en PSaltos
	

	if ( debug ) {}

	pilaSaltos.push( cuadruplos.size() );

	
}

void accion_2_haz_mientras() {
	// sacar resultado de pSaltos, sacar retorno de pSaltos
	// generar gotofalso resultado retorno
	

	int resultado = pilaOperandos.top();
	pilaOperandos.pop();

	pilaTipos.pop();

	int retorno = pilaSaltos.top();
	pilaSaltos.pop();
	

	Cuadruplo cuadruploTemp = Cuadruplo("gotoT", to_string(resultado), "", to_string(retorno));
	cuadruplos.push_back( cuadruploTemp );


}


void accion_1_definicion_proc(string tipo, string nombre) {
	// Dar de alta el nombre del procedimiento en el Dir de Procs
	// Verificar la semantica
	

	
	int direccion = getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0, global, temporal, objeto, funcion);
	//cout << "Crear metodo " << nombre << " Direccion: " << direccion << " Tipo: " << yyTipo <<  endl;
	dirProcedimientos.crearMetodo(tipo, nombre,direccion);
	cout << "Crear variable Tipo: " << yyTipo << " Nombre: " << nombre << " Direccion: " <<   direccion   << endl;

	
}

void accion_2_definicion_proc(string tipo, string nombre, int direccion) {
	// Ligar cada parametro a la tabla de parametros del dir de procs
	//cout << "Crear parametro " << nombre << " Direccion: " << direccion << endl;
	dirProcedimientos.agregaParametro(tipo, nombre, direccion);
}


void accion_7_definicion_proc() {
	// Liberar la tabla de variables locales del procedimiento
	// Generar una accion de RETORNO
	

	int resultado = pilaOperandos.top();
	pilaOperandos.pop();
	int tipoOperando = pilaTipos.top();
	pilaTipos.pop();
	

	int direccionMetodo = dirProcedimientos.buscaDireccion(funcionNombre);
	int tipoFuncion = dirProcedimientos.checaTipo(funcionNombre);
	int tipoOperador  = getIndexOperador("=");

	int tipoResultado = cuboSemantico[tipoOperando][tipoFuncion][tipoOperador];
	
	if ( tipoResultado != -1 ) {

		Cuadruplo cuadruploTemp = Cuadruplo("=", to_string(resultado), "" , to_string(direccionMetodo));
		cuadruplos.push_back( cuadruploTemp );	

	} else {
		cerr << "Tipos incompatibles en linea: " << line_num <<   endl;
		exit(-1);
	}
	
}


void accion_1_llamada_proc(string objetoNombre, string metodoNombre) {
	// Verificar que el procedimiento exista como tal en el Dir. de procs
		

	bool existePredicado = dirProcedimientos.checaPredicado(metodoNombre);
	int estructuraVariable = dirProcedimientos.checaEstructura(objetoNombre);
		
	// 1 = funciones, 0 = variable, 2 = objeto
	if (existePredicado == false && estructuraVariable != 1) { 
		cerr << "ERROR: Method not found:  \"" << metodoNombre << " of variable: " << objetoNombre;
		cerr << "\" on line " << line_num << endl;
		exit(-1);
	}
	

	
}

void accion_2_llamada_proc() {

	// Generar accipon: Era tamaño (expansion del reagistro de activacion, de acuerdo a tamaño definido )
	// inicializar contador de parametros k = 1;

	indexParametro = 0;
	int bloqueMetodo = dirProcedimientos.buscaBloque(metodoNombre);
	Cuadruplo cuadruploTemp = Cuadruplo("era", to_string(bloqueMetodo), "" , "");
	cuadruplos.push_back( cuadruploTemp );	
	
}

void accion_3_llamada_proc() {
	// Argumento ? pop de pilaOperandos, tipoArg = pop.Pilatipos
	// Verificar tipo de argumento contra el parametro k 
	// Generar PARAMETRO, Argumento, parametro k 
	
	int tipo = pilaTipos.top();
	pilaTipos.pop();
	//TODO Aqui truena porque el checa argumento esta esperando algo antes, pero en este caso es solo una funcion
	bool concuerdaTipo = dirProcedimientos.checaArgumentoTipo(tipo);
	
	if ( concuerdaTipo == false ) {
		cerr << "Wrong argument: on line " << line_num << endl;
		exit(-1);
	}


	int argument = pilaOperandos.top();
	pilaOperandos.pop();

	Cuadruplo cuadruploTemp = Cuadruplo("param", to_string(argument), "param"+to_string(indexParametro++), "");
	cuadruplos.push_back( cuadruploTemp );


	
}

void accion_4_llamada_proc() {
	// K = K + 1, apuntar al siguiente parametro
	indexParametro++;

	
}

void accion_5_llamada_proc() {
	// Verificar que el ultimo parametro apunte a nulo ( en nuestro caso checar el size del vector de params contra k )
	bool completezPredicado = dirProcedimientos.checaCompletezPred(true);

	if ( completezPredicado == false ) {


		cerr << "Faltan parametros en linea " << line_num << endl;
		exit(-1);

	
	}

	
}

void accion_6_llamada_proc(string nombreProc) {
	// Generar GOSUB , nombre proc, dir de inicio
	
	

	int direccionVariable = dirProcedimientos.buscaDireccion(nombreProc);
	int tipoVariable = dirProcedimientos.checaTipo(nombreProc);
	
	int estructura = dirProcedimientos.checaEstructura(nombreProc);

	// solo hacer esto si es una funcion o objeto
	if ( estructura != 0 ) {

		pilaOperandos.push(direccionVariable);
		pilaTipos.push(tipoVariable);



		Cuadruplo cuadruploTemp = Cuadruplo("gosub", nombreProc, to_string(cuadruplos.size()) , "");
		cuadruplos.push_back( cuadruploTemp );	
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

int getSiguienteDireccion(int tipo, bool constante, bool global, bool temporal, bool objeto, bool funcion) {

	
	if ( constante) {
		return offsetConstantes[tipo]+ indexConstantes[tipo]++;

	} else if ( temporal ) {
		return offsetTemporales[tipo]+ indexTemporales[tipo]++;
	
	} else if ( objeto ) {
		return offsetDirObjetos[tipo]+ indexDirObjetos[tipo]++;

	}  else if ( funcion ) {
		return offsetDirFunciones[tipo]+ indexDirFunciones[tipo]++;
	}
	else if ( global ) {
		return offsetGlobales[tipo]+ indexGlobales[tipo]++;
		
	}

	return -1;

}

string getTipoVariable(int tipo ) {
	switch (tipo) {
		case 0:
			return "bandera";
			break;
		case 1:
			return "entero";
			break;
		case 2: 
			return "decimal";
			break;
		case 3:
			return "texto";
			break;
		case 4:
			return "vacio";
			break;

		return "vacio";
	}

}

int getIndexTipoVariable(string nombre ) { 
	if ( nombre == "bandera") return 0;
	else if (nombre == "entero") return 1;
	else if ( nombre == "decimal") return 2;
	else if (nombre == "texto" ) return 3;
	else return -1 ;
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



/** 
	getScope
	Funcion que apartir de una direccion regresa el scope en el que se encuentra
	@param dir direccion a buscar
	@return el scope en el que se encuentra la direccion.
**/
int getScope(int dir){

	if(dir >= OFF_LOWER_LIMIT && dir < OFF_BAND_TEMP){
		return _GLOBAL;
	}else if(dir >= OFF_BAND_TEMP && dir < OFF_BAND_CONST){
		return _TEMPORAL;
	}else if(dir >= OFF_BAND_CONST && dir < OFF_BAND_DIR_OBJ){
		return _CONSTANTE;
	}else if(dir >= OFF_BAND_DIR_OBJ && dir <= OFF_BAND_DIR_FUNCION){
		return _OBJETO;
	}else if(dir >= OFF_BAND_DIR_FUNCION && dir <= OFF_UPPER_LIMIT){
		return _FUNCION;
	}else {
		return _ERROR;
	}
}

/**
	getTipoDireccion
	Recibe una direccion y un scope y regresa el tipo de dato de esta direccion para leer el objeto 
	@param direccion representa la direccion a analizar, ejemplo 16500
	@param scope representa el scope en el que se encuentra la direccion
	@return el tipo de variable que representa esta direccion,0 bandera, 1 entero, 2 decimal 3 texto

**/
int getTipoDireccion ( int dir, int scope ) {
	int tipoDireccion = -1 ;

    switch (scope) {
        case _GLOBAL:
                tipoDireccion = floor( ( dir - OFF_BAND_GLOBAL  )/ 1000 ) ; 
        break;
        case _TEMPORAL: 
                tipoDireccion = floor( ( dir - OFF_BAND_TEMP  )/ 1000 ) ;
        break;
        case _CONSTANTE: 
                tipoDireccion = floor( ( dir - OFF_BAND_CONST  )/ 1000 ) ; 
        break;
        case _FUNCION:
                
                tipoDireccion = floor( ( dir - OFF_BAND_DIR_FUNCION  )/ 1000 ) ; 
                

        break;
        case _OBJETO:

                tipoDireccion = floor( ( dir - OFF_BAND_DIR_OBJ  )/ 1000 ) ; 
        break;

    }
	return tipoDireccion; 

}

/**
        getOperandoIndex
        Funcion que regresa un entero dependiendo del operador que recibe.
        @param operador, operador a buscar
        @return un entero definido como constante global que se usara para las operaciones
**/
int getOperandoIndex(string operador){

    if ( operador == "+") { return _PLUS; }
    if ( operador == "-") { return _MINUS; }
    if ( operador == "*") { return _TIMES; }
    if ( operador == "/") { return _SLASH; }
    if ( operador == "==") { return _EQLEQL; }
    if ( operador == "!=") { return _NEQ; }
    if ( operador == ">") { return _GTR; }
    if ( operador == "<") { return _LSS; }
    if ( operador == "=") { return _EQL; }
    if ( operador == ">=") { return _GTROEQL; }
    if ( operador == "<=") { return _LSSOEQL; }
    if ( operador == "||") { return _OR; }
    if ( operador == "&&") { return _AND; }
    if ( operador == "lee") { return _LEESYM; }
    if ( operador == "muestra") { return _MUESTRASYM; }
    if ( operador == "gotoF") { return _GOTOF; }
    if ( operador == "gotoT") { return _GOTOT; }
    if ( operador == "goto") { return _GOTO; }
    if ( operador == "era") { return _ERA; }
    if ( operador == "gosub") { return _GSUB; }
    if ( operador == "retorno") { return _RETURN; }
    if ( operador == "param") { return _PARAM; }
    if ( operador == "ver") { return _VER; }
    if ( operador == "end") { return _END; }
    if ( operador == "saltolinea") { return _SALTOLINEA; }
    return - 1;
}



/**
    pideEntero
    Metodo que ependiendo del scope regresa el valor del entero que se pide
    @param dir, direccion del entero en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor del entero conseguido en memoria
**/
int pideEntero (int dir) { 
    int scope = getScope(dir);
    int valor = -1;
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideEntero( dir - OFF_ENT_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideEnteroTemp( dir - OFF_ENT_TEMP );
                
        break;
        case _CONSTANTE: 
        		valor =  atoi(constantesEnteras[dir- OFF_ENT_CONST ].valor.c_str());
                
        break;
        case _FUNCION:
                valor =  memoria.pideEnteroLoc(  memoria.pideDirEnteroFunc( dir - OFF_ENT_DIR_FUNCION ));

        break;
        case _OBJETO: {
                valor =  memoria.pideEnteroObj(  memoria.pideDirEnteroObj( dir - OFF_ENT_DIR_OBJ ));
                
        }				
        break;

    }
    return valor;
}

/**
    pideBandera
    Metodo que ependiendo del scope regresa el valor del bandera que se pide
    @param dir, direccion del bandera en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor de la bandera conseguido en memoria
**/
bool pideBandera (int dir) { 

    int scope = getScope(dir);
    bool valor = false;
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideBandera( dir - OFF_BAND_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideBanderaTemp( dir - OFF_BAND_TEMP );
                
        break;
        case _CONSTANTE: {

        		string val =  constantesBandera[dir- OFF_BAND_CONST ].valor;
        		valor = val == "falso" ? 0 : 1 ;
        }

        break;
        case _FUNCION:
                
                valor =  memoria.pideBanderaLoc(  memoria.pideDirBanderaFunc( dir - OFF_BAND_DIR_FUNCION ));
        break;
        case _OBJETO: 

                valor =  memoria.pideBanderaObj(  memoria.pideDirBanderaObj( dir - OFF_BAND_DIR_OBJ ));
                
        break;

    }
    return valor;
}

/**
    pideTexto
    Metodo que ependiendo del scope regresa el valor del texto  que se pide
    @param dir, direccion del texto en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor de la texto conseguido en memoria
**/
string pideTexto (int dir) { 

    int scope = getScope(dir);
    string valor = "";
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideTexto( dir - OFF_TEXT_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideTextoTemp( dir - OFF_TEXT_TEMP );
                
        break;
        case _CONSTANTE: 
        		valor =  constantesTexto[dir- OFF_TEXT_CONST ].valor;
        break;
        case _FUNCION:
                
                valor =  memoria.pideTextoLoc(  memoria.pideDirTextoFunc( dir - OFF_TEXT_DIR_FUNCION ));
        break;
        case _OBJETO:

                valor =  memoria.pideTextoObj(  memoria.pideDirTextoObj( dir - OFF_TEXT_DIR_OBJ ));
                
        break;

    }
    return valor;
}

/**
    pideDecimal
    Metodo que ependiendo del scope regresa el valor del decimal que se pide
    @param dir, direccion del decimal en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor de la decimal conseguido en memoria
**/
double pideDecimal (int dir) { 

    int scope = getScope(dir);
    double valor = -1.0;
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideDecimal( dir - OFF_DEC_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideDecimalTemp( dir - OFF_DEC_TEMP );

        break;
        case _CONSTANTE: 
        		valor =  atof(constantesDecimales[dir- OFF_DEC_CONST ].valor.c_str());
      
        break;
        case _FUNCION:
                
                valor =  memoria.pideDecimalLoc(  memoria.pideDirDecimalFunc( dir - OFF_DEC_DIR_FUNCION ));
        break;
        case _OBJETO:

                valor =  memoria.pideDecimalObj(  memoria.pideDirDecimalObj( dir - OFF_DEC_DIR_OBJ ));
                
        break;

    }
    return valor;
}


/**
    guardaEntero
    Metodo que dependiendo del scope guarda la variable entera en la memoria correspondiente
    @param dir, direccion del entero en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaEntero (int dir, int valor) { 

    int scope = getScope(dir);
    switch (scope) {
        case _GLOBAL:
                memoria.guardaEntero( dir - OFF_ENT_GLOBAL , valor );
        break;
        case _TEMPORAL: 
        		
                memoria.guardaEnteroTemp( dir - OFF_ENT_TEMP , valor );

        break;
        case _CONSTANTE: 
                memoria.guardaEntero( dir - OFF_ENT_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaEnteroLoc(  memoria.pideDirEnteroFunc( dir - OFF_ENT_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaEnteroObj(  memoria.pideDirEnteroObj( dir - OFF_ENT_DIR_OBJ), valor );
        break;

    }
}

/**
    guardaBandera
    Metodo que dependiendo del scope guarda la variable booleana en la memoria correspondiente
    @param dir, direccion del booleana en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaBandera (int dir, bool valor) { 

    int scope = getScope(dir);
    switch (scope) {
        case _GLOBAL:
                memoria.guardaBandera( dir - OFF_BAND_GLOBAL , valor );
        break;
        case _TEMPORAL: 
                memoria.guardaBanderaTemp( dir - OFF_BAND_TEMP , valor );
        break;
        case _CONSTANTE: 
                memoria.guardaBandera( dir - OFF_BAND_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaBanderaLoc(  memoria.pideDirBanderaFunc( dir - OFF_BAND_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaBanderaObj(  memoria.pideDirBanderaObj( dir - OFF_BAND_DIR_OBJ), valor );
        break;

    }
}

/**
    guardaDecimal
    Metodo que dependiendo del scope guarda la variable decimal en la memoria correspondiente
    @param dir, direccion del decimal en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaDecimal (int dir, double valor) { 

    int scope = getScope(dir);

    switch (scope) {
        case _GLOBAL:
                memoria.guardaDecimal( dir - OFF_DEC_GLOBAL , valor );
        break;
        case _TEMPORAL: {
                memoria.guardaDecimalTemp( dir - OFF_DEC_TEMP , valor );        
        }
        break;
        case _CONSTANTE: 
                memoria.guardaDecimalTemp( dir - OFF_DEC_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaDecimalLoc(  memoria.pideDirDecimalFunc( dir - OFF_DEC_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaDecimalObj(  memoria.pideDirDecimalObj( dir - OFF_DEC_DIR_OBJ), valor );
        break;

    }
}



/**
    guardaTexto
    Metodo que dependiendo del scope guarda la variable texto en la memoria correspondiente
    @param dir, direccion del texto en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaTexto (int dir, string valor) { 

    int scope = getScope(dir);

    switch (scope) {
        case _GLOBAL:
                memoria.guardaTexto( dir - OFF_TEXT_GLOBAL , valor );
        break;
        case _TEMPORAL: 
                memoria.guardaTextoTemp( dir - OFF_TEXT_TEMP , valor );
        break;
        case _CONSTANTE: 
                memoria.guardaTexto( dir - OFF_TEXT_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaTextoLoc(  memoria.pideDirTextoFunc( dir - OFF_TEXT_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaTextoObj(  memoria.pideDirTextoObj( dir - OFF_TEXT_DIR_OBJ), valor );
        break;

    }
}




/**
 * plus_op
 * Funcion utilizada para llevar a cabo la suma de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void plus_op(Cuadruplo current){

    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i+d==2){
        iRes = pideEntero(dirIzq) + pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;

    } else if (i+d==4) {

    	dRes = pideDecimal(dirIzq) + pideDecimal(dirDer);    	

    } else if (i==2){


        dRes = pideEntero(dirDer) + pideDecimal(dirIzq);
    }
    else{
      dRes = pideDecimal(dirDer) + pideEntero(dirIzq);
    }
    guardaDecimal(dirRes,dRes);
    
}

/**
 * minus_op
 * Funcion utilizada para llevar a cabo la resta de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void minus_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i+d==2){
        iRes = pideEntero(dirIzq) - pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;
    } else  if (i+d==4){
        dRes = pideDecimal(dirIzq) - pideDecimal(dirDer);

    } else  if (i==2){
        dRes = pideDecimal(dirIzq) - pideEntero(dirDer);
    }
    else{
        dRes = pideEntero(dirIzq) - pideDecimal(dirDer);
    }
    guardaDecimal(dirRes,dRes);
}

/**
 * times_op
 * Funcion utilizada para llevar a cabo la multiplicacion de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void times_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));

    if (i+d==2){

        iRes = pideEntero(dirIzq) * pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;
    } else if (i+d==4){
        dRes = pideDecimal(dirIzq) * pideDecimal(dirDer);
    } else if (i==2){
        dRes = pideDecimal(dirIzq) * pideEntero(dirDer);
    }
    else{
        dRes = pideEntero(dirIzq) * pideDecimal(dirDer);
    }
    guardaDecimal(dirRes,dRes);
}

/**
 * divide_op
 * Funcion utilizada para llevar a cabo la division de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void divide_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i+d==2){
        dRes = pideEntero(dirIzq) / pideEntero(dirDer);
    } else if (i+d==4){
        dRes = pideDecimal(dirIzq) / pideDecimal(dirDer);
    } else if (i==2){
        dRes = pideDecimal(dirIzq) / pideEntero(dirDer);
    }
    else{
        dRes = pideEntero(dirIzq) / pideDecimal(dirDer);
    }

    guardaDecimal(dirRes,dRes);
}

/**
 * equal_op
 * Funcion utilizada para llevar a cabo la operacion logica de == de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void equal_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 6){
        bRes=(pideTexto(dirIzq) == pideTexto(dirDer));
    } else if (i + d == 3){
        if (i==2){
            bRes = (pideDecimal(dirIzq) == pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) == pideDecimal(dirDer));
        }
    } else if (i + d == 0){
        bRes=(pideBandera(dirIzq) == pideBandera(dirDer));
    } else if (i + d == 2){
        bRes=(pideEntero(dirIzq) == pideEntero(dirDer));
    } else if (i + d == 4){
        bRes=(pideDecimal(dirIzq) == pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * notequal_op
 * Funcion utilizada para llevar a cabo la operacion logica de != de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void notequal_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 6){
        bRes=(pideTexto(dirIzq) == pideTexto(dirDer));
    } else if (i + d == 3){
        if (i==2){
            bRes = (pideDecimal(dirIzq) != pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) != pideDecimal(dirDer));
        }
    } else if (i + d == 0){
        bRes=(pideBandera(dirIzq) != pideBandera(dirDer));
    } else if (i + d == 2){
        bRes=(pideEntero(dirIzq) != pideEntero(dirDer));
    } else if (i + d == 4){
        bRes=(pideDecimal(dirIzq) != pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * more_op
 * Funcion utilizada para llevar a cabo la operacion logica de > de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void more_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i==2){
            bRes = (pideDecimal(dirIzq) > pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) > pideDecimal(dirDer));
        }
    } else if (i + d == 0){
        bRes=(pideBandera(dirIzq) > pideBandera(dirDer));
    } else if (i + d == 2){
        bRes=(pideEntero(dirIzq) > pideEntero(dirDer));
    } else if (i + d == 4){
        bRes=(pideDecimal(dirIzq) > pideDecimal(dirDer));
    }

    guardaBandera(dirRes,bRes);
}

/**
 * less_op
 * Funcion utilizada para llevar a cabo la operacion logica de < de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void less_op(Cuadruplo current) {
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i==2){
            bRes = (pideDecimal(dirIzq) < pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) < pideDecimal(dirDer));
        }
    } else if (i + d == 0){
        bRes=(pideBandera(dirIzq) < pideBandera(dirDer));
    } else if (i + d == 2){
        bRes=(pideEntero(dirIzq) < pideEntero(dirDer));
    } else if (i + d == 4){
        bRes=(pideDecimal(dirIzq) < pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * moreeq_op
 * Funcion utilizada para llevar a cabo la operacion logica de >= de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void moreeq_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i==2){
            bRes = (pideDecimal(dirIzq) >= pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) >= pideDecimal(dirDer));
        }
    } else if (i + d == 0){
        bRes=(pideBandera(dirIzq) >= pideBandera(dirDer));
    } else if (i + d == 2){
        bRes=(pideEntero(dirIzq) >= pideEntero(dirDer));
    } else if (i + d == 4){
        bRes=(pideDecimal(dirIzq) >= pideDecimal(dirDer));
    }

    guardaBandera(dirRes,bRes);
}

/**
 * lesseq_op
 * Funcion utilizada para llevar a cabo la operacion logica de <= de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void lesseq_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i==2){
            bRes = (pideDecimal(dirIzq) <= pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) <= pideDecimal(dirDer));
        }
    } else if (i + d == 0){
        bRes=(pideBandera(dirIzq) <= pideBandera(dirDer));
    } else if (i + d == 2){
        bRes=(pideEntero(dirIzq) <= pideEntero(dirDer));
    } else if (i + d == 4){
        bRes=(pideDecimal(dirIzq) <= pideDecimal(dirDer));
    }

    guardaBandera(dirRes,bRes);
}

/**
 * or_op
 * Funcion utilizada para llevar a cabo la operacion logica de || de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void or_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    bool bRes;
    bRes=(pideBandera(dirIzq) || pideBandera(dirDer));

    guardaBandera(dirRes,bRes);
}

/**
 * and_op
 * Funcion utilizada para llevar a cabo la operacion logica de && de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void and_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    bool bRes;
    bRes=(pideBandera(dirIzq) && pideBandera(dirDer));

    guardaBandera(dirRes,bRes);
}


/**
 * assign_op
 * Funcion utilizada para llevar a cabo la operacion logica de = de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void assign_op(Cuadruplo current){
  int dirIzq = atoi(current.getIzq().c_str());
  int dirRes = atoi(current.getRes().c_str());
  int i,r;
  i=getTipoDireccion(dirIzq,getScope(dirIzq));
  r=getTipoDireccion(dirRes,getScope(dirRes));
  switch(r){
    case 0:
      guardaBandera(dirRes,pideBandera(dirIzq));
      break;
    case 1:
      if(i==1) {
     	
        guardaEntero(dirRes,pideEntero(dirIzq));
      }
      else {
      	
        guardaEntero(dirRes,pideDecimal(dirIzq));
      }
      break;
    case 2:
      if(i==1)
        guardaDecimal(dirRes,pideEntero(dirIzq) + 0.0);
      else
        guardaDecimal(dirRes,pideDecimal(dirIzq));
      break;
    case 3:
      guardaTexto(dirRes,pideTexto(dirIzq));

      break;
    default:
      break;
  }
}

/**
 * print_op
 * Funcion utilizada para llevar a cabo la operacion logica de muestra() de una direccion de memoria
 * @param cuadruplo, representando el cuadruplo actual
 */
void print_op(Cuadruplo current){
  int dirRes = atoi(current.getRes().c_str());
  int r;
  r=getTipoDireccion(dirRes,getScope(dirRes));
  switch(r){
    case 0:
      cout << pideBandera(dirRes);
      break;
    case 1:
    cout << pideEntero(dirRes);
      break;
    case 2:
    cout << pideDecimal(dirRes);
      break;
    case 3: {

    	string token = pideTexto(dirRes);
    	if ( getScope(dirRes) == 2) {
			token = token.substr(1,token.size()-2);
    	}

    	cout << token;
    }
      break;
    default:
      break;
  }
}

/**
 * checkType
 * Funcion utilizada para checar si lo que se lee es correcto para enteros o decimales
 * @param type, que es el tipo de variable; var, string que es la variable a probar
 * @return valor buleano para decir si esta correcto el string de entrada
 */
bool checkType(int type, string var){
  bool dot=false;

  //Checa que sea entero valido
  if (type==1){
    if (!isdigit(var[0])){
      if(var[0]!='+'&&var[0]!='-'){
        return false;
      }
    }
    for (int i = 1 ;i < var.size() ;i++){
      if (!isdigit(var[i])){
        return false;
      }
    }
    return true;
  }
//checa que sea un decimal valido
  if (type==2){
    if (!isdigit(var[0])){
      if(var[0]!='+'&&var[0]!='-'){
        if (var[0]=='.')
          dot=true;
        else
          return false;
      }
    }
    for (int i = 1 ;i < var.size() ;i++){
      if (!isdigit(var[i])){
        if (var[i]=='.'&&!dot)
          dot=true;
        else
          return false;
      }
    }
    return true;
  }
}

/**
 * read_op
 * Funcion utilizada para leer contenido del usuario para memoria
 * @param cuadruplo, representando el cuadruplo actual
 * @return valor buleano para decir si se pudo ejecutar la funcion
 */

bool read_op(Cuadruplo current){
  
  string input;
  int r;
  int dirRes = atoi(current.getRes().c_str());
  r=getTipoDireccion(dirRes,getScope(dirRes));
  if (r==0){
    bool b;
    cin >> b;
    guardaBandera(dirRes,b);
    return true;
  }
  cin >> input;
  switch(r){
    case 1:
      if (checkType(1,input)){
        int res = atoi(input.c_str());
        guardaEntero(dirRes,res);
        return true;
      }
      else{
        cout <<"No se pudo leer entero"<<endl;
        return false;
      }
      break;
    case 2:
      if (checkType(2,input)){
        double res = atof(input.c_str());
        guardaDecimal(dirRes,res);
        return true;
      }
      else{
        cout <<"No se pudo leer decimal"<<endl;
        return false;
      }
      break;
    case 3:
      guardaTexto(dirRes,input);
      return true;
      break;
    default:
      return false;
      break;
  }
}


/**
 * indexGOTOF
 * Funcion utilizada para representar el GOTOF
 * @param cuadruplo, representando el cuadruplo actual: @param i, para saber cual era la original
 * @return valor entero que es la direccion del cuadruplo a seguir
 */
int indexGOTOF(int i,Cuadruplo current){
  bool b;
  int dirRes = atoi(current.getRes().c_str());
  int dirIzq = atoi(current.getIzq().c_str());

  b = pideBandera(dirIzq);
  return b ? i : (dirRes-1);//-1 porque al final de la iteracion hara i++
}

/**
 * indexGOTOT
 * Funcion utilizada para representar el GOTOT
 * @param cuadruplo, representando el cuadruplo actual: @param i, para saber cual era la original
 * @return valor entero que es la direccion del cuadruplo a seguir
 */
int indexGOTOT(int i,Cuadruplo current){
  bool b;
  int dirRes = atoi(current.getRes().c_str());
  int dirIzq = atoi(current.getIzq().c_str());
  b = pideBandera(dirIzq);
  return b ?  (dirRes-1) : i;//-1 porque al final de la iteracion hara i++
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
        //cout << "Current: " << current.getOp() << " getOpIndex: " <<  getOperandoIndex(current.getOp() ) << endl;
        switch ( getOperandoIndex(current.getOp() ))  {

            //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
            case _PLUS    : plus_op(current);   break; // Funcion que hace la suma
            case _MINUS   : minus_op(current);   break; // Funcion que hace la resta
            case _TIMES   : times_op(current);   break; // Funcion que hace la multiplicacion
            case _SLASH   : divide_op(current);   break; // Funcion que hace la division
            case _EQLEQL  : equal_op(current);   break; // Funcion que hace ==
            case _NEQ     : notequal_op(current);   break; // Funcion que hace !=
            case _GTR     : more_op(current);   break; // Funcion que hace >
            case _LSS     : less_op(current);   break; // Funcion que hace <
            case _GTROEQL : moreeq_op(current);   break; // Funcion que hace >=
            case _LSSOEQL : lesseq_op(current);   break; // Funcion que hace <=
            case _OR      : or_op(current);   break; // Funcion que hace ||
            case _AND     : and_op(current);   break; // Funcion que hace &&
            case _MUESTRASYM : print_op(current);   break; // Funcion que el output
            case _SALTOLINEA : cout << endl ;   break; // Funcion que el output
            case _LEESYM  : read_op(current);   break; // Funcion que hace la lectura 
            case _EQL     : assign_op(current);   break; // Funcion que hace la asignacion
			case _GOTO    : i = atoi(current.getRes().c_str()) ;  break;// -1 para equilibrar el i++
			case _GOTOF   : i = indexGOTOF(i,current);  break;
			case _GOTOT   : i = indexGOTOT(i,current); break;


        }
        
    }
}

