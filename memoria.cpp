

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


//Metodos Direcciones Funciones
    int pideDirEnteroFunc(int dir){
        return enterosDirFunc[dir];
    }
    int pideDirBanderaFunc(int dir){
        return banderasDirFunc[dir];
    }
    int pideDirDecimalFunc(int dir){
        return decimalesDirFunc[dir];
    }
    int pideDirTextoFunc(int dir){
        return textosDirFunc[dir];
    }
    bool guardaEnterosDirFunc(int dir, int val){
        if (dir >= enterosDirFunc.size()){
            return false;
        }
        enterosDirFunc[dir]=val;
        return true;
    }
    bool guardaBanderasDirFunc(int dir, int val){
        if (dir >= banderasDirFunc.size()){
            return false;
        }
        banderasDirFunc[dir]=val;
        return true;
    }
    bool guardaDecimalesDirFunc(int dir, int val){
        if (dir >= decimalesDirFunc.size()){
            return false;
        }
        decimalesDirFunc[dir]=val;
        return true;
    }
    bool guardaTextosDirFunc(int dir, int val){
        if (dir >= textosDirFunc.size()){
            return false;
        }
        textosDirFunc[dir]=val;
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