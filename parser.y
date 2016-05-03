%{
#include <cstdio>
#include <iostream>
#include <string.h>
#include "cuadruplo.cpp"
#include <stack>
#include <queue>
#include <string>     // std::string, std::to_string
#include <vector>
#include <sstream>
#include <iomanip>
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
string objetoPadre = "default";
string metodoNombre = "";
string funcionNombre = "";
struct variable vAux;
struct bloque bAux;
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
int bloqueglobal = 0;
int indexParametro = 0;
bool metodo = false;
bool global = true;
bool objeto = false;
bool temporal = false;
bool funcion = false; 
stack<int> pilaOperandos;
stack<string> pilaOperadores;
queue<int> filaArgumentos;
stack<int> pilaTipos;
stack<int> pilaSaltos;
stack<int> pilaSUB;
vector<Cuadruplo> cuadruplos; 
vector<constante> constantesEnteras;
vector<constante> constantesDecimales;
vector<constante> constantesTexto;
vector<constante> constantesBandera;
int cuboSemantico[4][4][13] = 	
{
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


%}

%union {
	int ival;
	float fval;
	char *sval;
	bool bval;
}

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

programa  			:  Objetos Funciones Main ;

Objetos				:  Objeto Objetos
					| ;

Objeto 				: OBJETOSYM  IDENTIFICADOR { 
						objetoNombre = yytext; 
						objeto = true;
						dirProcedimientos.crearObjeto(objetoNombre); 

					}  LCURLY AtributosPrivados AtributosPublicos RCURLY SEMICOLON {
						objeto = false;
						dirProcedimientos.terminaBloque();
					} ;

AtributosPrivados	: PRIVADOSYM LCURLY  VariablesObjetos Funciones   RCURLY
					|  epsilon ;

AtributosPublicos	: PUBLICOSYM LCURLY  Variables FuncionesObjetos   RCURLY 
					|  epsilon ;

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
						accion_1_definicion_proc(yyTipo, $4);
						global = false; 

					} ParamsObjeto BloqueFuncion SEMICOLON {
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
					} ParamObjeto1 
					| epsilon ;
ParamObjeto1		: COMMA ParamObjeto 
					| epsilon ;

Args				: {
					  int tipoObjeto = -1;
					  if ( metodo ) { 
					   	tipoObjeto = dirProcedimientos.checaTipo(objetoNombre);
					  }
					  if ( !dirProcedimientos.comienzaArgumentos(tipoObjeto, objetoNombre)) {
					   		cout << "Error:" << endl;
					   		exit(-1);
					   }
					} Expresion { 
					  accion_3_llamada_proc();
					} Args1
					| epsilon ;

Args1				: COMMA Expresion {
					  accion_3_llamada_proc();
					} Args1
					| epsilon;

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

					   metodo = false;
					   objetoNombre = $1;
					   metodoNombre = $1;
					   int variableIndex = dirProcedimientos.buscaVariable(objetoNombre);
					   
					   if (variableIndex == -1 ) { 
							cerr << "ERROR: Variable not found:  \"" << objetoNombre;
							cerr << "\" on line " << line_num << endl;
							exit(-1);
						}

					}  Llamada1 Llamada2 ;
Llamada1			: DOT IDENTIFICADOR {
					  metodoNombre = $2;
					  metodo = true;
						//accion_1_llamada_proc_predicado(objetoNombre, metodoNombre);
					} Llamada1
					| epsilon ;
