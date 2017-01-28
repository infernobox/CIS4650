/**
 * Author: Vanessa White
 * Class: CIS*4650 Compilers
 * Purpose: Flex Specification for the news article written in SGML
 * Date: January 2017
*/

%{

	#include "globals.h"
%}

real									([0-9]+"."[0-9]+)|([0-9]*"."[0-9]+)
integer									[0-9]+
sign									("+"|"-")?
number									^{sign}({real}|{integer})
whitespace								[ \n\t\r]+
word									[a-zA-z0-9 \t\n\r]+
apostrophized							({word}"'")+{word}
hyphenated								({word}"-")+{word}
punctuation								[!@#$%^&*()_=-]

%%

{number}									{	cout << "Number " << yytext << endl; }
{word}										{	cout << "Word " << yytext << endl; }
{apostrophized}								{	cout << "Apostrophized " << yytext << endl; }
{hyphenated}								{	cout << "Hyphenated " << yytext << endl; }
{punctuation}								{	cout << "Punctuation " << yytext << endl; }



%%

main(int argc, char const *argv[]) {

    FILE * f;
    char * buffer[1024];

    f = fopen(argv[1], "r");

        
    if(argc == 2 && (f = fopen(argv[1], "r")))
    {
        yyin = f;
    }

    yylex();

    return 0;
}