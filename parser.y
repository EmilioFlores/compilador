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

 
struct constante
{
	int direccion;
	int tipo;
	string valor;
};
void yyerror(const char *s);
void printCuboSemantico();
void accion_1(string yytext, int tipo);
void accion_2(string operador);
void accion_3(string operador);
void accion_4();
void accion_5();
void accion_6(string fondoFalso);
void accion_7();
void accion_8(string operador);
void accion_9();
int getIndexOperador(string operador);


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

Objeto 				: OBJETOSYM  IDENTIFICADOR { objetoNombre = yytext;} LCURLY AtributosPrivados AtributosPublicos RCURLY SEMICOLON ;

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

FuncionObjeto		: FUNCIONSYM  Tipo IDENTIFICADOR ParamsObjeto BloqueFuncion SEMICOLON FuncionObjeto
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

ParamObjeto 		: Tipo IDENTIFICADOR  ParamObjeto1 
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

Asignacion 			: IDENTIFICADOR EQL Expresion  ;



Expresion			: Exp Expresion1 ;
Expresion1 			: Expresion2 Exp { accion_9(); }
					| epsilon ;

Expresion2 			: LSS { accion_8(yytext); }
					| GTR { accion_8(yytext); }
					| EQLEQL { accion_8(yytext); }
					| NEQ { accion_8(yytext); } ;

Exp 				: Termino { accion_4(); }	Exp1 ;
Exp1				: PLUS {
								accion_2(yytext);
								
						   } Exp 
					| MINUS {
								accion_2(yytext);
						   } Exp
					| epsilon	;

Termino				: Factor { accion_5(); } Termino1	;
Termino1			: TIMES {
								accion_3(yytext);
						   } Termino
					| SLASH {
								accion_3(yytext);
						   } Termino
					| epsilon	;

Factor				: LPAREN { accion_6("("); } Expresion { accion_7(); }  RPAREN
					| Factor1 VarCteExp 
Factor1 			: PLUS
					| MINUS
					| epsilon	;



VarCteExp			:	IDENTIFICADOR { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										// si es 4, entonces es un identificador

										accion_1(yytext, 4);
									 };
					|	ENTERO { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1(yytext, 1);
								};
					|	BANDERA { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1(yytext, 0);
									};
					|	TEXTO   { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1(yytext, 3);
									};
					|	DECIMAL { 
										// 1. Meter a pilaO (direccion de variable) y meter a PTipos el tipo de variable
										accion_1(yytext, 2);

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
									dirProcedimientos.crearVariable(yyTipo, $4, 1, 1000 );  
								   }  ;
VariableObjeto		: VARSYM  Tipo { yyTipo = yytext } IDENTIFICADOR   {  
									//TODO Hace funcion que me regrese la direccion. 
									dirProcedimientos.crearVariable(yyTipo, $4, 0, 1000 );  
								   }  ; ;
//Variable2			: COMMA IDENTIFICADOR Variable2
//					| epsilon ;


Condicion			: CONDICIONSYM LPAREN Expresion RPAREN Bloque Condicion1 
Condicion1			: FALLOSYM Bloque | epsilon ;



Ciclo				: CICLOSYM LPAREN Ciclo1 COMMA Expresion COMMA Ciclo1 RPAREN Bloque  ; 
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

