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

aaa|AAA              { return ZOP_AAA; }
aas|AAS              { return ZOP_AAA; }   /* было смешано, теперь раздельно */
daa|DAA              { return ZOP_DAA; }
das|DAS              { return ZOP_DAA; }   /* аналогично */

cbw|CBW|cwd|CWD|cwde|CWDE|cdq|CDQ { return ZOP_CBW; }
cdqe|CDQE            { return ZOP_CDQE; }

clc|CLC|cld|CLD|cli|CLI|clts|CLTS|cmc|CMC|stc|STC|std|STD|sti|STI { return ZOP_CLC; }
lahf|LAHF|sahf|SAHF  { return ZOP_LAHF; }

pusha|PUSHA|pushad|PUSHAD|pushaw|PUSHAW { return ZOP_PUSHA; }
popa|POPA|popad|POPAD|popaw|POPAW       { return ZOP_POPA; }
pushf|PUSHF|pushfd|PUSHFD|pushfw|PUSHFW|pushfq|PUSHFQ { return ZOP_PUSHF; }
popf|POPF|popfd|POPFD|popfw|POPFW|popfq|POPFQ       { return ZOP_POPF; }
leave|LEAVE          { return ZOP_LEAVE; }

hlt|HLT              { return ZOP_HLT; }
cpuid|CPUID          { return ZOP_CPUID; }
rdtsc|RDTSC|rdpmc|RDPMC|rdmsr|RDMSR { return ZOP_RDTSC; }
wrmsr|WRMSR          { return ZOP_WRMSR; }
invd|INVD|wbinvd|WBINVD { return ZOP_INVD; }
syscall|SYSCALL|sysenter|SYSENTER|sysexit|SYSEXIT|sysret|SYSRET { return ZOP_SYSCALL; }
swapgs|SWAPGS        { return ZOP_SWAPGS; }

movsb|MOVSB|movsw|MOVSW|movsd|MOVSD { return ZOP_MOVS; }
movsq|MOVSQ          { return ZOP_MOVSQ; }
cmpsb|CMPSB|cmpsw|CMPSW|cmpsd|CMPSD { return ZOP_CMPS; }
cmpsq|CMPSQ          { return ZOP_CMPSQ; }
scasb|SCASB|scasw|SCASW|scasd|SCASD { return ZOP_SCAS; }
scasq|SCASQ          { return ZOP_SCASQ; }
stosb|STOSB|stosw|STOSW|stosd|STOSD { return ZOP_STOS; }
stosq|STOSQ          { return ZOP_STOSQ; }
lodsb|LODSB|lodsw|LODSW|lodsd|LODSD { return ZOP_LODS; }
lodsq|LODSQ          { return ZOP_LODSQ; }
insb|INSB|insw|INSW|insd|INSD       { return ZOP_INS; }
outsb|OUTSB|outsw|OUTSW|outsd|OUTSD { return ZOP_OUTS; }

f2xm1|F2XM1|fabs|FABS|fchs|FCHS|fclex|FCLEX|fdecstp|FDECSTP|fdisi|FDISI|feni|FENI|fincstp|FINCSTP|finit|FINIT|fninit|FNINIT|fnop|FNOP|fpatan|FPATAN|fprem|FPREM|fprem1|FPREM1|fptan|FPTAN|frndint|FRNDINT|fscale|FSCALE|fsqrt|FSQRT|fstp|FSTP|ftst|FTST|fxam|FXAM|fxch|FXCH|fxtract|FXTRACT|fyl2x|FYL2X|fyl2xp1|FYL2XP1|fcompp|FCOMPP|fcomp|FCOMP|fucompp|FUCOMPP|fsin|FSIN|fcos|FCOS|fsincos|FSINCOS|fld1|FLD1|fldl2e|FLDL2E|fldl2t|FLDL2T|fldlg2|FLDLG2|fldln2|FLDLN2|fldpi|FLDPI|fldz|FLDZ|fsetpm|FSETPM|fnclex|FNCLEX|fndisi|FNDISI|fneni|FNENI|fninit|FNINIT { return ZOP_FPU; }

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

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

;.*                  { /* ignore */ }

.                    { fprintf(stderr, "Unknown character: %s\n", yytext); }

%%
