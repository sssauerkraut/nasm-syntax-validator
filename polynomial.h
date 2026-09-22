#ifndef POLYNOMIAL_H
#define POLYNOMIAL_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/* ---------- Моном: коэффициент + отсортированный набор (var, exp) ---------- */
typedef struct Monomial {
    double   coeff;
    char** vars;    /* имена переменных (отсортированы) */
    int* exps;    /* степени (параллельно vars) */
    int      nvars;   /* количество переменных */
    struct Monomial* next;
} Monomial;

/* ---------- Полином = связный список мономов ---------- */
typedef struct Polynomial {
    Monomial* terms;
} Polynomial;

/* ---------- Таблица глобальных переменных ---------- */
typedef struct GlobalVar {
    char* name;
    Polynomial* poly;
    struct GlobalVar* next;
} GlobalVar;

/* ---------- Создание / освобождение ---------- */
Polynomial* create_zero(void);
Polynomial* create_constant(double c);
Polynomial* create_variable(const char* name);
Polynomial* copy_polynomial(Polynomial* p);
void        free_polynomial(Polynomial* p);

/* ---------- Арифметика ---------- */
Polynomial* add_polynomials(Polynomial* a, Polynomial* b);
Polynomial* subtract_polynomials(Polynomial* a, Polynomial* b);
Polynomial* multiply_polynomials(Polynomial* a, Polynomial* b);
Polynomial* divide_polynomials(Polynomial* a, Polynomial* b);
Polynomial* negate_polynomial(Polynomial* p);
Polynomial* power_polynomial(Polynomial* p, int exp);

/* ---------- Проверки ---------- */
int is_zero(Polynomial* p);
int is_constant(Polynomial* p, double* out);
int is_monomial(Polynomial* p);
int total_degree(Polynomial* p);

/* ---------- Печать ---------- */
void print_polynomial(Polynomial* p);

/* ---------- Глобальные переменные ---------- */
void        set_variable(const char* name, Polynomial* poly);
Polynomial* get_variable(const char* name);
int         is_defined(const char* name);

#endif