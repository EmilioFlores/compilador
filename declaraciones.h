#include "estructuras.h"
#include "memoria.h"
#include "trie.h"
#include "dirProcedimientos.h"

extern string yyTipo;
extern string objetoNombre ;
extern string metodoNombre ;
extern string funcionNombre ;


extern int offsetGlobales[4] ;
extern int offsetTemporales[4] ;
extern int offsetConstantes[4] ;
extern int offsetDirObjetos[4] ;
extern int offsetDirFunciones[4] ;

extern int indexGlobales[4] ;
extern int indexTemporales[4] ;
extern int indexConstantes[4] ;
extern int indexDirObjetos[4] ;
extern int indexDirFunciones[4] ;



extern int indexParametro ;

extern bool metodo ;
extern bool global ;
extern bool objeto ;
extern bool temporal ;
extern bool funcion ;

extern stack<int> pilaOperandos;
extern stack<string> pilaOperadores;
extern stack<int> pilaTipos;
extern stack<int> pilaSaltos;


extern vector<Cuadruplo> cuadruplos; 
extern vector<constante> constantes;

extern int cuboSemantico[4][4][13];


extern int line_num;

 
extern bool debug;

extern Memoria memoria; 

extern dirProcedimientos dirProcedimientos ;