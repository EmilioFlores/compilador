
#include <iostream>

using namespace std;

class Cuadruplo{
	private:
		
		string op;
		int der;
		int izq;
		int res;


	public:
		

		string getOp();
		int getDer();
		int getIzq();
		int getRes();
		Cuadruplo(string opp, int izqq, int derr, int ress);


		
};


string Cuadruplo ::  getOp() {
	return op;
};

int Cuadruplo :: getDer() {
	return der;
}

int Cuadruplo :: getIzq() {
	return izq;
}

int Cuadruplo :: getRes() {
	return res;
}

Cuadruplo :: Cuadruplo(string opp, int izqq, int derr, int ress) {
		op = opp;
		der = derr;
		izq = izqq;
		res = ress;
}

