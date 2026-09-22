typedef union {
    double       dval;
    Polynomial*  poly;
    char*        sval;
} YYSTYPE;
#define	NUMBER	257
#define	IDENT	258
#define	PLUS	259
#define	MINUS	260
#define	MUL	261
#define	DIV	262
#define	POW	263
#define	LPAREN	264
#define	RPAREN	265
#define	END	266
#define	ASSIGN	267
#define	QUESTION	268
#define	IMPLICIT	269


extern YYSTYPE yylval;
