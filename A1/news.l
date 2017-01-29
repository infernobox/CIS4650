/**
 * Author: Vanessa White
 * File: news.l
 * Class: CIS*4650 Compilers
 * Purpose: Flex Specification for the news article written in SGML
 * Date: January 2017
*/

%{

    #include "globals.h"

    struct TokenStruct yylval;
%}

digit           [0-9]
number          ^(-|[+])?{digit}*(.)?{digit}*
letter          [a-zA-z]
whitespace      [ \t]+
newline         \n
word            [a-zA-z0-9 \t\n]+
punctuation     [!@#$%^&*{}()_?><:";'\.,~`|/]+
apostrophized   ({letter}+([']*))+
hyphenated      ({letter}+([-]*))+
rel-normalized  (DOC|TEXT|P|DOCNO|DATE|HEADLINE|LENGTH)
open-tag        ^(<){1}{letter}+(>){1}
close-tag       ^("</"){1}{letter}+(>){1}

%array yytext


%%

{open-tag}                              {
                                            cout << "Open-tag " << yytext[0] << endl;
                                            string str(yytext);
                                            cout << str << endl;

                                            cout << str.substr(1, str.length() - 2) << endl;
                                            cout << str.length() << endl;
                                        }

{close-tag}                             {
                                            cout << "Close-tag " << yytext[0] << endl;
                                            string str(yytext);
                                            cout << str << endl;

                                            cout << str.substr(2, str.length() - 3) << endl;
                                            cout << str.length() << endl;
                                        }

{number}                                {   
                                            cout << "Number " << yytext << endl;
                                        }
                                        
{word}                                  {   
                                            cout << "Word " << yytext << endl;
                                        }

{apostrophized}                         {   
                                            cout << "Apostrophized " << yytext << endl;
                                        }

{hyphenated}                            {   
                                            cout << "Hyphenated " << yytext << endl;
                                        }

{punctuation}                           {
                                            cout << "Punctuation " << yytext << endl;
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