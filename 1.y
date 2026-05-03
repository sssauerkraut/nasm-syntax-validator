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

/* Токены инструкций */
%token MOV ADD INC ADC

/* Токены регистров (по размерам) */
%token <str> REG8 REG16 REG32 REG64

/* Токены для чисел и констант */
%token <num> NUMBER SBYTE

/* Токены для указателей размера */
%token BYTE_PTR WORD_PTR DWORD_PTR QWORD_PTR PTR

/* Токены для памяти и символов */
%token COMMA LBRACK RBRACK PLUS MINUS
%token <str> ID

%token EOL

%%

program:
    | program line
    ;

line:
    instruction EOL      { printf("OK\n"); }
    | EOL
    | error EOL          { yyerrok; printf("Skipping line\n"); }
    ;

instruction:
    mov_instr
    | add_instr
    | inc_instr
    | adc_instr          /* ДОБАВИТЬ */
    ;

/* ============ ADC - ВСЕ ВАРИАНТЫ ============ */

adc_instr:
    /* reg32, reg32 */
    ADC reg32_op COMMA reg32_op
    /* reg32, imm (константа) */
    | ADC reg32_op COMMA imm_op
    /* reg8, reg8 */
    | ADC reg8_op COMMA reg8_op
    /* reg8, imm */
    | ADC reg8_op COMMA imm_op
    /* reg16, reg16 */
    | ADC reg16_op COMMA reg16_op
    /* reg16, imm */
    | ADC reg16_op COMMA imm_op
    /* reg64, reg64 (если нужно) */
    | ADC reg64_op COMMA reg64_op
    /* reg64, imm */
    | ADC reg64_op COMMA imm_op
    /* reg32, mem */
    | ADC reg32_op COMMA mem_op
    /* mem, reg32 */
    | ADC mem_op COMMA reg32_op
    /* mem, imm */
    | ADC mem_op COMMA imm_op
    /* reg_al, imm */
    | ADC reg_al_op COMMA imm_op
    /* reg_ax, imm */
    | ADC reg_ax_op COMMA imm_op
    /* reg_eax, imm */
    | ADC reg_eax_op COMMA imm_op
    ;
/* ============ ОПЕРАНДЫ ============ */

/* Регистр 8-bit */
reg8_op:
    REG8  { printf("reg8: %s\n", $1); }
    ;

/* Регистр 16-bit */
reg16_op:
    REG16  { printf("reg16: %s\n", $1); }
    ;

/* Регистр 32-bit */
reg32_op:
    REG32  { printf("reg32: %s\n", $1); }
    ;

/* Регистр 64-bit */
reg64_op:
    REG64  { printf("reg64: %s\n", $1); }
    ;

/* Специальные регистры для ADC AL/AX/EAX/RAX */
reg_al_op:
    REG8  { if(strcmp($1, "al") != 0) yyerror("Expected AL"); printf("AL\n"); }
    ;

reg_ax_op:
    REG16 { if(strcmp($1, "ax") != 0) yyerror("Expected AX"); printf("AX\n"); }
    ;

reg_eax_op:
    REG32 { if(strcmp($1, "eax") != 0) yyerror("Expected EAX"); printf("EAX\n"); }
    ;

reg_rax_op:
    REG64 { if(strcmp($1, "rax") != 0) yyerror("Expected RAX"); printf("RAX\n"); }
    ;

/* Память (базовая) */
mem_op:
    LBRACK ID RBRACK           { printf("mem: [%s]\n", $2); }
    | LBRACK REG32 RBRACK      { printf("mem: [%s]\n", $2); }
    | LBRACK REG32 PLUS NUMBER RBRACK  { printf("mem: [%s+%d]\n", $2, $4); }
    | LBRACK REG32 MINUS NUMBER RBRACK { printf("mem: [%s-%d]\n", $2, $4); }
    ;

/* rm8 - регистр 8-bit ИЛИ память */
rm8_op:
    reg8_op
    | mem_op
    | BYTE_PTR PTR mem_op  { printf("byte ptr\n"); }
    ;

/* rm16 - регистр 16-bit ИЛИ память */
rm16_op:
    reg16_op
    | mem_op
    | WORD_PTR PTR mem_op  { printf("word ptr\n"); }
    ;

/* rm32 - регистр 32-bit ИЛИ память */
rm32_op:
    reg32_op
    | mem_op
    | DWORD_PTR PTR mem_op { printf("dword ptr\n"); }
    ;

/* Константы */
imm_op:
    NUMBER  { printf("imm: %d\n", $1); }
    ;

imm8_op:
    NUMBER  { if($1 < -128 || $1 > 255) yyerror("imm8 out of range"); printf("imm8: %d\n", $1); }
    ;

imm16_op:
    NUMBER  { if($1 < -32768 || $1 > 65535) yyerror("imm16 out of range"); printf("imm16: %d\n", $1); }
    ;

imm32_op:
    NUMBER  { printf("imm32: %d\n", $1); }
    ;

sbyte_op:
    SBYTE   { printf("sbyte: %d\n", $1); }
    | NUMBER { if($1 > 127) yyerror("sbyte out of range"); printf("sbyte: %d\n", $1); }
    ;

/* ============ ОСТАЛЬНЫЕ ИНСТРУКЦИИ (шаблоны) ============ */

mov_instr:
    MOV reg32_op COMMA reg32_op { printf("MOV r32, r32\n"); }
    | MOV reg32_op COMMA NUMBER { printf("MOV r32, imm\n"); }
    ;

add_instr:
    ADD reg32_op COMMA reg32_op { printf("ADD r32, r32\n"); }
    ;

inc_instr:
    INC reg32_op { printf("INC r32\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}