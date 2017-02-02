/**
 * Author: Vanessa White
 * File: util.h
 * Class: CIS*4650 Compilers
 * Purpose: Utiliy functions for the SGML 
 * Date: February 2nd, 2017
*/

#ifndef _UTIL_H_
#define _UTIL_H_

#include "globals.h"

/**
* void printToken( FILE *, enum Filters, struct GlobalStack &, struct TokenStruct &)
* Used in: util.cpp
*
* Prints the token returned from the *.l file to the specified FILE *
* 
* @param FILE *: the file pointer
* @param struct GlobalStack &: the global stack
* @param struct TokenStruct &: the struct holding the string value of the tokens.
**/
void printToken( FILE *, enum Filters, struct GlobalStack &, struct TokenStruct &);

/**
* bool checkRelevancy(string token)
* Used in: tokens.l
*
* Checks if the current tag being processed is relevant or not.
* 
* @param string token: the token currently being processed
* @return true if the tag is relevant, otherwise false
**/
bool checkRelevancy(string token);

/**
* char * toUpperCase(char * str)
* Used in: tokens.l
*
* Changes tag text to uppercase (normalizes the text)
* 
* @param char * tag: the string that needs to be normalized
* @return the new normalized string
**/
char * toUpperCase(char * str);

/**
* string parseTag(char * tag)
* Used in: tokens.l
*
* Extracts text from open and close tags
* 
* @param char * tag: the token currently being processed that needs to be parsed
* @return the tagname without the <, / and >
**/
string parseTag(char * tag);

/**
* bool toOutput()
* Used in: tokens.l
*
* Checks the global stack to see if the token being processed should be outputted or ot
* 
* @return true if it should be outputted, otherwise false
**/
bool toOutput();

/**
* void displayUnmatched(struct GlobalStack &globalStack)
* Used in: scanner.cpp
*
* Displays all the unmatched open tags at the end of processing
* 
* @param struct GlobalStack &globalStack: the global stack
**/
void displayUnmatched(struct GlobalStack &globalStack);

#endif