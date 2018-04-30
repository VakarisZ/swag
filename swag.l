%option noyywrap
%{
#include <stdio.h>
#include <iostream>
#define YY_DECL extern "C" int yylex()
int line_num = 1;
using namespace std;
#include "swag.tab.h"  // to get the token types that we return
%}
%%
sWaG        { return SWAG; }
type           { return TYPE; }
"end"            { return T_END; }
[ \t]           ;
[0-9]+            { yylval.ival = atoi(yytext); return T_INT; }
[a-zA-Z]			   {yylval.id = yytext[0]; return T_ID;}
\"[a-zA-Z0-9]+\"      {
	// we have to copy because we can't rely on yytext not changing underneath us:
	yylval.sval = strdup(yytext);
	return T_STRING;
}
"print"				    { return T_PRINT; }
"="                     { return T_ASSIGN; }
"=="                    { return T_CEQ; }
"!="                    { return T_CNE; }
"<"                     { return T_CLT; }
"<="                    { return T_CLE; }
">"                     { return T_CGT; }
">="                    { return T_CGE; }
"("                     { return T_LPAREN ;}
")"                     { return T_RPAREN ;}
"{"                     { return T_LBRACE ;}
"}"                     { return T_RBRACE ;}
"+"                     { return T_PLUS ;}
"-"                     { return T_MINUS ;}
"*"                     { return T_MUL ;}
"/"                     { return T_DIV; }
.                       printf("Unknown token!n"); yyterminate();
\n { ++line_num; return T_ENDL; }
%%