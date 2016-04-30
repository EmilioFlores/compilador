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

void solve();

int getIndexOperador(string operador);
string getTipoVariable(int tipo );
int getSiguienteDireccion(int tipo, bool constante, bool global, bool temporal, bool objeto, bool funcion);
template <typename T> string to_string(T value);
int getIndexTipoVariable(string nombre );


class TrieNode {
public:
    TrieNode *abc[62];
    bool termina;
    int varNo;
    TrieNode() {
        termina=false;
        varNo=-1;
        for (int i = 0 ; i < 62;i++)
            abc[i]=NULL;
    }
};
class Trie {
private:
    TrieNode* root;
public:
    Trie() {
        root = new TrieNode();
    }
    int trieAux (char c){
        if (c>= '0' && c<= '9'){
            return c-'0';
        }
        if (c>= 'a' && c<= 'z'){
            return (c-'a') + 10;
        }
        if (c>= 'A' && c<= 'Z'){
            return (c-'Z') + 26;
        }
        return -1;
    }
    bool insert(string word,int place,int num) {
        TrieNode *aux;
        aux=root;
        int val;
        //se guarda(al revez) con el valor place, que es un int y representa el bloque
        do{
            if(aux->abc[place%10]==NULL){
                aux->abc[place%10]=new TrieNode();
            }
            aux = aux->abc[place%10];
            place /= 10;
        }while (place>0);
        
        for (int i = 0 ; i < word.size();i++){
            val=trieAux(word[i]);
            if(aux->abc[val]==NULL){
                aux->abc[val]=new TrieNode();
            }
            aux = aux->abc[val];
        }
        if (aux->termina){
            return false;
        }
        aux->varNo=num;
        num++;
        aux->termina=true;
        return true;
    }
    
    // Returns if the word is in the trie.
    int search(string word,int place) {
        TrieNode *aux;
        aux=root;
        int val;
        do{
            if(aux->abc[place%10]==NULL){
                return -1;
            }
            aux = aux->abc[place%10];
            place /= 10;
        }while (place>0);
        for (int i = 0 ; i < word.size();i++){
            val=trieAux(word[i]);
            if(aux->abc[val]==NULL){
                return -1;
            }
            aux = aux->abc[val];
        }
        return aux->varNo;
    }
};


struct variable{
    int tipo;//< 5 si es de los tipos estandares, >= 5 si es un tipo definido
    string id;//nombre de la variable
    int estructura;//0 variables, 1 funciones, 2 objetos
    int bloque;//por si es funcion u objeto
    int direccion; //direccion a la base de datos
    bool privacidad;//true si es publico, false si es privado
    
};

struct Objeto{
    vector<int> tipos;//tipos de direcciones a sustituir
    vector<int> dirCuadruplo;//Direciones a sustituir
    vector<int> dirReales;//direciones reales de objeto  *en caso de ser un objeto->
    //sera direccion al mismo arreglo de objetos
};


struct bloque{
    int tipo;
    string estructura = "bloque";
    string nombre;
    vector <int> vVar;//Variables del bloque
    vector <int> vParam;//Parametros (en caso de que sea un metodo)
    //vector <int> vBloquesSup;//Bloques superiores del bloque en cuestion (ayuda a buscar variables globales que puedan ser usadas en el bloque)
    int inMemoria[4];//Variable para inicializar la memoria con las cantidades
};


class Memoria{
private:
    //Arreglos de Vectores de Memoria
    vector<int> enteros;
    vector<bool> banderas;
    vector<double> decimales;
    vector<string> textos;
    
    vector<int> enterosLoc;
    vector<bool> banderasLoc;
    vector<double> decimalesLoc;
    vector<string> textosLoc;
    
    vector<int> enterosTemp;
    vector<bool> banderasTemp;
    vector<double> decimalesTemp;
    vector<string> textosTemp;
    
    //Arreglos de Vectores de Memoria de Objetos
    //direciones que apuntan a variables de objetos
    vector<int> enterosDirObj;
    vector<int> banderasDirObj;
    vector<int> decimalesDirObj;
    vector<int> textosDirObj;
    vector<int> objetosDirObj;//este ultimo es para los objetos dentro de otros objeots en funciones
    
