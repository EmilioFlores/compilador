# Lesp. Lenguaje en español.

El proposito del lenguaje es ayudar a aquellas personas que batallan con el lenguaje del ingles y quieren aprender a realizar código, de una manera fácil, minimalista y rápida.

Primeramente para instalar el lenguaje se requiere [descargar este repositorio](https://github.com/EmilioFlores/compilador/archive/master.zip)

Posteriormente instalar Flex, Bison  y asegurarse de tener un compilador que compile código en C++. 

Colocarse en la carpeta de descarga de este repositorio y ejecutar el siguiente comando en la linea terminal
```terminal
  bison -d parser.y; flex scanner.l ; g++ -std=c++11 lex.yy.c parser.tab.c -lfl -o Lesp
```

Por último, para probar que se haya instalado correctamente puedes verificar corriendo la siguiente linea de código.
```terminal
    Lesp bubbleSort.txt
```


| Tipo        | Declaracion           | Ejemplo  |
| ------------- |:-------------:| -----:|
| Booleano      | bandera | 0 o 1 |
| Entero      | entero   |  1234, 546, -54 |
| Numero flotante | decimal      |    0.054, 3.1416 |
| Texto | texto      |  "hola", "como estas" |

Como en todos los lenguajes, lo primero que se aprende es como hacer tu primer hola mundo!

```javacript
programa { 
  muestraLinea("Hola Mundo!");
}
```

####Definicioes de variables en Lesp
```javascript
programa {


 var entero x; 
 x = 10;
 muestraLinea(x);

}
```

*resultado: 10*


####Definicioes de un arreglo en Lesp
```javascript
programa {

    var entero x[20]; 
    var entero unaDimension[10]; 
    x[2]=3;
    x[1]=2;
    x[0]=1;
    muestraLinea(x[0], “ “, x[1], “ “,  [2]);

}
```




*resultado: 1  2  3*


####Condiciones
```javascript

programa {

   var entero x=0; 
   Condicion ( x > 0 ){
         x = x + 5;
    } fallo {
         x = x + 10;
    }
  muestraLinea(x);
}
```

*resultado: 10*

```javascript
programa {

  var entero i;
  ciclo ( i = 0, i < 5, i = i + 1){
         muestraLinea(i);
  }

}

```
*resultado: 0 1 2 3 4 5* 


####Funciones
```javascript

funcion entero fibIterativo(entero n)
{
     var entero a ; 
     var entero b ;
     var entero c ;
     var entero i ;
     a = 1;
     b = 1;

     ciclo (i = 3 ; i < n ; i = i +1){
         c = a + b;
         a = b;
         b = c;
     };

     regresa b;
};

funcion entero fibRecursivo(entero n)
{
     var entero ramaIzquierda;
     var entero ramaDerecha;
     condicion(n == 0){
           n = 0;
     } fallo {
               condicion(n < 3){
                      n = 1 ;
               } fallo {
                    ramaIzquierda = fibRecursivo(n - 1);
                    ramaDerecha = fibRecursivo(n - 2);
                    n = ramaIzquierda + ramaDerecha;             
     };
     regresa n;
};

programa {

     var entero x;
     var entero y;
     var entero z;
     z = 10;
     x = fibIterativo(z);
     y = fibRecursivo(z);

     muestraLinea(“Fibonacci iterativo: ”x);
     muestraLinea(“También recursivo!: ”y);
}

```

*Resultado: Fibonacci iterativo: 55*
*Tambien Recursivo!: 55*

```javascript
cbjeto Cosa {
        privado {
        }
        publico {
               var entero x;
               var entero y;
               funcion entero suma (){
                         regresa (x + y);
    
        }
};

Programa{
      Cosa coso;
      coso.x = 1;
      coso.y = 1;
      muestraLinea(coso.suma());
}
```

*resultado: 2*
