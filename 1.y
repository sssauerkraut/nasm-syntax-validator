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

%token MOV ADD INC ADC SUB AND OR XOR CMP SBB NEG NOT MUL IDIV DIV MULI
%token SHL SHR SAR SAL ROL ROR RCL RCR
%token BFS BSR BTC BTR BTS CMPXCHG CMPXCHG486 XADD POP PUSH AAD AAM
%token SECTION SEGMENT
%token <str> DOT_ID
%type <str> section_name
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
%token AAD AAM
%token BOUND LDS LGS LSS LES LFS
%token CMPXCHG CMPXCHG486 XADD POP PUSH
%token FBLD FBSTP FLD FSTP FCMOVU FCMOVNU FCMOVNE FCOMI FCOMIP FDIVP FDIVRP FCMOVNBE FCMOVNB
%token FUCOM FUCOMIP FUCOMP FSUBRP FSUBP FUCOMI FMULP
%token LGDT LIDT SIDT SGDT FSTCW FNSAVE FLDCW FSTENV FNSTCW FLDENV FRSTOR FNSTENV INVLPG FSAVE
%token SLDT SMSW
%token IN OUT
%token RET RETF RETN RETW RETD
%token SHLD SHRD
%token FDIV FDIVR FMUL FADD FSUB FSUBR
%token FIADD FICOM FICOMP FIDIV FIDIVR FILD FIMUL FIST FISTP FISTTP FISUB FISUBR
%token FNSTSW FSTSW
%token FCOM FCOMP
%token UD0 UD1 UD2B
%token MOVZX MOVSX
%token INT JECXZ JCXZ JCC
%token LOOP LOOPE LOOPNE LOOPNZ LOOPZ
%token <str> FPUREG FPU0
%token <num> NUMBER
%token <str> REG8 REG16 REG32 SREG
%type <str> reg8_op reg16_op reg32_op sreg_op fpureg_op fpu0_op
%token PREFETCH PREFETCHW STR FFREE FFREEP LAR LSL LLDT LMSW LTR
%token MWAIT MWAITX VERR VERW BSWAP RDSHR WRSHR SVLDT SVTS RSLDT RSTS
%token CALL NEAR FAR COLON
%token XBTS IBTS ARPL ENTER EQU
%token NOP MOVD MOVQ RSDC TEST XCHG
%token FST IMUL INVPCID INVLPGA JMP JMPE MONITOR MONITORX
%token CPU_READ CPU_WRITE FEMMS LOADALL LOADALL286
%token XMMWORD
%token NOP
%token FXCH
%token LEA

%token <str> MMXOP MMXREG CMOVCC SETCC CREG DREG TREG


%token BYTE WORD DWORD PTR TWORD

%token COMMA LBRACK RBRACK PLUS MINUS
%token <str> ID
%type <str> jmp_target
%token EOL
%expect 12
%%

program:
    | program line
    ;

line:
    instruction EOL          { printf(" OK\n"); }
  | label EOL                { printf("\n"); }
  | label instruction EOL    { printf(" OK\n"); }
  | section_decl EOL         { printf("\n"); }
  | bare_section EOL         { /* уже выводит printf */ }
  | EOL
  | error EOL                { yyerrok; printf(" Skipping line\n"); }
  ;
instruction:
    mov_instr | inc_instr | arith_instr | zero_operand_instr
  | shift_instr | negnot_instr | bsf_instr | btc_instr
  | cmpxchg_instr | xadd_instr | pop_instr | push_instr
  | aad_aam_instr
  | bound_load_instr
  | loop_instr
  | fpu_mem_instr | fpu_ldst_instr
  | fcmov_instr | fcom_group2_instr | fsub_group_instr
  | mem_only_instr
  | sldt_smsw_instr
  | out_instr | in_instr
  | ret_instr
  | shld_shrd_instr
  | fpu_arith_instr | fpu_int_instr
  | fnstsw_fstsw_instr
  | fcom_instr
  | ud_instr
  | movzx_instr
  | int_jmp_instr
  | fxch_instr
  | ffree_instr
  | lar_lsl_instr
  | llt_lmsw_ltr_instr
  | mwait_instr
  | verr_verw_instr
  | mmx_instr
  | bswap_instr
  | rdshr_wrshr_instr
  | svldt_svts_rsldt_rsts_instr
  | call_instr
  | xbts_instr
  | cmovcc_instr
  | ibts_instr
  | arpl_instr
  | enter_instr
  | equ_instr
  | imul_instr
  | invpcid_instr
  | invlpga_instr
  | jmp_instr
  | jmpe_instr
  | monitor_instr
  | monitorx_instr
  | nop_instr
  | movd_instr
  | movq_instr
  | rsdc_instr
  | test_instr
  | xchg_instr
  | setcc_instr
  | lea_instr
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
    | CPU_READ  { printf(" CPU_READ"); }
    | CPU_WRITE { printf(" CPU_WRITE"); }
    | FEMMS     { printf(" FEMMS"); }
    | LOADALL   { printf(" LOADALL"); }
    | LOADALL286 { printf(" LOADALL286"); }
    ;

