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

// print out the token based on the file.
void printToken(FILE * f, enum Filters token, struct TokenStack &tokenStack, struct GlobalStack &gs) {

	/* recognizing tokens sent by the FLEX parser */
	switch(token)
	{
		case ENDFILE:
			break;
		case OPENTAG:
			cout << "*OPEN-" << tokenStack.value.c_str();
			//cout << "*s " << gs.stck.top() << endl;
			break;
		case CLOSETAG:
			cout << "*CLOSE-" << tokenStack.value << endl;
			//cout << "*s " << gs.stck.top() << endl;

			if(gs.stck.top().compare(tokenStack.value) == 0)
			{
				//cout << "MATCHING OPEN & CLOSE TAG" << endl;
				gs.stck.pop();
			}
			else
			{
				/* Have to add them to some sort of error check to display at the end of input */
				cout << "error: no matching open-tag for </" << tokenStack.value << ">" << endl;
			}
			break;
		case WORD:
			//cout << tokenStack.value;
			cout << "WORD(" << tokenStack.value.c_str() << ")" << endl;
			break;
	}
}