    vector<int> enterosObj;
    vector<bool> banderasObj;
    vector<double> decimalesObj;
    vector<string> textosObj;
    
    //direciones que apuntan a variables de funciones
    vector<int> enterosDirFunc;
    vector<int> banderasDirFunc;
    vector<int> decimalesDirFunc;
    vector<int> textosDirFunc;
    
    
public:
    int cantEnt=0;
    int cantBan=0;
    int cantDec=0;
    int cantTex=0;
    
    int cantEntObj=0;
    int cantBanObj=0;
    int cantDecObj=0;
    int cantTexObj=0;
    
    int cantEntDirObj=0;
    int cantBanDirObj=0;
    int cantDecDirObj=0;
    int cantTexDirObj=0;
    
    int cantEntDirFunc=0;
    int cantBanDirFunc=0;
    int cantDecDirFunc=0;
    int cantTexDirFunc=0;
    
    int entLocActual = 0;
    int banLocActual = 0;
    int decLocActual = 0;
    int texLocActual = 0;
    
    //Metodo que inicializara los vectores de memoria dependiendo de la memoria estatica necesaria
    void inicializa(){
        
        enteros.resize(cantEnt);

        banderas.resize(cantBan);
        decimales.resize(cantDec);
        textos.resize(cantTex);
        
        enterosObj.resize(cantEntObj);
        banderasObj.resize(cantBanObj);
        decimalesObj.resize(cantDecObj);
        textosObj.resize(cantTexObj);
        
        enterosDirObj.resize(cantEntDirObj);
        banderasDirObj.resize(cantBanDirObj);
        decimalesDirObj.resize(cantDecDirObj);
        textosDirObj.resize(cantTexDirObj);
        
        enterosDirFunc.resize(cantEntDirFunc);
        banderasDirFunc.resize(cantBanDirFunc);
        decimalesDirFunc.resize(cantDecDirFunc);
        textosDirFunc.resize(cantTexDirFunc);
        
        enterosTemp.resize(1000);
        banderasTemp.resize(1000);
        decimalesTemp.resize(1000);
        textosTemp.resize(1000);
        
        enterosLoc.resize(1000);
        banderasLoc.resize(1000);
        decimalesLoc.resize(1000);
        textosLoc.resize(1000);
    }
    
    //Metodos que regresan el espacio de memoria
    int pideEntero(int dir){
        cout << "Direccion recibida: " << dir << " Tamaño: " << enteros.size() << endl;

        return enteros[dir];
    }
    bool pideBandera(int dir){
        return banderas[dir];
    }
    double pideDecimal(int dir){
        return decimales[dir];
    }
    string pideTexto(int dir){
        return textos[dir];
    }
    
    int pideEnteroTemp(int dir){
        return enterosTemp[dir];
    }
    bool pideBanderaTemp(int dir){
        return banderasTemp[dir];
    }
    double pideDecimalTemp(int dir){
        return decimalesTemp[dir];
    }
    string pideTextoTemp(int dir){
        return textosTemp[dir];
    }
    
    int pideEnteroLoc(int dir){
        return enterosLoc[dir];
    }
    bool pideBanderaLoc(int dir){
        return banderasLoc[dir];
    }
    double pideDecimalLoc(int dir){
        return decimalesLoc[dir];
    }
    string pideTextoLoc(int dir){
        return textosLoc[dir];
    }
    
    //Metodos que asignan contenido a la memoria
    bool guardaEntero(int dir, int val){
        if (dir >= enteros.size()){
            return false;
        }
        enteros[dir]=val;
        return true;
    }
    bool guardaBandera(int dir, bool val){
        if (dir >= banderas.size()){
            return false;
        }
        banderas[dir]=val;
        return true;
    }
    bool guardaDecimal(int dir, double val){
        if (dir >= decimales.size()){
            return false;
        }
        decimales[dir]=val;
        return true;
    }
    bool guardaTexto(int dir, string val){
        if (dir >= textos.size()){
            return false;
        }
        textos[dir]=val;
        return true;
    }
    