/* ============ МНОЖЕСТВА ВТОРЫХ ОПЕРАНДОВ АРИФМЕТИЧЕСКИЕ============ */
arith_src_for_reg8:
    reg8_op  { }
  | mem_op   { }
  | imm_op  { }
  ;

arith_src_for_reg16:
    reg16_op  { }
  | mem_op    { }
  | imm_op  { }
  ;

arith_src_for_reg32:
    reg32_op  { }
  | mem_op    { }
  | imm_op  { }
  ;

arith_src_for_mem:
    reg8_op   { }
  | reg16_op  { }
  | reg32_op  { }
  | imm_op   { }
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
negnot_op:
    NEG | NOT | MUL | IDIV | DIV
    ;

negnot_instr:
    negnot_op rm8_op
  | negnot_op rm16_op
  | negnot_op rm32_op
  ;

inc_instr:
    INC reg8_op
  | INC reg16_op
  | INC reg32_op
  ;

shift_op:
    SHL | SHR | SAR | SAL | ROL | ROR | RCL | RCR
    ;

shift_instr:
    shift_op rm8_op COMMA reg8_op {
        if (strcasecmp($<str>4, "cl") != 0)
            yyerror("shift count must be CL or immediate");
    }
  | shift_op rm8_op COMMA imm_op { }
  | shift_op rm16_op COMMA reg8_op {
        if (strcasecmp($<str>4, "cl") != 0)
            yyerror("shift count must be CL or immediate");
    }
  | shift_op rm16_op COMMA imm_op { }
  | shift_op rm32_op COMMA reg8_op {
        if (strcasecmp($<str>4, "cl") != 0)
            yyerror("shift count must be CL or immediate");
    }
  | shift_op rm32_op COMMA imm_op { }
  ;

bsf_op:
    BFS | BSR
    ;

bsf_instr:
    bsf_op reg16_op COMMA rm16_op
  | bsf_op reg32_op COMMA rm32_op
  ;

btc_op:
    BTC | BTR | BTS
    ;

btc_instr:
    btc_op rm16_op COMMA reg16_op
  | btc_op rm32_op COMMA reg32_op
  | btc_op rm16_op COMMA imm_op
  | btc_op rm32_op COMMA imm_op
  ;

cmpxchg_op:
    CMPXCHG | CMPXCHG486
    ;

cmpxchg_instr:
    cmpxchg_op rm8_op  COMMA reg8_op
  | cmpxchg_op rm16_op COMMA reg16_op
  | cmpxchg_op rm32_op COMMA reg32_op
  ;

xadd_op:
    XADD
    ;

xadd_instr:
    xadd_op rm8_op  COMMA reg8_op
  | xadd_op rm16_op COMMA reg16_op
  | xadd_op rm32_op COMMA reg32_op
  ;

pop_instr:
    POP rm16_op
  | POP rm32_op
  | POP sreg_op
  ;

push_instr:
    PUSH rm16_op
  | PUSH rm32_op
  | PUSH sreg_op
  | PUSH imm_op
  ;

aad_aam_op:
    AAD | AAM
    ;

aad_aam_instr:
    aad_aam_op { }
  | aad_aam_op imm_op { }
  ;

bound_load_op:
    BOUND | LDS | LGS | LSS | LES | LFS
    ;

bound_load_instr:
    bound_load_op reg16_op COMMA mem_op
  | bound_load_op reg32_op COMMA mem_op
  ;
