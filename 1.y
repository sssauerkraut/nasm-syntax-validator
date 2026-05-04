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

%token MOV ADD INC ADC SUB AND OR XOR CMP SBB

/* Инструкции без операндов (Zero Operand) */
%token ZOP_AAA ZOP_AAS ZOP_DAA ZOP_DAS
%token ZOP_CBW ZOP_CWD ZOP_CWDE ZOP_CDQ ZOP_CDQE
%token ZOP_CLC ZOP_CLD ZOP_CLI ZOP_CLTS ZOP_CMC
%token ZOP_STC ZOP_STD ZOP_STI
%token ZOP_LAHF ZOP_SAHF
%token ZOP_PUSHA ZOP_POPA ZOP_PUSHF ZOP_POPF
%token ZOP_LEAVE
%token ZOP_HLT ZOP_CPUID ZOP_RDTSC ZOP_RDPMC ZOP_RDMSR ZOP_WRMSR
%token ZOP_INVD ZOP_WBINVD
%token ZOP_SYSCALL ZOP_SYSENTER ZOP_SYSEXIT ZOP_SYSRET ZOP_SWAPGS
%token ZOP_MOVS ZOP_MOVSQ ZOP_CMPS ZOP_CMPSQ
%token ZOP_SCAS ZOP_SCASQ ZOP_STOS ZOP_STOSQ
%token ZOP_LODS ZOP_LODSQ ZOP_INS ZOP_OUTS
%token ZOP_FPU
%token ZOP_PAUSE ZOP_FWAIT ZOP_XLAT
%token ZOP_UD2 ZOP_ICEBP ZOP_INT3 ZOP_INTO ZOP_SALC
%token ZOP_RDTSCP ZOP_RSM ZOP_SMINT ZOP_RDM


%token <str> REG8 REG16 REG32

%token <num> NUMBER SBYTE

%token BYTE_PTR WORD_PTR DWORD_PTR PTR

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
    | zero_operand_instr   
    ;

/* ============ ИНСТРУКЦИИ БЕЗ ОПЕРАНДОВ ============ */
zero_operand_instr:
    ZOP_AAA   { printf(" AAA"); }
    | ZOP_AAS { printf(" AAS"); }
    | ZOP_DAA { printf(" DAA"); }
    | ZOP_DAS { printf(" DAS"); }
    | ZOP_CBW { printf(" CBW"); }
    | ZOP_CWD { printf(" CWD"); }
    | ZOP_CWDE { printf(" CWDE"); }
    | ZOP_CDQ { printf(" CDQ"); }
    | ZOP_CLC { printf(" CLC"); }
    | ZOP_CLD { printf(" CLD"); }
    | ZOP_CLI { printf(" CLI"); }
    | ZOP_CLTS { printf(" CLTS"); }
    | ZOP_CMC { printf(" CMC"); }
    | ZOP_STC { printf(" STC"); }
    | ZOP_STD { printf(" STD"); }
    | ZOP_STI { printf(" STI"); }
    | ZOP_LAHF { printf(" LAHF"); }
    | ZOP_SAHF { printf(" SAHF"); }
    | ZOP_PUSHA { printf(" PUSHA"); }
    | ZOP_POPA { printf(" POPA"); }
    | ZOP_PUSHF { printf(" PUSHF"); }
    | ZOP_POPF { printf(" POPF"); }
    | ZOP_LEAVE { printf(" LEAVE"); }
    | ZOP_HLT { printf(" HLT"); }
    | ZOP_CPUID { printf(" CPUID"); }
    | ZOP_RDTSC { printf(" RDTSC"); }
    | ZOP_RDPMC { printf(" RDPMC"); }
    | ZOP_RDMSR { printf(" RDMSR"); }
    | ZOP_WRMSR { printf(" WRMSR"); }
    | ZOP_INVD { printf(" INVD"); }
    | ZOP_WBINVD { printf(" WBINVD"); }
    | ZOP_SYSCALL { printf(" SYSCALL"); }
    | ZOP_SYSENTER { printf(" SYSENTER"); }
    | ZOP_SYSEXIT { printf(" SYSEXIT"); }
    | ZOP_SYSRET { printf(" SYSRET"); }
    | ZOP_SWAPGS { printf(" SWAPGS"); }
    | ZOP_MOVS { printf(" MOVS"); }
    | ZOP_CMPS { printf(" CMPS"); }
    | ZOP_SCAS { printf(" SCAS"); }
    | ZOP_STOS { printf(" STOS"); }
    | ZOP_LODS { printf(" LODS"); }
    | ZOP_INS { printf(" INS"); }
    | ZOP_OUTS { printf(" OUTS"); }
    | ZOP_FPU { printf(" FPU"); }
    | ZOP_PAUSE { printf(" PAUSE"); }
    | ZOP_FWAIT { printf(" FWAIT"); }
    | ZOP_XLAT { printf(" XLAT"); }
    | ZOP_UD2 { printf(" UD2"); }
    | ZOP_ICEBP { printf(" ICEBP"); }
    | ZOP_INT3 { printf(" INT3"); }
    | ZOP_INTO { printf(" INTO"); }
    | ZOP_SALC { printf(" SALC"); }
    ;    

/* ============ МНОЖЕСТВА ВТОРЫХ ОПЕРАНДОВ АРИФМЕТИЧЕСКИЕ============ */
arith_src_for_reg8:
    reg8_op
    | mem_op
    | imm8_op
    ;

arith_src_for_reg16:
    reg16_op
    | mem_op
    | imm16_op
    | imm8_op
    | sbyte8_op
    ;

arith_src_for_reg32:
    reg32_op
    | mem_op
    | imm32_op
    | imm8_op
    | sbyte8_op
    ;

arith_src_for_mem:
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
    arith_op reg8_op  COMMA arith_src_for_reg8
    | arith_op reg16_op COMMA arith_src_for_reg16
    | arith_op reg32_op COMMA arith_src_for_reg32
    | arith_op mem_op   COMMA arith_src_for_mem
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

/* Память */
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