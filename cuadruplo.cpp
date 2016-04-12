
#include <iostream>

using namespace std;

class Cuadruplo{
	private:
		
		string op;
		string der;
		string izq;
		string res;


	public:
		

		string getOp();
		string getDer();
		string getIzq();
		string getRes();
		void setOp(string op);
		void setDer(string der);
		void setIzq(string izq);
		void setRes(string res);

		Cuadruplo(string opp, string izqq, string derr, string ress);


		
};


string Cuadruplo ::  getOp() {
	return op;
};

string Cuadruplo :: getDer() {
	return der;
}

string Cuadruplo :: getIzq() {
	return izq;
}

string Cuadruplo :: getRes() {
	return res;
}

void Cuadruplo :: setOp(string opp) {
	op = opp;
}

void Cuadruplo :: setDer(string derr) {
	der = derr;
}
void Cuadruplo :: setIzq(string izqq) {
	izq = izqq;
}
void Cuadruplo :: setRes(string ress) {
	res = ress;
}
Cuadruplo :: Cuadruplo(string opp, string izqq, string derr, string ress) {
		op = opp;
		der = derr;
		izq = izqq;
		res = ress;
}