loop_op:
    LOOP | LOOPE | LOOPNE | LOOPNZ | LOOPZ
    ;

loop_instr:
    loop_op jmp_target
  | loop_op jmp_target COMMA reg16_op {
        if (strcasecmp($<str>3, "cx") != 0) yyerror("second operand must be CX");
    }
  | loop_op jmp_target COMMA reg32_op {
        if (strcasecmp($<str>3, "ecx") != 0) yyerror("second operand must be ECX");
    }
  ;
fpu_mem_instr_op:
    FBLD | FBSTP
  ;

fpu_mem_instr:
    fpu_mem_instr_op mem80_op
  ;

fpu_ldst_op:
    FLD | FSTP | FST
  ;

fpu_ldst_instr:
    fpu_ldst_op mem32_op
  | fpu_ldst_op mem80_op
  | fpu_ldst_op fpureg_op
  | fpu_ldst_op
  ;

fcmov_group_op:
    FCMOVU | FCMOVNU | FCMOVNE | FCOMI | FCOMIP | FDIVP | FDIVRP | FCMOVNBE | FCMOVNB
  ;

fcmov_instr:
    fcmov_group_op { }
  | fcmov_group_op fpureg_op { }
  | fcmov_group_op fpu0_op COMMA fpureg_op { }
  | FDIVP fpureg_op COMMA fpu0_op { }
  | FDIVRP fpureg_op COMMA fpu0_op { }
  ;

fcom_group2_op:
    FUCOM | FUCOMIP | FUCOMP | FUCOMI
    ;

fcom_group2_instr:
    fcom_group2_op { }
  | fcom_group2_op fpureg_op { }
  | fcom_group2_op fpu0_op COMMA fpureg_op { }
  ;

fsub_group_op:
    FSUBRP | FSUBP | FMULP
    ;

fsub_group_instr:
    fsub_group_op { }
  | fsub_group_op fpureg_op { }
  | fsub_group_op fpureg_op COMMA fpu0_op { }
  ;

mem_only_op:
    LGDT | LIDT | SIDT | SGDT
  | FSTCW | FNSAVE | FLDCW | FSTENV | FNSTCW | FLDENV | FRSTOR | FNSTENV | INVLPG | FSAVE
  | PREFETCH | PREFETCHW
  ;

mem_only_instr:
    mem_only_op mem_op
  ;

sldt_smsw_op:
    SLDT | SMSW | STR
    ;

sldt_smsw_instr:
    sldt_smsw_op rm16_op
  | sldt_smsw_op rm32_op
  | sldt_smsw_op mem_base
  ;

out_instr:
    OUT imm_op COMMA reg8_op {
        if (strcasecmp($<str>4, "al") != 0) yyerror("OUT imm, reg8: must be AL");
    }
  | OUT imm_op COMMA reg16_op {
        if (strcasecmp($<str>4, "ax") != 0) yyerror("OUT imm, reg16: must be AX");
    }
  | OUT imm_op COMMA reg32_op {
        if (strcasecmp($<str>4, "eax") != 0) yyerror("OUT imm, reg32: must be EAX");
    }
  | OUT reg16_op COMMA reg8_op {
        if (strcasecmp($<str>2, "dx") != 0) yyerror("OUT DX, reg8: first operand must be DX");
        if (strcasecmp($<str>4, "al") != 0) yyerror("OUT DX, reg8: second operand must be AL");
    }
  | OUT reg16_op COMMA reg16_op {
        if (strcasecmp($<str>2, "dx") != 0) yyerror("OUT DX, reg16: first operand must be DX");
        if (strcasecmp($<str>4, "ax") != 0) yyerror("OUT DX, reg16: second operand must be AX");
    }
  | OUT reg16_op COMMA reg32_op {
        if (strcasecmp($<str>2, "dx") != 0) yyerror("OUT DX, reg32: first operand must be DX");
        if (strcasecmp($<str>4, "eax") != 0) yyerror("OUT DX, reg32: second operand must be EAX");
    }
  ;

