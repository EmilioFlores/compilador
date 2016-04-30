#ifndef CUADRUPLO_H
#define CUADRUPLO_H

#include <iostream>
#include <string>
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

#endif