Llamada2			: LPAREN {
						accion_6_expresiones("(");
						if ( metodo == false) {
							//accion_1_llamada_proc_no_predicado(objetoNombre, metodoNombre);
						}
						accion_2_llamada_proc();
					} Args RPAREN  {

						dirProcedimientos.terminaArgumentos();
						accion_6_llamada_proc(objetoPadre);
						accion_7_expresiones();
						//accion_5_llamada_proc();
					}
					| epsilon {
						if ( metodo ) {
							accion_1_expresiones(metodoNombre, 4);
						}
						else {
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
										int esVariable = dirProcedimientos.esVariable(variableIndex);
										if ( !esVariable ) { 
											cerr << "ERROR: en el simbolo  \"" << yytext;
											cerr << "\"  no se puede asignar contenido a un metodo, en linea " << line_num << endl;
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

VarCteExp			:	Llamada 
					|	ENTERO { 
						accion_1_expresiones(yytext, 1);
					};
					|	BANDERA { 
						accion_1_expresiones(yytext, 0);
					};
					|	TEXTO   { 
						accion_1_expresiones(yytext, 3);
					};
					|	DECIMAL { 
						accion_1_expresiones(yytext, 2);
					};
	
Variables			: Variable SEMICOLON Variables
					| epsilon ;
VariablesObjetos	: VariableObjeto SEMICOLON VariablesObjetos
					| epsilon ;

Variable			: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR  {  
								
						int direccion;
						direccion = getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0,  global, temporal, objeto, funcion);
						if ( !dirProcedimientos.crearVariable(yyTipo, $4, 1, direccion )) {
							exit (-1);
						};
					 }  Variable1 ;
Variable1			: LBRACKET Expresion RBRACKET 
					| epsilon;

VariableObjeto		: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR   {  
						dirProcedimientos.crearVariable(yyTipo, $4, 0, getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0, global, temporal, objeto, funcion));
    				};

Condicion			: CONDICIONSYM LPAREN Expresion RPAREN {
						accion_1_condicion_fallo();
					} Bloque Condicion1 { 
						accion_3_condicion_fallo();
					}
Condicion1			: FALLOSYM {
						accion_2_condicion_fallo();
					} Bloque | epsilon ;

Ciclo				: CICLOSYM  LPAREN Ciclo1 COMMA {
						accion_1_ciclo();
					} Expresion {
						accion_2_ciclo();
					} COMMA {
						accion_3_ciclo();
					} Ciclo1 {
						accion_4_ciclo();
					} RPAREN {
						accion_5_ciclo();
					} Bloque {
						accion_6_ciclo();
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
						rellenar(inicio, cuadruplos.size()  );
					} Bloque {  printCuadruplos(); }
epsilon				:	;




%%

/**
 * Metodo main del programa. Aqui se lleva a cabo la llamada al lexico y sintactico y finalmente se realiza la llamada 
 * a la maquina virtual para ejecutar el programa
 * @param  argc Numero de argumentos de entrada
 * @param  argv Argumentos de entrada
 * @return      valor entero dependiendo si la ejecución fue correcta o no
 */
int main(int argc, char **argv) {

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

/**
 * Funcion que despliega error por default de bison
 * @param s con el mensaje de error a desplegar
 */
void yyerror(const char *s) {

	extern int yylineno;	// defined and maintained in lex.c
 	extern char *yytext;	// defined and maintained in lex.c 
    cerr << "ERROR: " << s << " at symbol \"" << yytext;
	cerr << "\" on line " << line_num << endl;
	exit(-1);
}

/**
 * Accion 1 de expresiones. Aqui es donde se Mete a la pila de operandos el token recibido. Si es una constante
 * Entonces la da de alta en el vector de constantes, y si es una variable la resuelve y busca si existe
 * @param yytext Valor de la variable
 * @param tipo   Tipo de la variable, 0 bandera, 1 entero, 2 decimal, 3 texto
 */
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
			if (tipoVariable < 4 && ( estructuraVariable == 0 )  ) {
				
				// Si es una funcion, no meter nada a la pila, pues ya se metio arriba
				if ( estructuraVariable != 1) {

					pilaOperandos.push(direccionVariable);
					pilaTipos.push(tipoVariable);
				}
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

/**
 * Accion 2 de expresiones. Mete el operador a la pila de operadores. Operadores son +, -, *, /, etc.
 * @param operador a meter a la pila de operadores
 */	
void accion_2_expresiones(string operador){
	
	pilaOperadores.push(operador);	
}

/**
 * Accion 3 de expresiones. Mete el operador a la pila de operadores. Operadores son +, -, *, /, etc.
 * @param operador a meter a la pila de operadores
 */	
void accion_3_expresiones(string operador){
	
	pilaOperadores.push(operador);
}

/**
 * Accion 4 expresiones. Checa si es una suma o resta en el tope de la pila, y si si es, entonces realiza un chequeo semantico
 * entre los ultimos dos valores en la pila de operandos para finalmente generar el cuadruplo con la operacion que se hara
 * en esos dos operandos
 */
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

/**
 * Accion 5 expresiones. Checa si es una division o multiplicacion en el tope de la pila, y si si es, entonces realiza un chequeo semantico
 * entre los ultimos dos valores en la pila de operandos para finalmente generar el cuadruplo con la operacion que se hara
 * en esos dos operandos
 */
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

				int resultado = getSiguienteDireccion(tipoResultado, 0, global, temporal, objeto, funcion);				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);
				pilaTipos.push(tipoResultado);
				temporal = false;
			}	
			else {
				cerr << "Tipos incompatibles en la linea " << line_num << endl;
				exit(-1);
			}	
		}
	}
}

