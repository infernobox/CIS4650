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

void printToken( FILE * f, enum Filters token, struct GlobalStack &globalStack, struct TokenStruct &tokenStruct) {

	switch(token) 
	{
		case ERROR:
			cout << "close tag does not match open tag " << tokenStruct.value << endl;
			break;
		case OPENTAG:
			cout << "OPEN-" << globalStack.value.back() << endl;
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

