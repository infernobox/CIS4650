/**
 * Author: Vanessa White
 * File: util.cpp
 * Class: CIS*4650 Compilers
 * Purpose: Utiliy functions for the SGML 
 * Date: February, 2nd 2017
*/

#include "globals.h"
#include "util.h"
#include "scan.h"

using namespace std;

void printToken( FILE * outfile, enum Filters token, struct GlobalStack &globalStack, struct TokenStruct &tokenStruct) {

	switch(token) 
	{
		case ERROR:
			fprintf(stderr, "error at line(%d): no matching OPEN-TAG for %s\n", rowno, tokenStruct.value.c_str());
			break;
		case OPENTAG:
			fprintf(outfile, "OPEN-%s\n", globalStack.value.back().c_str());
			break;
		case CLOSETAG:
			fprintf(outfile, "CLOSE-%s\n", tokenStruct.value.c_str());
			break;
		case WORD:
			fprintf(outfile, "WORD(%s)\n", tokenStruct.value.c_str());
			break;
		case NUMBER:
			fprintf(outfile, "NUMBER(%s)\n", tokenStruct.value.c_str());
			break;
		case APOSTROPHIZED:
			fprintf(outfile, "APOSTROPHIZED(%s)\n", tokenStruct.value.c_str());
			break;
		case HYPHENATED:
			fprintf(outfile, "HYPHENATED(%s)\n", tokenStruct.value.c_str());
			break;
		case PUNCTUATION:
			fprintf(outfile, "PUNCTUATION(%s)\n", tokenStruct.value.c_str());
			break;
	}
}

void displayUnmatched(struct GlobalStack &globalStack) {

	vector<string>::iterator it;

	cout << "OPEN-TAG(s) which were unmatched: " << endl;

	for(it = globalStack.value.begin(); it != globalStack.value.end(); ++it)
	{
		cout << *it << " ";
	}
}

