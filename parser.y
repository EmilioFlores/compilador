%{
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
void accion_1_assignacion(int dirOperando, int tipoVariable);
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

// estatuto print
void accion_1_print();

// estatuto read
void accion_1_read(string yytext);

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

void resetOffsetIndexes(bool local);
int getIndexOperador(string operador);
int getSiguienteDireccion(string tipo, bool constante, bool local);
template <typename T> string to_string(T value);


dirProcedimientos dirProcedimientos ;
string yyTipo = "";
string objetoNombre = "default";
string metodoNombre = "";
string funcionNombre = "";


int offsetEnteroGlobal     		 	= 1000;
int offsetEnteroConstanteGlobal  	= 1900;
int offsetDecimalGlobal    		 	= 2000;
int offsetDecimalConstanteGlobal 	= 2900;
int offsetBanderaGlobal    		 	= 3000;
int offsetBanderaConstanteGlobal 	= 3900;
int offsetTextoGlobal      		 	= 4000;
int offsetTextoConstanteGlobal   	= 4900;
int offsetTemporalesGlobal 		 	= 5000;
int offsetTemporalesConstanteGlobal = 5900;
int offsetVacioGlobal 				= 6000;
int offsetVacioConstanteGlobal 		= 6900;

int offsetEnteroLocal     			= 7000;
int offsetEnteroConstanteLocal 		= 7900;
int offsetDecimalLocal    			= 8000;
int offsetDecimalConstanteLocal 	= 8900;
int offsetBanderaLocal    			= 9000;
int offsetBanderaConstanteLocal 	= 9900;
int offsetTextoLocal      			= 10000;
int offsetTextoConstanteLocal 		= 10900;
int offsetTemporalesLocal 			= 11000;
int offsetTemporalesConstanteLocal 	= 11900;
int offsetVacioLocal 				= 12000;
int offsetVacioConstanteLocal 		= 12900;



int indexEnterosGlobal      			= 0;
int indexDecimalGlobal      			= 0;
int idnexBanderaGlobal      			= 0;
int indexTextoGlobal        			= 0;
int indexTemporalesGlobal   			= 0;
int indexVacioGlobal  					= 0;
int indexEnteroConstantesGlobal      	= 0;
int indexDecimalConstantesGlobal      	= 0;
int idnexBanderaConstantesGlobal      	= 0;
int indexTextoConstantesGlobal        	= 0;
int indexTemporalesConstantesGlobal   	= 0;
int indexVacioConstantesGlobal   	  	= 0;

int indexEnterosLocal       			= 0;
int indexDecimalLocal       			= 0;
int idnexBanderaLocal       			= 0;
int indexTextoLocal         			= 0;
int indexTemporalesLocal    			= 0;
int indexVacioLocal   					= 0;
int indexEnteroConstantesLocal       	= 0;
int indexDecimalConstantesLocal       	= 0;
int idnexBanderaConstantesLocal       	= 0;
int indexTextoConstantesLocal         	= 0;
int indexTemporalesConstantesLocal    	= 0;
int indexVacioConstantesLocal    	  	= 0;

int indexParametro = 0;

bool metodo = false;
bool local = false;
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
						resetOffsetIndexes(local);
						dirProcedimientos.terminaBloque();
					} ;

AtributosPrivados	: PRIVADOSYM LCURLY { local = true; } VariablesObjetos Funciones  { local = false; } RCURLY
					|  epsilon ;

AtributosPublicos	: PUBLICOSYM LCURLY { local = true; } Variables FuncionesObjetos { local = false; } RCURLY 
					|  epsilon ;



Librerias 			: Libreria Libreria1 ;
Libreria  			: INCLUIRSYM LSS IDENTIFICADOR GTR  ;
Libreria1			: Libreria | ;




Funciones 			: Funcion ;
FuncionesObjetos	: FuncionObjeto ;

Funcion  			: FUNCIONSYM  Tipo { yyTipo = yytext } IDENTIFICADOR {
						funcionNombre = $4;
						accion_1_definicion_proc(yyTipo, $4);
					 	local = true; 
					} Params BloqueFuncion SEMICOLON {
						
						resetOffsetIndexes(local);
						local = false; 
					  	dirProcedimientos.terminaBloque();
					} Funcion
					| epsilon ;

FuncionObjeto		: FUNCIONSYM  Tipo { yyTipo = yytext } IDENTIFICADOR {
						funcionNombre = $4;
						//dirProcedimientos.crearMetodo(yyTipo, $4);
						accion_1_definicion_proc(yyTipo, $4);
						local = true; 

					} ParamsObjeto BloqueFuncion SEMICOLON {
					  resetOffsetIndexes(local);
					  local = false; 
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
						int direccion_virtual = getSiguienteDireccion(yyTipo, 0, local);

						accion_2_definicion_proc(yyTipo, $3, direccion_virtual);
					} Param1 
					| epsilon ;
Param1				: COMMA Param 
					| epsilon ;

