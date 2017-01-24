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
word            [a-zA-z0-9 \t\n]+
punctuation     [!@#$%^&*{}()_?><:";'\.,~`|/]+
apostrophized   {letter}+[']{1}{letter}+
hyphenated      {letter}+[-]{1}


%%

{number}                                {   
                                            cout << "Number " << yytext << endl;
                                            return NUMBER; 
                                        }
                                        
{word}                                  {   
                                            cout << "Word " << yytext << endl;
                                            return WORD;
                                        }

{apostrophized}                         {   cout << "Apostrophized " << yytext << endl;
                                            return APOS;
                                        }

{hyphenated}                            {   
                                            cout << "Hyphenated " << yytext << endl;
                                            return HYPHEN;
                                        }

{punctuation}                           {
                                            cout << "Punctuation " << yytext << endl;
                                            return PUNC;
                                        }

%%

main(int argc, char const *argv[]) {

    FILE * f;
    char * buffer[1024];
    printf("yas\n");
    f = fopen(argv[1], "r");

        
    if(argc == 2 && (f = fopen(argv[1], "r")))
    {
        yyin = f;
    }

    yylex();

    return 0;
}

int yywrap(void)
{
    return 1;
}