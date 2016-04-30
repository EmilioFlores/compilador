#ifndef MEMORIA_H
#define MEMORIA_H


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
    void inicializa();
    //Metodos que regresan el espacio de memoria
    int pideEntero(int dir);
    bool pideBandera(int dir);
    double pideDecimal(int dir);
    string pideTexto(int dir);
    
    int pideEnteroTemp(int dir);
    bool pideBanderaTemp(int dir);
    double pideDecimalTemp(int dir);
    string pideTextoTemp(int dir);
    
    int pideEnteroLoc(int dir);
    bool pideBanderaLoc(int dir);
    double pideDecimalLoc(int dir);
    string pideTextoLoc(int dir);
    
    //Metodos que asignan contenido a la memoria
    bool guardaEntero(int dir, int val);
    bool guardaBandera(int dir, bool val);
    bool guardaDecimal(int dir, double val);
    bool guardaTexto(int dir, string val);
    
    bool guardaEnteroTemp(int dir, int val);
    bool guardaBanderaTemp(int dir, bool val);
    bool guardaDecimalTemp(int dir, double val);
    bool guardaTextoTemp(int dir, string val);
    
    bool guardaEnteroLoc(int dir, int val);
    bool guardaBanderaLoc(int dir, bool val);
    bool guardaDecimalLoc(int dir, double val);
    bool guardaTextoLoc(int dir, string val);


//Metodos Direcciones Funciones
    int pideDirEnteroFunc(int dir);
    int pideDirBanderaFunc(int dir);
    int pideDirDecimalFunc(int dir);
    int pideDirTextoFunc(int dir);
    bool guardaEnterosDirFunc(int dir, int val);
    bool guardaBanderasDirFunc(int dir, int val);
    bool guardaDecimalesDirFunc(int dir, int val);
    bool guardaTextosDirFunc(int dir, int val);

    
    //Metodos objetos
    //Metodos que regresan el espacio de memoria
    int pideDirEnteroObj(int dir);
    int pideDirBanderaObj(int dir);
    int pideDirDecimalObj(int dir);
    int pideDirTextoObj(int dir);
    int pideDirObjetoObj(int dir);
    int pideEnteroObj(int dir);
    bool pideBanderaObj(int dir);
    double pideDecimalObj(int dir);
    string pideTextoObj(int dir);
    
    //Metodos que asignan contenido a la memoria
    bool guardaEnterosDirObj(int dir, int val);
    bool guardaBanderasDirObj(int dir, int val);
    bool guardaDecimalesDirObj(int dir, int val);
    bool guardaTextosDirObj(int dir, int val);
    bool guardaObjetosDirObj(int dir, int val);
    
    bool guardaEnteroObj(int dir, int val);
    bool guardaBanderaObj(int dir, bool val);
    bool guardaDecimalObj(int dir, double val);
    bool guardaTextoObj(int dir, string val);
    
    
};
#endif