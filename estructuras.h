
#ifndef ESTRUCTURAS_H
#define ESTRUCTURAS_H
struct constante
{
	int direccion;
	int tipo;
	string valor;
};


struct variable{
    int tipo;//< 5 si es de los tipos estandares, >= 5 si es un tipo definido
    string id;//nombre de la variable
    int estructura;//0 variables, 1 funciones, 2 objetos
    int bloque;//por si es funcion u objeto
    int direccion; //direccion a la base de datos
    bool privacidad;//true si es publico, false si es privado
    vector<pair<int,int>> dimensiones;// primero es el tam de la dimension, segundo es el M
    int tam;
};
struct Objeto{
    vector<int> tams;
    vector<int> tipos;//tipos de direcciones a sustituir
    vector<int> dirCuadruplo;//Direciones a sustituir
    vector<int> dirReales;//direciones reales de objeto  *en caso de ser un objeto->
    //sera direccion al mismo arreglo de objetos
};


struct bloque{
    int tipo;
    string estructura = "bloque";
    string nombre;//para saber cual es y donde pertenece
    string padre;//para saber si lo invoco un objeto
    vector <int> vVar;//Variables del bloque
    vector <int> vParam;//Parametros (en caso de que sea un metodo)
    //vector <int> vBloquesSup;//Bloques superiores del bloque en cuestion (ayuda a buscar variables globales que puedan ser usadas en el bloque)
    int direccionCuadruplo;
    int inMemoria[4];//Variable para inicializar la memoria con las cantidades
};



#endif