
#include "estructuras.h"

#include "trie.cpp"

    
Memoria memoria; 



class dirProcedimientos{
private:
    
public:
    //checa el id del tipo
    Trie *arbol =  new Trie(); // arbol de ids
    vector <variable> vVariables;
    vector <bloque> vBloques;
    vector<int> pilaBloques;
    vector<pair<int,int>> pilaArgumentos;
    vector<vector<int>> pilaFunciones; //pila para funciones del era
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
    vector<Objeto> vFunciones;
    
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
     
     NUEVOS METODOS
     
     */
    
    void eraBloques(int bloque){
        pilaBloques.push_back(bloque);
    }
    
    void retornoBloques(){
        pilaBloques.pop_back();
    }
    
    
    variable dameVariable(int iVar){
        return vVariables[iVar];
    }
    
    bloque dameBloque(int bloque){
        return vBloques[bloque];
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
    
    int buscaBloque(string id){
        int iVar;
        iVar = buscaVariable(id);
        if (iVar==-1){
            return -1;
        }
        return vVariables[iVar].bloque;
    }
    
    int buscaBloque(string padreTipo, string nombre){//busca bloque para llamadas a metodos de funciones
        for (int i = 0; i < vBloques.size();i++){
            if (vBloques[i].padre==padreTipo&&vBloques[i].nombre==nombre)
                return i;
        }
        return -1;
    }
    
    bool esVariable(int id){
        if (vVariables[id].estructura==0)
            return true;
        return false;
    }
    
    int buscaTipo(string tipo){
        for (int i = 0 ; i < tipos.size();i++){
            if (tipos[i]==tipo)
                return i;
        }
        return -1;
    }
    
    string nombreTipo(int tipo){
        return tipos[tipo];
    }
    
    int checaEstructura(string id){
        int iV = buscaVariable(id);
        if (iV==-1)
            return -1;
        return vVariables[iV].estructura;
    }
    
    void espacioArreglo(int tam){
        int tipo = vVariables.back().tipo;
        vBloques[bloqueAct].inMemoria[tipo]+=tam-1;
    }
    

    void agregaDimension(int iVar, int tam){
        pair<int,int> par;
        vVariables[iVar].tam*=tam;
        par.first=tam;
        par.second=vVariables[iVar].tam;
        vVariables[iVar].dimensiones.push_back(par);
    }
   int terminaDimensiones(int iVar){
        variable *vAux;
        vAux=&vVariables[iVar];
        //este procedimientodeja las m's preparadas
        for (int i = 0; i < vAux->dimensiones.size(); i++) {
            vAux->dimensiones[i].second =vAux->tam / vAux->dimensiones[i].second;
        }
        vBloques[bloqueAct].inMemoria[vAux->tipo] += vAux->tam -1 ;
        return vAux->tam -1 ;
    }
   
    pair<int,int> dameDimension(int iVar, int indexDimension){
        pair<int,int> par;
        par.first = vVariables[iVar].dimensiones[indexDimension].first;
        par.second = vVariables[iVar].dimensiones[indexDimension].second;
        return par;
    }
   
    int cantidadDimensiones(int iVar){
        return (int) vVariables[iVar].dimensiones.size();
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
        v.tam = 1;
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
    
    bool comienzaArgumentos(int tipo, string metodo){
        string sTipo;
        if (tipo==-1){
            sTipo="Programa";
        }
        else{
            sTipo=tipos[tipo];
        }
        pair<int,int> par;//el primero es la direccion del bloque, el segundo es el argumento actual
        par.first=buscaBloque(sTipo,metodo);
        par.second=0;
        if (par.first==-1){
            return false;
        }
        pilaArgumentos.push_back(par);
        return true;
    }
    
    bool terminaArgumentos(){
        int cantidadArg=(int)vBloques[pilaArgumentos.back().first].vParam.size();
        int argChecados=pilaArgumentos.back().second;
        pilaArgumentos.pop_back();
        if (argChecados<cantidadArg){
            return false;
        }
        return true;
    }
    
    //esta es para constantes
    bool checaArgumentoTipo(int tipo){
        int cantidadArg=(int)vBloques[pilaArgumentos.back().first].vParam.size();
        int argChecados=pilaArgumentos.back().second;
        if (argChecados==cantidadArg){
            return false;
        }
        int iVar =vBloques[pilaArgumentos.back().first].vParam[argChecados];
        if (vVariables[iVar].tipo!=tipo)
            return false;
        pilaArgumentos.back().second++;
        return true;
    }
    
    
    bool crearMetodo (string tipo, string id, int direccion, int direccionCuadruplo){
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
        bAux.padre=vBloques[bloqueAct].nombre;
        bAux.direccionCuadruplo=direccionCuadruplo;
        bAux.estructura="funcion";
        bAux.inMemoria[0]=bAux.inMemoria[1]=bAux.inMemoria[2]=bAux.inMemoria[3]=0;
        v.id=id;
        v.privacidad=true;// se les da privacidad publica por default
        vVariables.push_back(v);
        vBloques[bloqueAct].vVar.push_back(varNo);
        vBloques[bloqueAct].inMemoria[v.tipo]++;
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
    void copiaDireccionesObj(int tipo,int espacio, int val){
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
                    subsDireccionesObj(val);
                }
                break;
        };
    }
    int copiaDireccionesFunc(int tipo,int espacio){
        switch (tipo) {
            case 0:
                memoria.guardaDecimalesDirFunc(espacio - OFF_BAND_DIR_FUNCION, memoria.banLocActual);
                memoria.banLocActual++;
                return (memoria.banLocActual-1);
                break;
            case 1: 
                memoria.guardaEnterosDirFunc(espacio  - OFF_ENT_DIR_FUNCION, memoria.entLocActual);
                memoria.entLocActual++;

                return (memoria.entLocActual-1);

                break;
            case 2:
                memoria.guardaDecimalesDirFunc(espacio - OFF_DEC_DIR_FUNCION, memoria.decLocActual);
                memoria.decLocActual++;
                return (memoria.decLocActual-1);
                break;
            case 3:
                memoria.guardaTextosDirFunc(espacio - OFF_TEXT_DIR_FUNCION, memoria.texLocActual);
                memoria.texLocActual++;
                return (memoria.texLocActual-1);
                break;
            case 4:
                break;
            default:
                break;
        }
        return -1;
    }
    int copiaDireccionesFuncRet(int tipo,int espacio,int val){
        switch (tipo) {
            case 0:
                memoria.guardaBanderasDirFunc(espacio - OFF_BAND_DIR_FUNCION , val);
                break;
            case 1:
                memoria.guardaEnterosDirFunc(espacio - OFF_ENT_DIR_FUNCION, val);
                break;
            case 2:
                memoria.guardaDecimalesDirFunc(espacio - OFF_DEC_DIR_FUNCION, val);
                break;
            case 3:
                memoria.guardaTextosDirFunc(espacio - OFF_TEXT_DIR_FUNCION, val);
                break;
            case 4:
                break;
            default:
                break;
        }
        return -1;
    }
    
    void quitaEspacio(int tipo){
        switch (tipo) {
            case 0:
                memoria.banLocActual--;
                break;
            case 1:
                memoria.entLocActual--;
                break;
            case 2:
                memoria.decLocActual--;
                break;
            case 3:
                memoria.texLocActual--;
                break;
            case 4:
                break;
            default:
                break;
        }
    }
    
    
    //clase para copiar el estado actual del vector
    void subsDireccionesObj(int dir){
        int tam = (int)vObjetos[dir].dirReales.size();
        for (int i = 0 ; i < tam ; i++){
            copiaDireccionesObj(vObjetos[dir].tipos[i],vObjetos[dir].dirCuadruplo[i],vObjetos[dir].dirReales[i]);
        }
    }
    
    void era(int bloque){

        pilaBloques.push_back(bloque);
        Objeto funcion;
        funcion.tipos.resize(vBloques[bloque].vVar.size());
        funcion.dirCuadruplo.resize(vBloques[bloque].vVar.size());
        funcion.dirReales.resize(vBloques[bloque].vVar.size());
        int iVar;
        for (int i = 0 ; i < funcion.tipos.size() ; i++){

            iVar=vBloques[bloque].vVar[i];
            funcion.tipos[i]=vVariables[iVar].tipo;
            funcion.dirCuadruplo[i]=vVariables[iVar].direccion;
            funcion.dirReales[i]=copiaDireccionesFunc(vVariables[iVar].tipo,vVariables[iVar].direccion);
        }
        vFunciones.push_back(funcion);
    }
    
    void retorno(){
        int dir=(int)vFunciones.size()-1;
        int tam = (int)vFunciones[dir].dirReales.size();
        for (int i = 0 ; i < tam ; i++){
            quitaEspacio(vFunciones[dir].tipos[i]);
        }
        vFunciones.pop_back();
        pilaBloques.pop_back();
        dir--;
        if (dir>=0){
            tam = (int)vFunciones[dir].dirReales.size();
            for (int i = 0 ; i < tam ; i++){
                copiaDireccionesFuncRet(vFunciones[dir].tipos[i],vFunciones[dir].dirCuadruplo[i],vFunciones[dir].dirReales[i]);
            }
        }
    }
    
    
    string nombreVariable(int direccion){
        for (int i = 0 ; i < vVariables.size();i++){
            if (vVariables[i].direccion==direccion)
                return vVariables[i].id;
        }
        return "-1";
    }

    
    int direccionArgumento(int bloque, int index){
        return vVariables[vBloques[bloque].vParam[index]].direccion;
    }
    /*
     
     METODOS DE OBJETOS Y FUNCIONES
     
     */
    
    void terminaBloque(){
        pilaBloques.pop_back();
        bloqueAct=pilaBloques.back();
    }
    
    int dameCuadruplo(int bloque){
        return vBloques[bloque].direccionCuadruplo;
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
