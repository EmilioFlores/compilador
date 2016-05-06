
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
    /**
     * eraBloques
     * Funcion utilizada para hacer push de bloques en ejecucion
     * @param bloque, reperesentado la direccion de bloque en el arreglo de bloques
     */
    void eraBloques(int bloque){
        pilaBloques.push_back(bloque);
    }
    
    
    /*
     *
     * retornoBloques
     * Funcion utilizada para hacer pop de bloques en ejecucion
     */
    void retornoBloques(){
        pilaBloques.pop_back();
    }
    
    /*
     *
     * indexVariable
     * Funcion utilizada para regresar un index al arreglo de variables dependiendo de la direccion de estas
     *@param direccion, variable entero que tiene la direccion de entero que usan los cuadruplos
     *@return, entero que regresa la direccion vaiable
     *
     */
    int indexVariable(int direccion){
        for (int i = 0 ; i < vVariables.size();i++){
            if (vVariables[i].direccion==direccion)
                return i;
        }
        return -1;
    }
    
    /*
     *
     * agregaDimension
     * Funcion que agrega dimensiones para una variable estructurada (arreglos)
     *@param iVar, index que apunta al arreglo de variables de la variable dim. tam, tamaño de la dimension que se agrega
     *
     */
    void agregaDimension(int iVar, int tam){
        pair<int,int> par;
        vVariables[iVar].tam*=tam;
        par.first=tam;
        par.second=vVariables[iVar].tam;
        vVariables[iVar].dimensiones.push_back(par);
    }
    
    /*
     *
     * terminaDimensiones
     * Funcion utilizada para checar que se hayan enviado todas las dimensionesy dar tamaños y m's
     *@param iVar, variable entero que tiene la referencia de la variable en el arreglo de estas
     *@return, entero que regresa el tamaño de la variable en relacion a su tipo
     *
     */
    int terminaDimensiones(int iVar){
        variable *vAux;
        vAux = &vVariables[iVar];
        //este procedimientodeja las m's preparadas
        for (int i = 0; i < vAux->dimensiones.size(); i++) {
            vAux->dimensiones[i].second =vAux->tam / vAux->dimensiones[i].second;
        }
        vBloques[bloqueAct].inMemoria[vAux->tipo] += vAux->tam -1 ;
        return vAux->tam -1 ;
    }
    
    /*
     *
     * dameDimension
     * Funcion utilizada para regresar un index al arreglo de variables dependiendo de la direccion de estas
     *@param iVar, entero que apunta al arreglo de variables, @param indexDimension, dimension actual que se quiere recibir
     *@return, par de enteros que regresa el tamaño de la dimension que se pide y su m calculada
     *
     */
    pair<int,int> dameDimension(int iVar, int indexDimension){
        pair<int,int> par;
        par.first = vVariables[iVar].dimensiones[indexDimension].first;
        par.second = vVariables[iVar].dimensiones[indexDimension].second;
        return par;
    }
    
    int cantidadDimensiones(int iVar){
        return (int) vVariables[iVar].dimensiones.size();
    }
    
    string buscaPadreTipo(string id){
        int iVar = buscaVariable(id);
        if (iVar==-1)
            return "-1";
        return tipos[vVariables[iVar].tipo];
    }

    
    /*
     
     METODOS DE VARIABLES
     
     */
    
    /*
     *
     * buscaDireccion
     * Funcion utilizada que regresa la direccion de una id de variable
     *@param id, string con el nombre identificador de la variable
     *@return, entero que regresa el index de variable en arr<variable>
     *
     */
    int buscaDireccion(string id){
        int iVar;
        iVar = buscaVariable(id);
        if (iVar==-1){
            return -1;
        }
        return vVariables[iVar].direccion;
    }
    
    
    /*
     *
     * buscaBloque
     * Funcion utilizada que regresa la direccion de bloque de un metodo u objeto
     *@param id, string con el nombre identificador de la variable
     *@return, entero que regresa el index del gbloque en arr<variable>
     *
     */
    int buscaBloque(string id){
        int iVar;
        iVar = buscaVariable(id);
        if (iVar==-1){
            return -1;
        }
        return vVariables[iVar].bloque;
    }
    
    /*
     *
     * buscaBloque
     * Busca bloques que esten anidados en funciones
     *@param id, string con el nombre identificador de la variable
     *@return, entero que regresa el index de variable en arr<variable>
     *
     */
    int buscaBloque(string padreTipo, string nombre){//busca bloque para llamadas a metodos de funciones
        for (int i = 0; i < vBloques.size();i++){
            if (vBloques[i].padre==padreTipo&&vBloques[i].nombre==nombre)
                return i;
        }
        return -1;
    }
    
    /*
     *
     * esVariable
     * Funcion que checa si una variable es de esta estructur (no objeto ni metodo)
     *@param id, int con el index de la variable
     *@return, entero que regresa el index de variable en arr<variable>
     *
     */
    bool esVariable(int id){
        if (vVariables[id].estructura==0)
            return true;
        return false;
    }
    
    /*
     *
     * buscaTipo
     * Funcion utilizada que regresa el tipo de una variable
     *@param tipo, string con el nombre identificador de la variable
     *@return, entero que regresa el index de variable en arr<variable>
     *
     */
    int buscaTipo(string tipo){
        for (int i = 0 ; i < tipos.size();i++){
            if (tipos[i]==tipo)
                return i;
        }
        return -1;
    }
    
    /*
     *
     * nombreTipo
     * Funcion utilizada para regresar el string de un tipo segun un id.
     *@param tipo, int con el nombre identificador de la variable
     *@return, entero que regresa el index de variable en arr<variable>
     *
     */
    string nombreTipo(int tipo){
        return tipos[tipo];
    }
    
    /*
     *
     * checaEstructura
     * Funcion utilizada que regresa la estructura de variable
     *@param id, string con el nombre identificador de la variable
     *@return, entero que regresa el tipo de estructura de variable en arr<variable>
     * 0 variable, 1 objeto, 2 funcion
     *
     */
    int checaEstructura(string id){
        int iV = buscaVariable(id);
        if (iV==-1)
            return -1;
        return vVariables[iV].estructura;
    }
    
    /*
     *
     * espacioArreglo
     * Funcion utilizada qpara darle el espacio al array antes del ulti de mauro
     *@param tam, string con el nombre identificador de la variable
     *
     */
    void espacioArreglo(int tam){
        int tipo = vVariables.back().tipo;
        vBloques[bloqueAct].inMemoria[tipo]+=tam-1;
    }
    
    /*
     *
     * buscaVariable
     * Funcion utilizada el string id de una variable para regresar su index
     *@param id, string con el nombre identificador de la variable
     *@return, entero que regresa el index segun el arreglo de c++
     *
     */
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
    
    /*
     *
     * checaTipo
     * Funcion utilizada que regresa el tipo de un string
     *@param id, string con el nombre identificador de la variable
     *@return, entero que regresa el tipo de variable en arr<variable>
     *
     */
    int checaTipo(string id){
        int iV = buscaVariable(id);
        if (iV==-1)
            return -1;
        return vVariables[iV].tipo;
    }
    
    /*
     *
     * crearVariable
     * Funcion utilizada que para darle espacion a una variable
     *@param string, tipo , string id,
     *@return, entero que regresa el index de variable en arr<variable>
     *
     */
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
        v.tam=1;
        v.direccion=direccion;
        v.bloque = -1;
        if (v.tipo>4){
            v.estructura=2;
            v.bloque=bloqueTipo[v.tipo-5];
            v.direccion=vObjetos.size();
            creaMemoriaObjeto(v.bloque);
        }
        else{
            if (v.tipo < 4) {
                vBloques[bloqueAct].inMemoria[v.tipo]++;
            }
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
    
    
    /*
     *
     * creaMemoriaObjeto
     * Funcion utilizada para darle la memoria a un objeto
     *@param bloque, entero que apunta en el arreglo de lboques el index
     *@return, entero que regresa el index de variable en arr<variable>
     *
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
        vObjetos[o].tams.resize(tam);
        for (int i = 0 ; i < tam;i++){
            v=vBloques[bloque].vVar[i];
            vObjetos[o].tams[i]=vVariables[v].tam;
            vObjetos[o].tipos[i]=vVariables[v].tipo;
            vObjetos[o].dirCuadruplo[i]=vVariables[v].direccion;
            vObjetos[o].dirReales[i]=espacioMemoriaObjeto(vVariables[v].tipo,vVariables[v].tam);
        }
    }
    
    /*
     *
     * crearObjeto
     * Funcion utilizada para crear el objeto
     *@param tipo, string con el nombre del tipo del objeto
     *@return, buleano para dcir se puede
     *
     */
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
    
    /*
     *
     * espacioMemoriaObjeto
     * Funcion utilizada para darle espacios de memoria a los objetos
     *@param tipo, entero del tipo de memoria que se creara, tam, entero de lo que se aumentara
     *@return, regresa el espacio de var
     *
     */
    int espacioMemoriaObjeto(int tipo,int tam){

        switch (tipo) {
            case 0:
                memoria.cantBanObj+=tam;
                return memoria.cantBanObj=tam;
                break;
            case 1:
                memoria.cantEntObj+=tam;
                return memoria.cantEntObj=tam;
                break;
            case 2:
                memoria.cantDecObj+=tam;
                return memoria.cantDecObj=tam;
                break;
            case 3:
                memoria.cantTexObj+=tam;
                return memoria.cantTexObj=tam;
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
    
    /*
     *
     * agregaParametro
     * Funcion para agregar parametros en compilacion
     *@param tipo, string con el nombre del tipo, id, string con el id de variable, direccion, entero con la direccion real de este
     *@return, buleano que informa si se pudo crear.
     *
     */
    bool agregaParametro (string tipo, string id, int direccion){
        if (crearVariable(tipo,id,false,direccion)){
            vBloques[bloqueAct].vParam.push_back(varNo-1);//-1 porque en crearVariable se le suma uno
            return true;
        }
        return false;
    }
    

    int buscaVariableObj(int bloque, string id){
        for (int i = 0 ; i < vBloques[bloque].vVar.size();i++){
            int iVar = vBloques[bloque].vVar[i];
            if (vVariables[iVar].id==id){
                return iVar;
            }
        }
        return -1;
    }
   
    int buscaBloque(int iVar){
        return vVariables[iVar].bloque;
    }
   
    int buscaDireccion(int iVar){
        return vVariables[iVar].direccion;
    }
    int buscaEstructura(int iVar){
        return vVariables[iVar].estructura;
    }

    int checaTipoVarObj(int iVar){
        return vVariables[iVar].tipo;
    }

    /*
     *
     * comienzaArgumentos
     * Funcion utilizada para darle comienzo al conteo de argumentos y definicion
     *@param tipo, entero con el index del tipo, metodo, string con nombre del metodo en bloque
     *@return, buleado que regresa si se puede hacer el argumento, si es una variable
     *
     */
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
    
    /*
     *
     * terminaArgumentos
     * Funcion utilizada en ejecucion al terminar de leer argumentos que regresa si estuvieron correctos
     *@return, buleano que dice si la definicion de los objetos estuvo bien declarada
     *
     */
    bool terminaArgumentos(){
        if (pilaArgumentos.empty()){
            return true;
        }
        int cantidadArg=(int)vBloques[pilaArgumentos.back().first].vParam.size();
        int argChecados=pilaArgumentos.back().second;
        pilaArgumentos.pop_back();
        if (argChecados<cantidadArg){
            return false;
        }
        return true;
    }
    
    /*
     *
     * checaArgumentoTipo
     * Funcion utilizada que regresa si el argumento fue bien enviado por tipo
     *@param tipo, entero que representa el tipo de variable en arguemnto
     *@return, boolean que representa error si no se pudo
     *
     */
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
    
    /*
     *
     * buscaDireccion
     * Funcion utilizada que regresa la direccion de una id de variable
     *@param id, string con el nombre identificador de la variable
     *@return, entero que regresa el index de variable en arr<variable>
     *
     */
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
        v.tam = 1;
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
        //bloqueTipo.push_back(sigBloque);
        tipos.push_back("Funcion");//placeholder para mantener el orden de la relacion tipos, tipoBloque, vBloques
        pilaBloques.push_back(sigBloque);
        bloqueAct = sigBloque;
        varNo++;
        return true;
    }
    
    /*
     
     METODOS DE DIRECCIONES *ERA*
     
     */
    /*
     *
     * copiaDireccionesObj
     * Funcion parte del era de objeto para copiar direcciones reales y de memoria
     *@param tipo, entero que da el tipo, espacio, entero que da el index y val que da el lugar
     *
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
    
    /*
     *
     * copiaDireccionesFunc
     * Funcion utilizada que regresa la direccion de una id de variable
     *@param tipo, entero que tiene el tipo y epacio quenecesito
     *@return, entero que regresa el index de variable en la creacion de memo
     *
     */
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
    
    /*
     *
     * copiaDireccionesFuncRet
     * Funcion utilizada que regresa la direccion de una id de variable
     *@param tipo, entero que tiene el tipo y epacio quenecesito
     *@return, entero que regresa el index de variable en la creacion de memo
     *
     */
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
    
    /*
     *
     * quitaEspacio
     * Funcio que quita los ejmplos que tengo entre los objetos
     *@param tipo, entero que tiene el tipo y tamaño a borrar LO que necesito
     *
     */
    void quitaEspacio(int tipo, int tam){
        switch (tipo) {
            case 0:
                memoria.banLocActual-=tam;
                break;
            case 1:
                memoria.entLocActual-=tam;
                break;
            case 2:
                memoria.decLocActual-=tam;
                break;
            case 3:
                memoria.texLocActual-=tam;
                break;
            case 4:
                break;
            default:
                break;
        }
    }
    
    /*
     *
     * subsDireccionesObj
     * Funcion que simula un era de variable
     *@param dir, direccion a memoria del entero
     *
     */
    //clase para copiar el estado actual del vector
    void subsDireccionesObj(int dir){
        int tam = (int)vObjetos[dir].dirReales.size();
        for (int i = 0 ; i < tam ; i++){
            for (int j = 0 ; j < vObjetos[dir].tams[i];i++){
                copiaDireccionesObj(vObjetos[dir].tipos[i],vObjetos[dir].dirCuadruplo[i]+j,vObjetos[dir].dirReales[i]+j);
            }
        }
    }
    
    /*
     *
     * era
     * Funcion que guarda variables antiguasy genera un nuevo espacio de stack
     *@param bloque, entero que tiene el identificador al arreglo de bloques
     *
     */
    void era(int bloque){
        
        pilaBloques.push_back(bloque);
        Objeto funcion;
        funcion.tipos.resize(vBloques[bloque].vVar.size());
        funcion.tams.resize(vBloques[bloque].vVar.size());
        funcion.dirCuadruplo.resize(vBloques[bloque].vVar.size());
        funcion.dirReales.resize(vBloques[bloque].vVar.size());
        int iVar;
        for (int i = 0 ; i < funcion.tipos.size() ; i++){
            
            iVar=vBloques[bloque].vVar[i];
            funcion.tipos[i]=vVariables[iVar].tipo;
            funcion.dirCuadruplo[i]=vVariables[iVar].direccion;
            funcion.tams[i]=vVariables[iVar].tam;
            for (int j = 0 ; j < vVariables[iVar].tam; j++){
                funcion.dirReales[i]=copiaDireccionesFunc(vVariables[iVar].tipo,vVariables[iVar].direccion+j);
            }
        }
        vFunciones.push_back(funcion);
    }
    
    /*
     *
     * retorno
     * Funcion utilizada para hacer la hacer pop al estado atual
     *
     */
    void retorno(){
        int dir=(int)vFunciones.size()-1;
        int tam = (int)vFunciones[dir].dirReales.size();
        for (int i = 0 ; i < tam ; i++){
            quitaEspacio(vFunciones[dir].tipos[i],vFunciones[dir].tams[i]);
        }
        vFunciones.pop_back();
        pilaBloques.pop_back();
        dir--;
        if (dir>=0){
            tam = (int)vFunciones[dir].dirReales.size();
            for (int i = 0 ; i < tam ; i++){
                for (int j = 0 ; j < vFunciones[dir].tams[i]; j++){
                    copiaDireccionesFuncRet(vFunciones[dir].tipos[i],vFunciones[dir].dirCuadruplo[i]+j,vFunciones[dir].dirReales[i]+j);
                }
            }
        }
    }
    
    
    
    int direccionArgumento(int bloque, int index){
        return vVariables[vBloques[bloque].vParam[index]].direccion;
    }
    /*
     
     METODOS DE OBJETOS Y FUNCIONES
     
     */
    
    /*
     *
     * terminaBloque()
     * termina la candtidad de bloques a -1
     *
     */
    void terminaBloque(){
        pilaBloques.pop_back();
        bloqueAct=pilaBloques.back();
    }
    
    /**
     * nombreVariable
     * Metodo que dado una direccion me regresa el nombre de una variable
     * @param  direccion de la variable a buscar
     * @return           nombre de la variable
     */
    string nombreVariable(int direccion){
        for (int i = 0 ; i < vVariables.size();i++){
            if (vVariables[i].direccion==direccion)
                return vVariables[i].id;
        }
        return "-1";
    }

    /*
     *
     * dameCuadruplo
     * Funcion utilizada que regresa las dimensiones de su cuadruplo
     *@param bloque, entero espacio indez
     *@return, entero que regresa el index de variable en la creacion de memo
     *
     */
    int dameCuadruplo(int bloque){
        return vBloques[bloque].direccionCuadruplo;
    }
    
    /*
     
     METODOS DE MEMORIA
     
     */
    
    /*
     *
     * inicializaMemoria()
     * Funcion utilizada que cuenta as variables por tipo de clase y luego les da el espacio de memoria
     *
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