/**
 * Accion 6 expresiones. Genera un fondo falso para identificar que se estan metiendo parentesis a la expresion
 * @param fondoFalso "("
 */
void accion_6_expresiones(string fondoFalso){
	pilaOperadores.push(fondoFalso);
}

/**
 * Accion 7 expresiones. Vacia la pila de operadores con el último valor que esta tenia
 */
void accion_7_expresiones(){
	pilaOperadores.pop();
}

/**
 * Accion 8 expresiones. Mete a la pila de operadores el ultimo operador que encontro
 * @param operador encontrado.
 */
void accion_8_expresiones(string operador){
	pilaOperadores.push(operador);
}

/**
 * Accion 9 expresiones. Si el tope de la pila de operadores es alguna operacion logica entre dos operandos, realiza 
 * estas operaciones y finalmente genera el cuadruplo correspondiente
 */
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

/**
 * Accion 1 asignación. Meter id en la pila de operadores
 * @param dirOperando  direccion del operando generado anteriormente
 * @param tipoVariable tipo del operando leido
 */
void accion_1_assignacion(int dirOperando, int tipoVariable){
	pilaTipos.push(tipoVariable);
	pilaOperandos.push(dirOperando);
}

/**
 * Accion 2 asignacion. Meter en pilaOperadores el operador leido	
 * @param operador leido en la sintaxis
 */
void accion_2_assignacion(string operador){
	pilaOperadores.push(operador);
}

/**
 * Accion 3 asignacion. sacar der de pilaO. Sacar izq de pilaO. asigna = pOperadores.pop(). Genera codigo de asignacion
 */
void accion_3_assignacion( ){
	int der = pilaOperandos.top();
	pilaOperandos.pop();
	int tipoDer = pilaTipos.top();
	pilaTipos.pop();
	int izq = pilaOperandos.top();
	pilaOperandos.pop();
	int tipoIzq = pilaTipos.top();
	pilaTipos.pop();
	
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

/**
 * Accion 1 condicion fallo. Sacar el ultimo valor de la pila de tipos y checar si es diferente a boleano. En caso contrario
 * Entonces genera una accion gotoF con el resultado sacado y hacer un push a la pila de saltos con el contador actual
 */
void accion_1_condicion_fallo() {
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

/**
 * Accion 2 condicion fallo. Generar un cuadruplo goto__, saar de la pila de saltos el ultimo y hacer una accion de rellenar
 * con el valor obtenido. Finalmente realizar un push a la pila de saltos el contador
 */
void accion_2_condicion_fallo(){
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(-1));
	cuadruplos.push_back( cuadruploTemp );	
	int falso = pilaSaltos.top();
	pilaSaltos.pop();
	rellenar(falso, cuadruplos.size()  );
	pilaSaltos.push( cuadruplos.size() -1 );
}

/**
 * Accion 3 condicion fallo. Sacar fin de la pila de saltos y rellenar el fin con el contador actual
 */
void accion_3_condicion_fallo() {
	int fin = pilaSaltos.top();
	pilaSaltos.pop();
	rellenar(fin, cuadruplos.size()  );
}

/**
 * Accion 1 print. Conseguir el resultado con un pop de la fila de operandos y generar el cuadruplo muestra con el resultado obtenido
 */
void accion_1_print() {
	int res = pilaOperandos.top();
	pilaOperandos.pop();
	Cuadruplo cuadruploTemp = Cuadruplo("muestra", "", "" , to_string(res));
	cuadruplos.push_back( cuadruploTemp );		
}

/**
 * Accion 2 print. Generar una accion de salto de linea para cuando se llame el estatuto muestraLinea.
 */
void accion_2_print() {
	Cuadruplo cuadruploTemp = Cuadruplo("saltolinea", "", "" , "");
	cuadruplos.push_back( cuadruploTemp );	
}

/**
 * Accion 1 read. Buscar que la variable exista en la tabla de variables. Generar un cuadruplo lee con la variable leida
 * @param nombre de la variable a leer.
 */
void accion_1_read(string nombre) { 

	int variableIndex = dirProcedimientos.buscaVariable(nombre);
	bool esVariable = dirProcedimientos.esVariable(variableIndex);

   if (variableIndex == -1 ) { 
		cerr << "ERROR: Variable not found:  \"" << nombre;
		cerr << "\" on line " << line_num << endl;
		exit(-1);
	}
   if ( !esVariable ) { 
		cerr << "ERROR: No se pueden leer metodos:  \"" << nombre;
		cerr << "\" on line " << line_num << endl;
		exit(-1);
	}
	int direccionVariable = dirProcedimientos.buscaDireccion(nombre);
	Cuadruplo cuadruploTemp = Cuadruplo("lee", "", "" , to_string(direccionVariable) );
	cuadruplos.push_back( cuadruploTemp );	
}

/**
 * Accion 1 ciclo. Meter a la pila de saltos el contador actual
 */
void accion_1_ciclo() {
	pilaSaltos.push( cuadruplos.size() );
}

/**
 * Accion 2 ciclo. Sacar aux de la pila de tipos y verificar que sea boleano. En caso correcto sacar el resultado de la pila de 
 * operandos y generar un gotoFalso con el valor boleano hacia el resultado. Finalmente realizar un push a la pila de saltos con cont
 */
void accion_2_ciclo() {
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
		cuadruploTemp = Cuadruplo("goto", "", "" , to_string(-1)); //bloque
		cuadruplos.push_back( cuadruploTemp );
		pilaSaltos.push( cuadruplos.size() -1 );
	}
}

