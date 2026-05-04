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

mov                  { return MOV; }
add                  { return ADD; }
inc                  { return INC; }
adc                  { return ADC; }
sub                  { return SUB; }
and                  { return AND; }
or                   { return OR; }
xor                  { return XOR; }
cmp                  { return CMP; }
sbb                  { return SBB; }

aaa|AAS                { return ZOP_AAA; }
daa|das                { return ZOP_DAA; }
cbw|cwd|cwde|cdq       { return ZOP_CBW; }
cdqe                   { return ZOP_CDQE; }

clc|cld|cli|clts|cmc|stc|std|sti  { return ZOP_CLC; }
lahf|sahf              { return ZOP_LAHF; }

pusha|pushad|pushaw    { return ZOP_PUSHA; }
popa|popad|popaw       { return ZOP_POPA; }
pushf|pushfd|pushfw|pushfq { return ZOP_PUSHF; }
popf|popfd|popfw|popfq { return ZOP_POPF; }
leave                  { return ZOP_LEAVE; }

hlt                    { return ZOP_HLT; }
cpuid                  { return ZOP_CPUID; }
rdtsc|rdpmc|rdmsr      { return ZOP_RDTSC; }
wrmsr                  { return ZOP_WRMSR; }
invd|wbinvd            { return ZOP_INVD; }
syscall|sysenter|sysexit|sysret { return ZOP_SYSCALL; }
swapgs                 { return ZOP_SWAPGS; }

movsb|movsw|movsd      { return ZOP_MOVS; }
movsq                  { return ZOP_MOVSQ; }
cmpsb|cmpsw|cmpsd      { return ZOP_CMPS; }
cmpsq                  { return ZOP_CMPSQ; }
scasb|scasw|scasd      { return ZOP_SCAS; }
scasq                  { return ZOP_SCASQ; }
stosb|stosw|stosd      { return ZOP_STOS; }
stosq                  { return ZOP_STOSQ; }
lodsb|lodsw|lodsd      { return ZOP_LODS; }
lodsq                  { return ZOP_LODSQ; }
insb|insw|insd         { return ZOP_INS; }
outsb|outsw|outsd      { return ZOP_OUTS; }

f2xm1|fabs|fchs|fclex|fdecstp|fdisi|feni|fincstp|finit
fninit|fnop|fpatan|fprem|fprem1|fptan|frndint|fscale
fsqrt|fstp|ftst|fxam|fxch|fxtract|fyl2x|fyl2xp1
fcompp|fcomp|fucompp|fsin|fcos|fsincos
fld1|fldl2e|fldl2t|fldlg2|fldln2|fldpi|fldz
fsetpm|fnclex|fndisi|fneni|fninit                { return ZOP_FPU; }

pause                  { return ZOP_PAUSE; }
wait|fwait             { return ZOP_FWAIT; }
xlat|xlatb             { return ZOP_XLAT; }
ud2|ud2a               { return ZOP_UD2; }
icebp                  { return ZOP_ICEBP; }
int3|int03             { return ZOP_INT3; }
into                   { return ZOP_INTO; }
salc                   { return ZOP_SALC; }
rdtscp                 { return ZOP_RDTSCP; }
rsm                    { return ZOP_RSM; }
smint|smintold         { return ZOP_SMINT; }
rdm                    { return ZOP_RDM; }


al|ah|bl|bh|cl|ch|dl|dh  { yylval.str = strdup(yytext); return REG8; }

ax|bx|cx|dx|si|di|sp|bp  { yylval.str = strdup(yytext); return REG16; }

eax|ebx|ecx|edx|esi|edi|esp|ebp  { yylval.str = strdup(yytext); return REG32; }

0[xX][0-9A-Fa-f]+    { yylval.num = strtol(yytext+2, NULL, 16); return NUMBER; }
[0-9]+[hH]           { char *end; yylval.num = strtol(yytext, &end, 16); return NUMBER; }
[0-9]+               { yylval.num = atoi(yytext); return NUMBER; }

-[0-9]+              { yylval.num = atoi(yytext); return SBYTE; }

byte|BYTE            { return BYTE_PTR; }
word|WORD            { return WORD_PTR; }
dword|DWORD          { return DWORD_PTR; }
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