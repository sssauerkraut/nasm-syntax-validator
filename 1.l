%{
#include "1.tab.h"
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

%%

[ \t]+               { /* ignore */ }
"\n"                 { return EOL; }

mov                  { return MOV; }
add                  { return ADD; }
inc                  { return INC; }

eax|ebx|ecx|edx      { yylval.str = strdup(yytext); return REG; }

[0-9]+               { yylval.num = atoi(yytext); return NUMBER; }

","                  { return COMMA; }

;.*                  { /* comment */ }

.                    { fprintf(stderr, "Unknown character: %s\n", yytext); }

%%