/**
 * Accion 3 ciclo. Generar un push a la pila de saltos con el contador actual. 
 */
void accion_3_ciclo() {
	pilaSaltos.push( cuadruplos.size()  ); 
}

/**
 * Accion 4 ciclo. Generar una accion de goto retorno despues de la asignacion del ciclo. Sacar el retorno correcto de la pila de saltos
 * y guardar de nuevo el la pila los temporales obtenidos.
 */
void accion_4_ciclo() {

	int asigna = pilaSaltos.top();
	pilaSaltos.pop();
	int gotoBloque = pilaSaltos.top();
	pilaSaltos.pop();
	int gotoFalso = pilaSaltos.top();
	pilaSaltos.pop();
	int retorno = pilaSaltos.top();
	pilaSaltos.pop();
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(retorno));
	cuadruplos.push_back( cuadruploTemp );
	pilaSaltos.push( gotoFalso );
	pilaSaltos.push( gotoBloque );
	pilaSaltos.push( asigna );
}

/**
 * Generar una accion de relleno de bloque hacia primera instruccion de estatutos de bloque. 
 */
void accion_5_ciclo() {
	int asigna = pilaSaltos.top();
	pilaSaltos.pop();
	int bloque = pilaSaltos.top();
	pilaSaltos.pop();
	rellenar(bloque, cuadruplos.size()  );
	pilaSaltos.push( asigna );
}

/**
 * Accion 6 ciclo. Genera una accion de relleno para el falso. Generar un cuadruplo goto asigna.
 */
void accion_6_ciclo() {
	int asigna = pilaSaltos.top();
	pilaSaltos.pop();
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(asigna));
	cuadruplos.push_back( cuadruploTemp );
	int falso = pilaSaltos.top();
	pilaSaltos.pop();
	rellenar(falso, cuadruplos.size()  );
}

/**
 * Accion 1 haz mientras. Meter el contador en la pila de saltos
 */
void accion_1_haz_mientras() {
	pilaSaltos.push( cuadruplos.size() );
}

/**
 * Accion 2 haz mientras. Sacar resultado de pila de operandos, sacar el retorno de pila de saltos y generar
 * una accion de gotoT con el resultado al retorno
 */