ParamObjeto 		: Tipo { yyTipo = yytext } IDENTIFICADOR {
						int direccion_virtual = getSiguienteDireccion(yyTipo, 0, local);
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
					| Factor1 VarCteExp 
Factor1 			: PLUS
					| MINUS
					| epsilon	;



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
									if (debug ) {
									}
									// Si la variable era local o global 
									int direccion;
									
									direccion = getSiguienteDireccion(yyTipo, 0,  local);

									
									cout << "Crear variable Tipo: " << yyTipo << " Nombre: " << $4 << " Direccion: " <<   direccion << " Local: " << local   << endl;
									
									dirProcedimientos.crearVariable(yyTipo, $4, 1, direccion );

								   }  ;
VariableObjeto		: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR   {  
									//TODO Hace funcion que me regrese la direccion. 
									if (debug ) {
										cout << "Crear Objeto Tipo: " << yyTipo << " Nombre: " << $4 << endl;
									}

									dirProcedimientos.crearVariable(yyTipo, $4, 0, getSiguienteDireccion(yyTipo, 0, local));  
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

				constante.direccion = getSiguienteDireccion("bandera", 1, local);
				constante.tipo = 0;
				constante.valor = yytext;

			break;
			case 1: // entero
				constante.direccion = getSiguienteDireccion("entero", 1, local);
				constante.tipo = 1;
				constante.valor = yytext;
			break;
			case 2: // decimal
				constante.direccion = getSiguienteDireccion("decimal", 1, local);
				constante.tipo = 2;
				constante.valor = yytext;

			break;
			case 3: // texto
				constante.direccion = getSiguienteDireccion("texto", 1, local);
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
				int resultado = getSiguienteDireccion("temporal",0,local);
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);
				

			}	
			else {
				cerr << "Tipos incompatibles en la linea: " << line_num <<  endl;
				exit(-1);
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
				int resultado = getSiguienteDireccion("temporal", 0, local);
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);
				

			}	
			else {
				cerr << "Tipos incompatibles en la linea " << line_num << endl
;				exit(-1);
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
				int resultado = getSiguienteDireccion("temporal", 0, local);
				
				Cuadruplo cuadruploTemp = Cuadruplo(operador, to_string(izq), to_string(der), to_string(resultado));
				cuadruplos.push_back( cuadruploTemp );

				pilaOperandos.push(resultado);

				pilaTipos.push(tipoResultado);

			}	
			else {
				cerr << "Tipos incompatibles en la linea: " << line_num << endl;
				exit(-1);
			}	

		}
	}
	if (debug ) {
		cout << "accion_9_expresiones Termina   " << line_num <<  endl;
	}
}


