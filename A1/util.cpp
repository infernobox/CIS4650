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
	bool poppedMatch = false;
	/* recognizing tokens sent by the FLEX parser */
	switch(token)
	{
		case ENDFILE:
			break;
		case OPENTAG:
			/* Check if it is a relevant tag, if not do not output it */
			relevant = checkRelevancy(tokenStack.value); 

			if(relevant)
			{
				cout << "*OPEN-" << tokenStack.value << endl;
			}
			normalizedStack.push(tokenStack.value);
			break;
		case CLOSETAG:
			/* Check if it is a relevant tag, if not do not output it */
			relevant = checkRelevancy(tokenStack.value);
			cout << "CLOSE FOUND " << tokenStack.value << endl;
			cout << normalizedStack.top() << endl;
			if(relevant)
			{
				/* Keep looping until we find the tag that we need to to match to open tag
					might have the case where the open tag does not have a matching close tag
					then it halts output on the correct close-tag
				*/
				//while(!poppedMatch) 
				//{
					if(normalizedStack.top().compare(tokenStack.value) == 0)
					{
						//cout << "MATCHING OPEN & CLOSE TAG" << endl;
						cout << "*CLOSE-" << tokenStack.value << endl;
						normalizedStack.pop();
						poppedMatch = true;
					}
					else
					{
						/* Have to add them to some sort of error check to display at the end of input */
						if(checkRelevancy(normalizedStack.top()))
						{
							noMatch.push(normalizedStack.top());
						}
						else
						{
							normalizedStack.pop();
						}
					}
				//}
			}
			else
			{
				normalizedStack.pop();
			}
			break;
		case WORD:
			relevant = checkRelevancy(normalizedStack.top());

			if(relevant)
			{
				cout << "*WORD(" << tokenStack.value.c_str() << ")" << endl;	
			}
			break;
	}

	while(!noMatch.empty())
	{
		cout << "error: no matching closing-tag for <" << noMatch.top() << ">" << endl;
		noMatch.pop();
	}
}

bool checkRelevancy(string token) {

	for(int i = 0; i < relevantTags.size(); i++)
	{
		if(token.compare(relevantTags.at(i)) == 0)
		{
			cout << "rele " << relevantTags.at(i) << endl;
			return true;
		}
	}

	return false;
}