    bool guardaEnteroTemp(int dir, int val){
        if (dir >= enterosTemp.size()){
            return false;
        }
        enterosTemp[dir]=val;
        return true;
    }
    bool guardaBanderaTemp(int dir, bool val){
        if (dir >= banderasTemp.size()){
            return false;
        }
        banderasTemp[dir]=val;
        return true;
    }
    bool guardaDecimalTemp(int dir, double val){
        if (dir >= decimalesTemp.size()){
            return false;
        }
        decimalesTemp[dir]=val;
        return true;
    }
    bool guardaTextoTemp(int dir, string val){
        if (dir >= textosTemp.size()){
            return false;
        }
        textosTemp[dir]=val;
        return true;
    }
    
    bool guardaEnteroLoc(int dir, int val){
        if (dir >= enterosLoc.size()){
            return false;
        }
        enterosLoc[dir]=val;
        return true;
    }
    bool guardaBanderaLoc(int dir, bool val){
        if (dir >= banderasLoc.size()){
            return false;
        }
        banderasLoc[dir]=val;
        return true;
    }
    bool guardaDecimalLoc(int dir, double val){
        if (dir >= decimalesLoc.size()){
            return false;
        }
        decimalesLoc[dir]=val;
        return true;
    }
    bool guardaTextoLoc(int dir, string val){
        if (dir >= textosLoc.size()){
            return false;
        }
        textosLoc[dir]=val;
        return true;
    }
    
    //Metodos objetos
    //Metodos que regresan el espacio de memoria
    int pideDirEnteroObj(int dir){
        return enterosDirObj[dir];
    }
    int pideDirBanderaObj(int dir){
        return banderasDirObj[dir];
    }
    int pideDirDecimalObj(int dir){
        return decimalesDirObj[dir];
    }
    int pideDirTextoObj(int dir){
        return textosDirObj[dir];
    }
    int pideDirObjetoObj(int dir){
        return objetosDirObj[dir];
    }
    int pideEnteroObj(int dir){
        return enterosObj[dir];
    }
    bool pideBanderaObj(int dir){
        return banderasObj[dir];
    }
    double pideDecimalObj(int dir){
        return decimalesObj[dir];
    }
    string pideTextoObj(int dir){
        return textosObj[dir];
    }
    
    //Metodos que asignan contenido a la memoria
    bool guardaEnterosDirObj(int dir, int val){
        if (dir >= enterosDirObj.size()){
            return false;
        }
        enterosDirObj[dir]=val;
        return true;
    }
    bool guardaBanderasDirObj(int dir, int val){
        if (dir >= banderasDirObj.size()){
            return false;
        }
        banderasDirObj[dir]=val;
        return true;
    }
    bool guardaDecimalesDirObj(int dir, int val){
        if (dir >= decimalesDirObj.size()){
            return false;
        }
        decimalesDirObj[dir]=val;
        return true;
    }
    bool guardaTextosDirObj(int dir, int val){
        if (dir >= textosDirObj.size()){
            return false;
        }
        textosDirObj[dir]=val;
        return true;
    }
    bool guardaObjetosDirObj(int dir, int val){
        if (dir >= objetosDirObj.size()){
            return false;
        }
        objetosDirObj[dir]=val;
        return true;
    }
    
    bool guardaEnteroObj(int dir, int val){
        if (dir >= enterosObj.size()){
            return false;
        }
        enterosObj[dir]=val;
        return true;
    }
    bool guardaBanderaObj(int dir, bool val){
        if (dir >= banderasObj.size()){
            return false;
        }
        banderasObj[dir]=val;
        return true;
    }
    bool guardaDecimalObj(int dir, double val){
        if (dir >= decimalesObj.size()){
            return false;
        }
        decimalesObj[dir]=val;
        return true;
    }
    bool guardaTextoObj(int dir, string val){
        if (dir >= textosObj.size()){
            return false;
        }
        textosObj[dir]=val;
        return true;
    }
    
    
};

