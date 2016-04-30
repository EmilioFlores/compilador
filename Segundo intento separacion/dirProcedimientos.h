#ifndef DIRPROCEDIMIENTOS_H
#define DIRPROCEDIMIENTOS_H


class dirProcedimientos{
private:
    
public:
    //checa el id del tipo
    Trie *arbol =  new Trie(); // arbol de ids
    vector <variable> vVariables;
    vector <bloque> vBloques;
    vector <int> pilaBloques;
    int cantVariables[2][5];//
    vector <string> tipos;
    vector <int> bloqueTipo;//bloque del tipo si es un objeto
    int bloqueAct;
    int sigBloque;//es el id del siguiente bloque a crear
    int varNo;
    int ultVariabe;//esta es la direccion de la ultima variable que fue checada, para checar predicados, pertenencia objetos etc.
    int argActual = 0;//argumento actual inicializado en 0
    string nombreUltVar;
    int inMemoria[4];//Variable para inicializar la memoria con las cantidades
    vector<Objeto> vObjetos;
    
    dirProcedimientos();
    
    int buscaDireccion(string id);
    
    int buscaTipo(string tipo);
    //buscaVariable checa si la variable ha sido instanciada antes en el proyecto y regresa su indice la tabla de variables de variables
    // regresa -1 si no la encontro
    int buscaVariable (string id);
    
    int checaTipo(string id);
    //crearVariable es para checar si puede crear una variable. ej: entero x; o 'Objeto' y; donde Objeto es un tipo previamente definido
    //esta funcion tambien sirve para decir si una variable es publica a un objeto, con el bool privacidad
    bool crearVariable(string tipo, string id, bool privacidad,int direccion);
    /*
     
     METODOS DE OBJETOS
     
     */
    
    void creaMemoriaObjeto(int bloque);
    
    bool crearObjeto(string tipo);
    
    int espacioMemoriaObjeto(int tipo);
    
    /*
     
     METODOS DE FUNCIONES
     
     */
    
    
    bool agregaParametro (string tipo, string id, int direccion);
    //esta es para argumentos normales
    bool checaArgumentoID(string id);
    
     int checaEstructura(string id);
    //esta es para constantes
    bool checaArgumentoTipo(int tipo);
    
    // se llama al final de checar cada metodo
    bool checaCompletezPred(bool metodo);
    
    bool checaPredicado(string id);
    
    bool crearMetodo (string tipo, string id, int direccion);
    /*
     
     METODOS DE DIRECCIONES *ERA*
     
     */
    
    //clase auxiliar de subs
    void copiaDirecciones(int tipo,int espacio, int val);
    //clase para copiar el estado actual del vector
    void subsDireccionesObj(int dir);
    /*
     
     METODOS DE OBJETOS Y FUNCIONES
     
     */
    void terminaBloque();
    /*
     
     METODOS DE MEMORIA
     
     */

    void inicializaMemoria();
};
#endif