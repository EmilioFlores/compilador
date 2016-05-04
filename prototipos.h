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
void accion_4_ciclo();
void accion_5_ciclo();
void accion_6_ciclo();
// estatuto print
void accion_1_print();
void accion_2_print();
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
void accion_1_llamada_proc_predicado(string objetoNombre, string metodoNombre);
void accion_1_llamada_proc_no_predicado(string objetoNombre, string metodoNombre);
void accion_2_llamada_proc();
void accion_3_llamada_proc();
void accion_4_llamada_proc();
void accion_5_llamada_proc();
void accion_6_llamada_proc(string nombreProc);

void accion_1_arreglo_def(int indexVariableCreada, int tam);
void accion_2_arreglo_def(int  indexVariableCreada);

void accion_1_acceso_arreglo();
void accion_2_acceso_arreglo(string name);
void accion_3_acceso_arreglo();
void accion_4_acceso_arreglo();
void accion_5_acceso_arreglo();

void solve();
void plus_op(Cuadruplo current);
void minus_op(Cuadruplo current);
void times_op(Cuadruplo current);
void divide_op(Cuadruplo current);
void equal_op(Cuadruplo current);
void notequal_op(Cuadruplo current);
void more_op(Cuadruplo current);
void less_op(Cuadruplo current);
void moreeq_op(Cuadruplo current);
void lesseq_op(Cuadruplo current);
void or_op(Cuadruplo current);
void and_op(Cuadruplo current);

void solve();
void plus_op(Cuadruplo current);
void minus_op(Cuadruplo current);
void times_op(Cuadruplo current);
void divide_op(Cuadruplo current);
void equal_op(Cuadruplo current);
void notequal_op(Cuadruplo current);
void more_op(Cuadruplo current);
void less_op(Cuadruplo current);
void moreeq_op(Cuadruplo current);
void lesseq_op(Cuadruplo current);
void or_op(Cuadruplo current);
void and_op(Cuadruplo current);

int pideEntero(int dir);
bool pideBandera(int dir);
string pideTexto(int dir);
double pideDecimal(int dir);
void guardaEntero(int dir, int valor);
void guardaBandera(int dir, int valor);
void guardaTexto(int dir, int valor);
void guardaDecimal(int dir, int valor);

int getScope(int dir);
int getDirBase(int scope, int arregloTipo);
int getOperandoIndex(string operador);
int getIndexOperador(string operador);
string getTipoVariable(int tipo );
int getSiguienteDireccion(int tipo, bool constante, bool global, bool temporal, bool objeto, bool funcion);
template <typename T> string to_string(T value);
int getIndexTipoVariable(string nombre );
