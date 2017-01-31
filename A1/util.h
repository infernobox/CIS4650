/**
 * Author: Vanessa White
 * File: util.h
 * Class: CIS*4650 Compilers
 * Purpose: Utiliy functions for the SGML 
 * Date: January 2017
*/

#ifndef _UTIL_H_
#define _UTIL_H_

#include "globals.h"

//Prints the token and outputs it to a file
void printToken( FILE *, enum Filters, struct TokenStack &, struct GlobalStack &);
bool checkRelevancy(string token);

#endif