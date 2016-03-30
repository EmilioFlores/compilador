string tipos[] = {"vacio","bandera","entero","gran entero","decimal","caracter","texto","funcion","metodo"};
vector <int> bloques;
int bloqueAct = 0;
int bloqueMax = 0;

struct variable{
	int tipo;
	int estructura;//0 variables, 1 funciones, 2 objetos
	int bloque;//por si es funcion u objeto
	bool publico;
};

class bloque{
	private:
		int tipo;
		string nombre;
		vector <variable> vVar;
		Trie arbol;
		vector<variable> param;
		variable retorno;
		int varNo;
		bool entonctro;
	public:
		bool crearVariable(int tipo, string id , bool publico){
			//checa si la variable esta usada
			if (arbol->search(id)){
				return false;
			}
			variable v;
			v.tipo = tipo;
			v.estructura = 0;
			v.bloque = -1;
			vVar.push(v);
			arbol->insert(id,bloqueAct);
			return true;
		};
		bool 

		  
};