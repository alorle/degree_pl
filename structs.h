#ifndef STRUCTS_H
#define STRUCTS_H

#include <string.h>

typedef int bool;
#define TRUE 1
#define FALSE 0

/**
 * Posibles tipos de una variable
 */
typedef enum {
    VAR_DESCONOCIDO,
    VAR_ENTERO,
    VAR_REAL,
    VAR_BOOLEANO,
    VAR_CARACTER,
    VAR_CADENA
} variable_tipo;

const static char* variable_tipo_names[] = {
    "DESCONOCIDO",
    "ENTERO",
    "REAL",
    "BOOLEANO",
    "CARACTER",
    "CADENA"
};

/**
  * Posibles tipos de una expresion
  */
typedef enum {
    EXP_ARITMETICO,
    EXP_BOOLEANO
} expresion_tipo;

const static char* expresion_tipo_names[] = {
    "ARITMETICO",
    "BOOLEANO"
};

/**
  * Posibles operadores
  */
typedef enum
{
    OP_ASIGNACION,

    // Operadores aritméticos
    OP_SUMA_ENTERO,
    OP_SUMA_REAL,
    OP_RESTA_ENTERO,
    OP_RESTA_REAL,
    OP_PRODUCTO_ENTERO,
    OP_PRODUCTO_REAL,
    OP_DIVISION_ENTERO,
    OP_DIVISION_REAL,
    OP_MODDULO,
    OP_MENOS_ENTERO,
    OP_MENOS_REAL,
    OP_ENTERO2REAL,

    // Operadores booleanos
    OP_BOOL_AND,
    OP_BOOL_OR,
    OP_BOOL_NOT,
    OP_BOOL_DISTINTO,
    OP_BOOL_IGUAL,
    OP_BOOL_MENOR,
    OP_BOOL_MENOR_IGUAL,
    OP_BOOL_MAYOR,
    OP_BOOL_MAYOR_IGUAL,

    // Operadores de saltos
    OP_GOTO,
    OP_CONDICIONAL_GOTO
} operador;

const static char* operador_names[] = {
    "ASIGNACION         ",

    // Operadores aritméticos
    "SUMA ENTERA        ",
    "SUMA REAL          ",
    "RESTA ENTERA       ",
    "RESTA REAL         ",
    "PRODUCTO ENTERO    ",
    "PRODUCTO REAL      ",
    "DIVISION ENTERA    ",
    "DIVISION REAL      ",
    "MODDULO            ",
    "MENOS ENTERO       ",
    "MENOS REAL         ",
    "ENTERO 2 REAL      ",

    // Operadores booleanos
    "BOOL AND           ",
    "BOOL OR            ",
    "BOOL NOT           ",
    "BOOL DISTINTO      ",
    "BOOL IGUAL         ",
    "BOOL MENOR         ",
    "BOOL MENOR IGUAL   ",
    "BOOL MAYOR         ",
    "BOOL MAYOR IGUAL   ",

    // Operadores de saltos
    "OP_GOTO            ",
    "OP_CONDICIONAL_GOTO"
};

/**
  * Struct para la lista de verdadero y falso
  *
  * - size: tamaño de la lista
  *
  * - array: lista de identificadores de quads
  */
typedef struct {
    int size;
    int *array;
} bool_list;

/**
  * Struct para los operadores aritméticos
  *
  * - id: es el valor que identifica al
  *       operador en la tabla de símbolos
  *
  * - tipo: identifica el tipo del operador
  */
typedef struct {
    int id;
    variable_tipo tipo;
} op_aritmetico;

/**
  * Struct para los operadores boolenaos
  *
  * - verdadero: lista de saltos (ids a la tabla de cuadruplas)
  *              cuando el operador se evalue a verdadero
  *
  * - falso: lista de saltos (ids a la tabla de cuadruplas)
  *          cuando el operador se evalue a falso
  */
typedef struct {
    bool_list verdadero;
    bool_list falso;
} op_booleano;

/**
  * Estructura de una expresión
  *
  * - tipo: tipo de la expresión
  * - a: datos de la expresión aritmética
  * - b: datos de la expresión booleana
  */
typedef struct {
    expresion_tipo tipo;
    op_aritmetico a;
    op_booleano b;
} expresion;

#endif
