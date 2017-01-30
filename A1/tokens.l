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
integer									[0-9]+
sign									("+"|"-")?
number									^{sign}({real}|{integer})
whitespace								[ \n\t\r]+
word									[a-zA-z0-9 \t\n]+
apostrophized							({word}"'")+{word}
hyphenated								({word}"-")+{word}
punctuation								[!@#$%{}\:,;?></^&`~*()_=-]
open-tag								("<"){letter}+(">")
close-tag								("</"){1}{letter}+(">"){1}

%%

{number}									{	cout << "Number " << yytext << endl; return NUMBER;}
{word}										{	 return WORD; }
{apostrophized}								{	cout << "Apostrophized " << yytext << endl; return APOSTROPHIZED; }
{hyphenated}								{	cout << "Hyphenated " << yytext << endl; return HYPHENATED; }
{punctuation}								{	cout << "Punctuation " << yytext << endl; return PUNCTUATION; }
{open-tag}									{	
												
												int i = 0;
												while(yytext[i])
												{
													yytext[i] = toupper(yytext[i]);
													i++;
												}
												string str(yytext);
												normalized = str.substr(1, str.length() - 2);
												yylval.value = normalized;
												gStack.stck.push(normalized);
												return OPENTAG; 
											}
{close-tag}									{	 
												int i = 0;
												while(yytext[i])
												{
													yytext[i] = toupper(yytext[i]);
													i++;
												}
												string str(yytext);
												normalized = str.substr(2, str.length() - 3);
												yylval.value = normalized;
												return CLOSETAG; }

%%

enum Filters getToken(void) {
	return (enum Filters)yylex();
}