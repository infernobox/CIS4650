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
    string normalizedText;
    stack<string> normalizedStack;
    bool relevant = false;
    array<string, 7> relevantTags = { "DOC", "TEXT", "P", "DOCNO", "DATE", "HEADLINE", "LENGTH"};
%}

letter                                  [a-zA-z]
real                                    ([0-9]+"."[0-9]+)|([0-9]*"."[0-9]+)
digit                                   [0-9]
sign                                    ("+"|"-")?
open-tag                                ("<")[a-zA-z0-9=\" ]+(">")
close-tag                               ("</"){1}[a-zA-z0-9 ]+(">"){1}
word                                    ({digit}*{letter}+{digit}*)+
number                                  (^{sign}{real}|^{sign}{digit}+|{digit}+|{real})
apostrophized                           ({word}("'"){1})+{word}
hyphenated                              ({word}("-"){1})+{word}
punctuation                             [!@#$%{}\:,;?></^&`~*()_='-]

whitespace                              [ \t\n]+

%%

{open-tag}                                  {
                                                yytext = toUpperCase(yytext);
                                                normalizedText = parseTag(yytext);
                                                //cout << normalizedText << endl;
                                                relevant = checkRelevancy(normalizedText);

                                                if(relevant)
                                                {
                                                    cout << "*OPEN-" << normalizedText << endl;
                                                }
                                                normalizedStack.push(normalizedText);

                                            }
{close-tag}                                 {   
                                                yytext = toUpperCase(yytext);
                                                //normalizedText = parseTag(yytext);
                                                cout << normalizedText << endl;

                                                relevant = checkRelevancy(normalizedText);

                                                if(normalizedStack.top().compare(normalizedText))
                                                {
                                                    cout << "Match found" << endl;
                                                    normalizedStack.pop();
                                                }

                                               /* if(relevant)
                                                {
                                                    cout << "*CLOSE-" << normalizedText << endl; 
                                                }
                                                else
                                                {
                                                    normalizedStack.pop();
                                                }*/
                                            }
{word}                                      {   
                                                if(checkRelevancy(normalizedStack.top()))
                                                {
                                                    cout << "*WORDS(" << yytext << ")" << endl;
                                                }
                                            }
{number}                                    {   
                                                if(checkRelevancy(normalizedStack.top()))
                                                {
                                                    cout << "*NUMBER(" << yytext << ")" << endl;
                                                }
                                            }
                                            
{apostrophized}                             {   
                                                if(checkRelevancy(normalizedStack.top()))
                                                {
                                                    cout << "*APOSTROPHIZED(" << yytext << ")" << endl;
                                                }
                                            }
{hyphenated}                                {   
                                                if(checkRelevancy(normalizedStack.top()))
                                                {
                                                    cout << "*HYPHENATED(" << yytext << ")" << endl;
                                                }
                                            }
{punctuation}                               {   
                                                if(checkRelevancy(normalizedStack.top()))
                                                {
                                                    cout << "*WORDS(" << yytext << ")" << endl;
                                                }
                                            }
{whitespace}                                {}

%%

enum Filters getToken(void) {
    return (enum Filters)yylex();
}

bool checkRelevancy(string token) {

    //cout << "checkRelevancy" << token << endl;

    for(int i = 0; i < relevantTags.size(); i++)
    {
        if(token.compare(relevantTags.at(i)) == 0)
        {
            //cout << "rele " << relevantTags.at(i) << endl;
            return true;
        }
    }

    return false;
}

char * toUpperCase(char * str) {

    int i = 0;
    while(str[i])
    {
        str[i] = toupper(str[i]);
        i++;
    }

    return str;
}

string parseTag(char * tag) {

    string str(tag);
    string normalized;

    string::iterator it;

    for(it = str.begin(); it != str.end(); ++it)
    {
        if(isalnum(*it))
        {
            normalized = normalized + *it;
        }
    }

    //normalized = str.substr(1, str.length() - 2);

    return normalized;
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