void accion_1(string yytext, int tipo){
	cout << "accion_1 Empieza >>> " << yytext <<  " <<< " <<  endl;
	// Si no era una variable registrada y es constante
	if ( tipo != 4 ) {
		// crea variable constante en el scope
		cout << "accion_1 If antes >>> " << yytext <<  " <<< " <<  endl;
		constante constante; 
		
		cout << "accion_1 If despues >>> " << yytext <<  " <<< " <<  endl;
		switch (tipo) {
			case 0: // bandera

				constante.direccion = offsetBanderaConstante + idnexBanderaConstantes++;
				constante.tipo = tipo;
				constante.valor = yytext;

			break;
			case 1: // entero
				constante.direccion = offsetEnteroConstante + indexEnteroConstantes++;
				constante.tipo = tipo;
				constante.valor = yytext;
			break;
			case 2: // decimal
				constante.direccion = offsetDecimalConstante + indexDecimalConstantes++;
				constante.tipo = tipo;
				constante.valor = yytext;

			break;
			case 3: // texto
				constante.direccion = offsetTextoConstante + indexTextoConstantes++;
				constante.tipo = tipo;
				constante.valor = yytext;

			break;
		}
		

		cout << "accion_1 If  switch 1 >>> " << yytext <<  " <<< " <<  endl;
		constantes.push_back(constante);			
		cout << "accion_1 If  switch 2 >>> " << yytext <<  " <<< " <<  endl;
		pilaOperandos.push(constante.direccion);
		cout << "accion_1 If  switch 3 >>> " << yytext <<  " <<< " <<  endl;
		pilaTipos.push(constante.tipo);
		cout << "accion_1 If  switch 4 >>> " << yytext <<  " <<< " <<  endl;
		
		
	}
	else {

		cout << "accion_1 Else >>> " << yytext <<  " <<< " <<  endl;
		// la variable ya estaba registrada
		int direccionVariable = dirProcedimientos.buscaDireccion(yytext);
		if (direccionVariable != -1 ) {

			
			int tipoVariable = dirProcedimientos.buscaTipo(yytext);

			//0 bandera, 1 entero, 2 decimal, 3 texto
			if (tipoVariable < 4) {

				pilaOperandos.push(direccionVariable);
				pilaTipos.push(tipo);

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
	cout << "accion_1 Termina >>> " << yytext <<  " <<< " <<  endl;
}

void accion_2(string operador){
	cout << "accion_2 Empieza operador >>> " << operador <<  " <<< " <<  endl;
	pilaOperadores.push(operador);
	cout << "accion_2 Termina operador >>> " << operador <<  " <<< " <<  endl;
}

void accion_3(string operador){
	
	cout << "accion_3 Empieza operador >>> " << operador <<  " <<< " <<  endl;
	pilaOperadores.push(operador);
	cout << "accion_3 Termina operador >>> " << operador <<  " <<< " <<  endl;
}

void accion_4() {
	// Si top de pOperadores = + or -

	cout << "accion_4 Empieza  >>>  <<< " <<  endl;
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
				int resultado = indexTemporales++;
				
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
}


void accion_5() {
	// Si top de pOperadores = * or /
	cout << "accion_5 Empieza  >>> "<< pilaOperadores.size() <<  " <<< " <<  endl;
	if ( pilaOperadores.size() != 0 ) {
		if ( pilaOperadores.top() == "/" || pilaOperadores.top() == "*") {

			cout << "accion_5 If 1  >>>  <<< " <<  endl;
			int tipoDer = -1, tipoIzq = -1;
			int tipoResultado = -1, tipoOperador;
			tipoDer = pilaTipos.top();
			pilaTipos.pop();

			tipoIzq = pilaTipos.top();
			pilaTipos.pop();

			cout << "accion_5 If 2  >>>  <<< " <<  endl;
			//Checa si son permitidas las operaciones
			string operador = pilaOperadores.top();
			pilaOperadores.pop();

			cout << "accion_5 If 3  >>>  <<< " <<  endl;
			tipoOperador  = getIndexOperador(operador);
			cout << "accion_5 If 4  >>>  <<< " <<  endl;
			tipoResultado = cuboSemantico[tipoIzq][tipoDer][tipoOperador];
			cout << "accion_5 If 5  >>>  <<< " <<  endl;

			if (tipoResultado != -1 ) {


				int der, izq;

				der = pilaOperandos.top();
				pilaOperandos.pop();

				izq = pilaOperandos.top();
				pilaOperandos.pop();

				// Aumenta los temporales en 1
				int resultado = indexTemporales++;
				
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
}

void accion_6(string fondoFalso){
	cout << "accion_6 Empieza  >>>  <<< " <<  endl;
	pilaOperadores.push(fondoFalso);
}
void accion_7(){
	
	cout << "accion_7 Empieza  >>>  <<< " <<  endl;
	pilaOperadores.pop();

}
void accion_8(string operador){
	cout << "accion_8 Empieza  >>>  <<< " <<  endl;
	
	pilaOperadores.push(operador);
}

void accion_9(){
	cout << "accion_9 Empieza  >>>  <<< " <<  endl;
	
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
				int resultado = indexTemporales++;
				
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