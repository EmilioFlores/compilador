
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
		void setOp(string op);
		void setDer(int der);
		void setIzq(int izq);
		void setRes(int res);

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

void Cuadruplo :: setOp(string opp) {
	op = opp;
}

void Cuadruplo :: setDer(int derr) {
	der = derr;
}
void Cuadruplo :: setIzq(int izqq) {
	izq = izqq;
}
void Cuadruplo :: setRes(int ress) {
	res = ress;
}
Cuadruplo :: Cuadruplo(string opp, int izqq, int derr, int ress) {
		op = opp;
		der = derr;
		izq = izqq;
		res = ress;
}

