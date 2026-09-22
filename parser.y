%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "polynomial.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern int  yylineno;

void yyerror(const char* s);

static int poly_to_int(Polynomial* p, int* ok) {
    *ok = 0;
    double c;
    if (is_constant(p, &c)) {
        double r = round(c);                 /* работает и для отрицательных */
        if (fabs(c - r) < 1e-9) {
            *ok = 1;
            return (int)r;
        }
    }
    return 0;
}
%}

%union {
    double       dval;
    Polynomial*  poly;
    char*        sval;
}

%token <dval> NUMBER
%token <sval> IDENT
%token PLUS MINUS MUL DIV POW LPAREN RPAREN END ASSIGN QUESTION
%token IMPLICIT

%type <poly> expr term factor atomic power primary

%left PLUS MINUS
%left MUL DIV IMPLICIT
%right POW

%start program

%%

program:
      program line
    |
    ;

line:
      expr END {
          print_polynomial($1);
          free_polynomial($1);
      }
    | IDENT ASSIGN expr END {
          set_variable($1, $3);
          printf("%s = ", $1);
          print_polynomial($3);
          free_polynomial($3);
          free($1);
      }
    | IDENT ASSIGN QUESTION END {
          Polynomial* p = get_variable($1);
          if (!p) {
              fprintf(stderr, "Error: undefined variable '%s' at line %d\n",
                      $1, yylineno);
          } else {
              printf("%s = ", $1);
              print_polynomial(p);
              free_polynomial(p);
          }
          free($1);
      }
    | expr ASSIGN QUESTION END {
          print_polynomial($1);
          free_polynomial($1);
      }
    | error END { yyerrok; }
    | END { }
    ;

expr:
      expr PLUS term {
          $$ = add_polynomials($1, $3);
          free_polynomial($1); free_polynomial($3);
      }
    | expr MINUS term {
          $$ = subtract_polynomials($1, $3);
          free_polynomial($1); free_polynomial($3);
      }
    | term { $$ = $1; }
    ;

term:
      term MUL factor {
          $$ = multiply_polynomials($1, $3);
          free_polynomial($1); free_polynomial($3);
      }
    | term DIV factor {
          $$ = divide_polynomials($1, $3);
          free_polynomial($1); free_polynomial($3);
          if (!$$) $$ = create_zero();
      }
    | term atomic %prec IMPLICIT {     /* неявное умножение: только без ведущего знака */
          $$ = multiply_polynomials($1, $2);
          free_polynomial($1); free_polynomial($2);
      }
    | factor { $$ = $1; }
    ;

factor:
      PLUS factor  { $$ = $2; }
    | MINUS factor {
          $$ = negate_polynomial($2);
          free_polynomial($2);
      }
    | atomic { $$ = $1; }
    ;

atomic:
      power POW factor {               /* ^ связывает сильнее унарного минуса */
          int ok;
          int e = poly_to_int($3, &ok);
          if (!ok) {
              fprintf(stderr,
                      "Error: exponent must be non-negative "
                      "integer at line %d\n", yylineno);
              $$ = create_zero();
          } else if (e < 0) {
              fprintf(stderr,
                      "Error: negative exponent not supported at line %d\n",
                      yylineno);
              $$ = create_zero();
          } else {
              $$ = power_polynomial($1, e);
          }
          free_polynomial($1); free_polynomial($3);
      }
    | power { $$ = $1; }
    ;

power:
      primary { $$ = $1; }
    ;

primary:
      NUMBER {
          $$ = create_constant($1);
      }
    | IDENT {
          Polynomial* p = get_variable($1);
          if (p) $$ = p;
          else   $$ = create_variable($1);
          free($1);
      }
    | LPAREN expr RPAREN { $$ = $2; }
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Syntax error: %s at line %d\n", s, yylineno);
}