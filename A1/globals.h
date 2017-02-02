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
#include <array>
#include <vector>

enum Filters { 

	/* Book-keeping filters */
	ENDFILE, ERROR,
	/* Embedded Text */
	WORD, NUMBER, APOSTROPHIZED, HYPHENATED, PUNCTUATION,

	/* Tag Types */
	OPENTAG, CLOSETAG
};

struct TokenStruct {
  string value;
  int row;
};

struct GlobalStack {

	vector<string> value;
};

extern int rowno;     /* input file row number */

#endif