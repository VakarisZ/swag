%{
#include <stdio.h>    
#include <stdlib.h>
#include <ctype.h>
#include <iostream>
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num; 
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	char *sval;
    char id;
}
%token SWAG TYPE
//Compares
%token T_CEQ T_CNE T_CLT T_CLE T_CGT T_CGE
//Utils
%token T_LPAREN T_RPAREN T_LBRACE T_RBRACE
//Math and assing
%left T_PLUS T_MINUS T_MUL T_DIV T_ASSIGN
//Termination
%token T_END T_ENDL
//Methods
%token T_PRINT

%token <ival> T_INT
%token <id> T_ID
%type <ival> plain_statement exp term 
%type <id> assignment

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token sval T_STRING

%start program

%%
// BNF gramatika:

program: block_statements ;

block_statements : block_statement | block_statements block_statement;

block_statement : statement | T_END;

statement : plain_statement;

plain_statement :   assignment T_ENDL {;}
                    | T_PRINT exp T_ENDL			{printf("Printing %d\n", $2);}
                    ;

assignment : T_ID T_ASSIGN exp  { updateSymbolVal($1,$3); } T_ENDL

exp    	: term                  {$$ = $1;}
       	| exp '+' term          {$$ = $1 + $3;}
       	| exp '-' term          {$$ = $1 - $3;}
       	;

term   	: T_INT                {$$ = $1;}
		| T_ID			{$$ = symbolVal($1);} 
        ;        
        

%%

int main(int, char**) {
	// open a file handle to a particular file:
	FILE *myfile = fopen("swag.in", "r");
	// make sure it is valid:
	if (!myfile) {
		cout << "I can't open swag.in!" << endl;
		return -1;
	}
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	
}

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

void yyerror(const char *s) {
	cout << "EEK, parse error on line " << line_num << "! Message: " << s << endl;
	// might as well halt now:
	exit(-1);
}