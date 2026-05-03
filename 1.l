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