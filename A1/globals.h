/**
 * Author: Vanessa White
 * File: globals.h
 * Class: CIS*4650 Compilers
 * Purpose: Global types and variables for the news article written in SGML
 * Date: January 2017
*/

#ifndef _GLOBALS_H_
#define _GLOBALS_H_

using namespace std;

#include <cstdio>
#include <string>
#include <iostream>
#include <cctype>
#include <stack>

enum Filters { 

	/* Book-keeping filters */
	ENDFILE,
	/* Embedded Text */
	WORD, NUMBER, APOSTROPHIZED, HYPHENATED, PUNCTUATION,

	/* Tag Types */
	OPENTAG, CLOSETAG
};

struct TokenStack {
  string value;
  int row;
};

struct GlobalStack {

	stack<string> stck;
};

extern int rowno;     /* input file row number */

#endif