void accion_1_assignacion(int dirOperando, int tipoVariable){
	//Meter id en PilaO
	if (debug ) {
		cout << "accion_1_assignacion Empieza" <<  endl;
	}

	pilaTipos.push(tipoVariable);
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

void accion_1_print() {
	


	if ( debug ) {
		cout << "accion_1_print Empieza" << endl;
	}

	int res = pilaOperandos.top();
	pilaOperandos.pop();

	Cuadruplo cuadruploTemp = Cuadruplo("print", "", "" , to_string(res));
	cuadruplos.push_back( cuadruploTemp );	

	if ( debug ) {
		cout << "accion_1_print Termina" << endl;
	}
}


void accion_1_read(string nombre) { 

	if ( debug ) {
		cout << "accion_1_read Empieza" << endl;
	}

	int variableIndex = dirProcedimientos.buscaVariable(nombre);

   if (variableIndex == -1 ) { 
		cerr << "ERROR: Variable not found:  \"" << nombre;
		cerr << "\" on line " << line_num << endl;
		exit(-1);
	}


	Cuadruplo cuadruploTemp = Cuadruplo("read", "", "" , nombre );
	cuadruplos.push_back( cuadruploTemp );	

	if ( debug ) {
		cout << "accion_1_read Termina" << endl;
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

	pilaTipos.pop();

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
	int direccion = getSiguienteDireccion(yyTipo, 0, local);
	//cout << "Crear metodo " << nombre << " Direccion: " << direccion << " Tipo: " << yyTipo <<  endl;
	dirProcedimientos.crearMetodo(tipo, nombre,direccion);
	cout << "Crear variable Tipo: " << yyTipo << " Nombre: " << nombre << " Direccion: " <<   direccion   << endl;

	if ( debug ) {
		cout << "accion_1_definicion_proc Termina" << endl;
	}
}

void accion_2_definicion_proc(string tipo, string nombre, int direccion) {
	// Ligar cada parametro a la tabla de parametros del dir de procs
	
	

	if ( debug ) {
		cout << "accion_2_definicion_proc Empieza" << endl;
	}
	//cout << "Crear parametro " << nombre << " Direccion: " << direccion << endl;
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
	int estructuraVariable = dirProcedimientos.checaEstructura(objetoNombre);
		
	// 1 = funciones, 0 = variable, 2 = objeto
	if (existePredicado == false && estructuraVariable != 1) { 
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
	
	bool completezPredicado = dirProcedimientos.checaCompletezPred(true);

	if ( completezPredicado == false ) {


		cerr << "Faltan parametros en linea " << line_num << endl;
		exit(-1);

	
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
	int tipoVariable = dirProcedimientos.checaTipo(nombreProc);
	
	int estructura = dirProcedimientos.checaEstructura(nombreProc);

	// solo hacer esto si es una funcion o objeto
	if ( estructura != 0 ) {

		pilaOperandos.push(direccionVariable);
		pilaTipos.push(tipoVariable);



		Cuadruplo cuadruploTemp = Cuadruplo("gosub", nombreProc, to_string(cuadruplos.size()) , "");
		cuadruplos.push_back( cuadruploTemp );	
	}
	

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

int getSiguienteDireccion(string tipo, bool constante, bool local) {

	if ( local ) {

		if ( !constante ) {

			if (tipo == "entero") {
				return offsetEnteroLocal + indexEnterosLocal++;

			} else if ( tipo == "decimal") {
				return offsetDecimalLocal + indexDecimalLocal++;

			} else if ( tipo == "texto") {
				return offsetTextoLocal + indexTextoLocal++;

			} else if ( tipo == "bandera") {
				return offsetBanderaLocal + idnexBanderaLocal++;
				
			} else if ( tipo == "temporal") {
				return offsetTemporalesLocal + indexTemporalesLocal++;

			} else if ( tipo == "vacio") {
				return offsetVacioLocal + indexVacioLocal++;

			}
		}
		else {
			
			if (tipo == "entero") {
				return offsetEnteroConstanteLocal + indexEnteroConstantesLocal++;

			} else if ( tipo == "decimal") {
				return offsetDecimalConstanteLocal + indexDecimalConstantesLocal++;

			} else if ( tipo == "texto") {
				return offsetTextoConstanteLocal + indexTextoConstantesLocal++;

			} else if ( tipo == "bandera") {
				return offsetBanderaConstanteLocal + idnexBanderaConstantesLocal++;
				
			} else if ( tipo == "temporal") {
				return offsetTemporalesConstanteLocal + indexTemporalesConstantesLocal++;

			} else if ( tipo == "vacio") {
				return offsetVacioConstanteLocal + indexVacioConstantesLocal++;

			}	
		}
	} else {
		if ( !constante ) {

			if (tipo == "entero") {
				return offsetEnteroGlobal + indexEnterosGlobal++;

			} else if ( tipo == "decimal") {
				return offsetDecimalGlobal + indexDecimalGlobal++;

			} else if ( tipo == "texto") {
				return offsetTextoGlobal + indexTextoGlobal++;

			} else if ( tipo == "bandera") {
				return offsetBanderaGlobal + idnexBanderaGlobal++;
				
			} else if ( tipo == "temporal") {
				return offsetTemporalesGlobal + indexTemporalesGlobal++;

			} else if ( tipo == "vacio") {
				return offsetVacioGlobal + indexVacioGlobal++;

			}
		}
		else {
			if (tipo == "entero") {
				return offsetEnteroConstanteGlobal + indexEnteroConstantesGlobal++;

			} else if ( tipo == "decimal") {
				return offsetDecimalConstanteGlobal + indexDecimalConstantesGlobal++;

			} else if ( tipo == "texto") {
				return offsetTextoConstanteGlobal + indexTextoConstantesGlobal++;

			} else if ( tipo == "bandera") {
				return offsetBanderaConstanteGlobal + idnexBanderaConstantesGlobal++;
				
			} else if ( tipo == "temporal") {
				return offsetTemporalesConstanteGlobal + indexTemporalesConstantesGlobal++;

			} else if ( tipo == "vacio") {
				return offsetVacioConstanteGlobal + indexVacioConstantesGlobal++;

			}	
		}
	}
	return 0;

}

void resetOffsetIndexes(bool local) {
	if ( local ) {
		indexEnterosLocal       			= 0;
		indexDecimalLocal       			= 0;
		idnexBanderaLocal       			= 0;
		indexTextoLocal         			= 0;
		indexTemporalesLocal    			= 0;
		indexVacioLocal   					= 0;
		indexEnteroConstantesLocal       	= 0;
		indexDecimalConstantesLocal       	= 0;
		idnexBanderaConstantesLocal       	= 0;
		indexTextoConstantesLocal         	= 0;
		indexTemporalesConstantesLocal    	= 0;
		indexVacioConstantesLocal    	  	= 0;

	} else {

		indexEnterosGlobal      			= 0;
		indexDecimalGlobal      			= 0;
		idnexBanderaGlobal      			= 0;
		indexTextoGlobal        			= 0;
		indexTemporalesGlobal   			= 0;
		indexVacioGlobal  					= 0;
		indexEnteroConstantesGlobal      	= 0;
		indexDecimalConstantesGlobal      	= 0;
		idnexBanderaConstantesGlobal      	= 0;
		indexTextoConstantesGlobal        	= 0;
		indexTemporalesConstantesGlobal   	= 0;
		indexVacioConstantesGlobal   	  	= 0;
	}
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