Memoria memoria; 

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
    
    dirProcedimientos(){
        string tiposAux[] = {"bandera","entero","decimal","texto","vacio"};
        for(int i = 0; i < 5 ;i++){//lleno tipos con los tipos predefinidos
            tipos.push_back(tiposAux[i]);
        }
        bloqueAct = 0;
        sigBloque = 0;//es el id del siguiente bloque a crear
        inMemoria[0]=inMemoria[1]=inMemoria[2]=inMemoria[3]=0;
        varNo = 0;
        pilaBloques.push_back(0);
        bloque bAux;
        bAux.inMemoria[0]=bAux.inMemoria[1]=bAux.inMemoria[2]=bAux.inMemoria[3]=0;
        bAux.tipo = 4;
        bAux.nombre = "Programa";
        vBloques.push_back(bAux);
    }
    
    
    /*
     
     METODOS DE VARIABLES
     
     */
    
    int buscaDireccion(string id){
        int iVar;
        iVar = buscaVariable(id);
        if (iVar==-1){
            return -1;
        }
        return vVariables[iVar].direccion;
    }
    
    int buscaTipo(string tipo){
        for (int i = 0 ; i < tipos.size();i++){
            if (tipos[i]==tipo)
                return i;
        }
        return -1;
    }
    
    //buscaVariable checa si la variable ha sido instanciada antes en el proyecto y regresa su indice la tabla de variables de variables
    // regresa -1 si no la encontro
    int buscaVariable (string id){
        int val=-1;
        for (int i = pilaBloques.size()-1 ; i >= 0 ; i--){
            val = arbol->search(id,pilaBloques[i]);
            if (val>-1){
                nombreUltVar = id;
                ultVariabe=val;// para saber cual fue la ultima variable inicializada
                argActual=0;//se reinicializa argumentos actuales a 0 para saber que no se a checado ningun argumento de esta variable posible metodo
                return val;
            }
        }
        cout << "No se encontro la variable "<< id << endl;
        return -1;
    }
    
    int checaTipo(string id){
        int iV = buscaVariable(id);
        if (iV==-1)
            return -1;
        return vVariables[iV].tipo;
    }
    
    //crearVariable es para checar si puede crear una variable. ej: entero x; o 'Objeto' y; donde Objeto es un tipo previamente definido
    //esta funcion tambien sirve para decir si una variable es publica a un objeto, con el bool privacidad
    bool crearVariable(string tipo, string id, bool privacidad,int direccion){
        variable v;
        v.tipo = buscaTipo(tipo);
        if (v.tipo==-1){
            cout << tipo << " "<< id << " Tipo Inexistente"<<endl;
            return false;
        }
        //checa si la variable esta usada, si no la inserta
        if (!arbol->insert(id,bloqueAct,varNo)){
            cout << tipo << " "<< id << " Id usada en el bloque "<<endl;
            return false;
        }
        v.estructura = 0;
        v.direccion=direccion;
        v.bloque = -1;
        if (v.tipo>4){
            v.estructura=2;
            v.bloque=bloqueTipo[v.tipo-4];
            v.direccion=vObjetos.size();
            creaMemoriaObjeto(v.bloque);
        }
        else{
            if (v.tipo < 4)
                vBloques[bloqueAct].inMemoria[v.tipo]++;
        }
        v.privacidad=privacidad;
        v.id=id;
        vVariables.push_back(v);
        vBloques[bloqueAct].vVar.push_back(varNo);
        varNo++;//
        return true;
    }
    
    /*
     
     METODOS DE OBJETOS
     
     */
    
    void creaMemoriaObjeto(int bloque){//crea la memoria para un objeto con la informacion en el bloque que lo define
        Objeto obj;
        vObjetos.push_back(obj);
        int v;
        int tam=(int)vBloques[bloque].vVar.size();
        int o =(int) vObjetos.size()-1;
        vObjetos[o].dirCuadruplo.resize(tam);
        vObjetos[o].dirReales.resize(tam);
        vObjetos[o].tipos.resize(tam);
        for (int i = 0 ; i < tam;i++){
            v=vBloques[bloque].vVar[i];
            vObjetos[o].tipos[i]=vVariables[i].tipo;
            vObjetos[o].dirCuadruplo[i]=vVariables[v].direccion;
            vObjetos[o].dirReales[i]=espacioMemoriaObjeto(vVariables[i].tipo);
        }
    }
    
    bool crearObjeto(string tipo){
        for (int i = 0 ; i < tipos.size() ; i++){
            if (tipos[i]==tipo){
                cout << "Tipo ya usado " << tipo << endl;
                return false;
            }
        }
        bloque bAux;
        sigBloque++;
        bAux.tipo = (int) tipos.size();
        bAux.nombre = tipo;
        bAux.estructura="objeto";
        bAux.inMemoria[0]=bAux.inMemoria[1]=bAux.inMemoria[2]=bAux.inMemoria[3]=0;
        vBloques.push_back(bAux);
        tipos.push_back(tipo);
        bloqueAct = sigBloque;
        bloqueTipo.push_back(sigBloque);
        pilaBloques.push_back(sigBloque);
        return true;
    }
    
    int espacioMemoriaObjeto(int tipo){
        switch (tipo) {
            case 0:
                memoria.cantBanObj++;
                return memoria.cantBanObj-1;
                break;
            case 1:
                memoria.cantEntObj++;
                return memoria.cantEntObj-1;
                break;
            case 2:
                memoria.cantDecObj++;
                return memoria.cantDecObj-1;
                break;
            case 3:
                memoria.cantTexObj++;
                return memoria.cantTexObj-1;
                break;
            case 4:
                return -1;
                break;
            default:
                if(tipo>4){
                    int dir =(int) vObjetos.size();//guardo la direccion del objeto a crear
                    creaMemoriaObjeto(tipo-4);//le doy espacio de memoria con objeto con direccion que es tipo-4 por la relacion arreglo de tipos y arreglo de bloques
                    return dir;
                }
                return -1;
                break;
        };
        return -1;
    }
    
    /*
     
     METODOS DE FUNCIONES
     
     */
    
    
    bool agregaParametro (string tipo, string id, int direccion){
        if (crearVariable(tipo,id,false,direccion)){
            vBloques[bloqueAct].vParam.push_back(varNo-1);//-1 porque en crearVariable se le suma uno
            return true;
        }
        return false;
    }
    
    //esta es para argumentos normales
    bool checaArgumentoID(string id){
        int iAux = ultVariabe;// se guardan para mantener los datos del metodo que llamo los argumentos
        string sAux = nombreUltVar;
        if (vVariables[ultVariabe].estructura!=1){
            cout << "La variable "<<nombreUltVar<<" no es un metodo no debe tener argumentos"<<endl;
            return false;
        }
        if (argActual+1>vBloques[vVariables[ultVariabe].bloque].vParam.size()){
            cout <<"Se excedio en argumentos"<<endl;
            return false;
        }
        if (vVariables[buscaVariable(id)].tipo!=vVariables[vBloques[vVariables[iAux].bloque].vParam[argActual]].tipo)
        {
            cout << "No coinciden los tipos del argumento #"<<argActual<<endl;
            return false;
        }
        argActual++;
        ultVariabe=iAux;
        nombreUltVar = sAux;
        return true;
    }
    
     int checaEstructura(string id){
        int iV = buscaVariable(id);
        if (iV==-1)
            return -1;
        return vVariables[iV].estructura;
    }
    //esta es para constantes
    bool checaArgumentoTipo(int tipo){
        int iAux = ultVariabe;// se guardan para mantener los datos del metodo que llamo los argumentos
        string sAux = nombreUltVar;
        if (vVariables[ultVariabe].estructura!=1){
            cout << "La variable "<<nombreUltVar<<" no es un metodo no debe tener argumentos"<<endl;
            return false;
        }
        if (argActual+1>vBloques[vVariables[ultVariabe].bloque].vParam.size()){
            cout <<"Se excedio en argumentos"<<endl;
            return false;
        }
        if (tipo!=vVariables[vBloques[vVariables[iAux].bloque].vParam[argActual]].tipo)
        {
            cout << "No coinciden los tipos del argumento #"<<argActual+1<<endl;
            return false;
        }
        argActual++;
        ultVariabe=iAux;
        nombreUltVar = sAux;
        return true;
    }
    
    // se llama al final de checar cada metodo
    bool checaCompletezPred(bool metodo){
        if (vVariables[ultVariabe].estructura==1)//checa si la variable es un metodo, si no no
        {
            if (!metodo){
                cout << "Falto la declaracion de argumentos del metodo"<<endl;
                return false;
            }
            
            if (argActual!=vBloques[vVariables[ultVariabe].bloque].vParam.size()){
                cout << "Faltan argumentos" << endl;
                return false;
            }
            return true;
        }
        else{
            cout << "La variable no es un metodo"<<endl;
            return false;
        }
    }
    
    bool checaPredicado(string id){
        int iAux = ultVariabe; //guardamos la ultima variable usada que corresponde al objeto invocador
        string sAux = nombreUltVar;
        
        if (vVariables[iAux].estructura!=2){
            cout << "La variable "+sAux+" no es un objeto no puede invocar predicados"<<endl;
            return false;
        }
        int bloqueM =vVariables[iAux].bloque;
        int iVar=-1;
        for (int  i = 0 ; i < vBloques[bloqueM].vVar.size();i++){
            if (vVariables[vBloques[bloqueM].vVar[i]].id==id){
                iVar=vBloques[bloqueM].vVar[i];
            }
        }
        if(iVar==-1){
            cout << "No se encontro la variable publica "+id+" dentro de "+nombreUltVar<<endl;
            return false;
        }
        ultVariabe=iVar;
        
        return true;
    }
    
    bool crearMetodo (string tipo, string id, int direccion){
        variable v;
        v.tipo = buscaTipo(tipo);
        if (v.tipo==-1){
            cout << tipo << " "<< id << " Tipo Inexistente"<<endl;
            return false;
        }
        if (!arbol->insert(id,bloqueAct,varNo)){//guarda el id en el bloque anterior
            cout << tipo << " "<< id << " Id usada en el bloque "<<endl;
            return false;
        }
        sigBloque++;
        if (!arbol->insert(id,sigBloque,varNo)){//guarda el id en el bloque actual para que no se pueda redefinir adentro
            cout << tipo << " "<< id << " Id usada en el bloque "<<endl;
            return false;
        }
        v.estructura = 1;
        v.direccion=direccion;
        v.bloque = sigBloque;//los metodos señalan a un bloque para enseñar sus parametros
        bloque bAux;
        bAux.tipo = v.tipo;
        bAux.nombre = id;
        bAux.estructura="funcion";
        bAux.inMemoria[0]=bAux.inMemoria[1]=bAux.inMemoria[2]=bAux.inMemoria[3]=0;
        v.id=id;
        v.privacidad=true;// se les da privacidad publica por default
        vVariables.push_back(v);
        vBloques[bloqueAct].vVar.push_back(varNo);
        vBloques.push_back(bAux);
        bloqueTipo.push_back(sigBloque);
        tipos.push_back("Funcion");//placeholder para mantener el orden de la relacion tipos, tipoBloque, vBloques
        pilaBloques.push_back(sigBloque);
        bloqueAct = sigBloque;
        varNo++;
        return true;
    }
    
    /*
     
     METODOS DE DIRECCIONES *ERA*
     
     */
    
    //clase auxiliar de subs
    void copiaDirecciones(int tipo,int espacio, int val){
        switch (tipo) {
            case 0:
                memoria.guardaBanderasDirObj(espacio, val);
                break;
            case 1:
                memoria.guardaEnterosDirObj(espacio, val);
                break;
            case 2:
                memoria.guardaDecimalesDirObj(espacio, val);
                break;
            case 3:
                memoria.guardaTextosDirObj(espacio, val);
                break;
            case 4:
                break;
            default:
                if(tipo>4){
                    memoria.guardaObjetosDirObj(espacio, val);
                }
                break;
        };
    }
    
    
    
    //clase para copiar el estado actual del vector
    void subsDireccionesObj(int dir){
        int tam = (int)vObjetos[dir].dirReales.size();
        for (int i = 0 ; i < tam ; i++){
            copiaDirecciones(vObjetos[dir].tipos[i],vObjetos[dir].dirCuadruplo[i],vObjetos[dir].dirReales[i]);
        }
    }
    
    /*
     
     METODOS DE OBJETOS Y FUNCIONES
     
     */
    
    void terminaBloque(){
        pilaBloques.pop_back();
        bloqueAct=pilaBloques.back();
    }
    
    /*
     
     METODOS DE MEMORIA
     
     */
    
    void inicializaMemoria(){
        for (int i = 0; i< vBloques.size();i++){
            if (vBloques[i].estructura=="bloque"){
                memoria.cantBan+=vBloques[i].inMemoria[0];
                memoria.cantEnt+=vBloques[i].inMemoria[1];
                memoria.cantDec+=vBloques[i].inMemoria[2];
                memoria.cantTex+=vBloques[i].inMemoria[3];
            }
            if (vBloques[i].estructura=="objeto"){
                memoria.cantBanDirObj+=vBloques[i].inMemoria[0];
                memoria.cantEntDirObj+=vBloques[i].inMemoria[1];
                memoria.cantDecDirObj+=vBloques[i].inMemoria[2];
                memoria.cantTexDirObj+=vBloques[i].inMemoria[3];
            }
            if (vBloques[i].estructura=="funcion"){
                memoria.cantBanDirFunc+=vBloques[i].inMemoria[0];
                memoria.cantEntDirFunc+=vBloques[i].inMemoria[1];
                memoria.cantDecDirFunc+=vBloques[i].inMemoria[2];
                memoria.cantTexDirFunc+=vBloques[i].inMemoria[3];
            }
        }
        cout << "Memoria cant ent:" << memoria.cantEnt << endl;
        memoria.inicializa();
    }
};


