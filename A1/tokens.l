/**
 * Author: Vanessa White
 * File: tokens.l
 * Class: CIS*4650 Compilers
 * Purpose: Flex Specification for the news article written in SGML
 * Date: January 2017
*/

%{

	#include "globals.h"
	#include "util.h"
	#include "scan.h"

	struct TokenStack yylval;
	struct GlobalStack gStack;
	string normalized;
%}

letter									[a-zA-z]
real									([0-9]+"."[0-9]+)|([0-9]*"."[0-9]+)
digit									[0-9]
sign									("+"|"-")?
open-tag								("<")[a-zA-z0-9=\" ]+(">")
close-tag								("</"){1}[a-zA-z0-9 ]+(">"){1}
word									({digit}*{letter}+{digit}*)+
number									(^{sign}{real}|^{sign}{digit}+|{digit}+|{real})
apostrophized							({word}("'"){1})+{word}
hyphenated								({word}("-"){1})+{word}
punctuation								[!@#$%{}\:,;?></^&`~*()_='-]

whitespace								[ \t\n]+

%%

{open-tag}									{	
												cout << "Open tag " << yytext << endl;
												/*int i = 0;
												while(yytext[i])
												{
													yytext[i] = toupper(yytext[i]);
													i++;
												}

												string str(yytext);
												normalized = str.substr(1, str.length() - 2);
												yylval.value = normalized;
												gStack.stck.push(normalized);
												return OPENTAG; */
											}
{close-tag}									{ 	cout << "Close tag " << yytext << endl; }
{word}										{	cout << "words " << yytext << endl;}
{number}									{	cout << "numbers " << yytext << endl; }
{apostrophized}								{	cout << "apostrophized " << yytext << endl; }
{hyphenated}								{ 	cout << "hyphenated " << yytext << endl; }
{punctuation}								{	cout << "punctuation " << yytext << endl; }
{whitespace}								{}

%%

enum Filters getToken(void) {
	return (enum Filters)yylex();
}

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