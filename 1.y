%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
extern FILE *yyin;
void yyerror(const char *s);
void yywarn(const char *s);
int yylex(void);
%}

%union {
    int num;
    char *str;
}

/* Токены инструкций */
%token MOV ADD INC ADC SUB AND OR XOR CMP SBB

/* Токены регистров */
%token <str> REG8 REG16 REG32

/* Токены для чисел и констант */
%token <num> NUMBER SBYTE

/* Токены для указателей размера */
%token BYTE_PTR WORD_PTR DWORD_PTR PTR

/* Токены для памяти и символов */
%token COMMA LBRACK RBRACK PLUS MINUS
%token <str> ID

%token EOL

%%

program:
    | program line
    ;

line:
    instruction EOL      { printf(" OK\n"); }
    | EOL
    | error EOL          { yyerrok; printf(" Skipping line\n"); }
    ;

instruction:
    mov_instr
    | inc_instr
    | arith_instr
    ;

/* ============ МНОЖЕСТВА ВТОРЫХ ОПЕРАНДОВ ============ */
src_for_reg8:
    reg8_op
    | mem_op
    | imm8_op
    ;

src_for_reg16:
    reg16_op
    | mem_op
    | imm16_op
    | imm8_op
    | sbyte8_op
    ;

src_for_reg32:
    reg32_op
    | mem_op
    | imm32_op
    | imm8_op
    | sbyte8_op
    ;

src_for_mem:
    reg8_op
    | reg16_op
    | reg32_op
    | imm8_op
    | imm16_op
    | imm32_op
    | sbyte8_op
    ;

/* ============ АРИФМЕТИЧЕСКИЕ ИНСТРУКЦИИ ============ */

arith_op:
    ADD | ADC | SUB | SBB | CMP | AND | OR | XOR
    ;

arith_instr:
    arith_op reg8_op  COMMA src_for_reg8
    | arith_op reg16_op COMMA src_for_reg16
    | arith_op reg32_op COMMA src_for_reg32
    | arith_op mem_op   COMMA src_for_mem
    ;


/* ============ ДРУГИЕ ИНСТРУКЦИИ ============ */

mov_instr:
    MOV reg32_op COMMA src_for_reg32
    | MOV reg16_op COMMA src_for_reg16
    | MOV reg8_op  COMMA src_for_reg8
    ;

inc_instr:
    INC reg8_op
    | INC reg16_op
    | INC reg32_op
    ;

/* ============ ОПЕРАНДЫ (ОПРЕДЕЛЕНИЯ) ============ */

/* Регистры */
reg8_op:   REG8  { printf("    reg8: %s", $1); } ;
reg16_op:  REG16 { printf("    reg16: %s", $1); } ;
reg32_op:  REG32 { printf("    reg32: %s", $1); } ;

/* Память (общая) */
mem_op:
    BYTE_PTR PTR mem_base  { printf("    byte ptr"); }
    | WORD_PTR PTR mem_base { printf("    word ptr"); }
    | DWORD_PTR PTR mem_base { printf("    dword ptr"); }
    | BYTE_PTR mem_base  { printf("    byte"); }
    | WORD_PTR mem_base { printf("    word"); }
    | DWORD_PTR mem_base { printf("    dword"); }
    | mem_base              { printf("    mem"); }
    ;

mem_base:
    LBRACK mem_addr RBRACK
    ;

mem_addr:
    ID                     { printf(" [%s]", $1); }
    | REG32                { printf(" [%s]", $1); }
    | REG32 PLUS NUMBER    { printf(" [%s+%d]", $1, $3); }
    | REG32 MINUS NUMBER   { printf(" [%s-%d]", $1, $3); }
    ;

/* Константы */
imm8_op:   NUMBER { if($1 < -128 || $1 > 255) yywarn("imm8 out of range"); 
                    printf("    imm8: %d", ($1  & 0xFF)); } ;

imm16_op:  NUMBER { if($1 < -32768 || $1 > 65535) yywarn("imm16 out of range"); 
                    printf("    imm16: %d", ($1 & 0xFFFF)); } ;

imm32_op:  NUMBER { printf("    imm32: %d", ($1 & 0xFFFFFF)); } ;

sbyte8_op: SBYTE { printf("    sbyte: %d", $1); }
          | NUMBER { if($1 > 127 || $1 < -128) yywarn("sbyte out of range"); 
                     printf("    sbyte: %d", ((int8_t)($1 & 0xFF))); }
          ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "\n  ERROR: %s\n", s);
}
void yywarn(const char *s) {
    fprintf(stderr, "\n  WARNING: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            perror(argv[1]);
            return 1;
        }
        yyin = f;
    } 
    int result = yyparse();    
    if (yyin != stdin)           
        fclose(yyin);

    printf("=== NASM Validator (x86, 32-bit) ===\n");
    printf("Enter assembly code (Ctrl+C to finish):\n");
    printf("\n=== Validation complete ===\n");
    return result;
}