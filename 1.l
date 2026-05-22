%{
#include "1.tab.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap

%%

[ \t]+               { /* ignore */ }
"\n"                 { return EOL; }

mov|MOV              { return MOV; }
add|ADD              { return ADD; }
inc|INC              { return INC; }
adc|ADC              { return ADC; }
sub|SUB              { return SUB; }
and|AND              { return AND; }
or|OR                { return OR; }
xor|XOR              { return XOR; }
cmp|CMP              { return CMP; }
sbb|SBB              { return SBB; }

neg|NEG              { return NEG; }
not|NOT              { return NOT; }
mul|MUL              { return MUL; }
idiv|IDIV            { return IDIV; }
div|DIV              { return DIV; }

shl|SHL              { return SHL; }
shr|SHR              { return SHR; }
sar|SAR              { return SAR; }
sal|SAL              { return SAL; }
rol|ROL              { return ROL; }
ror|ROR              { return ROR; }
rcl|RCL              { return RCL; }
rcr|RCR              { return RCR; }

bsf|BSF              { return BFS; }
bsr|BSR              { return BSR; }

btc|BTC              { return BTC; }
btr|BTR              { return BTR; }
bts|BTS              { return BTS; }

cmpxchg|CMPXCHG      { return CMPXCHG; }
cmpxchg486|CMPXCHG486 { return CMPXCHG486; }
xadd|XADD            { return XADD; }

pop|POP              { return POP; }
push|PUSH            { return PUSH; }

aad|AAD              { return AAD; }
aam|AAM              { return AAM; }

bound|BOUND          { return BOUND; }
lds|LDS              { return LDS; }
lgs|LGS              { return LGS; }
lss|LSS              { return LSS; }
les|LES              { return LES; }
lfs|LFS              { return LFS; }

loop|LOOP            { return LOOP; }
loope|LOOPE          { return LOOPE; }
loopne|LOOPNE        { return LOOPNE; }
loopnz|LOOPNZ        { return LOOPNZ; }
loopz|LOOPZ          { return LOOPZ; }

fbld|FBLD            { return FBLD; }
fbstp|FBSTP          { return FBSTP; }
fld|FLD              { return FLD; }
fstp|FSTP            { return FSTP; }

fcmovu|FCMOVU        { return FCMOVU; }
fcmovnu|FCMOVNU      { return FCMOVNU; }
fcmovne|FCMOVNE      { return FCMOVNE; }
fcomi|FCOMI          { return FCOMI; }
fcomip|FCOMIP        { return FCOMIP; }
fdivp|FDIVP          { return FDIVP; }
fdivrp|FDIVRP        { return FDIVRP; }
fcmovnbe|FCMOVNBE    { return FCMOVNBE; }
fcmovnb|FCMOVNB      { return FCMOVNB; }

fucom|FUCOM          { return FUCOM; }
fucomip|FUCOMIP      { return FUCOMIP; }
fucomp|FUCOMP        { return FUCOMP; }
fsubrp|FSUBRP        { return FSUBRP; }
fsubp|FSUBP          { return FSUBP; }
fucomi|FUCOMI        { return FUCOMI; }
fmulp|FMULP          { return FMULP; }

lgdt|LGDT            { return LGDT; }
lidt|LIDT            { return LIDT; }
sidt|SIDT            { return SIDT; }
sgdt|SGDT            { return SGDT; }
fstcw|FSTCW          { return FSTCW; }
fnsave|FNSAVE        { return FNSAVE; }
fldcw|FLDCW          { return FLDCW; }
fstenv|FSTENV        { return FSTENV; }
fnstcw|FNSTCW        { return FNSTCW; }
fldenv|FLDENV        { return FLDENV; }
frstor|FRSTOR        { return FRSTOR; }
fnstenv|FNSTENV      { return FNSTENV; }
invlpg|INVLPG        { return INVLPG; }
fsave|FSAVE          { return FSAVE; }

sldt|SLDT            { return SLDT; }
smsw|SMSW            { return SMSW; }

out|OUT              { return OUT; }
in|IN                { return IN; }

ret|RET              { return RET; }
retf|RETF            { return RETF; }
retn|RETN            { return RETN; }
retw|RETW            { return RETW; }
retd|RETD            { return RETD; }

shld|SHLD            { return SHLD; }
shrd|SHRD            { return SHRD; }

fdiv|FDIV            { return FDIV; }
fdivr|FDIVR          { return FDIVR; }
fmul|FMUL            { return FMUL; }
fadd|FADD            { return FADD; }
fsub|FSUB            { return FSUB; }
fsubr|FSUBR          { return FSUBR; }

fiadd|FIADD          { return FIADD; }
ficom|FICOM          { return FICOM; }
ficomp|FICOMP        { return FICOMP; }
fidiv|FIDIV          { return FIDIV; }
fidivr|FIDIVR        { return FIDIVR; }
fild|FILD            { return FILD; }
fimul|FIMUL          { return FIMUL; }
fist|FIST            { return FIST; }
fistp|FISTP          { return FISTP; }
fisttp|FISTTP        { return FISTTP; }
fisub|FISUB          { return FISUB; }
fisubr|FISUBR        { return FISUBR; }

fnstsw|FNSTSW        { return FNSTSW; }
fstsw|FSTSW          { return FSTSW; }

fcom|FCOM            { return FCOM; }
fcomp|FCOMP          { return FCOMP; }

ud0|UD0              { return UD0; }
ud1|UD1              { return UD1; }
ud2b|UD2B            { return UD2B; }

movzx|MOVZX          { return MOVZX; }
movsx|MOVSX          { return MOVSX; }

int|INT              { return INT; }
jecxz|JECXZ          { return JECXZ; }
jcxz|JCXZ            { return JCXZ; }

ja|JA|jae|JAE|jb|JB|jbe|JBE|jc|JC|je|JE|jg|JG|jge|JGE|jl|JL|jle|JLE|jna|JNA|jnae|JNAE|jnb|JNB|jnbe|JNBE|jnc|JNC|jne|JNE|jng|JNG|jnge|JNGE|jnl|JNL|jnle|JNLE|jno|JNO|jnp|JNP|jns|JNS|jnz|JNZ|jo|JO|jp|JP|jpe|JPE|jpo|JPO|js|JS|jz|JZ { return JCC; }

aaa|AAA              { return ZOP_AAA; }
aas|AAS              { return ZOP_AAS; }
daa|DAA              { return ZOP_DAA; }
das|DAS              { return ZOP_DAS; }

cbw|CBW              { return ZOP_CBW; }
cwd|CWD              { return ZOP_CWD; }
cwde|CWDE            { return ZOP_CWDE; }
cdq|CDQ              { return ZOP_CDQ; }
cdqe|CDQE            { return ZOP_CDQE; }

clc|CLC              { return ZOP_CLC; }
cld|CLD              { return ZOP_CLD; }
cli|CLI              { return ZOP_CLI; }
clts|CLTS            { return ZOP_CLTS; }
cmc|CMC              { return ZOP_CMC; }
stc|STC              { return ZOP_STC; }
std|STD              { return ZOP_STD; }
sti|STI              { return ZOP_STI; }

lahf|LAHF            { return ZOP_LAHF; }
sahf|SAHF            { return ZOP_SAHF; }

pusha|PUSHA|pushad|PUSHAD|pushaw|PUSHAW { return ZOP_PUSHA; }
popa|POPA|popad|POPAD|popaw|POPAW       { return ZOP_POPA; }
pushf|PUSHF|pushfd|PUSHFD|pushfw|PUSHFW|pushfq|PUSHFQ { return ZOP_PUSHF; }
popf|POPF|popfd|POPFD|popfw|POPFW|popfq|POPFQ       { return ZOP_POPF; }
leave|LEAVE          { return ZOP_LEAVE; }

hlt|HLT              { return ZOP_HLT; }
cpuid|CPUID          { return ZOP_CPUID; }
rdtsc|RDTSC          { return ZOP_RDTSC; }
rdpmc|RDPMC          { return ZOP_RDPMC; }
rdmsr|RDMSR          { return ZOP_RDMSR; }
wrmsr|WRMSR          { return ZOP_WRMSR; }
invd|INVD            { return ZOP_INVD; }
wbinvd|WBINVD        { return ZOP_WBINVD; }

syscall|SYSCALL      { return ZOP_SYSCALL; }
sysenter|SYSENTER    { return ZOP_SYSENTER; }
sysexit|SYSEXIT      { return ZOP_SYSEXIT; }
sysret|SYSRET        { return ZOP_SYSRET; }
swapgs|SWAPGS        { return ZOP_SWAPGS; }

movsb|MOVSB          { return ZOP_MOVS; }
movsw|MOVSW          { return ZOP_MOVS; }
movsd|MOVSD          { return ZOP_MOVS; }
movsq|MOVSQ          { return ZOP_MOVSQ; }

cmpsb|CMPSB          { return ZOP_CMPS; }
cmpsw|CMPSW          { return ZOP_CMPS; }
cmpsd|CMPSD          { return ZOP_CMPS; }
cmpsq|CMPSQ          { return ZOP_CMPSQ; }

scasb|SCASB          { return ZOP_SCAS; }
scasw|SCASW          { return ZOP_SCAS; }
scasd|SCASD          { return ZOP_SCAS; }
scasq|SCASQ          { return ZOP_SCASQ; }

stosb|STOSB          { return ZOP_STOS; }
stosw|STOSW          { return ZOP_STOS; }
stosd|STOSD          { return ZOP_STOS; }
stosq|STOSQ          { return ZOP_STOSQ; }

lodsb|LODSB          { return ZOP_LODS; }
lodsw|LODSW          { return ZOP_LODS; }
lodsd|LODSD          { return ZOP_LODS; }
lodsq|LODSQ          { return ZOP_LODSQ; }

insb|INSB            { return ZOP_INS; }
insw|INSW            { return ZOP_INS; }
insd|INSD            { return ZOP_INS; }

outsb|OUTSB          { return ZOP_OUTS; }
outsw|OUTSW          { return ZOP_OUTS; }
outsd|OUTSD          { return ZOP_OUTS; }

f2xm1|F2XM1|fabs|FABS|fchs|FCHS|fclex|FCLEX|fdecstp|FDECSTP|fdisi|FDISI|feni|FENI|fincstp|FINCSTP|finit|FINIT|fninit|FNINIT|fnop|FNOP|fpatan|FPATAN|fprem|FPREM|fprem1|FPREM1|fptan|FPTAN|frndint|FRNDINT|fscale|FSCALE|fsqrt|FSQRT|ftst|FTST|fxam|FXAM|fxtract|FXTRACT|fyl2x|FYL2X|fyl2xp1|FYL2XP1|fcompp|FCOMPP|fucompp|FUCOMPP|fsin|FSIN|fcos|FCOS|fsincos|FSINCOS|fld1|FLD1|fldl2e|FLDL2E|fldl2t|FLDL2T|fldlg2|FLDLG2|fldln2|FLDLN2|fldpi|FLDPI|fldz|FLDZ|fsetpm|FSETPM|fnclex|FNCLEX|fndisi|FNDISI|fneni|FNENI|fninit|FNINIT { return ZOP_FPU; }

pause|PAUSE          { return ZOP_PAUSE; }
wait|WAIT|fwait|FWAIT { return ZOP_FWAIT; }
xlat|XLAT|xlatb|XLATB { return ZOP_XLAT; }
ud2|UD2|ud2a|UD2A    { return ZOP_UD2; }
icebp|ICEBP          { return ZOP_ICEBP; }
int3|INT3|int03|INT03 { return ZOP_INT3; }
into|INTO            { return ZOP_INTO; }
salc|SALC            { return ZOP_SALC; }
rdtscp|RDTSCP        { return ZOP_RDTSCP; }
rsm|RSM              { return ZOP_RSM; }
smint|SMINT|smintold|SMINTOLD { return ZOP_SMINT; }
rdm|RDM              { return ZOP_RDM; }

al|AL|ah|AH|bl|BL|bh|BH|cl|CL|ch|CH|dl|DL|dh|DH  { yylval.str = strdup(yytext); return REG8; }
ax|AX|bx|BX|cx|CX|dx|DX|si|SI|di|DI|sp|SP|bp|BP  { yylval.str = strdup(yytext); return REG16; }
eax|EAX|ebx|EBX|ecx|ECX|edx|EDX|esi|ESI|edi|EDI|esp|ESP|ebp|EBP  { yylval.str = strdup(yytext); return REG32; }
es|ES|cs|CS|ss|SS|ds|DS|fs|FS|gs|GS              { yylval.str = strdup(yytext); return SREG; }

st0|ST0|st\(0\)|ST\(0\)        { yylval.str = strdup(yytext); return FPU0; }
st[1-7]|ST[1-7]|st\([1-7]\)|ST\([1-7]\) { yylval.str = strdup(yytext); return FPUREG; }

tword|TWORD          { return TWORD; }

0[xX][0-9A-Fa-f]+    { yylval.num = strtol(yytext+2, NULL, 16); return NUMBER; }
[0-9]+[hH]           { char *end; yylval.num = strtol(yytext, &end, 16); return NUMBER; }
[0-9]+               { yylval.num = atoi(yytext); return NUMBER; }

byte|BYTE            { return BYTE; }
word|WORD            { return WORD; }
dword|DWORD          { return DWORD; }
ptr|PTR              { return PTR; }

","                  { return COMMA; }
"["                  { return LBRACK; }
"]"                  { return RBRACK; }
"+"                  { return PLUS; }
"-"                  { return MINUS; }

packssdw|PACKSSDW|packsswb|PACKSSWB|packuswb|PACKUSWB|paddb|PADDB|paddd|PADDD|paddsb|PADDSB|paddsiw|PADDSIW|paddsw|PADDSW|paddusb|PADDUSB|paddusw|PADDUSW|paddw|PADDW|pand|PAND|pandn|PANDN|paveb|PAVEB|pavgusb|PAVGUSB|pcmpeqb|PCMPEQB|pcmpeqd|PCMPEQD|pcmpeqw|PCMPEQW|pcmpgtb|PCMPGTB|pcmpgtd|PCMPGTD|pcmpgtw|PCMPGTW|pf2id|PF2ID|pfacc|PFACC|pfadd|PFADD|pfcmpeq|PFCMPEQ|pfcmpge|PFCMPGE|pfcmpgt|PFCMPGT|pfmax|PFMAX|pfmin|PFMIN|pfmul|PFMUL|pfrcp|PFRCP|pfrcpit1|PFRCPIT1|pfrcpit2|PFRCPIT2|pfrsqit1|PFRSQIT1|pfrsqrt|PFRSQRT|pfsub|PFSUB|pfsubr|PFSUBR|pi2fd|PI2FD|pmaddwd|PMADDWD|pmagw|PMAGW|pmulhriw|PMULHRIW|pmulhrwa|PMULHRWA|pmulhrwc|PMULHRWC|pmulhw|PMULHW|pmullw|PMULLW|psubb|PSUBB|psubd|PSUBD|psubsb|PSUBSB|psubsiw|PSUBSIW|psubsw|PSUBSW|psubusb|PSUBUSB|psubusw|PSUBUSW|psubw|PSUBW|punpckhbw|PUNPCKHBW|punpckhdq|PUNPCKHDQ|punpckhwd|PUNPCKHWD|punpcklbw|PUNPCKLBW|punpckldq|PUNPCKLDQ|punpcklwd|PUNPCKLWD|por|POR|pxor|PXOR { yylval.str = strdup(yytext); return MMXOP; }

mm0|MM0|mm1|MM1|mm2|MM2|mm3|MM3|mm4|MM4|mm5|MM5|mm6|MM6|mm7|MM7 { yylval.str = strdup(yytext); return MMXREG; }

prefetch|PREFETCH      { return PREFETCH; }
prefetchw|PREFETCHW    { return PREFETCHW; }
str|STR                { return STR; }
ffree|FFREE            { return FFREE; }
ffreep|FFREEP          { return FFREEP; }
fxch|FXCH              { return FXCH; }
lar|LAR                { return LAR; }
lsl|LSL                { return LSL; }
lldt|LLDT              { return LLDT; }
lmsw|LMSW              { return LMSW; }
ltr|LTR                { return LTR; }
mwait|MWAIT            { return MWAIT; }
mwaitx|MWAITX          { return MWAITX; }
verr|VERR              { return VERR; }
verw|VERW              { return VERW; }
bswap|BSWAP            { return BSWAP; }
rdshr|RDSHR            { return RDSHR; }
wrshr|WRSHR            { return WRSHR; }
svldt|SVLDT            { return SVLDT; }
svts|SVTS              { return SVTS; }
rsldt|RSLDT            { return RSLDT; }
rsts|RSTS              { return RSTS; }
call|CALL              { return CALL; }
near|NEAR              { return NEAR; }
far|FAR                { return FAR; }
":"                    { return COLON; }
xbts|XBTS              { return XBTS; }
ibts|IBTS              { return IBTS; }
arpl|ARPL              { return ARPL; }
enter|ENTER            { return ENTER; }
equ|EQU                { return EQU; }
nop|NOP                { return NOP; }
movd|MOVD              { return MOVD; }
movq|MOVQ              { return MOVQ; }
rsdc|RSDC              { return RSDC; }
test|TEST              { return TEST; }
xchg|XCHG              { return XCHG; }
fst|FST                { return FST; }
imul|IMUL              { return IMUL; }
invpcid|INVPCID        { return INVPCID; }
invlpga|INVLPGA        { return INVLPGA; }
jmp|JMP                { return JMP; }
jmpe|JMPE              { return JMPE; }
monitor|MONITOR        { return MONITOR; }
monitorx|MONITORX      { return MONITORX; }
cpu_read|CPU_READ      { return CPU_READ; }
cpu_write|CPU_WRITE    { return CPU_WRITE; }
femms|FEMMS            { return FEMMS; }
loadall|LOADALL        { return LOADALL; }
loadall286|LOADALL286  { return LOADALL286; }
xmmword|XMMWORD|oword|OWORD { return XMMWORD; }

cmova|CMOVA|cmovae|CMOVAE|cmovb|CMOVB|cmovbe|CMOVBE|cmovc|CMOVC|cmove|CMOVE|cmovg|CMOVG|cmovge|CMOVGE|cmovl|CMOVL|cmovle|CMOVLE|cmovna|CMOVNA|cmovnae|CMOVNAE|cmovnb|CMOVNB|cmovnbe|CMOVNBE|cmovnc|CMOVNC|cmovne|CMOVNE|cmovng|CMOVNG|cmovnge|CMOVNGE|cmovnl|CMOVNL|cmovnle|CMOVNLE|cmovno|CMOVNO|cmovnp|CMOVNP|cmovns|CMOVNS|cmovnz|CMOVNZ|cmovo|CMOVO|cmovp|CMOVP|cmovpe|CMOVPE|cmovpo|CMOVPO|cmovs|CMOVS|cmovz|CMOVZ { yylval.str = strdup(yytext); return CMOVCC; }

seta|SETA|setae|SETAE|setb|SETB|setbe|SETBE|setc|SETC|sete|SETE|setg|SETG|setge|SETGE|setl|SETL|setle|SETLE|setna|SETNA|setnae|SETNAE|setnb|SETNB|setnbe|SETNBE|setnc|SETNC|setne|SETNE|setng|SETNG|setnge|SETNGE|setnl|SETNL|setnle|SETNLE|setno|SETNO|setnp|SETNP|setns|SETNS|setnz|SETNZ|seto|SETO|setp|SETP|setpe|SETPE|setpo|SETPO|sets|SETS|setz|SETZ { yylval.str = strdup(yytext); return SETCC; }

cr0|CR0|cr2|CR2|cr3|CR3|cr4|CR4 { yylval.str = strdup(yytext); return CREG; }
dr0|DR0|dr1|DR1|dr2|DR2|dr3|DR3|dr6|DR6|dr7|DR7 { yylval.str = strdup(yytext); return DREG; }
tr6|TR6|tr7|TR7                   { yylval.str = strdup(yytext); return TREG; }

pslld|PSLLD|psllq|PSLLQ|psllw|PSLLW|psrad|PSRAD|psraw|PSRAW|psrld|PSRLD|psrlq|PSRLQ|psrlw|PSRLW { yylval.str = strdup(yytext); return MMXOP; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

;.*                  { /* ignore */ }

.                    { fprintf(stderr, "Unknown character: %s\n", yytext); }

%%
