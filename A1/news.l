/**
 * Author: Vanessa White
 * Class: CIS*4650 Compilers
 * Purpose: Flex Specification for the news article written in SGML
 * Date: January 2017
*/

%{

    #include "globals.h"

    struct TokenStruct yylval;
%}

digit           [0-9]
number          ^(-|[+])?{digit}+(.)?{digit}+
letter          [a-zA-z]
whitespace      [ \t]+
newline         \n
word            [{letter}{digit}]




%%

{word}                                  {   
                                            cout << "Word " << yytext << endl;
                                        }
{number}                                {   
                                            cout << "Number " << yytext << endl;
                                            return NUMBER; 
                                        }

%%

main(int argc, char const *argv[]) {

    FILE * f;
    printf("yas\n");
    f = fopen(argv[1], "r");

    yyin = f;
    yylex();
  

    return 0;
}