in_instr:
    IN reg8_op COMMA imm_op {
        if (strcasecmp($<str>2, "al") != 0) yyerror("IN reg8, imm: first operand must be AL");
    }
  | IN reg16_op COMMA imm_op {
        if (strcasecmp($<str>2, "ax") != 0) yyerror("IN reg16, imm: first operand must be AX");
    }
  | IN reg32_op COMMA imm_op {
        if (strcasecmp($<str>2, "eax") != 0) yyerror("IN reg32, imm: first operand must be EAX");
    }
  | IN reg8_op COMMA reg16_op {
        if (strcasecmp($<str>2, "al") != 0) yyerror("IN reg8, DX: first operand must be AL");
        if (strcasecmp($<str>4, "dx") != 0) yyerror("IN reg8, DX: second operand must be DX");
    }
  | IN reg16_op COMMA reg16_op {
        if (strcasecmp($<str>2, "ax") != 0) yyerror("IN reg16, DX: first operand must be AX");
        if (strcasecmp($<str>4, "dx") != 0) yyerror("IN reg16, DX: second operand must be DX");
    }
  | IN reg32_op COMMA reg16_op {
        if (strcasecmp($<str>2, "eax") != 0) yyerror("IN reg32, DX: first operand must be EAX");
        if (strcasecmp($<str>4, "dx") != 0) yyerror("IN reg32, DX: second operand must be DX");
    }
  ;

ret_op:
    RET | RETF | RETN | RETW | RETD
    ;

ret_instr:
    ret_op { }
  | ret_op imm_op { }
  ;
shld_shrd_op:
    SHLD | SHRD
    ;

shld_shrd_instr:
    shld_shrd_op rm16_op COMMA reg16_op COMMA imm_op { }
  | shld_shrd_op rm16_op COMMA reg16_op COMMA reg8_op {
        if (strcasecmp($<str>5, "cl") != 0)
            yyerror("shift count must be CL or immediate");
    }
  | shld_shrd_op rm32_op COMMA reg32_op COMMA imm_op { }
  | shld_shrd_op rm32_op COMMA reg32_op COMMA reg8_op {
        if (strcasecmp($<str>5, "cl") != 0)
            yyerror("shift count must be CL or immediate");
    }
  ;

fpu_arith_op:
    FDIV | FDIVR | FMUL | FADD | FSUB | FSUBR
    ;

fpu_arith_instr:
    fpu_arith_op mem32_op { }
  | fpu_arith_op fpureg_op { }
  | fpu_arith_op fpureg_op COMMA fpu0_op { }
  | fpu_arith_op fpu0_op COMMA fpureg_op { }
  | fpu_arith_op { }
  ;

fpu_int_op:
    FIADD | FICOM | FICOMP | FIDIV | FIDIVR | FILD | FIMUL | FIST | FISTP | FISTTP | FISUB | FISUBR
    ;

fpu_int_instr:
    fpu_int_op mem16_op { }
  | fpu_int_op mem32_op { }
  ;

fnstsw_fstsw_op:
    FNSTSW | FSTSW
    ;

fnstsw_fstsw_instr:
    fnstsw_fstsw_op mem_op { }
  | fnstsw_fstsw_op reg16_op {
        if (strcasecmp($<str>2, "ax") != 0)
            yyerror("FNSTSW/FSTSW register operand must be AX");
    }
  ;

fcom_op:
    FCOM | FCOMP
    ;

fcom_instr:
    fcom_op mem32_op { }
  | fcom_op fpureg_op { }
  | fcom_op fpu0_op COMMA fpureg_op { }
  | fcom_op { }
  ;

ud_op:
    UD0 | UD1 | UD2B
    ;

ud_instr:
    ud_op { }
  | ud_op reg16_op COMMA rm16_op { }
  | ud_op reg32_op COMMA rm32_op { }
  ;

movzx_movsx_op:
    MOVZX | MOVSX
    ;

movzx_instr:
    movzx_movsx_op reg16_op COMMA reg8_op { }
  | movzx_movsx_op reg16_op COMMA mem8_op { }
  | movzx_movsx_op reg32_op COMMA rm8_op  { }
  | movzx_movsx_op reg32_op COMMA rm16_op { }
  ;

int_jmp_instr:
    INT imm_op { }
  | JECXZ jmp_target { }
  | JCXZ jmp_target { }
  | JCC jmp_target { }
  ;

fxch_instr:
    FXCH { }
  | FXCH fpureg_op { }
  | FXCH fpureg_op COMMA fpu0_op { }
  | FXCH fpu0_op COMMA fpureg_op { }
  ;