void accion_2_haz_mientras() {
	int resultado = pilaOperandos.top();
	pilaOperandos.pop();
	pilaTipos.pop();
	int retorno = pilaSaltos.top();
	pilaSaltos.pop();
	Cuadruplo cuadruploTemp = Cuadruplo("gotoT", to_string(resultado), "", to_string(retorno));
	cuadruplos.push_back( cuadruploTemp );
}

/**
 * Accion 1 definicion proc. Dar de alta el nombre del procedimiento en el directorio de procedimientos. Verificar la semantica 
 * @param tipo   tipo de funcion
 * @param nombre de la funcion recibida
 */
void accion_1_definicion_proc(string tipo, string nombre) {	
	int direccion = getSiguienteDireccion(getIndexTipoVariable(yyTipo), 0, global, temporal, objeto, funcion);
	if ( !dirProcedimientos.crearMetodo(tipo, nombre,direccion, cuadruplos.size() ) ) {
		exit(-1);
	}	
}

/**
 * Accion 2 definicion proc. Dar de alta cada parametro en el directorio de procedimientos.
 * @param tipo      del parametro leido.
 * @param nombre    del parametro leido
 * @param direccion local a la funcion del parametro leido
 */
void accion_2_definicion_proc(string tipo, string nombre, int direccion) {
	dirProcedimientos.agregaParametro(tipo, nombre, direccion);
}

/**
 * Accion 7 definicion proc. Generar una accion de retorno para el metodo en caso de que tenga retorno. 
 */
