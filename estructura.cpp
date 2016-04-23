
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
    int num;
public:
    Trie() {
        root = new TrieNode();
        num = 0;
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
    bool insert(string word,int place) {
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
    int tipo;//< 9 si es de los tipos estandares, >= 9 si es un tipo definido
    string id;//nombre de la variable
    int estructura;//0 variables, 1 funciones, 2 objetos
    int bloque;//por si es funcion u objeto
    int direccion; //direccion a la base de datos
    bool privacidad;//true si es publico, false si es privado
};

struct Memoria{
    int enteros_total;
    int decimal_total;
    int bandera_total;
    int texto_total;
    int temporal_total;
};

struct bloque{
    int tipo;
    string nombre;
    struct Memoria memoria;
    vector <int> vVar;//Variables Publicas del bloque
    vector <int> vParam;//Parametros (en caso de que sea un metodo)
    //vector <int> vBloquesSup;//Bloques superiores del bloque en cuestion (ayuda a buscar variables globales que puedan ser usadas en el bloque)
};


class dirProcedimientos {
private:
    
public:
    //checa el id del tipo
    Trie *arbol =  new Trie(); // arbol de ids
    vector <variable> vVariables;
    vector <bloque> vBloques;
    vector <int> pilaBloques;
    vector <string> tipos;
    vector <int> bloqueTipo;//bloque del tipo si es un objeto
    int bloqueAct;
    int sigBloque;//es el id del siguiente bloque a crear
    int varNo;
    int ultVariabe;//esta es la direccion de la ultima variable que fue checada, para checar predicados, pertenencia objetos etc.
    int argActual = 0;//argumento actual inicializado en 0
    string nombreUltVar;
    dirProcedimientos(){
        string tiposAux[] = {"bandera","entero","decimal","texto","vacio"};
        for(int i = 0; i < 5 ;i++){//lleno tipos con los tipos predefinidos
            tipos.push_back(tiposAux[i]);
        }
        bloqueAct = 0;
        sigBloque = 0;//es el id del siguiente bloque a crear
        varNo = 0;
        pilaBloques.push_back(0);
        bloque bAux;
        bAux.tipo = 4;
        bAux.nombre = "Programa";
        vBloques.push_back(bAux);
    }
    int buscaTipo(string tipo){
        for (int i = 0 ; i < tipos.size();i++){
            if (tipos[i]==tipo)
                return i;
        }
        return -1;
    }
    
    int checaTipo(string id){
        int iV = buscaVariable(id);
        if (iV==-1)
            return -1;
        return vVariables[iV].tipo;
    }
    
    int checaEstructura(string id){
        int iV = buscaVariable(id);
        if (iV==-1)
            return -1;
        return vVariables[iV].estructura;
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
        if (!arbol->insert(id,bloqueAct)){
            cout << tipo << " "<< id << " Id usada en el bloque "<<endl;
            return false;
        }
        v.estructura = 0;
        v.bloque = -1;
        if (v.tipo>4){
            v.estructura=2;
            v.bloque=bloqueTipo[v.tipo-5];
        }
        v.privacidad=privacidad;
        v.id=id;
        v.direccion=direccion;
        vVariables.push_back(v);
        if (privacidad){//esto para agregar las variables publicas de un objeto
            if (tipo == "entero ") {}
            else if ( tipo == "bandera") {}
            else if ( tipo == "decimal") {}
            else if ( tipo == "texto") {}
            
            vBloques[bloqueAct].memoria.enteros_total++;
            vBloques[bloqueAct].vVar.push_back(varNo);
        }
        varNo++;//
        return true;
    }
    
    ///buscaVariable checa si la variable ha sido instanciada antes en el proyecto y regresa su indice la tabla de variables de variables
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
        vBloques.push_back(bAux);
        tipos.push_back(tipo);
        bloqueAct = sigBloque;
        bloqueTipo.push_back(sigBloque);
        pilaBloques.push_back(sigBloque);
        return true;
    }
    
    bool crearMetodo (string tipo, string id, int direccion){
        variable v;
        v.tipo = buscaTipo(tipo);
        if (v.tipo==-1){
            cout << tipo << " "<< id << " Tipo Inexistente"<<endl;
            return false;
        }
        if (!arbol->insert(id,bloqueAct)){
            cout << tipo << " "<< id << " Id usada en el bloque "<<endl;
            return false;
        }
        sigBloque++;
        v.estructura = 1;
        v.bloque = sigBloque;//los metodos señalan a un bloque para enseñar sus parametros
        bloque bAux;
        bAux.tipo = v.tipo;
        bAux.nombre = id;
        v.id=id;
        v.direccion=direccion;
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
        return true;
    }
    
    int buscaDireccion(string id){
        int iVar;
        iVar = buscaVariable(id);
        if (iVar==-1){
            return -1;
        }
        return vVariables[iVar].direccion;
    }
    bool agregaParametro (string tipo, string id, int direccion){
        if (crearVariable(tipo,id,false,direccion)){
            vBloques[bloqueAct].vParam.push_back(varNo-1);//-1 porque en crearVariable se le suma uno
            return true;
        }
        return false;
    }
    void terminaBloque(){
        pilaBloques.pop_back();
        bloqueAct=pilaBloques.back();
    }
};
