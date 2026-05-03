@echo off
bison -d 1.y
flex 1.l
gcc -o parser.exe 1.tab.c lex.yy.c
echo Build complete!