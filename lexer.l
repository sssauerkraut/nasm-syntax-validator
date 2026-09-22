%{
#include "polynomial.h"
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>

extern int yylineno;

/* Собственный strdup, чтобы не зависеть от _GNU_SOURCE */
static char* lex_strdup(const char* s) {
    size_t n = strlen(s) + 1;
    char* r = (char*)malloc(n);
    if (r) memcpy(r, s, n);
    return r;
}

/* Флаг: emit END один раз в конце файла, чтобы закрыть последнюю строку
   без завершающего \n */
static int eof_end_emitted = 0;
%}

%option noyywrap
%option yylineno

digit       [0-9]
letter      [a-zA-Z]
integer     {digit}+
real        {integer}\.{integer}
ident       {letter}
whitespace  [ \t\r]

%%

{real}          { yylval.dval = atof(yytext); return NUMBER; }
{integer}       { yylval.dval = atof(yytext); return NUMBER; }
{ident}         { yylval.sval = lex_strdup(yytext); return IDENT; }

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }
"^"             { return POW; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"="             { return ASSIGN; }
"?"             { return QUESTION; }
\n              { return END; }

"#"[^\n]*       { /* комментарий до конца строки */ }
{whitespace}+   { /* игнорируем пробелы и табы */ }

<<EOF>>         {
                    if (!eof_end_emitted) {
                        eof_end_emitted = 1;
                        return END;
                    }
                    yyterminate();
                }

.               { printf("LEX: unknown char '%c' (0x%02X)\n",
                         yytext[0], (unsigned char)yytext[0]); }

%%