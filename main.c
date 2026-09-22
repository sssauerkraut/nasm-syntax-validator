#include <stdio.h>
#include <stdlib.h>
#include "polynomial.h"

extern int   yyparse(void);
extern FILE* yyin;
extern int   yylineno;

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input-file>\n", argv[0]);
        fprintf(stderr, "  Input file example:\n");
        fprintf(stderr, "    A = x + 1\n");
        fprintf(stderr, "    B = x - 1\n");
        fprintf(stderr, "    C = A * B\n");
        fprintf(stderr, "    C = ?\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Cannot open file: %s\n", argv[1]);
        return 1;
    }

    printf("Processing file: %s\n\n", argv[1]);
    yylineno = 1;
    yyparse();
    fclose(yyin);
    return 0;
}