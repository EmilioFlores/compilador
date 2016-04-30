#ifndef OPERACIONES_H
#define OPERACIONES_H
void plus_op(Cuadruplo current);
void minus_op(Cuadruplo current);
void times_op(Cuadruplo current);
void divide_op(Cuadruplo current);
void equal_op(Cuadruplo current);
void notequal_op(Cuadruplo current);
void more_op(Cuadruplo current);
void less_op(Cuadruplo current);
void moreeq_op(Cuadruplo current);
void lesseq_op(Cuadruplo current);
void or_op(Cuadruplo current);
void and_op(Cuadruplo current);

int pideEntero(int dir);
bool pideBandera(int dir);
string pideTexto(int dir);
double pideDecimal(int dir);
void guardaEntero(int dir, int valor);
void guardaBandera(int dir, int valor);
void guardaTexto(int dir, int valor);
void guardaDecimal(int dir, int valor);

#endif