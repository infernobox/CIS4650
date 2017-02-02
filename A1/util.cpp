/**
 * Author: Vanessa White
 * File: util.cpp
 * Class: CIS*4650 Compilers
 * Purpose: Utiliy functions for the SGML 
 * Date: January 2017
*/

#include "globals.h"
#include "util.h"
#include "scan.h"

using namespace std;

void printToken( FILE * outfile, enum Filters token, struct GlobalStack &globalStack, struct TokenStruct &tokenStruct) {

	switch(token) 
	{
		case ERROR:
			//cout << "error: no matching OPEN-TAG for " << tokenStruct.value  << " at lineno " << rowno << endl;
			fprintf(stderr, "%s %d %s\n", "error, line ", rowno, "no matching OPEN-TAG");
			break;
		case OPENTAG:
			cout << "OPEN-" << globalStack.value.back().c_str() << endl;
			break;
		case CLOSETAG:
			cout << "CLOSE-" << tokenStruct.value << endl;
			break;
		case WORD:
			cout << "WORD(" << tokenStruct.value << ")" << endl;
			break;
		case NUMBER:
			cout << "NUMBER(" << tokenStruct.value << ")" << endl;
			break;
		case APOSTROPHIZED:
			cout << "APOSTROPHIZED(" << tokenStruct.value << ")" << endl;
			break;
		case HYPHENATED:
			cout << "HYPHENATED(" << tokenStruct.value << ")" << endl;
			break;
		case PUNCTUATION:
			cout << "PUNCTUATION(" << tokenStruct.value << ")" << endl;
			break;
	}
}

void displayUnmatched(struct GlobalStack &globalStack) {

	vector<string>::iterator it;

	cout << "Unmatched open-tags: " << endl;

	for(it = globalStack.value.begin(); it != globalStack.value.end(); ++it)
	{
		cout << *it << endl;
	}
}