ffree_op:
    FFREE | FFREEP
    ;

ffree_instr:
    ffree_op { }
  | ffree_op fpureg_op { }
  | ffree_op fpu0_op { }
  ;

lar_lsl_op:
    LAR | LSL
    ;

lar_lsl_instr:
    lar_lsl_op reg16_op COMMA mem_op
  | lar_lsl_op reg16_op COMMA reg16_op
  | lar_lsl_op reg16_op COMMA reg32_op
  | lar_lsl_op reg32_op COMMA mem_op
  | lar_lsl_op reg32_op COMMA reg16_op
  | lar_lsl_op reg32_op COMMA reg32_op
  ;

llt_lmsw_ltr_op:
    LLDT | LMSW | LTR
    ;

llt_lmsw_ltr_instr:
    llt_lmsw_ltr_op rm16_op
  | llt_lmsw_ltr_op mem_base
  ;

mwait_op:
    MWAIT | MWAITX
    ;

mwait_instr:
    mwait_op { }
  | mwait_op reg32_op COMMA reg32_op {
        if (strcasecmp($<str>2, "eax") != 0) yyerror("first operand must be EAX");
        if (strcasecmp($<str>4, "ecx") != 0) yyerror("second operand must be ECX");
    }
  ;

verr_verw_op:
    VERR | VERW
    ;

verr_verw_instr:
    verr_verw_op rm16_op
  | verr_verw_op mem_base
  ;

mmxreg_op:
    MMXREG { }
    ;

mmxrm_op:
    mmxreg_op { }
  | mem_op    { }
  ;

mmx_instr:
    MMXOP mmxreg_op COMMA mmxrm_op { }
   | MMXOP mmxreg_op COMMA imm_op   { }
  ;

bswap_instr:
    BSWAP reg32_op { }
  ;

rdshr_wrshr_op:
    RDSHR | WRSHR
  ;

rdshr_wrshr_instr:
    rdshr_wrshr_op rm32_op { }
  ;

svldt_svts_rsldt_rsts_op:
    SVLDT | SVTS | RSLDT | RSTS
    ;

svldt_svts_rsldt_rsts_instr:
    svldt_svts_rsldt_rsts_op mem80_op { }
  ;

call_instr:
    CALL jmp_target
  | CALL jmp_target NEAR
  | CALL jmp_target FAR
  | CALL imm_op COLON imm_op
  | CALL mem_base
  | CALL mem_base FAR
  | CALL rm16_op NEAR
  | CALL rm32_op NEAR
  ;
xbts_instr:
    XBTS reg16_op COMMA mem_op
  | XBTS reg16_op COMMA reg16_op
  | XBTS reg32_op COMMA mem_op
  | XBTS reg32_op COMMA reg32_op
  ;

cmovcc_instr:
    CMOVCC reg16_op COMMA mem_op      { }
  | CMOVCC reg16_op COMMA reg16_op    { }
  | CMOVCC reg32_op COMMA mem_op      {  }
  | CMOVCC reg32_op COMMA reg32_op    {  }
  ;

ibts_instr:
    IBTS rm16_op COMMA reg16_op { }
  | IBTS rm32_op COMMA reg32_op { }
  ;

arpl_instr:
    ARPL rm16_op COMMA reg16_op { }
  ;

enter_instr:
    ENTER imm_op COMMA imm_op { }
  ;

equ_instr:
    EQU imm_op { }
  | EQU imm_op COLON imm_op { }
  ;

imul_instr:
    IMUL rm8_op
  | IMUL rm16_op
  | IMUL rm32_op
  | IMUL reg16_op COMMA rm16_op
  | IMUL reg32_op COMMA rm32_op
  | IMUL reg16_op COMMA imm_op
  | IMUL reg32_op COMMA imm_op
  | IMUL reg16_op COMMA rm16_op COMMA imm_op
  | IMUL reg32_op COMMA rm32_op COMMA imm_op
  ;

invpcid_instr:
    INVPCID reg32_op COMMA mem128_op { }
  ;

invlpga_instr:
    INVLPGA { }
  | INVLPGA reg32_op COMMA reg32_op {
        if (strcasecmp($<str>2, "eax") != 0) yyerror("INVLPGA: first operand must be EAX");
        if (strcasecmp($<str>4, "ecx") != 0) yyerror("INVLPGA: second operand must be ECX");
    }
  ;

