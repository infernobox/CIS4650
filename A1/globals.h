/**
 * Author: Vanessa White
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

enum Filters { 

	/* Embedded Text */
	WORD, NUMBER

};

struct TokenStruct {
  string value;
  int row;
};

extern int rowno;     /* input file row number */

#endif