dirProcedimientos dirProcedimientos ;





string yyTipo = "";
string objetoNombre = "default";
string metodoNombre = "";
string funcionNombre = "";


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


#define _GLOBAL     0
#define _TEMPORAL   1
#define _CONSTANTE  2
#define _FUNCION    3
#define _OBJETO     4
#define _ERROR      5


#define _BANDERA 0
#define _ENTERO  1
#define _DECIMAL 2
#define _TEXTO   3

#define _PLUS 0
#define _MINUS 1
#define _TIMES 2
#define _SLASH 3
#define _EQLEQL 4
#define _NEQ 5
#define _GTR 6
#define _LSS 7
#define _EQL 8
#define _GTROEQL 9 
#define _LSSOEQL 10
#define _OR 11
#define _AND 12
#define _LEESYM 13 
#define _MUESTRASYM 14
#define _GOTOT 15
#define _GOTOF 16
#define _GOTO 17
#define _ERA 18
#define _GSUB 19
#define _RETURN 20
#define _PARAM 21
#define _VER 22
#define _END 23



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
        dirProcedimientos.inicializaMemoria();
        solve();		

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
**/
int getOperandoIndex(string operador){

    if ( operador == "+") { return 0; }
    if ( operador == "-") { return 1; }
    if ( operador == "*") { return 2; }
    if ( operador == "/") { return 3; }
    if ( operador == "==") { return 4; }
    if ( operador == "!=") { return 5; }
    if ( operador == ">") { return 6; }
    if ( operador == "<") { return 7; }
    if ( operador == "=") { return 8; }
    if ( operador == ">=") { return 9; }
    if ( operador == "<=") { return 10; }
    if ( operador == "||") { return 11; }
    if ( operador == "&&") { return 12; }
    if ( operador == "lee") { return 13; }
    if ( operador == "muestra") { return 14; }
    if ( operador == "gotof") { return 15; }
    if ( operador == "gotot") { return 16; }
    if ( operador == "goto") { return 17; }
    if ( operador == "era") { return 18; }
    if ( operador == "gosub") { return 19; }
    if ( operador == "retorno") { return 20; }
    if ( operador == "param") { return 21; }
    if ( operador == "ver") { return 22; }
    if ( operador == "end") { return 23; }
    return - 1;
}


void plus_op (Cuadruplo current) {


	//TODO checkTemporal, local, objeto global
		//TODO check INT , Double 
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());

	int scopeIzq = getScope(dirIzq); 
	int scopeDer = getScope(dirDer); 

    switch (tipoIzq ) {
        
    }

	int tipoIzq = getTipoDireccion(dirIzq, scopeIzq);
	int tipoDer = getTipoDireccion(dirDer, scopeDer);

    int valorIzq = memoria.pideEntero(dirIzq - OFF_ENT_CONST );
    valorIzq = atoi(constantes[dirIzq - OFF_ENT_CONST].valor.c_str());

    int valorDer = memoria.pideEntero(dirDer - OFF_ENT_CONST );
    valorDer = atoi(constantes[dirDer - OFF_ENT_CONST].valor.c_str());

    memoria.guardaEntero( dirRes - OFF_ENT_TEMP , valorIzq + valorDer);


    
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
        
        switch ( getOperandoIndex(current.getOp() ))  {
            //  +     -     *     /    ==    !=     >     <     =    >=    <=    ||     &&
            case _PLUS    : plus_op(current);   break; // Funcion que hace la suma
            
            break;
        }
    }


}

