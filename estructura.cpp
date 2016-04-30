//
//  main.cpp
//  proyectoCompiladores
//
//  Created by Francisco Canseco on 01/04/16.
//  Copyright (c) 2016 Francisco Canseco. All rights reserved.
//

#include <iostream>
#include <vector>
#include <string>

using namespace std;
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
    Memoria memoria;//ESTO SE DEBE DE BORRAR!!!!!!!!!
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
        memoria.inicializa();
    }
};
