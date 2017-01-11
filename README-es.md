# UPNA | Procesadores del Lenguaje

__Authors:__ [Álvaro Orduna León](https://github.com/AlvaroOrduna) y [Iñigo Echavarri Beloqui](https://github.com/iechavarri)

__Description:__ proyecto realizado para la asignatura Procesadores del Lenguaje impartida en el Grado de Ingeniería Informática de la Universidad Pública de Navarra (UPNA).

__License:__ proyecto bajo la [licencia MIT](LICENSE)

## Uso

Existe un `Makefile` donde se encuentran todos los métodos para construir y probar el compilador.

La opción `verbose` permite construir el compilador con opciones que permiten un mejor seguimiento de lo que el sistema está realizando en cada momento.

Además, existen tres test, denominados `test1`, `test2` y `test3` que permiten ejecutar los tres algoritmos de prueba.

Así, podemos construir y probar el compilador del siguiente modo:

```sh
make clean [verbose] compiler
make clean [verbose] test1
make clean [verbose] test2
make clean [verbose] test3
```

## Logros

### Scanner

En primer lugar tenemos el _**scanner**_. Éste es capaz de reconocer todos los _tokens_ de la gramática al completo. Reconoce tanto palabras reservadas, como operadores, identificadores, comentarios, etc.

Además, es insensible a mayúsculas y minúsculas en el reconocimiento de palabras reservadas. Por el contrario, el _parser_ que veremos a continuación si que lo es al tratar variables.

Por último, comentar que es capaz de asociar los valores necesarios para el _parser_ en la variable _yylval_. En el caso de los literales, almacena el valor de ellos y en el de las variables, almacena el nombre de la misma. Por último, en el caso de los operadores relacionales, almacena el valor entero correspondiente con el operador, gracias a un _enum_ definido para ello.

La única variación con respecto a la especificación gramatical es que las variables booleanas deben comenzar por _b_ o _B_. Esto es debido a que necesitamos diferenciar en el _parser_ las expresiones booleanas de las aritméticas, siguiendo el modelo de _Fortran_.

### Parser

En segundo lugar, tenemos el _**parser**_. Éste recibe los _tokens_ del _scanner_ y va realizando reducciones conforme va reconocimendo las expresiones de la gramática.

Construye código en tres direcciones mediante una libraría denominada `quad_table` que almacena en una tabla de quadruplas. Este código es generado para las expresiones aritméticas y para las booleanas, así como las asignaciones de este tipo de expresiones y variables.

Las variables son almacenadas conforme se definen en el algoritmo en una tabla de símbolos definida en la librería `sym_table`.

El _**YYSTYPE**_ es un _union_, que puede contener literales (cadenas, caracter, entero, real y booleano), operadores y estructuras más complejas para almacenar expresiones y operandos.

En cuanto a la prioridad de los tokens, hemos definido algunas prioridades como por ejemplo la de los operadores aritméticos y su asociatividad. Esto nos ha llevado a tener un resultado final de 11 conflictos de tipo _desplazamiento/reducción_ y 3 de tipo _reducción/reducción_. Por las pruebas realizadas, estos conflictos parecen resolverse bien de manera autónoma y no afectan a la gramatica implementada.

Por último, el _parser_ es capaz de reconocer toda la estructura de cualquier algoritmo (al menos los testados) para la gramática dada. Es decir, diferencia las distintas secciones del programa, como son las zona de declaración, de instrucciones, etc.

### Estructuras y utlidades

Hemos generado diferentes librerías para el correcto funcionamiento del compilador.

- **structs**: define todas las estucturas, unions y enumerados necesarios en el resto de librerías, parser y scanner.
- **sym_table**: se encarga de gestionar y definir la tabla de símbolos y de las opareciones de la misma. Además, está preparada para poder ampliar su estructura, pudiendo incluir en el futuro funciones y tipos definidos por el ususario en el algoritmo.
- **quad_table**: es responsable de las operaciones realizadas contra la tabla de cuadruplas así como de su estructura, para generar el código en tres direcciones.
- **bool_utils**: aglutina las utilidades necesarias para las operaciones booleanas. Se decidió separar la librería para permitir, en un futuro, la ampliación de utilidades para las instrucciones en las que intervengan expresiones o variables booleanas.

### Gestión de errores y debug

Como complemento, hemos implementado un sistema por el cual los errores generados por el _parser_ intentan dar la máxima cantidad de información posible al usuario para que pueda corregir el error.

Además, también hemos implementado un sistema _verbose_ para poder ver en detalle el progreso realizado por el compilador. Al finalizar este modo, el sistema muestra las tablas de símbolos y cuadruplas.

## Distribución del trabajo

| Iñigo Echavarri | Álvaro Orduna |
|:---------------:|:-------------:|
|       40%       |      60%      |
