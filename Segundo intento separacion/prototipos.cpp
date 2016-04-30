
#include "prototipos.h"



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

			break;
			case 1: // entero
				constante.direccion = getSiguienteDireccion(tipo, 1, global, temporal, objeto, funcion);
				constante.tipo = 1;
				constante.valor = yytext;
			break;
			case 2: // decimal
				constante.direccion = getSiguienteDireccion(tipo, 1, global, temporal, objeto, funcion);
				constante.tipo = 2;
				constante.valor = yytext;

			break;
			case 3: // texto
				constante.direccion = getSiguienteDireccion(tipo, 1, global, temporal, objeto, funcion);
				constante.tipo = 3;
				constante.valor = yytext;

			break;
		}
		global = true;
		
		constantes.push_back(constante);			
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

	Cuadruplo cuadruploTemp = Cuadruplo("print", "", "" , to_string(res));
	cuadruplos.push_back( cuadruploTemp );	

	
}


void accion_1_read(string nombre) { 


	int variableIndex = dirProcedimientos.buscaVariable(nombre);

   if (variableIndex == -1 ) { 
		cerr << "ERROR: Variable not found:  \"" << nombre;
		cerr << "\" on line " << line_num << endl;
		exit(-1);
	}


	Cuadruplo cuadruploTemp = Cuadruplo("read", "", "" , nombre );
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

	int retorno = pilaSaltos.top();
	pilaSaltos.pop();
	
	Cuadruplo cuadruploTemp = Cuadruplo("goto", "", "", to_string(retorno));
	cuadruplos.push_back( cuadruploTemp );

	rellenar(falso, cuadruplos.size()  );


	
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
	

	Cuadruplo cuadruploTemp = Cuadruplo("gotoF", to_string(resultado), "", to_string(retorno));
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
	Cuadruplo cuadruploTemp = Cuadruplo("era", metodoNombre, "" , "");
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
		return _FUNCION;
	}else if(dir >= OFF_BAND_DIR_FUNCION && dir <= OFF_UPPER_LIMIT){
		return _OBJETO;
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
                
                tipoDireccion = floor( ( dir - OFF_BAND_DIR_OBJ  )/ 1000 ) ; 
                

        break;
        case _OBJETO:

                tipoDireccion = floor( ( dir - OFF_BAND_DIR_FUNCION  )/ 1000 ) ; 
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
    if ( operador == "gotof") { return _GOTOF; }
    if ( operador == "gotot") { return _GOTOT; }
    if ( operador == "goto") { return _GOTO; }
    if ( operador == "era") { return _ERA; }
    if ( operador == "gosub") { return _GSUB; }
    if ( operador == "retorno") { return _RETURN; }
    if ( operador == "param") { return _PARAM; }
    if ( operador == "ver") { return _VER; }
    if ( operador == "end") { return _END; }
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
                valor =  memoria.pideEntero( dir - OFF_ENT_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideEntero( dir - OFF_ENT_CONST );
        break;
        case _FUNCION:
                
                valor =  memoria.pideEnteroLoc(  memoria.pideDirEnteroFunc( dir - OFF_ENT_DIR_FUNCION ));
        break;
        case _OBJETO:

                valor =  memoria.pideEnteroObj(  memoria.pideDirEnteroObj( dir - OFF_ENT_DIR_OBJ ));
                
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
                valor =  memoria.pideBandera( dir - OFF_BAND_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideBandera( dir - OFF_BAND_CONST );
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
                valor =  memoria.pideTexto( dir - OFF_TEXT_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideTexto( dir - OFF_TEXT_CONST );
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
                valor =  memoria.pideDecimal( dir - OFF_DEC_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideDecimal( dir - OFF_DEC_CONST );
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
                memoria.guardaEntero( dir - OFF_ENT_TEMP , valor );
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
                memoria.guardaBandera( dir - OFF_BAND_TEMP , valor );
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
                memoria.guardaDecimal( dir - OFF_DEC_TEMP , valor );
        break;
        case _CONSTANTE: 
                memoria.guardaDecimal( dir - OFF_DEC_CONST , valor ); 
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
                memoria.guardaTexto( dir - OFF_TEXT_TEMP , valor );
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
    }
    if (i+d==4){
          dRes = pideDecimal(dirIzq) + pideDecimal(dirDer);
      }
        if (i=2){
            dRes = pideDecimal(dirIzq) + pideEntero(dirDer);
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
    }
    if (i+d==4){
        dRes = pideDecimal(dirIzq) - pideDecimal(dirDer);
    }
    if (i=2){
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
    }
    if (i+d==4){
        dRes = pideDecimal(dirIzq) * pideDecimal(dirDer);
    }
    if (i=2){
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
        iRes = pideEntero(dirIzq) / pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;
    }
    if (i+d==4){
        dRes = pideDecimal(dirIzq) / pideDecimal(dirDer);
    }
    if (i=2){
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
    }
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) == pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) == pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) == pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) == pideEntero(dirDer));
    }
    if (i + d == 4){
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
    }
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) != pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) != pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) != pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) != pideEntero(dirDer));
    }
    if (i + d == 4){
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
        if (i=2){
            bRes = (pideDecimal(dirIzq) > pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) > pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) > pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) > pideEntero(dirDer));
    }
    if (i + d == 4){
        bRes=(pideDecimal(dirIzq) > pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * less_op
 * Funcion utilizada para llevar a cabo la operacion logica de < de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void less_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) < pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) < pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) < pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) < pideEntero(dirDer));
    }
    if (i + d == 4){
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
        if (i=2){
            bRes = (pideDecimal(dirIzq) >= pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) >= pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) >= pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) >= pideEntero(dirDer));
    }
    if (i + d == 4){
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
        if (i=2){
            bRes = (pideDecimal(dirIzq) <= pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) <= pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) <= pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) <= pideEntero(dirDer));
    }
    if (i + d == 4){
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