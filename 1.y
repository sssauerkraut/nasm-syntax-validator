%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int num;
    char *str;
}

%token MOV ADD INC
%token <str> REG
%token <num> NUMBER
%token COMMA EOL

%%

program:
    | program line
    ;

line:
    instruction EOL      { printf("OK: instruction parsed\n"); }
    | EOL
    ;

instruction:
    mov_instr | add_instr | inc_instr
    ;

mov_instr:
    MOV REG COMMA NUMBER   { printf("mov %s, %d\n", $2, $4); }
    | MOV REG COMMA REG    { printf("mov %s, %s\n", $2, $4); }
    ;

add_instr:
    ADD REG COMMA REG      { printf("add %s, %s\n", $2, $4); }
    | ADD REG COMMA NUMBER { printf("add %s, %d\n", $2, $4); }
    ;

inc_instr:
    INC REG                { printf("inc %s\n", $2); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}