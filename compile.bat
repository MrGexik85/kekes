flex lexer.l
bison -d parser.y
gcc -c lex.yy.c parser.tab.c

gcc -o compiler.exe lex.yy.o parser.tab.o