jmp_instr:
    JMP jmp_target
  | JMP jmp_target NEAR
  | JMP jmp_target FAR
  | JMP imm_op COLON imm_op
  | JMP mem_base
  | JMP mem_base NEAR
  | JMP mem_base FAR
  | JMP rm16_op
  | JMP rm16_op NEAR
  | JMP rm32_op
  | JMP rm32_op NEAR
  ;

jmpe_instr:
    JMPE jmp_target
  | JMPE rm16_op
  | JMPE rm32_op
  ;

monitor_instr:
    MONITOR { }
  | MONITOR reg32_op COMMA reg32_op COMMA reg32_op {
        if (strcasecmp($<str>2, "eax") != 0) yyerror("MONITOR: first operand must be EAX");
        if (strcasecmp($<str>4, "ecx") != 0) yyerror("MONITOR: second operand must be ECX");
        if (strcasecmp($<str>6, "edx") != 0) yyerror("MONITOR: third operand must be EDX");
    }
  ;

monitorx_instr:
    MONITORX { }
  | MONITORX reg16_op COMMA reg32_op COMMA reg32_op {
        if (strcasecmp($<str>2, "ax") != 0) yyerror("MONITORX: first operand must be AX");
        if (strcasecmp($<str>4, "ecx") != 0) yyerror("MONITORX: second operand must be ECX");
        if (strcasecmp($<str>6, "edx") != 0) yyerror("MONITORX: third operand must be EDX");
    }
  | MONITORX reg32_op COMMA reg32_op COMMA reg32_op {
        if (strcasecmp($<str>2, "eax") != 0) yyerror("MONITORX: first operand must be EAX");
        if (strcasecmp($<str>4, "ecx") != 0) yyerror("MONITORX: second operand must be ECX");
        if (strcasecmp($<str>6, "edx") != 0) yyerror("MONITORX: third operand must be EDX");
    }
  ;

mov_instr:
    MOV rm8_op  COMMA rm8_op
  | MOV rm8_op  COMMA imm_op
  | MOV rm16_op COMMA rm16_op
  | MOV rm16_op COMMA imm_op
  | MOV rm16_op COMMA sreg_op
  | MOV sreg_op COMMA rm16_op
  | MOV rm32_op COMMA rm32_op
  | MOV rm32_op COMMA imm_op
  | MOV rm32_op COMMA sreg_op
  | MOV sreg_op COMMA rm32_op
  | MOV rm32_op COMMA creg_op
  | MOV creg_op COMMA rm32_op
  | MOV rm32_op COMMA dreg_op
  | MOV dreg_op COMMA rm32_op
  | MOV rm32_op COMMA treg_op
  | MOV treg_op COMMA rm32_op
  | MOV mem_base COMMA mem_base
  | MOV mem_base COMMA rm16_op
  | MOV mem_base COMMA rm32_op
  | MOV mem_base COMMA rm8_op
  | MOV rm32_op COMMA mem_base
  | MOV rm16_op COMMA mem_base
  | MOV rm8_op COMMA mem_base
  ;

nop_instr:
    NOP { }
  | NOP rm16_op {  }
  | NOP rm32_op {  }
  ;

movd_instr:
    MOVD mmxreg_op COMMA rm32_op   {  }
  | MOVD rm32_op COMMA mmxreg_op   { }
  ;

movq_instr:
    MOVQ mmxreg_op COMMA mmxrm_op   {  }
  | MOVQ mmxrm_op COMMA mmxreg_op   {  }
  ;

rsdc_instr:
    RSDC sreg_op COMMA mem80_op { }
  ;

test_instr:
    TEST rm8_op COMMA rm8_op
  | TEST rm16_op COMMA rm16_op
  | TEST rm32_op COMMA rm32_op
  | TEST reg8_op COMMA imm_op {
        if (strcasecmp($<str>2, "al") != 0)
            yyerror("TEST: reg8 immediate form requires AL");
    }
  | TEST reg16_op COMMA imm_op {
        if (strcasecmp($<str>2, "ax") != 0)
            yyerror("TEST: reg16 immediate form requires AX");
    }
  | TEST reg32_op COMMA imm_op {
        if (strcasecmp($<str>2, "eax") != 0)
            yyerror("TEST: reg32 immediate form requires EAX");
    }
   | TEST mem8_op COMMA imm_op
  | TEST mem16_op COMMA imm_op
  | TEST mem32_op COMMA imm_op
 ;

