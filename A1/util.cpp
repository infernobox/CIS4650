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

stack<string> normalizedStack;
stack<string> noMatch;
array<string, 7> relevantTags = { "DOC", "TEXT", "P", "DOCNO", "DATE", "HEADLINE", "LENGTH"};

// print out the token based on the file.
void printToken(FILE * f, enum Filters token, struct TokenStack &tokenStack, struct GlobalStack &gs) {

	bool relevant = false;
	/* recognizing tokens sent by the FLEX parser */
	switch(token)
	{
		case ENDFILE:
			break;
		case OPENTAG:
			relevant = checkRelevancy(tokenStack.value);

			if(relevant)
			{
				cout << "*OPEN-" << tokenStack.value;
				normalizedStack.push(tokenStack.value);
			}
			//cout << "*s " << gs.stck.top() << endl;
			break;
		case CLOSETAG:
			relevant = checkRelevancy(tokenStack.value);

			if(relevant)
			{
				cout << "*CLOSE-" << tokenStack.value << endl;

				if(normalizedStack.top().compare(tokenStack.value) == 0)
				{
					//cout << "MATCHING OPEN & CLOSE TAG" << endl;
					normalizedStack.pop();
				}
				else
				{
					/* Have to add them to some sort of error check to display at the end of input */
					noMatch.push(normalizedStack.top());
				//	cout << "error: no matching open-tag for </" << normalizedStack.top() << ">" << endl;
				}
			}
			
			//cout << "*s " << gs.stck.top() << endl;
			break;
		case WORD:
			//cout << tokenStack.value;
			if(relevant)
			{
				cout << "WORD(" << tokenStack.value.c_str() << ")" << endl;	
			}
			break;
	}

/*	while(!noMatch.empty())
	{
		cout << "error: no matching open-tag for </" << noMatch.top() << ">" << endl;
		noMatch.pop();
	}

	while(!normalizedStack.empty())
	{
		cout << "error: no matching close-tag for <" << normalizedStack.top() << ">" << endl;
		normalizedStack.pop();
	}
*/
}

bool checkRelevancy(string token) {

	for(int i = 0; i < relevantTags.size(); i++)
	{
		if(token.compare(relevantTags.at(i)) == 0)
		{
			return true;
		}
	}

	return false;
}