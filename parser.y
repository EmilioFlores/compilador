%{
#include <cstdio>
#include <iostream>
#include <string.h>
#include "cuadruplo.cpp"
#include "estructura.cpp"
#include <stack>
#include <vector>
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

int getIndexOperador(string operador);
int getSiguienteDireccion(string tipo, bool constante);


dirProcedimientos dirProcedimientos ;
string yyTipo = "";
string objetoNombre = "default";


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

int indexEnteros    = 0;
int indexDecimal    = 0;
int idnexBandera    = 0;
int indexTexto      = 0;
int indexTemporales = 0;
int indexEnteroConstantes    = 0;
int indexDecimalConstantes    = 0;
int idnexBanderaConstantes    = 0;
int indexTextoConstantes      = 0;
int indexTemporalesConstantes = 0;


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
%token SEMICOLON
%token COMMA
%token DOT
%token EQL
%token EQLEQL
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

Objeto 				: OBJETOSYM  IDENTIFICADOR { 
						objetoNombre = yytext; 
						dirProcedimientos.crearObjeto(objetoNombre); 

					}  LCURLY AtributosPrivados AtributosPublicos RCURLY SEMICOLON {
						dirProcedimientos.terminaBloque();
					} ;

AtributosPrivados	: PRIVADOSYM LCURLY VariablesObjetos Funciones RCURLY
					|  epsilon ;

AtributosPublicos	: PUBLICOSYM LCURLY Variables FuncionesObjetos RCURLY 
					|  epsilon ;



Librerias 			: Libreria Libreria1 ;
Libreria  			: INCLUIRSYM LSS IDENTIFICADOR GTR  ;
Libreria1			: Libreria | ;




Funciones 			: Funcion ;
FuncionesObjetos	: FuncionObjeto ;

Funcion  			: FUNCIONSYM  Tipo IDENTIFICADOR Params BloqueFuncion SEMICOLON Funcion
					| epsilon ;

FuncionObjeto		: FUNCIONSYM  Tipo { yyTipo = yytext } IDENTIFICADOR {
						
						dirProcedimientos.crearMetodo(yyTipo, $4);

					} ParamsObjeto BloqueFuncion SEMICOLON {

					  dirProcedimientos.terminaBloque();
					} FuncionObjeto
					| epsilon ;


Tipo				: ENTEROSYM  
					| DECIMALSYM  
					| TEXTOSYM 
					| BANDERASYM 
					| IDENTIFICADOR ;


Params				: LPAREN Param RPAREN ;
ParamsObjeto		: LPAREN ParamObjeto RPAREN ;

Param 				: Tipo IDENTIFICADOR  Param1 
					| epsilon ;
Param1				: COMMA Param 
					| epsilon ;

ParamObjeto 		: Tipo { yyTipo = yytext } IDENTIFICADOR {

						dirProcedimientos.agregaParametro(yyTipo, $3, getSiguienteDireccion(yyTipo, 0));

					} ParamObjeto1 
					| epsilon ;
ParamObjeto1		: COMMA ParamObjeto 
					| epsilon ;


Args				: VarCte Args1
					| epsilon ;

Args1				: COMMA VarCte Args1
					| epsilon ;



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


Llamada				: IDENTIFICADOR   Llamada1 Llamada2  SEMICOLON ;
Llamada1			: DOT IDENTIFICADOR Llamada1
					| epsilon ;
Llamada2			: LPAREN Args RPAREN  
					| epsilon ;

Asignacion 			: IDENTIFICADOR {
										int direccionVariable = dirProcedimientos.buscaDireccion($1);
										accion_1_assignacion(direccionVariable );
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
					| Factor1 VarCteExp 
Factor1 			: PLUS
					| MINUS
					| epsilon	;



VarCteExp			:	IDENTIFICADOR { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										// si es 4, entonces es un identificador

										accion_1_expresiones(yytext, 4);
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

VarCte			:	IDENTIFICADOR 
					|	ENTERO 
					|	BANDERA 
					|	TEXTO   
					|	DECIMAL ;


Variables			: Variable SEMICOLON Variables
					| epsilon ;
VariablesObjetos	: VariableObjeto SEMICOLON VariablesObjetos
					| epsilon ;



Variable			: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR  {  
									//TODO Hace funcion que me regrese la direccion. 
									if (debug ) {
										cout << "Crear variable Tipo: " << yyTipo << " Nombre: " << $4 << endl;
									}
									dirProcedimientos.crearVariable(yyTipo, $4, 1, getSiguienteDireccion(yyTipo, 0) );

								   }  ;
VariableObjeto		: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR   {  
									//TODO Hace funcion que me regrese la direccion. 
									if (debug ) {
										cout << "Crear Objeto Tipo: " << yyTipo << " Nombre: " << $4 << endl;
									}

									dirProcedimientos.crearVariable(yyTipo, $4, 0, getSiguienteDireccion(yyTipo, 0) );  
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
					} SEMICOLON ;
Ciclo1 				: Asignacion 
					| epsilon ;

Escritura			: MUESTRALINEASYM LPAREN EstatutosSalida RPAREN SEMICOLON ;
					| MUESTRASYM LPAREN EstatutosSalida RPAREN SEMICOLON ;

EstatutosSalida		: Llamada
					| VarCte
					| epsilon ;


Lectura				: LEESYM VarCte SEMICOLON ;

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
		cout << "direccionVariable " << direccionVariable << endl;
		}
		if (direccionVariable != -1 ) {

			
			int tipoVariable = dirProcedimientos.checaTipo(yytext);


			//0 bandera, 1 entero, 2 decimal, 3 texto
			if (tipoVariable < 4) {

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
				Cuadruplo cuadruploTemp = Cuadruplo(operador, izq, der, resultado);
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
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, izq, der, resultado);
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
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, izq, der, resultado);
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


	
	int der = pilaOperandos.top();
	pilaOperandos.pop();

	int izq = pilaOperandos.top();
	pilaOperandos.pop();

	string asigna = pilaOperadores.top();
	pilaOperadores.pop();

	Cuadruplo cuadruploTemp = Cuadruplo(asigna, der, 0 , izq);
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
	
		Cuadruplo cuadruploTemp = Cuadruplo("gotoF", resultado, 0 , -1);
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
	Cuadruplo cuadruploTemp = Cuadruplo("goto", 0, 0 , -1);
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
	
		Cuadruplo cuadruploTemp = Cuadruplo("gotoF", resultado, 0 , -1);
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
	
	Cuadruplo cuadruploTemp = Cuadruplo("goto", 0, 0 , retorno);
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
	

	Cuadruplo cuadruploTemp = Cuadruplo("gotoF", resultado, 0 , retorno);
	cuadruplos.push_back( cuadruploTemp );


	if ( debug ) {
		cout << "accion_2_haz_mientras Termina" << endl;
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

	
	cuadruplos[fin].setRes(cont);

}