xchg_instr:
    XCHG rm8_op COMMA rm8_op
  | XCHG rm16_op COMMA rm16_op
  | XCHG rm32_op COMMA rm32_op
  ;

setcc_instr:
    SETCC rm8_op { printf(" %s", $1); }
  ;

lea_instr:
    LEA reg16_op COMMA mem_op
  | LEA reg32_op COMMA mem_op
  | LEA reg16_op COMMA imm_op
  | LEA reg32_op COMMA imm_op
  ;
/* ============ ОПЕРАНДЫ (ОПРЕДЕЛЕНИЯ) ============ */
reg8_op:  REG8  { $$ = $1; printf("    reg8: %s", $1); };
reg16_op: REG16 { $$ = $1; printf("    reg16: %s", $1); };
reg32_op: REG32 { $$ = $1; printf("    reg32: %s", $1); };
sreg_op:  SREG  { $$ = $1; printf(" %s", $1); };
fpureg_op:FPUREG  {$$ = $1; printf(" %s", $1); };
fpu0_op: FPU0 { $$ = $1; printf(" %s", $1); };

mem8_op:
    BYTE PTR mem_base   { printf("    byte ptr"); }
  | BYTE mem_base        { printf("    byte"); }
  ;

mem16_op:
    WORD PTR mem_base   { printf("    word ptr"); }
  | WORD mem_base        { printf("    word"); }
  ;

mem32_op:
    DWORD PTR mem_base  { printf("    dword ptr"); }
  | DWORD mem_base       { printf("    dword"); }
  ;

mem80_op:
    TWORD PTR mem_base  { printf("    tword ptr"); }
  | TWORD mem_base       { printf("    tword"); }
  ;
mem128_op:
    XMMWORD PTR mem_base   { printf("    xmmword ptr"); }
  | XMMWORD mem_base       { printf("    xmmword"); }
  ;

mem_op:
    mem8_op  { }
  | mem16_op { }
  | mem32_op { }
  | mem80_op { }
  | mem_base { }
  ;

rm8_op  : reg8_op  { } | mem8_op { } ;
rm16_op : reg16_op { } | mem16_op { } ;
rm32_op : reg32_op { } | mem32_op { } ;
creg_op: CREG { printf(" %s", $1); };
dreg_op: DREG { printf(" %s", $1); };
treg_op: TREG { printf(" %s", $1); };

mem_base:
    LBRACK mem_addr RBRACK
    ;

mem_addr:
    ID                     { printf(" [%s]", $1); }
  | REG32                { printf(" [%s]", $1); }
  | REG32 MULI NUMBER    { printf(" [%s*%d]", $1, $3); }
  | REG32 PLUS NUMBER    { printf(" [%s+%d]", $1, $3); }
  | REG32 PLUS REG32    { printf(" [%s+%s]", $1, $3); }
  | REG32 PLUS REG32 MULI NUMBER     { printf(" [%s+%s*%d]", $1, $3, $5); }
  | REG32 MINUS NUMBER   { printf(" [%s-%d]", $1, $3); }
  | NUMBER { printf(" [%d]", $1); }
  ;


imm_op:  NUMBER { printf("    imm: %d", ($1 & 0xFFFFFF)); } ;
jmp_target:
    NUMBER   { printf("    target: %d", ($1 & 0xFFFFFF)); }
  | ID       { printf("    target: %s", $1); }
  | DOT_ID   { printf("    local: %s", $1); }
  ;
label:
    ID COLON     { printf(" Label: %s", $1); }
  | DOT_ID COLON { printf(" LocalLabel: %s", $1); }
  ;

section_decl:
    SECTION section_name { printf(" Section: %s", $2); }
    | SEGMENT section_name { printf(" Segment: %s", $2); }
    ;
bare_section:
    DOT_ID EOL   { printf(" Section: %s\n", $1); }
    ;
section_name:
    ID      { $$ = $1; }
  | DOT_ID  { $$ = $1; }
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