void accion_7_definicion_proc() {
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

/**
 * Accion 2 llamada proc. Generar accipon: Era tamaño (expansion del reagistro de activacion, de acuerdo a tamaño definido )
*   inicializar contador de parametros k = 1;
 */
void accion_2_llamada_proc() {
	indexParametro = 0;
	// Si es una variable o funcion de un objeto, como hago un era de un obj de la direccion del objeto
	if ( metodo ) {
		int direccion = dirProcedimientos.buscaDireccion(objetoNombre);
		//cout << "Metodo nombre: " << metodoNombre  << " objetoNombre: " << objetoNombre << " metodo: " << metodo << endl;
		Cuadruplo cuadruploTemp = Cuadruplo("eraObj", to_string(direccion), "" , "");
		cuadruplos.push_back( cuadruploTemp );

		int tipoObjeto = dirProcedimientos.checaTipo(objetoNombre);
		int bloqueMetodo = dirProcedimientos.buscaBloque(dirProcedimientos.nombreTipo(tipoObjeto), metodoNombre);
		//cout << "tipo objeto: "<< tipoObjeto<< " nombre: " <<  dirProcedimientos.nombreTipo(tipoObjeto) <<  " objetoNombre: " << objetoNombre << endl; 
		cuadruploTemp = Cuadruplo("era", to_string(bloqueMetodo), "" , "");
		cuadruplos.push_back( cuadruploTemp );
	} else {
		objetoPadre = objetoNombre;
		/*
		// Este es un era normal de funcion
		objetoPadre = objetoNombre;
		int bloqueMetodo = dirProcedimientos.buscaBloque(objetoNombre);
		Cuadruplo cuadruploTemp = Cuadruplo("era", to_string(bloqueMetodo), "" , "");
		cuadruplos.push_back( cuadruploTemp );	
		*/
	}	
}

/**
 * Accion 3 llamada proc. Checar que cada argumento recibido concuerde con los parametros que espera la funcion dada.
 * Meter cada parametro a la fila de argumentos. 
 */
void accion_3_llamada_proc() {

	int tipo = pilaTipos.top();
	pilaTipos.pop();
	bool concuerdaTipo = dirProcedimientos.checaArgumentoTipo(tipo);
	if ( concuerdaTipo == false ) {
		cerr << "Wrong argument: on line " << line_num << endl;
		exit(-1);
	}
	int argument = pilaOperandos.top();
	pilaOperandos.pop();
	filaArgumentos.push(argument);	
}

/**
 * Accion 4 llamada proc. Aumenta el indexParametro en uno, pues encontro un parametro extra.
 */
void accion_4_llamada_proc() {
	indexParametro++;
}

/**
 * Accion 6 llamada proc. Generar accion era, parametros y gosub para una funcion al mismo tiempo.
 * @param nombreProc del procedimiento que invoca la funcion.
 */
void accion_6_llamada_proc(string nombreProc) {
	// Generar GOSUB , nombre proc, dir de inicio
	// solo hacer esto si es una funcion o objeto
	int estructura = dirProcedimientos.checaEstructura(nombreProc);

	if ( estructura != 0 ) {
		if ( metodo  ) { 
			int tipoObjeto = dirProcedimientos.checaTipo(objetoNombre);				
			int bloqueMetodo = dirProcedimientos.buscaBloque(dirProcedimientos.nombreTipo(tipoObjeto), metodoNombre);
			Cuadruplo cuadruploTemp = Cuadruplo("gosub", to_string(bloqueMetodo), to_string(cuadruplos.size()) , "");
			cuadruplos.push_back( cuadruploTemp );	
		} else {
			// Este es un era normal de funcion
			int bloqueMetodo = dirProcedimientos.buscaBloque(nombreProc);
			Cuadruplo cuadruploTemp = Cuadruplo("era", to_string(bloqueMetodo), "" , "");
			cuadruplos.push_back( cuadruploTemp );	
			int indexParametro = 0; 
			while ( !filaArgumentos.empty() ) {

				int argument = filaArgumentos.front();
				filaArgumentos.pop();
				cuadruploTemp = Cuadruplo("param", to_string(argument), to_string(indexParametro), "");
				cuadruplos.push_back( cuadruploTemp );
				indexParametro++;
			}
			int direccionVariable = dirProcedimientos.buscaDireccion(nombreProc);
			int tipoVariable = dirProcedimientos.checaTipo(nombreProc);
			/*
			pilaOperandos.push(direccionVariable);
			pilaTipos.push(tipoVariable);
			*/
			bloqueMetodo = dirProcedimientos.buscaBloque(nombreProc);
			cuadruploTemp = Cuadruplo("gosub", to_string(bloqueMetodo), to_string(cuadruplos.size()) , "");
			cuadruplos.push_back( cuadruploTemp );	
			int tipoObjeto = dirProcedimientos.checaTipo(nombreProc);				
			// Si tiene valor de retorno la funcion genera un temporal asignandole la direccion de la funcion
			if ( tipoObjeto < 4) {			
				int direccion_virtual = getSiguienteDireccion(tipoObjeto, 0, 0, 1, 0, 0);
				cuadruploTemp = Cuadruplo("=", to_string(direccionVariable), "" , to_string(direccion_virtual));
				cuadruplos.push_back( cuadruploTemp );	
				pilaOperandos.push(direccion_virtual);
				pilaTipos.push(tipoObjeto);
			}
		}
	}
}

/**
 * getIndexOperador utilizado para conseguir un index dependiendo del operador que recibe la funcion.
 * @param  operador a buscar el index
 * @return          entero representando el index de la funcion.
 */
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

/**
 * getSiguientedireccion. Metodo utilizado para conseguir la siguiente direccion virtual del programa y aumentar las direcciones del mismo.
 * @param  tipo      de la direccion a asignar
 * @param  constante booleano representando si es constante la variable o no
 * @param  global    booleano representando si es global
 * @param  temporal  booleano representando si es temporal
 * @param  objeto    booleano representando si es un objeto
 * @param  funcion   booleano representando si es una funcion
 * @return           direccion conseguida con la suma de los offset y los index.
 */
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

/**
 * getTipoVariable se utiliza para conocer el nombre de la variable dado un tipo como entero
 * @param  tipo entero, 0 bandera, 1 entero, 2 decimal 3 texto
 * @return      string con el nombre del tipo de variable.
 */
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

/**
 * getIndexTipoVariable. Metodo utilizado para conseguir el index de la variable dada el tipo como un string
 * @param  nombre del tipo de variable
 * @return        entero representando el indice de la variable. 
 */
int getIndexTipoVariable(string nombre ) { 
	if ( nombre == "bandera") return 0;
	else if (nombre == "entero") return 1;
	else if ( nombre == "decimal") return 2;
	else if (nombre == "texto" ) return 3;
	else return -1 ;
}

/**
 * printcuadruplos. Metodo utilizado para imprimir los cuadruplos al terminar el proceso de creacion de codigo intermedio. 
 */
void printCuadruplos() { 
	for (int i = 0; i < cuadruplos.size(); i++ ) {
		cout << i << setw(17) <<  cuadruplos[i].getOp() << setw(17) << cuadruplos[i].getIzq() << setw(17) << cuadruplos[i].getDer() << setw(17) << cuadruplos[i].getRes() << endl ;
	}
}

/**
 * rellenar. Metodo utilizado para rellenar un cuadruplo con un valor dado
 * @param fin  indice del cuadruplo a llenar
 * @param cont indice del cuadruplo que debe de aparecer en el cuadruplo a llenar
 */
void rellenar(int fin, int cont) {
	cuadruplos[fin].setRes(to_string(cont));
}

/**
 * to_string. metodo utilizado para convertir cualquier tipo de dato en string.
 * @param  value a convertir
 * @return       valor convertido a tipo string.
 */
template <typename T> string to_string(T value) {
  std::ostringstream os ;
  os << value ;
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
    if ( operador == "eraObj") { return _ERAOBJ; }
    if ( operador == "retornoObj") { return _RETURNOBJ; }
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
        case _TEMPORAL: 
                memoria.guardaDecimalTemp( dir - OFF_DEC_TEMP , valor );        
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

void eraPROC(Cuadruplo current){
    int bloque = atoi(current.getIzq().c_str());
    dirProcedimientos.era(bloque);
    bloqueglobal = bloque;
}
 
int gosubPROC(int i, Cuadruplo current){
	int bloque = atoi(current.getIzq().c_str());
	pilaSUB.push(i);
	return dirProcedimientos.dameCuadruplo(bloque);
}

int retornoPROC(){
    dirProcedimientos.retorno();
    int top = pilaSUB.top();
    pilaSUB.pop();
    return top;
}

void paramPROC(Cuadruplo current){
    int dirDer = atoi(current.getDer().c_str());//index
    int dirIzq = atoi(current.getIzq().c_str());//direccion
    int i = getTipoDireccion(dirIzq,getScope(dirIzq));
    int index = dirProcedimientos.direccionArgumento(bloqueglobal,dirDer);
    switch (i){
      case 0:
        memoria.guardaBanderaLoc(memoria.pideDirBanderaFunc(index - OFF_BAND_DIR_FUNCION),pideBandera(dirIzq));
        break;
      case 1: 
        memoria.guardaEnteroLoc(memoria.pideDirEnteroFunc(index - OFF_ENT_DIR_FUNCION),pideEntero(dirIzq));
        break;
      case 2:
        memoria.guardaDecimalLoc(memoria.pideDirDecimalFunc(index - OFF_DEC_DIR_FUNCION),pideDecimal(dirIzq));
        break;
      case 3:
        memoria.guardaTextoLoc(memoria.pideDirTextoFunc(index - OFF_TEXT_DIR_FUNCION),pideTexto(dirIzq));
        break;
      default:
        break;	
    }
}

void eraObj(Cuadruplo current){//izquerda direccion de objeto, derecha bloque del objeto
    int dirDer = atoi(current.getDer().c_str());
    int dirIzq = atoi(current.getIzq().c_str());
    dirProcedimientos.eraBloques(dirIzq);
    dirProcedimientos.subsDireccionesObj(dirDer);
}

void returnObj(){
    dirProcedimientos.retornoBloques();
}

/**
 *  solve
 *  Metodo utilizado como si fuera la virtual machine. 
 */
void solve() {

    for(int i  = 0; i < cuadruplos.size(); i++){
        Cuadruplo current = cuadruplos[i];

        //
        //cout << "Current: " << current.getOp() << " getOpIndex: " <<  getOperandoIndex(current.getOp() ) <<  " Valor de i: " << i << endl;
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
			case _GOTO    : i = atoi(current.getRes().c_str()) - 1  ;  break;// -1 para equilibrar el i++
			case _GOTOF   : i = indexGOTOF(i,current);   break;
			case _GOTOT   : i = indexGOTOT(i,current);  break;
			case _ERA 	  : eraPROC(current); break;
		    case _GSUB 	  : i = gosubPROC(i,current)-1; break;
		    case _RETURN  : i = retornoPROC(); break;
		    case _PARAM   : paramPROC(current); break;
		 	case _ERAOBJ : eraObj(current); break;
			case _RETURNOBJ : returnObj(); break;
        }        
        //cout << "Despues Valor de i: " << i << endl;
    }
}