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

    string normalizedText;
    vector<string> normalizedStack;
    bool relevant = false;
    bool isOutputted = false;
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
punctuation                             [!@#$%{}\:.,;?></^&`~*()_='-]

whitespace                              [ \t\n]+

%%

{open-tag}                                  {
                                                yytext = toUpperCase(yytext);
                                                normalizedText = parseTag(yytext);
                                                relevant = checkRelevancy(normalizedText);
                                                isOutputted = toOutput();
                                                cout << "Open " << isOutputted << endl;
                                                if(relevant && isOutputted)
                                                {
                                                    cout << "*OPEN-" << normalizedText << endl;
                                                }
                                                cout << "\t\tNormalized " << normalizedText << endl;
                                                normalizedStack.push_back(normalizedText);
                                            }
{close-tag}                                 {   
                                                cout << "\t\t\t\tclose tag" << endl;
                                                yytext = toUpperCase(yytext);
                                                cout << "\t\t\t\tparsetag" << endl;
                                                normalizedText = parseTag(yytext);
                                                cout << "pls" << endl;
                                                //cout <<  "close " << normalizedText << " " << normalizedStack.back() << endl;
                                                // Check that the closing tag and open tag match 
                                                //If they do, pop it off the stack. Else it is an error
                                                if(!normalizedStack.empty() && normalizedStack.back().compare(normalizedText) == 0)
                                                {
                                                    cout << "Match found" << endl;
                                                    normalizedStack.pop_back();
                                                }
                                                relevant = checkRelevancy(normalizedText);
                                                isOutputted = toOutput();
                                                if(relevant && isOutputted)
                                                {
                                                    cout << "*CLOSE-" << normalizedText << endl; 
                                                }
                                            }
{word}                                      {  
                                                //cout << normalizedStack.top() << " word" << endl;
                                                isOutputted = toOutput();
                                                if(!normalizedStack.empty() && checkRelevancy(normalizedStack.back()) && isOutputted)
                                                {
                                                    cout << "*WORD(" << yytext << ")" << endl;
                                                }
                                            }
{number}                                    {   
                                                isOutputted = toOutput();
                                                if(!normalizedStack.empty() && checkRelevancy(normalizedStack.back()) && isOutputted)
                                                {
                                                    cout << "*NUMBER(" << yytext << ")" << endl;
                                                }
                                            }
                                            
{apostrophized}                             {   
                                                isOutputted = toOutput();
                                                if(!normalizedStack.empty() && checkRelevancy(normalizedStack.back()) && isOutputted)
                                                {
                                                    cout << "*APOSTROPHIZED(" << yytext << ")" << endl;
                                                }
                                            }
{hyphenated}                                {   
                                                isOutputted = toOutput();
                                                if(!normalizedStack.empty() && checkRelevancy(normalizedStack.back()) && isOutputted)
                                                {
                                                    cout << "*HYPHENATED(" << yytext << ")" << endl;
                                                }
                                            }
{punctuation}                               {  
                                                isOutputted = toOutput(); 
                                                if(!normalizedStack.empty() && checkRelevancy(normalizedStack.back()) && isOutputted)
                                                {
                                                    cout << "*PUNCTUATION(" << yytext << ")" << endl;
                                                }
                                            }
{whitespace}                                {   /* skip whitespace*/ }

%%

enum Filters getToken(void) {
    return (enum Filters)yylex();
}

/* Checks if the tag is relevant 
    Returns true if it is
    Returns false is the tag is irrelevant
*/
bool checkRelevancy(string token) {

    //cout << "checkRelevancy" << token << endl;

    for(int i = 0; i < relevantTags.size(); ++i)
    {
        if(token.compare(relevantTags.at(i)) == 0)
        {
            //cout << "rele " << relevantTags.at(i) << endl;
            return true;
        }
    }

    return false;
}

/* Checks that the stack has either all relevant or all irrelevant tags in it 
    Returns false if an irrelevant tag is in the stack
    Else returns true
*/
bool toOutput() {
    vector<string>::iterator it;
    bool found = false;

    for(it = normalizedStack.begin(); it != normalizedStack.end(); ++it)
    {
        found = false;

        for(int i = 0; i < relevantTags.size(); ++i)
        {
          //  cout << relevantTags.at(i) << " " << *it << endl;
            if(relevantTags.at(i).compare(*it) == 0)
            {
                found = true;
                break;
            }

            if(!found && i == relevantTags.size() - 1)
            {
                return false;
            }

        }
    }

    /*if(normalizedStack.empty())
    {
        return true;
    }

    for(it = normalizedStack.begin(); it != normalizedStack.end(); ++it)
    {
        found = false;

        for(int i = 0; i < relevantTags.size(); ++i)
        {
          //  cout << relevantTags.at(i) << " " << *it << endl;
            if(relevantTags.at(i).compare(*it) == 0)
            {
                found = true;
                break;
            }

        }
    }

    if(!found)
    {
        return false;
    }*/



    return true;
}

/* Converts lowercase string to all upper case
    Returns the string in uppercase
*/
char * toUpperCase(char * str) {

    int i = 0;
    while(str[i])
    {
        str[i] = toupper(str[i]);
        i++;
    }

    return str;
}

/* Parses the OPEN-TAG and CLOSE-TAG to remove th '<', '>' and '/'
    Allows the normalized text to be extracted
    Return the string containing the normalized text
*/
string parseTag(char * tag) {

    string str(tag);
    string normalized;

    string::iterator it; //an iterator to traverse through the string

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