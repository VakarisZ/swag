flex swag.l
bison -d swag.y
g++ swag.tab.c lex.yy.c -L"E:\GnuWin32\lib" -o result.exe