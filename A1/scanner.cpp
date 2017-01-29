/**
 * Author: Vanessa White
 * Class: CIS*4650 Compilers
 * Purpose: Scanner for news article written in SGML
 * Date: January 2017
*/

#include "globals.h"
#include "util.h"
#include "scan.h"

// declare and init global variables
int rowno = 1;
extern FILE * yyin;
extern FILE * yyout;
extern TokenStack yylval;


int main(int argc, char const *argv[])
{
	yyin = stdin;
	yyout = stdout;

	enum Filters tokenType;

	while((tokenType = getToken()) != ENDFILE)
	{
		printToken(yyout, tokenType, yylval);
	}
	return 0;
}