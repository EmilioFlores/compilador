
#include "operaciones.h"


/**
    pideEntero
    Metodo que ependiendo del scope regresa el valor del entero que se pide
    @param dir, direccion del entero en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor del entero conseguido en memoria
**/
int pideEntero (int dir) { 
    int scope = getScope(dir); 
    int valor = -1;
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideEntero( dir - OFF_ENT_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideEntero( dir - OFF_ENT_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideEntero( dir - OFF_ENT_CONST );
        break;
        case _FUNCION:
                
                valor =  memoria.pideEnteroLoc(  memoria.pideDirEnteroFunc( dir - OFF_ENT_DIR_FUNCION ));
        break;
        case _OBJETO:

                valor =  memoria.pideEnteroObj(  memoria.pideDirEnteroObj( dir - OFF_ENT_DIR_OBJ ));
                
        break;

    }
    return valor;
}

/**
    pideBandera
    Metodo que ependiendo del scope regresa el valor del bandera que se pide
    @param dir, direccion del bandera en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor de la bandera conseguido en memoria
**/
bool pideBandera (int dir) { 

    int scope = getScope(dir);
    bool valor = false;
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideBandera( dir - OFF_BAND_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideBandera( dir - OFF_BAND_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideBandera( dir - OFF_BAND_CONST );
        break;
        case _FUNCION:
                
                valor =  memoria.pideBanderaLoc(  memoria.pideDirBanderaFunc( dir - OFF_BAND_DIR_FUNCION ));
        break;
        case _OBJETO:

                valor =  memoria.pideBanderaObj(  memoria.pideDirBanderaObj( dir - OFF_BAND_DIR_OBJ ));
                
        break;

    }
    return valor;
}

/**
    pideTexto
    Metodo que ependiendo del scope regresa el valor del texto  que se pide
    @param dir, direccion del texto en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor de la texto conseguido en memoria
**/
string pideTexto (int dir) { 

    int scope = getScope(dir);
    string valor = "";
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideTexto( dir - OFF_TEXT_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideTexto( dir - OFF_TEXT_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideTexto( dir - OFF_TEXT_CONST );
        break;
        case _FUNCION:
                
                valor =  memoria.pideTextoLoc(  memoria.pideDirTextoFunc( dir - OFF_TEXT_DIR_FUNCION ));
        break;
        case _OBJETO:

                valor =  memoria.pideTextoObj(  memoria.pideDirTextoObj( dir - OFF_TEXT_DIR_OBJ ));
                
        break;

    }
    return valor;
}

/**
    pideDecimal
    Metodo que ependiendo del scope regresa el valor del decimal que se pide
    @param dir, direccion del decimal en cuadruplo
    @param scope, scope de la variable a conseguir
    @return el valor de la decimal conseguido en memoria
**/
double pideDecimal (int dir) { 

    int scope = getScope(dir);
    double valor = -1.0;
    switch (scope) {
        case _GLOBAL:
                valor =  memoria.pideDecimal( dir - OFF_DEC_GLOBAL );
        break;
        case _TEMPORAL: 
                valor =  memoria.pideDecimal( dir - OFF_DEC_TEMP );
                
        break;
        case _CONSTANTE: 
                valor =  memoria.pideDecimal( dir - OFF_DEC_CONST );
        break;
        case _FUNCION:
                
                valor =  memoria.pideDecimalLoc(  memoria.pideDirDecimalFunc( dir - OFF_DEC_DIR_FUNCION ));
        break;
        case _OBJETO:

                valor =  memoria.pideDecimalObj(  memoria.pideDirDecimalObj( dir - OFF_DEC_DIR_OBJ ));
                
        break;

    }
    return valor;
}


/**
    guardaEntero
    Metodo que dependiendo del scope guarda la variable entera en la memoria correspondiente
    @param dir, direccion del entero en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaEntero (int dir, int valor) { 

    int scope = getScope(dir);
    switch (scope) {
        case _GLOBAL:
                memoria.guardaEntero( dir - OFF_ENT_GLOBAL , valor );
        break;
        case _TEMPORAL: 
                memoria.guardaEntero( dir - OFF_ENT_TEMP , valor );
        break;
        case _CONSTANTE: 
                memoria.guardaEntero( dir - OFF_ENT_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaEnteroLoc(  memoria.pideDirEnteroFunc( dir - OFF_ENT_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaEnteroObj(  memoria.pideDirEnteroObj( dir - OFF_ENT_DIR_OBJ), valor );
        break;

    }
}

/**
    guardaBandera
    Metodo que dependiendo del scope guarda la variable booleana en la memoria correspondiente
    @param dir, direccion del booleana en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaBandera (int dir, bool valor) { 

    int scope = getScope(dir);
    switch (scope) {
        case _GLOBAL:
                memoria.guardaBandera( dir - OFF_BAND_GLOBAL , valor );
        break;
        case _TEMPORAL: 
                memoria.guardaBandera( dir - OFF_BAND_TEMP , valor );
        break;
        case _CONSTANTE: 
                memoria.guardaBandera( dir - OFF_BAND_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaBanderaLoc(  memoria.pideDirBanderaFunc( dir - OFF_BAND_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaBanderaObj(  memoria.pideDirBanderaObj( dir - OFF_BAND_DIR_OBJ), valor );
        break;

    }
}

/**
    guardaDecimal
    Metodo que dependiendo del scope guarda la variable decimal en la memoria correspondiente
    @param dir, direccion del decimal en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaDecimal (int dir, double valor) { 

    int scope = getScope(dir);

    switch (scope) {
        case _GLOBAL:
                memoria.guardaDecimal( dir - OFF_DEC_GLOBAL , valor );
        break;
        case _TEMPORAL: 
                memoria.guardaDecimal( dir - OFF_DEC_TEMP , valor );
        break;
        case _CONSTANTE: 
                memoria.guardaDecimal( dir - OFF_DEC_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaDecimalLoc(  memoria.pideDirDecimalFunc( dir - OFF_DEC_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaDecimalObj(  memoria.pideDirDecimalObj( dir - OFF_DEC_DIR_OBJ), valor );
        break;

    }
}



/**
    guardaTexto
    Metodo que dependiendo del scope guarda la variable texto en la memoria correspondiente
    @param dir, direccion del texto en cuadruplo
    @param scope, scope de la variable a guardar
**/
void guardaTexto (int dir, string valor) { 

    int scope = getScope(dir);

    switch (scope) {
        case _GLOBAL:
                memoria.guardaTexto( dir - OFF_TEXT_GLOBAL , valor );
        break;
        case _TEMPORAL: 
                memoria.guardaTexto( dir - OFF_TEXT_TEMP , valor );
        break;
        case _CONSTANTE: 
                memoria.guardaTexto( dir - OFF_TEXT_CONST , valor ); 
        break;
        case _FUNCION:
                memoria.guardaTextoLoc(  memoria.pideDirTextoFunc( dir - OFF_TEXT_DIR_FUNCION), valor );
        break;
        case _OBJETO:
                memoria.guardaTextoObj(  memoria.pideDirTextoObj( dir - OFF_TEXT_DIR_OBJ), valor );
        break;

    }
}





/**
 * plus_op
 * Funcion utilizada para llevar a cabo la suma de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void plus_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i+d==2){
        iRes = pideEntero(dirIzq) + pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;
    }
    if (i+d==4){
          dRes = pideDecimal(dirIzq) + pideDecimal(dirDer);
      }
        if (i=2){
            dRes = pideDecimal(dirIzq) + pideEntero(dirDer);
        }
        else{
          dRes = pideDecimal(dirDer) + pideEntero(dirIzq);
    }
    guardaDecimal(dirRes,dRes);
}

/**
 * minus_op
 * Funcion utilizada para llevar a cabo la resta de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void minus_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i+d==2){
        iRes = pideEntero(dirIzq) - pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;
    }
    if (i+d==4){
        dRes = pideDecimal(dirIzq) - pideDecimal(dirDer);
    }
    if (i=2){
        dRes = pideDecimal(dirIzq) - pideEntero(dirDer);
    }
    else{
        dRes = pideEntero(dirIzq) - pideDecimal(dirDer);
    }
    guardaDecimal(dirRes,dRes);
}

/**
 * times_op
 * Funcion utilizada para llevar a cabo la multiplicacion de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void times_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i+d==2){
        iRes = pideEntero(dirIzq) * pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;
    }
    if (i+d==4){
        dRes = pideDecimal(dirIzq) * pideDecimal(dirDer);
    }
    if (i=2){
        dRes = pideDecimal(dirIzq) * pideEntero(dirDer);
    }
    else{
        dRes = pideEntero(dirIzq) * pideDecimal(dirDer);
    }
    guardaDecimal(dirRes,dRes);
}

/**
 * divide_op
 * Funcion utilizada para llevar a cabo la division de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void divide_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    int iRes;
    double dRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i+d==2){
        iRes = pideEntero(dirIzq) / pideEntero(dirDer);
        guardaEntero(dirRes,iRes);
        return;
    }
    if (i+d==4){
        dRes = pideDecimal(dirIzq) / pideDecimal(dirDer);
    }
    if (i=2){
        dRes = pideDecimal(dirIzq) / pideEntero(dirDer);
    }
    else{
        dRes = pideEntero(dirIzq) / pideDecimal(dirDer);
    }
    guardaDecimal(dirRes,dRes);
}

/**
 * equal_op
 * Funcion utilizada para llevar a cabo la operacion logica de == de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void equal_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 6){
        bRes=(pideTexto(dirIzq) == pideTexto(dirDer));
    }
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) == pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) == pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) == pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) == pideEntero(dirDer));
    }
    if (i + d == 4){
        bRes=(pideDecimal(dirIzq) == pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * notequal_op
 * Funcion utilizada para llevar a cabo la operacion logica de != de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void notequal_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 6){
        bRes=(pideTexto(dirIzq) == pideTexto(dirDer));
    }
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) != pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) != pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) != pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) != pideEntero(dirDer));
    }
    if (i + d == 4){
        bRes=(pideDecimal(dirIzq) != pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * more_op
 * Funcion utilizada para llevar a cabo la operacion logica de > de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void more_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) > pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) > pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) > pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) > pideEntero(dirDer));
    }
    if (i + d == 4){
        bRes=(pideDecimal(dirIzq) > pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * less_op
 * Funcion utilizada para llevar a cabo la operacion logica de < de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void less_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) < pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) < pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) < pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) < pideEntero(dirDer));
    }
    if (i + d == 4){
        bRes=(pideDecimal(dirIzq) < pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * moreeq_op
 * Funcion utilizada para llevar a cabo la operacion logica de >= de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void moreeq_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) >= pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) >= pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) >= pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) >= pideEntero(dirDer));
    }
    if (i + d == 4){
        bRes=(pideDecimal(dirIzq) >= pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * lesseq_op
 * Funcion utilizada para llevar a cabo la operacion logica de <= de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void lesseq_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    int i,d,r;
    bool bRes;
    i=getTipoDireccion(dirIzq,getScope(dirIzq));
    d=getTipoDireccion(dirDer,getScope(dirDer));
    r=getTipoDireccion(dirRes,getScope(dirRes));
    if (i + d == 3){
        if (i=2){
            bRes = (pideDecimal(dirIzq) <= pideEntero(dirDer));
        }
        else{
            bRes = (pideEntero(dirIzq) <= pideDecimal(dirDer));
        }
    }
    if (i + d == 0){
        bRes=(pideBandera(dirIzq) <= pideBandera(dirDer));
    }
    if (i + d == 2){
        bRes=(pideEntero(dirIzq) <= pideEntero(dirDer));
    }
    if (i + d == 4){
        bRes=(pideDecimal(dirIzq) <= pideDecimal(dirDer));
    }
    guardaBandera(dirRes,bRes);
}

/**
 * or_op
 * Funcion utilizada para llevar a cabo la operacion logica de || de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void or_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    bool bRes;
    bRes=(pideBandera(dirIzq) || pideBandera(dirDer));
    guardaBandera(dirRes,bRes);
}

/**
 * and_op
 * Funcion utilizada para llevar a cabo la operacion logica de && de dos operandos
 * @param cuadruplo, representando el cuadruplo actual
 */
void and_op(Cuadruplo current){
    int dirIzq = atoi(current.getIzq().c_str());
    int dirDer = atoi(current.getDer().c_str());
    int dirRes = atoi(current.getRes().c_str());
    bool bRes;
    bRes=(pideBandera(dirIzq) && pideBandera(dirDer));
    guardaBandera(dirRes,bRes);
}

