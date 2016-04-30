
#include <math.h> 

// GLOBAL
#define OFF_BAND_GLOBAL 0
#define OFF_ENT_GLOBAL 1000
#define OFF_DEC_GLOBAL 2000
#define OFF_TEXT_GLOBAL 3000
// TEMPORAL
#define OFF_BAND_TEMP 4000
#define OFF_ENT_TEMP 5000
#define OFF_DEC_TEMP 6000
#define OFF_TEXT_TEMP 7000
// CONSTANTE
#define OFF_BAND_CONST 8000
#define OFF_ENT_CONST 9000
#define OFF_DEC_CONST 10000
#define OFF_TEXT_CONST 11000
// OBJETO
#define OFF_BAND_DIR_OBJ 12000
#define OFF_ENT_DIR_OBJ 13000
#define OFF_DEC_DIR_OBJ 14000
#define OFF_TEXT_DIR_OBJ 15000
// FUNCION
#define OFF_BAND_DIR_FUNCION 16000
#define OFF_ENT_DIR_FUNCION 17000
#define OFF_DEC_DIR_FUNCION 18000
#define OFF_TEXT_DIR_FUNCION 19000

#define OFF_LOWER_LIMIT 0
#define OFF_UPPER_LIMIT 20000


#define GLOBAL     0
#define TEMPORAL   1
#define CONSTANTE  2
#define FUNCION    3
#define OBJETO     4
#define ERROR      5


#define BANDERA 0
#define ENTERO  1
#define DECIMAL 2
#define TEXTO   3

#define GOTOT gotoT
#define GOTOF gotoF
#define GOTO  goto
#define ERA   era
#define GSUB  gosub
#define RETURN return  
#define PARAM param  
#define VER   ver  
#define END   end  

/** 
	getScope
	Funcion que apartir de una direccion regresa el scope en el que se encuentra
	@param dir direccion a buscar
	@return el scope en el que se encuentra la direccion.
**/
int getScope(int dir){

	if(dir >= OFF_LOWER_LIMIT && dir < OFF_BAND_TEMP){
		return GLOBAL;
	}else if(dir >= OFF_BAND_TEMP && dir < OFF_BAND_CONST){
		return TEMPORAL;
	}else if(dir >= OFF_BAND_CONST && dir < OFF_BAND_DIR_OBJ){
		return CONSTANTE;
	}else if(dir >= OFF_BAND_DIR_OBJ && dir <= OFF_BAND_DIR_FUNCION){
		return FUNCION;
	}else if(dir >= OFF_BAND_DIR_FUNCION && dir <= OFF_UPPER_LIMIT){
		return OBJETO;
	}else {
		return ERROR;
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
		case GLOBAL:
				tipoDireccion = floor( ( OFF_BAND_GLOBAL - dir )/ 1000 ) ; 
		break;
		case TEMPORAL; 
				tipoDireccion = floor( ( OFF_BAND_TEMP - dir )/ 1000 ) ;
		break;
		case CONSTANTE; 
				tipoDireccion = floor( ( OFF_BAND_CONST - dir )/ 1000 ) ; 
		break;
		case FUNCION; 
				tipoDireccion = floor( ( OFF_BAND_DIR_OBJ - dir )/ 1000 ) ; 

		break;
		case OBJETO; 
				tipoDireccion = floor( ( OFF_BAND_DIR_FUNCION - dir )/ 1000 ) ; 
		break;

	}
	return tipoDireccion; 

}









void solve() {




	for(int i  = 0; i < cuadruplos.size(); i++){
		Cuadruplo current = cuadruplos[i];
		/*
				
		string op;
		string der;
		string izq;
		string res;

		*/
		switch (current.getOp()) {
			//  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
			case PLUS    : plus(current);   break; // Funcion que hace la suma
			case MINUS   : minus();  break; //Funcion que hace la resta
			case TIMES   : times();  break; //Funcion que hace la multiplicacion
			case SLASH   : slash();  break; //Funcion que hace la division
			case EQLEQL  : equal_equal(); break; //Funcion que hace la comparacion positiva
			case NEQ 	 : not_equal();    break; //Funcion que hace la comparacion negativa
			case GTR 	 : greater_than();    break; //Funcion que hace >
			case LSS 	 : less_than();    break; //Funcion que hace <
			case EQL 	 : equals(); break;    //Funcion que hace la asignacion
			case GTROEQL : greater_equal(); break; //Funcion que hace la logica de >=
			case LSSOEQL : less_equal(); break; //Funcion que hace la logica de <=
			case OR 	 : or(); break; //Funcion que hace la comparacion logica OR
			case AND 	 : and(); break; //Funcion que hace la comparacion logica AND
			case LEESYM  : read(); break; //Funcion que hace la lectura
			case MUESTRASYM : write(); break; //funcion que hace la escritura
			case GOTOT : goto_true(); break; // funcion que hace el goto cuando es true
			case GOTOF : goto_false(); break; //funcion que hace el salto cuando es false
			case GOTO  : goto(); break; // funcion que hace el salto 
			case ERA :   era(); break; //Funcion que se encarga de preparar la funcion
			case GSUB :  go_sub(); break; //Funcion que hace la ejecucion de la funcion
			case RETURN : end_method(); break; //funcion que hace el final de la funcion
			case PARAM : parameter(); break; //Asocia un parametro a la funcion
			case VER :   verify_limits(); break; // Verifica los limites del arreglo
			case END:    exit(0); //Termina el programa
			default: 	exit(-1);
			break;
		}
	}


}

void plus (cuadruplo current) {


	//TODO checkTemporal, local, objeto global
		//TODO check INT , Double 

	int scopeIzq = getScope(current.getIzq()); 
	int scopeDer = getScope(current.getDer()); 

	int tipoIzq = getTipoDireccion(current.getIzq(), scopeIzq);
	int tipoDer = getTipoDireccion(current.getDer(), scopeDer);

}