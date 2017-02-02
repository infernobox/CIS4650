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
extern struct GlobalStack normalizedStack;
extern struct TokenStruct tokenValue;

int main(int argc, char const *argv[])
{
	yyin = stdin;
	yyout = stdout;

	enum Filters tokenType;

	// keep reading the file while there is tokens to read
	while((tokenType = getToken()) != ENDFILE)
	{
		printToken(yyout, tokenType, normalizedStack, tokenValue);
	}

	displayUnmatched(normalizedStack);
	return 0;
}