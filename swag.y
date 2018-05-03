%{
#include <stdio.h>    
#include <stdlib.h>
#include <ctype.h>
#include <iostream>
#include <vector>
#include <map>
#include <string>
#include "variable.h"
using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern int line_num; 
int symbols[52];
std::map<char*, Variable> varMap;
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
void yyerror(const char *s);
void addVariable(char* name, int val);
void addStringVariable(char* name, char* val);
%}

%union {
	int ival;
	char *sval;
    char id;
}

//Variable types
%token TT_INT TT_STR

//Compares
%token T_CEQ T_CNE T_CLT T_CLE T_CGT T_CGE

//Control
%token T_LPAREN T_RPAREN T_LBRACE T_RBRACE

//Math and assing
%left T_PLUS T_MINUS T_MUL T_DIV T_ASSIGN

//Termination
%token T_END T_ENDL

//Methods
%token T_PRINT

%token <ival> T_INT
%token <sval> T_ID
%type <ival> plain_statement exp term 
%type <sval> assignment

// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <sval> T_STRING

%start program

%%
// BNF gramatika:

program: block_statements ;

block_statements : block_statement | block_statements block_statement;

block_statement : 	statement 
					| T_END {cout << "bye." <<endl;}
					;

statement : plain_statement;

plain_statement :   assignment T_ENDL {;}
                    | T_PRINT exp T_ENDL			{cout << $2 <<endl;}
                    | TT_STR T_PRINT T_ID T_ENDL      {cout << varMap[$3].strVal <<endl;}
                    ;

assignment : TT_INT T_ID T_ASSIGN exp  { addVariable($2,$4); }
            | TT_STR T_ID T_ASSIGN T_STRING  { addStringVariable($2,$4); }
            ;

exp    	: term                  {$$ = $1;}
       	| exp T_PLUS term          {$$ = $1 + $3;}
       	| exp T_MINUS term          {$$ = $1 - $3;}
       	;

term   	: T_INT                {$$ = $1;}
		| T_ID			{ $$ = varMap[$1].intVal; }
        ;        
        
type    :   TT_INT
        |   TT_STR
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

/* Code written by Vakaris */

//weeeeeeeeeeeeeeeeed

void addVariable(char* name, int val){
    Variable var(name, val);
    varMap.insert(pair<char*, Variable>(name, var));
}

void addStringVariable(char* name, char* val){
    Variable var(name, val);
    varMap.insert(pair<char*, Variable>(name, var));
}

