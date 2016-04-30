

    //Metodo que inicializara los vectores de memoria dependiendo de la memoria estatica necesaria
    Memoria :: void inicializa(){
        
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
    Memoria :: int pideEntero(int dir){
        cout << "Direccion recibida: " << dir << " Tamaño: " << enteros.size() << endl;

        return enteros[dir];
    }
    Memoria ::  bool pideBandera(int dir){
        return banderas[dir];
    }
    Memoria ::  double pideDecimal(int dir){
        return decimales[dir];
    }
    Memoria :: string pideTexto(int dir){
        return textos[dir];
    }
    
    Memoria :: int pideEnteroTemp(int dir){
        return enterosTemp[dir];
    }
    Memoria ::  bool pideBanderaTemp(int dir){
        return banderasTemp[dir];
    }
    Memoria :: double pideDecimalTemp(int dir){
        return decimalesTemp[dir];
    }
    Memoria :: string pideTextoTemp(int dir){
        return textosTemp[dir];
    }
    
    Memoria :: int pideEnteroLoc(int dir){
        return enterosLoc[dir];
    }
    Memoria ::  bool pideBanderaLoc(int dir){
        return banderasLoc[dir];
    }
    Memoria :: double pideDecimalLoc(int dir){
        return decimalesLoc[dir];
    }
    Memoria :: string pideTextoLoc(int dir){
        return textosLoc[dir];
    }
    
    //Metodos que asignan contenido a la memoria
    Memoria :: bool guardaEntero(int dir, int val){
        if (dir >= enteros.size()){
            return false;
        }
        enteros[dir]=val;
        return true;
    }
    Memoria :: bool guardaBandera(int dir, bool val){
        if (dir >= banderas.size()){
            return false;
        }
        banderas[dir]=val;
        return true;
    }
    Memoria :: bool guardaDecimal(int dir, double val){
        if (dir >= decimales.size()){
            return false;
        }
        decimales[dir]=val;
        return true;
    }
    Memoria :: bool guardaTexto(int dir, string val){
        if (dir >= textos.size()){
            return false;
        }
        textos[dir]=val;
        return true;
    }
    
    Memoria :: bool guardaEnteroTemp(int dir, int val){
        if (dir >= enterosTemp.size()){
            return false;
        }
        enterosTemp[dir]=val;
        return true;
    }
    Memoria :: bool guardaBanderaTemp(int dir, bool val){
        if (dir >= banderasTemp.size()){
            return false;
        }
        banderasTemp[dir]=val;
        return true;
    }
    Memoria :: bool guardaDecimalTemp(int dir, double val){
        if (dir >= decimalesTemp.size()){
            return false;
        }
        decimalesTemp[dir]=val;
        return true;
    }
    Memoria :: bool guardaTextoTemp(int dir, string val){
        if (dir >= textosTemp.size()){
            return false;
        }
        textosTemp[dir]=val;
        return true;
    }
    
    Memoria :: bool guardaEnteroLoc(int dir, int val){
        if (dir >= enterosLoc.size()){
            return false;
        }
        enterosLoc[dir]=val;
        return true;
    }
    Memoria :: bool guardaBanderaLoc(int dir, bool val){
        if (dir >= banderasLoc.size()){
            return false;
        }
        banderasLoc[dir]=val;
        return true;
    }
    Memoria :: bool guardaDecimalLoc(int dir, double val){
        if (dir >= decimalesLoc.size()){
            return false;
        }
        decimalesLoc[dir]=val;
        return true;
    }
    Memoria :: bool guardaTextoLoc(int dir, string val){
        if (dir >= textosLoc.size()){
            return false;
        }
        textosLoc[dir]=val;
        return true;
    }


//Metodos Direcciones Funciones
    Memoria :: int pideDirEnteroFunc(int dir){
        return enterosDirFunc[dir];
    }
    Memoria :: int pideDirBanderaFunc(int dir){
        return banderasDirFunc[dir];
    }
    Memoria :: int pideDirDecimalFunc(int dir){
        return decimalesDirFunc[dir];
    }
    Memoria :: int pideDirTextoFunc(int dir){
        return textosDirFunc[dir];
    }
    Memoria :: bool guardaEnterosDirFunc(int dir, int val){
        if (dir >= enterosDirFunc.size()){
            return false;
        }
        enterosDirFunc[dir]=val;
        return true;
    }
    Memoria :: bool guardaBanderasDirFunc(int dir, int val){
        if (dir >= banderasDirFunc.size()){
            return false;
        }
        banderasDirFunc[dir]=val;
        return true;
    }
    Memoria :: bool guardaDecimalesDirFunc(int dir, int val){
        if (dir >= decimalesDirFunc.size()){
            return false;
        }
        decimalesDirFunc[dir]=val;
        return true;
    }
    Memoria :: bool guardaTextosDirFunc(int dir, int val){
        if (dir >= textosDirFunc.size()){
            return false;
        }
        textosDirFunc[dir]=val;
        return true;
    }

    
    //Metodos objetos
    //Metodos que regresan el espacio de memoria
    Memoria :: int pideDirEnteroObj(int dir){
        return enterosDirObj[dir];
    }
    Memoria :: int pideDirBanderaObj(int dir){
        return banderasDirObj[dir];
    }
    Memoria :: int pideDirDecimalObj(int dir){
        return decimalesDirObj[dir];
    }
    Memoria :: int pideDirTextoObj(int dir){
        return textosDirObj[dir];
    }
    Memoria :: int pideDirObjetoObj(int dir){
        return objetosDirObj[dir];
    }
    Memoria :: int pideEnteroObj(int dir){
        return enterosObj[dir];
    }
    Memoria :: bool pideBanderaObj(int dir){
        return banderasObj[dir];
    }
    Memoria :: double pideDecimalObj(int dir){
        return decimalesObj[dir];
    }
    Memoria :: string pideTextoObj(int dir){
        return textosObj[dir];
    }
    
    //Metodos que asignan contenido a la memoria
    Memoria :: bool guardaEnterosDirObj(int dir, int val){
        if (dir >= enterosDirObj.size()){
            return false;
        }
        enterosDirObj[dir]=val;
        return true;
    }
    Memoria :: bool guardaBanderasDirObj(int dir, int val){
        if (dir >= banderasDirObj.size()){
            return false;
        }
        banderasDirObj[dir]=val;
        return true;
    }
    Memoria :: bool guardaDecimalesDirObj(int dir, int val){
        if (dir >= decimalesDirObj.size()){
            return false;
        }
        decimalesDirObj[dir]=val;
        return true;
    }
    Memoria :: bool guardaTextosDirObj(int dir, int val){
        if (dir >= textosDirObj.size()){
            return false;
        }
        textosDirObj[dir]=val;
        return true;
    }
    Memoria :: bool guardaObjetosDirObj(int dir, int val){
        if (dir >= objetosDirObj.size()){
            return false;
        }
        objetosDirObj[dir]=val;
        return true;
    }
    
    Memoria :: bool guardaEnteroObj(int dir, int val){
        if (dir >= enterosObj.size()){
            return false;
        }
        enterosObj[dir]=val;
        return true;
    }
    Memoria :: bool guardaBanderaObj(int dir, bool val){
        if (dir >= banderasObj.size()){
            return false;
        }
        banderasObj[dir]=val;
        return true;
    }
    Memoria :: bool guardaDecimalObj(int dir, double val){
        if (dir >= decimalesObj.size()){
            return false;
        }
        decimalesObj[dir]=val;
        return true;
    }
    Memoria :: bool guardaTextoObj(int dir, string val){
        if (dir >= textosObj.size()){
            return false;
        }
        textosObj[dir]=val;
        return true;
    }