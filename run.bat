bison -d swag.y
flex -oswag.lex.c swag.l
gcc -o $@ swag.tab.c swag.lex.c swagfuncs.c