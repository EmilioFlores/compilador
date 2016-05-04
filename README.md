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
